class my_sequence extends uvm_sequence#(seq_item);

    `uvm_object_utils(my_sequence)

	bit a_awaddr=1;
    bit a_awvalid=1;
    bit a_wdata=1;
    bit a_wstrb=1;
    bit a_wvalid=1;
    bit a_araddr=1;
    bit a_arvalid=1;

    function new(string name="my_sequence");
        super.new(name);
        
    endfunction
    
    task body();
        req = seq_item::type_id::create("req");
        start_item(req);
		if(a_awaddr)
			req.randomize(AWADDR);
		if(a_awvalid)
			req.randomize(AWVALID);
		if(a_wdata)
			req.randomize(WDATA);
		if(a_wstrb)
			req.randomize(WSTRB);
		if(a_wvalid)
			req.randomize(WVALID);
		if(a_araddr)
			req.randomize(ARADDR);
		if(a_arvalid)
			req.randomize(ARVALID);
        req.randomize(BREADY,RREADY);
        finish_item(req);
		
		if(req.AWVALID)
		begin
			a_awaddr=0;
            a_awvalid=0;	
		end
		if(req.AWVALID && req.AWREADY)
		begin
			a_awaddr=1;
            a_awvalid=1;	
		end
		if(req.WVALID)
		begin
			a_wdata=0;
            a_wstrb=0;
            a_wvalid=0;
		end
		if(req.WVALID && req.WREADY)
		begin
			a_wdata=1;
            a_wstrb=1;
            a_wvalid=1;
		end
		if(req.ARVALID)
		begin
			a_araddr=0;
            a_arvalid=0;
		end
		if(req.ARVALID && req.ARREADY)
		begin
			a_araddr=1;
            a_arvalid=1;
		end
		if(req.RVALID)
		begin
			a_araddr=0;
            a_arvalid=0;
		end
		if(req.RVALID && req.RREADY)
		begin
			a_araddr=1;
            a_arvalid=1;
		end
    endtask

endclass
