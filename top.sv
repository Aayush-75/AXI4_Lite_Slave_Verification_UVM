`include "pkg.sv"
`include "interface.sv" 
`include "ram_dp_ar_aw.sv"
`include "syn_fifo.sv"
`include "checker.sv"	
	

module top;

    import uvm_pkg::*;
	import pkg::*;

    bit clk,rst;

    axi_if DUV_IF(clk,rst);

//left to do signal attaching

    initial
		forever 
		   #10 clk=~clk;

 	initial
	begin
		rst=1;
		@(posedge clk);
		rst=0;
		$display("%0t: RESET ENDED",$time);
	end
 	initial
	begin
		uvm_config_db#(virtual axi_if)::set(null,"*","vif",DUV_IF);
	    run_test("test");
	end	
    
endmoduleN