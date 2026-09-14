`include "define.sv"

interface axi_if(input clk,rst);

    //write address chanel 
    //m->s
    bit [`ADDR_WIDTH-1:0] AWADDR;
    bit AWVALID;
    //s->m
    bit AWREADY;

    //write data channel
    //m->s
    bit [`DATA_WIDTH-1:0] WDATA;
    bit [`STRB_WIDTH-1:0] WSTRB;
    bit WVALID;
    //s->m
    bit WREADY;

    //write response channel
    //m->s
    bit BREADY;
    //s->m
    bit [`RESP_WIDTH-1:0] BRESP;
    bit BVALID;

    //read address channel
    //m->s 
    bit [`ADDR_WIDTH-1:0] ARADDR;
    bit ARVALID;
    //s->m
    bit ARREADY;

    //read data channel
    //m->s
    bit RREADY;
    //s->m
    bit [`RESP_WIDTH-1:0] RRESP;
    bit [`DATA_WIDTH-1:0] RDATA;
    bit RVALID;

    clocking drv_cb @(posedge clk);
        default input #1 output #1;
        output AWADDR,AWVALID,WDATA,WSTRB,WVALID,BREADY,ARADDR,ARVALID,RREADY;
    endclocking 

    clocking ip_cb @(posedge clk);
        default input #1 output #1;
        input AWADDR,AWVALID,WDATA,WSTRB,WVALID,BREADY,ARADDR,ARVALID,RREADY;
    endclocking 

    clocking op_cb @(posedge clk);
        default input #1 output #1;
        input AWREADY,WREADY,BRESP,BVALID,ARREADY,RRESP,RDATA,RVALID;
    endclocking 

    modport drv_mod(clocking drv_cb, input clk,rst);
    modport ip_mod(clocking ip_cb, input clk,rst);
    modport op_mod(clocking op_cb, input clk,rst);

endinterface
