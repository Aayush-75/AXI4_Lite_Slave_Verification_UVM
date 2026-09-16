class my_sequence extends uvm_sequence#(seq_item);

    `uvm_object_utils(my_sequence)

    bit a_awaddr=1;
    bit a_awvalid=1;
    bit a_wdata=1;
    bit a_wstrb=1;
    bit a_wvalid=1;
    bit a_araddr=1;
    bit a_arvalid=1;

    seq_item seq;	

    function new(string name="my_sequence");
        super.new(name);
    	seq = seq_item::type_id::create("seq");
    endfunction
    
    task body();
        req = seq_item::type_id::create("req");
        start_item(req);
		if(a_awaddr)
			req.randomize(AWADDR); //with {AWADDR==seq.AWADDR;};
		else
			req.randomize(AWADDR) with {AWADDR==seq.AWADDR;};
		if(a_awvalid)
			req.randomize(AWVALID);
		else
			req.randomize(AWVALID) with {AWVALID==1;};
		if(a_wdata)
			req.randomize(WDATA); //with {WDATA==seq.WDATA;};
		else	
			req.randomize(WDATA) with {WDATA==seq.WDATA;};
		if(a_wstrb)
			req.randomize(WSTRB); //with {WSTRB==seq.WSTRB;};
		else
			req.randomize(WSTRB) with {WSTRB==seq.WSTRB;};
		if(a_wvalid)
			req.randomize(WVALID);
		else
			req.randomize(WVALID) with {WVALID==1;};
		if(a_araddr)
			req.randomize(ARADDR); //with {ARADDR==seq.ARADDR;};
		else	
			req.randomize(ARADDR) with {ARADDR==seq.ARADDR;};
		if(a_arvalid)
			req.randomize(ARVALID);
		else
			req.randomize(ARVALID) with {ARVALID==1;};
        req.randomize(BREADY,RREADY);
	finish_item(req);
	`uvm_info(get_type_name(),$sformatf("[%0t]: awaddr=%0d awvalid=%0d wdata=%0d wstrb=%0d wvalid=%0d araddr=%0d arvalid=%0d",$time,a_awaddr,a_awvalid,a_wdata,a_wstrb,a_wvalid,a_araddr,a_arvalid),UVM_MEDIUM);
	`uvm_info(get_type_name(),$sformatf("[%0t]: AWADDR=%0d AWVALID=%0d WDATA=%0d WSTRB=%0d WVALID=%0d BREADY=%0d ARADDR=%0d ARVALID=%0d RREADY=%0d",$time,req.AWADDR,req.AWVALID,req.WDATA,req.WSTRB,req.WVALID,req.BREADY, req.ARADDR,req.ARVALID,req.RREADY),UVM_MEDIUM);	
	`uvm_info(get_type_name(),$sformatf("[%0t]: AWREADY=%0d WREADY=%0d BRESP=%0d BVALID=%0d ARREADY=%0d RDATA=%0d RRESP=%0d RVALID=%0d",$time,req.AWREADY,req.WREADY,req.BRESP,req.BVALID,req.ARREADY,req.RDATA,req.RRESP,req.RVALID),UVM_MEDIUM); 	
		if(req.AWVALID)
		begin
			//$display("%0t GOT AWVALID",$time);
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
            		a_wvalid=1;
		end
		if(req.ARVALID)
		begin
			a_araddr=0;
            		a_arvalid=0;
			seq.ARADDR=req.ARADDR;
		end
		if(!a_arvalid && req.ARREADY)
		begin
			a_araddr=1;
            		a_arvalid=1;
		end
		//if(req.RVALID)
		//begin
		//	a_araddr=0;
            	//	a_arvalid=0;
		//end
		//if(!a_arvalid && req.RREADY)
		//begin
		//	a_araddr=1;
            	//	a_arvalid=1;
		//end
	//$display("%0t AWVALID=%0d a_awalid=%0d AWREADY=%0d",$time,req.AWVALID,a_awvalid,req.AWREADY);
    endtask

endclass
