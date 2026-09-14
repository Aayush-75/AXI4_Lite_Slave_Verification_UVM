`include "define.sv"

class seq_item extends uvm_sequence_item;

    `uvm_object_utils(seq_item)

    function new(string name="");
    	super.new(name);
    endfunction

    //write address chanel 
    //m->s
    rand bit [`ADDR_WIDTH-1:0] AWADDR;
    rand bit AWVALID;
    //s->m
    bit AWREADY;

    //write data channel
    //m->s
    rand bit [`DATA_WIDTH-1:0] WDATA;
    rand bit [`STRB_WIDTH-1:0] WSTRB;
    rand bit WVALID;
    //s->m
    bit WREADY;

    //write response channel
    //m->s
    rand bit BREADY;
    //s->m
    bit [`RESP_WIDTH-1:0] BRESP;
    bit BVALID;

    //read address channel
    //m->s 
    rand bit [`ADDR_WIDTH-1:0] ARADDR;
    rand bit ARVALID;
    //s->m
    bit ARREADY;

    //read data channel
    //m->s
    rand bit RREADY;
    //s->m
    bit [`RESP_WIDTH-1:0] RRESP;
    bit [`DATA_WIDTH-1:0] RDATA;
    bit RVALID;

endclass

class seq1 extends seq_item;

    `uvm_object_utils(seq1)
    
    function new(string name="");
    	super.new(name);
    endfunction

//    constraint c
//	{
//		solve AWVALID,WVALID,RREADY,BREADY,ARVALID before AWADDR,WDATA,WSTRB,ARADDR;
//	}

    constraint c1  //for write channel
    {
	AWADDR == 4;
	ARADDR == 4;
	AWVALID == 1;
	WSTRB == 4'b1111;
	WVALID == 1;	
	BREADY == 1;
	ARVALID == 1;
	RREADY == 1;
	
        //write channel constraint
        //AWVALID dist
        //{
        //    0 := 9,
        //    1 := 1
        //};
        //WVALID dist
        //{
        //    0 := 13,
        //    1 := 1
        //};
        //after this wait for BVALID in driver and when BVALID comes send BREADY 

        //read channel constraint 
        //ARVALID dist
        //{
        //    0 := 5,
        //    1 := 1
        //};
        //after this wait for RVALID in driver and when RVALID comes send RREADY
    }
endclass

class seq2 extends seq_item;

    `uvm_object_utils(seq2)

    function new(string name="");
    	super.new(name);
    endfunction

    constraint c1  //for write channel
    {
        //write channel constraint
        AWVALID dist
        {
            0 := 13,
            1 := 1
        };
        WVALID dist
        {
            0 := 9,
            1 := 1
        };
        //after this wait for BVALID in driver and when BVALID comes send BREADY 

        //read channel constraint 
        ARVALID dist
        {
            0 := 13,
            1 := 1
        };
        //after this wait for RVALID in driver and when RVALID comes send RREADY
    }
endclass

class seq3 extends seq_item;

    `uvm_object_utils(seq3)

    function new(string name="");
    	super.new(name);
    endfunction
    
    constraint c1  //for write channel
    {
        //write channel constraint
        AWVALID dist
        {
            0 := 4,
            1 := 1
        };
        WVALID dist
        {
            0 := 13,
            1 := 1
        };
        //after this wait for BVALID in driver and when BVALID comes send BREADY 

        //read channel constraint 
        ARVALID dist
        {
            0 := 13,
            1 := 1
        };
        //after this wait for RVALID in driver and when RVALID comes send RREADY
    }
endclass

class seq4 extends seq_item;

    `uvm_object_utils(seq4)

    function new(string name="");
    	super.new(name);
    endfunction

    constraint c1  //for write channel
    {
        //write channel constraint
        AWVALID dist
        {
            0 := 13,
            1 := 1
        };
        WVALID dist
        {
            0 := 4,
            1 := 1
        };
        //after this wait for BVALID in driver and when BVALID comes send BREADY 

        //read channel constraint 
        ARVALID dist
        {
            0 := 5,
            1 := 1
        };
        //after this wait for RVALID in driver and when RVALID comes send RREADY
    }
endclass
