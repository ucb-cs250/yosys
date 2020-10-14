/*
 *  yosys -- Yosys Open SYnthesis Suite
 *
 *  Copyright (C) 2012  Clifford Wolf <clifford@clifford.at>
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

// Ref: techlib/xilinx/arith_map.v
(* techmap_celltype = "$alu" *)
module _80_borca_alu (A, B, CI, BI, X, Y, CO);
	parameter A_SIGNED = 0;
	parameter B_SIGNED = 0;
	parameter A_WIDTH = 1;
	parameter B_WIDTH = 1;
	parameter Y_WIDTH = 1;
	parameter _TECHMAP_CONSTVAL_CI_ = 0;
	parameter _TECHMAP_CONSTMSK_CI_ = 0;

	(* force_downto *)
	input [A_WIDTH-1:0] A;
	(* force_downto *)
	input [B_WIDTH-1:0] B;
	(* force_downto *)
	output [Y_WIDTH-1:0] X, Y;

	input CI, BI;
	(* force_downto *)
	output [Y_WIDTH-1:0] CO;

	wire _TECHMAP_FAIL_ = Y_WIDTH <= 2;

	(* force_downto *)
	wire [Y_WIDTH-1:0] A_buf, B_buf;
	\$pos #(.A_SIGNED(A_SIGNED), .A_WIDTH(A_WIDTH), .Y_WIDTH(Y_WIDTH)) A_conv (.A(A), .Y(A_buf));
	\$pos #(.A_SIGNED(B_SIGNED), .A_WIDTH(B_WIDTH), .Y_WIDTH(Y_WIDTH)) B_conv (.A(B), .Y(B_buf));

	(* force_downto *)
	wire [Y_WIDTH-1:0] AA = A_buf;
	(* force_downto *)
	wire [Y_WIDTH-1:0] BB = BI ? ~B_buf : B_buf;

  // TODO: check this logic
	localparam CARRY4_COUNT = (Y_WIDTH + 3) / 4;
	localparam MAX_WIDTH    = CARRY4_COUNT * 4;
	localparam PAD_WIDTH    = MAX_WIDTH - Y_WIDTH;

	(* force_downto *)
	wire [MAX_WIDTH-1:0] S  = {{PAD_WIDTH{1'b0}}, AA ^ BB};
	(* force_downto *)
	wire [MAX_WIDTH-1:0] DI = {{PAD_WIDTH{1'b0}}, AA};

	(* force_downto *)
	wire [MAX_WIDTH-1:0] O;
	(* force_downto *)
	wire [MAX_WIDTH-1:0] C;
	assign Y = O, CO = C;

	genvar i;
	generate for (i = 0; i < CARRY4_COUNT; i = i + 1) begin:slice
		if (i == 0) begin
			carry_chain carry4 (
			  .Ci (1'd0),
			  .G  (DI[i*4 +: 4]),
			  .P  (S [i*4 +: 4]),
			  .S  (O [i*4 +: 4]),
			  .Co (C [i*4 +: 4])
			);
		end else begin
			carry_chain carry4 (
			  .Ci (C [i*4 - 1]),
			  .G  (DI[i*4 +: 4]),
			  .P  (S [i*4 +: 4]),
			  .S  (O [i*4 +: 4]),
			  .Co (C [i*4 +: 4])
			);
		end
	end endgenerate

	assign X = S;
endmodule

