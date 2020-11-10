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

