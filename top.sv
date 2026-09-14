`include "pkg.sv"
`include "interface.sv" 
`include "dut.sv"
//`include "checker.sv"	
	

module top;

    import uvm_pkg::*;
	import pkg::*;

    bit clk,rst;

    axi_if DUV_IF(clk,rst);

    axi4_lite_slave#(
    .ADDR_WIDTH(`ADDR_WIDTH),
    .DATA_WIDTH(`DATA_WIDTH)
    ) d1 (
    .ACLK    (clk), 
    .ARESETn (rst), 
    .AWADDR  (DUV_IF.AWADDR),   
    .AWPROT  (3'b000), 
    .AWVALID (DUV_IF.AWVALID), 
    .AWREADY (DUV_IF.AWREADY), 
    .WDATA   (DUV_IF.WDATA), 
    .WSTRB   (DUV_IF.WSTRB), 
    .WVALID  (DUV_IF.WVALID), 
    .WREADY  (DUV_IF.WREADY), 
    .BRESP   (DUV_IF.BRESP), 
    .BVALID  (DUV_IF.BVALID), 
    .BREADY  (DUV_IF.BREADY), 
    .ARADDR  (DUV_IF.ARADDR), 
    .ARPROT  (3'b000), 
    .ARVALID (DUV_IF.ARVALID), 
    .ARREADY (DUV_IF.ARREADY), 
    .RDATA   (DUV_IF.RDATA), 
    .RRESP   (DUV_IF.RRESP), 
    .RVALID  (DUV_IF.RVALID), 
    .RREADY  (DUV_IF.RREADY)
    );

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
