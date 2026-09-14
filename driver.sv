class my_driver extends uvm_driver#(seq_item);

    `uvm_component_utils(my_driver)

    axi_config cfg;
    virtual axi_if.drv_mod vif;
    virtual axi_if intrf;

    //deciding active and passive
    bit a_awaddr=1;
    bit a_awvalid=1;
    bit a_wdata=1;
    bit a_strb=1;
    bit a_valid=1;
    bit a_araddr=1;
    bit a_arvalid=1;
    

    function new(string name="my_driver",uvm_component parent=null);
        super.new(name,parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if(!uvm_config_db#(axi_config)::get(this,"","vif",cfg))
            `uvm_fatal(get_type_name(),"CONFIG FILE FATCHING FAILED");
    endfunction

    function void connect_phase(uvm_phase phase);
        vif = cfg.intrf;
        intrf = cfg.intrf;
    endfunction

    task run_phase(uvm_phase phase);
        repeat(2) @(vif.drv_cb);
        forever
        begin
            seq_item_port.get_next_item(req);
            drive();
            seq_item_port.item_done();
            //write address
            if(intrf.AWVALID)
                begin
                    //req.AWADDR.rand_mode(0);
                    //req.AWVALID.rand_mode(0);
		    a_awaddr=0;
		    a_awvalid=0;
                end
            if(intrf.AWVALID && intrf.AWREADY)
                begin
                    //req.AWADDR.rand_mode(1);
                    //req.AWVALID.rand_mode(1);
		    a_awaddr=1;
		    a_awvalid=1;
                end
            //write data
            if(intrf.WVALID)
                begin
                    //req.WDATA.rand_mode(0);
                    //req.WSTRB.rand_mode(0);
                    //req.WVALID.rand_mode(0);
    		    a_wdata=0;
		    a_wstrb=0;
		    a_wvalid=0;
                end
            if(intrf.WVALID && intrf.WREADY)
                begin
                    //req.WDATA.rand_mode(1);
                    //req.WSTRB.rand_mode(1);
                    //req.WVALID.rand_mode(1);
    		    a_wdata=1;
		    a_wstrb=1;
		    a_wvalid=1;
                end
            
            //read address
            if(intrf.ARVALID)
                begin
                    //req.ARADDR.rand_mode(0);
                    //req.ARVALID.rand_mode(0);
		    a_araddr=0;
		    a_arvalid=0;
                end
            if(intrf.ARVALID && intrf.ARREADY)
                begin
                    //req.ARADDR.rand_mode(1);
                    //req.ARVALID.rand_mode(1);
		    a_araddr=1;
		    a_arvalid=1;
                end
            //read data
            if(intrf.RVALID)
                begin
                    //req.ARADDR.rand_mode(0);
                    //req.ARVALID.rand_mode(0);
		    a_araddr=0;
		    a_arvalid=0;
                end
            if(intrf.RVALID && intrf.RREADY)
                begin
                    //req.ARADDR.rand_mode(1);
                    //req.ARVALID.rand_mode(1);
		    a_araddr=1;
		    a_arvalid=1;
                end
            @(vif.drv_cb);
        end
    endtask    

    task drive();
        intrf.AWADDR <= req.AWADDR;
        intrf.AWVALID <= req.AWVALID;
        intrf.WDATA <= req.WDATA;
        intrf.WSTRB <= req.WSTRB;
	intrf.WVALID <= req.WVALID;
        intrf.BREADY <= req.BREADY;
        intrf.ARADDR <= req.ARADDR;
        intrf.ARVALID <= req.ARVALID;
        intrf.RREADY <= req.RREADY;
    endtask

endclass
