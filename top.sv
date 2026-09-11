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

	dut d1(.ACLK(clk), .ARESETn(rst), .AWADDR(vif.AWADDR), .AWPROT(3'b000), .AWVALID(vif.AWVALID), .AWREADY(vif.AWREADY), .WDATA(vif.WDATA), .WSTRB(vif.WSTRB), .WVALID(vif.WVALID), .WREADY(vif.WREADY), .BRESP(vif.BRESP), .BVALID(vif.BVALID), .BREADY(vif.BREADY), .ARADDR(vif.ARADDR), .ARPROT(3'b000), .ARVALID(vif.ARVALID), .ARREADY(vif.ARREADY), .RDATA(vif.RDATA), .RRESP(vif.RRESP), .RVALID(vif.RVALID), .RREADY(vif.RREADY));

    initial
		forever 
		   #10 clk=~clk;

 	initial
	begin
		rst=0;
		@(posedge clk);
		rst=1;
		$display("%0t: RESET ENDED",$time);
	end
 	initial
	begin
		uvm_config_db#(virtual axi_if)::set(null,"*","vif",DUV_IF);
	    run_test("test");
	end	
    
endmodule
