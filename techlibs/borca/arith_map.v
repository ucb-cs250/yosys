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

	localparam CARRY4_COUNT = (Y_WIDTH + 3) / 4;
	localparam MAX_WIDTH    = CARRY4_COUNT * 4;
	localparam PAD_WIDTH    = MAX_WIDTH - Y_WIDTH;

	(* force_downto *)
	wire [MAX_WIDTH-1:0] S  = {{PAD_WIDTH{1'b0}}, AA ^ BB};
	(* force_downto *)
	wire [MAX_WIDTH-1:0] DI = {{PAD_WIDTH{1'b0}}, AA & BB};

	(* force_downto *)
	wire [MAX_WIDTH-1:0] O;
	(* force_downto *)
	wire C;
	assign Y = O, CO = C;

	genvar i;
	generate for (i = 0; i < CARRY4_COUNT; i = i + 1) begin:slice
		if (i == 0) begin
			carry_chain carry4 (
			  .Ci (1'd0),
			  .G  (DI[i*4 +: 4]),
			  .P  (S [i*4 +: 4]),
			  .S  (O [i*4 +: 4]),
			  .Co (C [i])
			);
		end else begin
			carry_chain carry4 (
			  .Ci (C [i-1]),
			  .G  (DI[i*4 +: 4]),
			  .P  (S [i*4 +: 4]),
			  .S  (O [i*4 +: 4]),
			  .Co (C [i*4 +: 4])
			);
		end
	end endgenerate

	assign X = S;
endmodule

module wide_adder (A, B, BI, Y, CO);
	parameter A_SIGNED = 0;
	parameter B_SIGNED = 0;
	parameter A_WIDTH = 1;
	parameter B_WIDTH = 1;
	parameter Y_WIDTH = 1;

	(* force_downto *)
	input [A_WIDTH-1:0] A;
	(* force_downto *)
	input [B_WIDTH-1:0] B;
	(* force_downto *)
	output [Y_WIDTH-1:0] Y;
	(* force_downto *)
	output [Y_WIDTH-1:0] CO;
  input BI;

	(* force_downto *)
	wire [Y_WIDTH-1:0] A_buf, B_buf;
	\$pos #(.A_SIGNED(A_SIGNED), .A_WIDTH(A_WIDTH), .Y_WIDTH(Y_WIDTH)) A_conv (.A(A), .Y(A_buf));
	\$pos #(.A_SIGNED(B_SIGNED), .A_WIDTH(B_WIDTH), .Y_WIDTH(Y_WIDTH)) B_conv (.A(B), .Y(B_buf));

	(* force_downto *)
	wire [Y_WIDTH-1:0] AA = A_buf;
	(* force_downto *)
	wire [Y_WIDTH-1:0] BB = BI ? ~B_buf : B_buf;

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
endmodule

(* techmap_celltype = "$mul" *)
module \$__MULTIPLIER (A, B, Y);
	parameter A_SIGNED = 0;
	parameter B_SIGNED = 0;
	parameter A_WIDTH = 1;
	parameter B_WIDTH = 1;
	parameter Y_WIDTH = 1;

	(* force_downto *)
	input [A_WIDTH-1:0] A;
	(* force_downto *)
	input [B_WIDTH-1:0] B;
	(* force_downto *)
	output [Y_WIDTH-1:0] Y;

  // Don't do techmapping to mac block if the operand's width is lesser than
  // the MAC's minimum width
  generate if (A_WIDTH < `MAC_WIDTH) begin
    wire _TECHMAP_FAIL_ = 1;
  end
  else begin
    localparam SLICE = (A_WIDTH + `MAC_WIDTH - 1) / `MAC_WIDTH;

    // TODO: padding?

    generate if (SLICE == 1) begin
      mac_block #(
        .MIN_WIDTH(`MAC_WIDTH)
      ) _TECHMAP_REPLACE_ (
        .A(A),
        .B(B),
        .C(Y)
      );
    end
    else begin
	    (* force_downto *)
      wire [2 * `MAC_WIDTH-1:0] TMP0[SLICE ** 2];
	    (* force_downto *)
      wire [2*Y_WIDTH-1:0] TMP1[SLICE ** 2];

	    genvar i, j;
	    generate
        for (i = 0; i < SLICE; i = i + 1) begin:slicei
          for (j = 0; j < SLICE; j = j + 1) begin: slicej
            // TODO: incorporate clk signal if pipelined and correct logic to interface
            // with the MAC block
            // Right now this is just a stub

            if (!(i == SLICE - 1 && j == SLICE - 1)) begin
              mac_block #(
                .MIN_WIDTH(`MAC_WIDTH)
              ) _TECHMAP_REPLACE_ (
                .A(A[i * `MAC_WIDTH +: `MAC_WIDTH]),
                .B(B[j * `MAC_WIDTH +: `MAC_WIDTH]),
                .C(TMP0[i * SLICE + j])
              );
            end
          end
        end
      endgenerate

      generate
        for (i = 0; i < SLICE; i = i + 1) begin: sumi
          for (j = 0; j < SLICE; j = j + 1) begin: sumj
            localparam SHIFT_WIDTH = (i + j) * `MAC_WIDTH;

            if (i == 0 && j == 0) begin
              wide_adder #(
                .A_SIGNED(A_SIGNED),
                .B_SIGNED(B_SIGNED),
                .A_WIDTH(2*Y_WIDTH),
                .B_WIDTH(2*Y_WIDTH),
                .Y_WIDTH(2*Y_WIDTH)
              ) inst (
                .A(0),
                .B({TMP0[0]}),
                .BI(0),
                .Y(TMP1[i * SLICE + j]),
                .CO()
              );
            end
            else if (i == SLICE - 1 && j == SLICE - 1) begin
              wide_adder #(
                .A_SIGNED(A_SIGNED),
                .B_SIGNED(B_SIGNED),
                .A_WIDTH(2*Y_WIDTH),
                .B_WIDTH(2*Y_WIDTH),
                .Y_WIDTH(2*Y_WIDTH)
              ) inst (
                .A(TMP1[i * SLICE + j - 1]),
                .B(0),
                .BI(0),
                .Y(TMP1[i * SLICE + j]),
                .CO()
              );
            end
            else begin
              wide_adder #(
                .A_SIGNED(A_SIGNED),
                .B_SIGNED(B_SIGNED),
                .A_WIDTH(2*Y_WIDTH),
                .B_WIDTH(2*Y_WIDTH),
                .Y_WIDTH(2*Y_WIDTH)
              ) inst (
                .A(TMP1[i * SLICE + j - 1]),
                .B({TMP0[i * SLICE + j], SHIFT_WIDTH'b0}),
                .BI(0),
                .Y(TMP1[i * SLICE + j]),
                .CO()
              );
            end
          end
        end
      endgenerate

      assign Y = TMP1[SLICE ** 2 - 1];

    end endgenerate
  end endgenerate
endmodule
