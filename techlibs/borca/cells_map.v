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

module  \$not (A, Y);
  parameter A_WIDTH = 1;
  parameter Y_WIDTH = 1;
  parameter A_SIGNED = 0;

  (* force_downto *)
  input [A_WIDTH-1:0] A;
  output [Y_WIDTH-1:0] Y;

  LUT4 #(.INIT(16'h5555)) _TECHMAP_REPLACE_ (.O(Y),
         .I0(A), .I1(1'b0), .I2(1'b0), .I3(1'b0));
endmodule

module \$lut (A, Y);
  parameter WIDTH = 0;
  parameter LUT = 0;

  (* force_downto *)
  input [WIDTH-1:0] A;
  output Y;

  generate
    if (WIDTH == 1) begin
      LUT4 #(.INIT(LUT)) _TECHMAP_REPLACE_ (.O(Y),
        .I0(A[0]), .I1(1'b0), .I2(1'b0), .I3(1'b0));
    end else
    if (WIDTH == 2) begin
      LUT4 #(.INIT(LUT)) _TECHMAP_REPLACE_ (.O(Y),
        .I0(A[0]), .I1(A[1]), .I2(1'b0), .I3(1'b0));
    end else
    if (WIDTH == 3) begin
      LUT4 #(.INIT(LUT)) _TECHMAP_REPLACE_ (.O(Y),
        .I0(A[0]), .I1(A[1]), .I2(A[2]), .I3(A[3]));
    end else
    if (WIDTH == 4) begin
      LUT4 #(.INIT(LUT)) _TECHMAP_REPLACE_ (.O(Y),
        .I0(A[0]), .I1(A[1]), .I2(A[2]), .I3(A[3]));
    end else begin
      wire _TECHMAP_FAIL_ = 1;
    end
  endgenerate
endmodule

module  \$_DFF_P_ (input D, C, E, output Q);
  parameter INIT = 1'b0;
  DFFER #(.INIT(INIT)) _TECHMAP_REPLACE_ (.D(D), .Q(Q), .CLK(C), .CE(1'b1), .RST(1'b0));
endmodule

module  \$_DFFE_PP_ (input D, C, E, output Q);
  parameter INIT = 1'b0;
  DFFER #(.INIT(INIT)) _TECHMAP_REPLACE_ (.D(D), .Q(Q), .CLK(C), .CE(E), .RST(1'b0));
endmodule

module  \$_DFFE_PN_ (input D, C, E, output Q);
  parameter INIT = 1'b0;
  DFFER #(.INIT(INIT)) _TECHMAP_REPLACE_ (.D(D), .Q(Q), .CLK(C), .CE(~E), .RST(1'b0));
endmodule

module  \$_SDFFE_PP0P_ (input D, C, E, R, output Q);
  parameter INIT = 1'b0;
  DFFER #(.INIT(INIT)) _TECHMAP_REPLACE_ (.D(D), .Q(Q), .CLK(C), .CE(E), .RST(R));
endmodule

module  \$_SDFFE_PP1P_ (input D, C, E, R, output Q);
  parameter INIT = 1'b1;
  DFFER #(.INIT(INIT)) _TECHMAP_REPLACE_ (.D(D), .Q(Q), .CLK(C), .CE(E), .RST(R));
endmodule

module  \$_SDFFE_PP0N_ (input D, C, E, R, output Q);
  parameter INIT = 1'b0;
  DFFER #(.INIT(INIT)) _TECHMAP_REPLACE_ (.D(D), .Q(Q), .CLK(C), .CE(~E), .RST(R));
endmodule

module  \$_SDFFE_PP1N_ (input D, C, E, R, output Q);
  parameter INIT = 1'b1;
  DFFER #(.INIT(INIT)) _TECHMAP_REPLACE_ (.D(D), .Q(Q), .CLK(C), .CE(~E), .RST(R));
endmodule

module  \$_SDFFE_PN0P_ (input D, C, E, R, output Q);
  parameter INIT = 1'b0;
  DFFER #(.INIT(INIT)) _TECHMAP_REPLACE_ (.D(D), .Q(Q), .CLK(C), .CE(E), .RST(~R));
endmodule

module  \$_SDFFE_PN1P_ (input D, C, E, R, output Q);
  parameter INIT = 1'b1;
  DFFER #(.INIT(INIT)) _TECHMAP_REPLACE_ (.D(D), .Q(Q), .CLK(C), .CE(E), .RST(~R));
endmodule

module  \$_SDFFE_PN0N_ (input D, C, E, R, output Q);
  parameter INIT = 1'b0;
  DFFER #(.INIT(INIT)) _TECHMAP_REPLACE_ (.D(D), .Q(Q), .CLK(C), .CE(~E), .RST(~R));
endmodule

module  \$_SDFFE_PN1N_ (input D, C, E, R, output Q);
  parameter INIT = 1'b1;
  DFFER #(.INIT(INIT)) _TECHMAP_REPLACE_ (.D(D), .Q(Q), .CLK(C), .CE(~E), .RST(~R));
endmodule

module  \$_SDFF_PP0_ (input D, C, R, output Q);
  parameter INIT = 1'b0;
  DFFER #(.INIT(INIT)) _TECHMAP_REPLACE_ (.D(D), .Q(Q), .CLK(C), .CE(1'b1), .RST(R));
endmodule

module  \$_SDFF_PP1_ (input D, C, R, output Q);
  parameter INIT = 1'b1;
  DFFER #(.INIT(INIT)) _TECHMAP_REPLACE_ (.D(D), .Q(Q), .CLK(C), .CE(1'b1), .RST(R));
endmodule

module  \$_SDFF_PN0_ (input D, C, R, output Q);
  parameter INIT = 1'b0;
  DFFER #(.INIT(INIT)) _TECHMAP_REPLACE_ (.D(D), .Q(Q), .CLK(C), .CE(1'b1), .RST(~R));
endmodule

module  \$_SDFF_PN1_ (input D, C, R, output Q);
  parameter INIT = 1'b1;
  DFFER #(.INIT(INIT)) _TECHMAP_REPLACE_ (.D(D), .Q(Q), .CLK(C), .CE(1'b1), .RST(~R));
endmodule
