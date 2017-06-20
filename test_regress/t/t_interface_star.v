// DESCRIPTION: Verilator: Verilog Test module
//
// This file ONLY is placed into the Public Domain, for any use,
// without warranty, 2017 by Wilson Snyder.

module t (/*AUTOARG*/
   // Inputs
   clk
   );

   input clk;
   integer cyc=1;

   counter_io c_data();

   counter_ansi c1 (.clk, .*);

   always @ (posedge clk) begin
      cyc <= cyc + 1;
      if (cyc==20) begin
	 if (c_data.value != 12345) $stop;
	 $write("*-* All Finished *-*\n");
	 $finish;
      end
   end
endmodule

interface counter_io;
  integer value;
endinterface

module counter_ansi
  (
   input clk,
   counter_io c_data
   );

   always_ff @ (posedge clk) begin
      c_data.value <= 12345;
   end
endmodule : counter_ansi
