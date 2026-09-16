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
    	seq = seq_item::type_id::create("seq");
    endfunction
    
    task body();
        req = seq_item::type_id::create("req");
        start_item(req);
		if(a_awaddr)
			req.randomize(AWADDR == seq.AWADDR);
		if(a_awvalid)
			req.randomize(AWVALID);
		if(a_wdata)
			req.randomize(WDATA == seq.WDATA);
		if(a_wstrb)
			req.randomize(WSTRB == seq.WSTRB);
		if(a_wvalid)
			req.randomize(WVALID);
		if(a_araddr)
			req.randomize(ARADDR == seq.ARADDR);
		if(a_arvalid)
			req.randomize(ARVALID);
        req.randomize(BREADY,RREADY);
	finish_item(req);
	`uvm_info(get_type_name(),$sformatf("[%0t]: awaddr=%0d awvalid=%0d wdata=%0d wstrb=%0d wvalid=%0d araddr=%0d arvalid=%0d",$time,a_awaddr,a_awvalid,a_wdata,a_wstrb,a_wvalid,a_araddr,a_arvalid),UVM_MEDIUM);
	//`uvm_info(get_type_name(),$sformatf("[%0t]: AWREADY=%0d WREADY=%0d BRESP=%0d BVALID=%0d ARREADY=%0d RDATA=%0d RRESP=%0d RVALID=%0d",$time,req.AWREADY,req.WREADY,req.BRESP,req.BVALID,req.ARREADY,req.RDATA,req.RRESP,req.RVALID),UVM_MEDIUM); 	
		if(req.AWVALID)
		begin
			a_awaddr=0;
			seq.AWADDR=req.AWADDR;
            		a_awvalid=0;	
		end
		if(!a_awvalid && req.AWREADY)
		begin
			a_awaddr=1;
            		a_awvalid=1;	
		end
		if(req.WVALID)
		begin
			a_wdata=0;
            		a_wstrb=0;
            		a_wvalid=0;
			seq.WDATA=req.WDATA;
			seq.WSTRB=req.WSTRB;
		end
		if(!a_wvalid && req.WREADY)
		begin
			a_wdata=1;
            		a_wstrb=1;
            i		a_wvalid=1;
		end
		if(req.ARVALID)
		begin
			a_araddr=0;
            		a_arvalid=0;
			seq.ARADDR==req.ARADDR;
		end
		if(!a_arvalid && req.ARREADY)
		begin
			a_araddr=1;
            		a_arvalid=1;
		end
		if(req.RVALID)
		begin
			a_araddr=0;
            		a_arvalid=0;
		end
		if(!a_arvalid && req.RREADY)
		begin
			a_araddr=1;
            		a_arvalid=1;
		end
    endtask

endclass
