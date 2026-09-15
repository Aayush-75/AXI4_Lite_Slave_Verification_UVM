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
			req.randomize(req.AWADDR);
		if(a_awvalid)
			req.randomize(req.AWVALID);
		if(a_wdata)
			req.randomize(req.WDATA);
		if(a_wstrb)
			req.randomize(req.WSTRB);
		if(a_wvalid)
			req.randomize(req.WVALID);
		if(a_araddr)
			req.randomize(req.ARADDR);
		if(a_arvalid)
			req.randomize(req.ARVALID);
        req.randomize(req.BREADY,req.RREADY);
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
