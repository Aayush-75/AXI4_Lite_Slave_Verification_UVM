class my_sequence extends uvm_sequence#(seq_item);

    `uvm_object_utils(my_sequence)

    my_driver drv;

    function new(string name="my_sequence");
        super.new(name);
        
    endfunction
    
    task body();
        req = seq_item::type_id::create("req");
        start_item(req);
	if(drv.a_awaddr)
	    req.randomize(req.AWADDR);
	if(drv.a_awvalid)
	    req.randomize(req.AWVALID);
	if(drv.a_wdata)
	    req.randomize(req.WDATA);
	if(drv.a_strb)
	    req.randomize(req.WSTRB);
	if(drv.a_valid)
	    req.randomize(req.WVALID);
	if(drv.a_araddr)
	    req.randomize(req.ARADDR);
	if(drv.a_arvalid)
	    req.randomize(req.ARVALID);
        req.randomize(req.BREADY,req.RREADY);
        finish_item(req);
    endtask

endclass
