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

// Ref: techlibs/xilinx/cells_sim.v
// TODO: update the pin-pin delays

module INV(
    (* clkbuf_inv = "I" *)
    output O,
    input I
);
  assign O = !I;
//  specify
//    (I => O) = 127;
//  endspecify
endmodule

(* abc9_lut=1 *)
module LUT1(output O, input I0);
  parameter [1:0] INIT = 0;
  assign O = I0 ? INIT[1] : INIT[0];
//  specify
//    (I0 => O) = 127;
//  endspecify
endmodule

(* abc9_lut=2 *)
module LUT2(output O, input I0, I1);
  parameter [3:0] INIT = 0;
  wire [ 1: 0] s1 = I1 ? INIT[ 3: 2] : INIT[ 1: 0];
  assign O = I0 ? s1[1] : s1[0];
//  specify
//    (I0 => O) = 238;
//    (I1 => O) = 127;
//  endspecify
endmodule

(* abc9_lut=3 *)
module LUT3(output O, input I0, I1, I2);
  parameter [7:0] INIT = 0;
  wire [ 3: 0] s2 = I2 ? INIT[ 7: 4] : INIT[ 3: 0];
  wire [ 1: 0] s1 = I1 ?   s2[ 3: 2] :   s2[ 1: 0];
  assign O = I0 ? s1[1] : s1[0];
//  specify
//    (I0 => O) = 407;
//    (I1 => O) = 238;
//    (I2 => O) = 127;
//  endspecify
endmodule

(* abc9_lut=4 *)
module LUT4(output O, input I0, I1, I2, I3);
  parameter [15:0] INIT = 0;
  wire [ 7: 0] s3 = I3 ? INIT[15: 8] : INIT[ 7: 0];
  wire [ 3: 0] s2 = I2 ?   s3[ 7: 4] :   s3[ 3: 0];
  wire [ 1: 0] s1 = I1 ?   s2[ 3: 2] :   s2[ 1: 0];
  assign O = I0 ? s1[1] : s1[0];
//  specify
//    (I0 => O) = 472;
//    (I1 => O) = 407;
//    (I2 => O) = 238;
//    (I3 => O) = 127;
//  endspecify
endmodule

(* abc9_lut=5 *)
module LUT5(output O, input I0, I1, I2, I3, I4);
  parameter [31:0] INIT = 0;
  wire [15: 0] s4 = I4 ? INIT[31:16] : INIT[15: 0];
  wire [ 7: 0] s3 = I3 ?   s4[15: 8] :   s4[ 7: 0];
  wire [ 3: 0] s2 = I2 ?   s3[ 7: 4] :   s3[ 3: 0];
  wire [ 1: 0] s1 = I1 ?   s2[ 3: 2] :   s2[ 1: 0];
  assign O = I0 ? s1[1] : s1[0];
//  specify
//    (I0 => O) = 631;
//    (I1 => O) = 472;
//    (I2 => O) = 407;
//    (I3 => O) = 238;
//    (I4 => O) = 127;
//  endspecify
endmodule

(* abc9_lut=6 *)
module LUT6(output O, input I0, I1, I2, I3, I4, I5);
  parameter [63:0] INIT = 0;
  wire [31: 0] s5 = I5 ? INIT[63:32] : INIT[31: 0];
  wire [15: 0] s4 = I4 ?   s5[31:16] :   s5[15: 0];
  wire [ 7: 0] s3 = I3 ?   s4[15: 8] :   s4[ 7: 0];
  wire [ 3: 0] s2 = I2 ?   s3[ 7: 4] :   s3[ 3: 0];
  wire [ 1: 0] s1 = I1 ?   s2[ 3: 2] :   s2[ 1: 0];
  assign O = I0 ? s1[1] : s1[0];
//  specify
//    (I0 => O) = 642;
//    (I1 => O) = 631;
//    (I2 => O) = 472;
//    (I3 => O) = 407;
//    (I4 => O) = 238;
//    (I5 => O) = 127;
//  endspecify
endmodule

module DFF (output q, input  d, clk);
  reg q;
  always @(posedge clk)
    q <= d;
endmodule

// From the CLB team
// This is just a placeholder
(* abc9_box, lib_whitebox *)
module carry_chain # (
  parameter INPUTS=4
) (
  (* abc9_carry *)
  input  [INPUTS-1:0] P,
  input  [INPUTS-1:0] G,
  output [INPUTS-1:0] S,
  input  Ci,
  output Co
);

endmodule

module mac_block #(
  parameter MIN_WIDTH = 8
) (
  input [MIN_WIDTH-1:0] A,
  input [MIN_WIDTH-1:0] B,
  output [4*MIN_WIDTH-1:0] C
);

endmodule

