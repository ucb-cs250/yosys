/*
 *  yosys -- Yosys Open SYnthesis Suite
 *
 *  Copyright (C) 2012  Clifford Wolf <clifford@clifford.at>
 *            (C) 2019  Eddie Hung    <eddie@fpgeh.com>
 *
 *  Permission to use, copy, modify, and/or distribute this software for any
 *  purpose with or without fee is hereby granted, provided that the above
 *  copyright notice and this permission notice appear in all copies.
 *
 *  THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
 *  WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
 *  MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
 *  ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
 *  WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
 *  ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
 *  OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
 *
 */

#include "kernel/register.h"
#include "kernel/celltypes.h"
#include "kernel/rtlil.h"
#include "kernel/log.h"

USING_YOSYS_NAMESPACE
PRIVATE_NAMESPACE_BEGIN

struct SynthBorcaPass : public ScriptPass
{
	SynthBorcaPass() : ScriptPass("synth_borca", "synthesis for Borca FPGAs") { }

	void on_register() override
	{
		RTLIL::constpad["synth_borca.abc9.xc7.W"] = "300"; // Number with which ABC will map a 6-input gate
								                                      // to one LUT6 (instead of a LUT5 + LUT2)
	}

	void help() override
	{
		//   |---v---|---v---|---v---|---v---|---v---|---v---|---v---|---v---|---v---|---v---|
		log("\n");
		log("    synth_borca [options]\n");
		log("\n");
		log("This command runs synthesis for Borca FPGAs\n");
		log("\n");
		log("    -top <module>\n");
		log("        use the specified module as top module\n");
		log("\n");
		log("    -edif <file>\n");
		log("        write the design to the specified edif file. writing of an output file\n");
		log("        is omitted if this parameter is not specified.\n");
		log("\n");
		log("    -blif <file>\n");
		log("        write the design to the specified BLIF file. writing of an output file\n");
		log("        is omitted if this parameter is not specified.\n");
		log("\n");
		log("    -run <from_label>:<to_label>\n");
		log("        only run the commands between the labels (see below). an empty\n");
		log("        from label is synonymous to 'begin', and empty to label is\n");
		log("        synonymous to the end of the command list.\n");
		log("\n");
		log("    -flatten\n");
		log("        flatten design before synthesis\n");
		log("\n");
		log("    -abc9\n");
		log("        use new ABC9 flow (EXPERIMENTAL)\n");
		log("\n");
		log("\n");
		log("The following commands are executed by this synthesis command:\n");
		help_script();
		log("\n");
	}

	std::string top_opt, edif_file, blif_file, family;
	bool flatten;
	bool abc9;
	bool flatten_before_abc;
  int lut_size = 4;

	void clear_flags() override
	{
		top_opt = "-auto-top";
		edif_file.clear();
		blif_file.clear();
		flatten = false;
		abc9 = false;
		flatten_before_abc = false;
		lut_size = 4;
	}

	void execute(std::vector<std::string> args, RTLIL::Design *design) override
	{
		std::string run_from, run_to;
		clear_flags();

		size_t argidx;
		for (argidx = 1; argidx < args.size(); argidx++)
		{
			if (args[argidx] == "-top" && argidx+1 < args.size()) {
				top_opt = "-top " + args[++argidx];
				continue;
			}
			if (args[argidx] == "-edif" && argidx+1 < args.size()) {
				edif_file = args[++argidx];
				continue;
			}
			if (args[argidx] == "-blif" && argidx+1 < args.size()) {
				blif_file = args[++argidx];
				continue;
			}
			if (args[argidx] == "-run" && argidx+1 < args.size()) {
				size_t pos = args[argidx+1].find(':');
				if (pos == std::string::npos)
					break;
				run_from = args[++argidx].substr(0, pos);
				run_to = args[argidx].substr(pos+1);
				continue;
			}
			if (args[argidx] == "-flatten") {
				flatten = true;
				continue;
			}
			if (args[argidx] == "-flatten_before_abc") {
				flatten_before_abc = true;
				continue;
			}
			if (args[argidx] == "-abc9") {
				abc9 = true;
				continue;
			}
			break;
		}
		extra_args(args, argidx, design);

		log_header(design, "Executing SYNTH_BORCA pass.\n");
		log_push();

		run_script(design, run_from, run_to);

		log_pop();
	}

	void script() override
	{
		std::string lut_size_s = std::to_string(lut_size);
		if (help_mode)
			lut_size_s = "[4]";

		if (check_label("begin")) {
			std::string read_args;
      read_args += " -lib -specify +/borca/cells_sim.v";
			run("read_verilog" + read_args);
			run(stringf("hierarchy -check %s", top_opt.c_str()));
		}

		if (check_label("prepare")) {
			run("proc");
			if (flatten || help_mode)
				run("flatten", "(with '-flatten')");
			run("deminout");
			run("opt_expr");
			run("opt_clean");
			run("check");
			run("opt -nodffe -nosdff");
			run("fsm");
			run("opt");
			run("wreduce [-keepdc]");
			run("peepopt");
			run("opt_clean");
      run("techmap -map +/techmap.v -map +/borca/arith_map.v -D MAC_WIDTH=16");
      run("opt -fast");
		}

    if (check_label("map_luts")) {
      run("abc -lut 4");
      run("clean");
    }

		if (check_label("map_cells")) {
			run("techmap -map +/borca/cells_map.v");
			run("clean");
		}

		if (check_label("finalize")) {
			run("clean");
		}

		if (check_label("check")) {
			run("hierarchy -check");
      run("stat");
			run("check -noinit");
		}

		if (check_label("edif")) {
			if (!edif_file.empty() || help_mode)
				run(stringf("write_edif -pvector bra %s", edif_file.c_str()));
		}

		if (check_label("blif")) {
			if (!blif_file.empty() || help_mode)
				run(stringf("write_blif %s", edif_file.c_str()));
		}
	}
} SynthBorcaPass;

PRIVATE_NAMESPACE_END
