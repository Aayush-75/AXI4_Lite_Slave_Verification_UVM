class my_driver extends uvm_driver#(seq_item);

    `uvm_component_utils(my_driver)

    axi_config cfg;
    virtual axi_if.drv_mod vif;
    virtual axi_if intrf;

    function new(string name="my_driver",uvm_component parent=null);
        super.new(name,parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if(!uvm_config_db#(alu_config)::get(this,"","cfg",cfg))
            'uvm_fatal(get_type_name(),"CONFIG FILE FATCHING FAILED");
    endfunction

    function void connect_phase(uvm_phase phase);
        vif = cfg.vif;
        intrf = cfg.vif;
    endfunction

    task run_phase(uvm_phase phase);
        repeat(2) @(vif.drv_cb);
        forever
        begin
            seq_item_port.get_next_item(req);
            drive();
            seq_item_port.finish_item();
            //write address
            if(intrf.AWVALID)
                begin
                    req.AWADDR.rand_mode(0);
                    req.AWVALID.rand_mode(0);
                end
            if(intrf.AWVALID && intrf.AWREADY)
                begin
                    req.AWADDR.rand_mode(1);
                    req.AWVALID.rand_mode(1);
                end
            //write data
            if(intrf.WVALID)
                begin
                    req.WDATA.rand_mode(0);
                    req.WSTRB.rand_mode(0);
                    req.WVALID.rand_mode(0);
                end
            if(intrf.WVALID && intrf.WREADY)
                begin
                    req.WDATA.rand_mode(1);
                    req.WSTRB.rand_mode(1);
                    req.WVALID.rand_mode(1);
                end
            
            //read address
            if(intrf.ARVALID)
                begin
                    req.ARADDR.rand_mode(0);
                    req.ARVALID.rand_mode(0);
                end
            if(intrf.ARVALID && intrf.ARREADY)
                begin
                    req.ARADDR.rand_mode(1);
                    req.ARVALID.rand_mode(1);
                end
            //read data
            if(intrf.RVALID)
                begin
                    req.ARADDR.rand_mode(0);
                    req.ARVALID.rand_mode(0);
                end
            if(intrf.RVALID && intrf.RVALID)
                begin
                    req.ARADDR.rand_mode(1);
                    req.ARVALID.rand_mode(1);
                end
            @(vif.drv_cb);
        end
    endtask    

    task drive();
        intrf.AWADDR <= seq.AWADDR;
        intrf.AWVALID <= seq.AWVALID;
        intrf.WDATA <= seq.WDATA;
        intrf.WSTRB <= seq.WSTRB;
        intrf.BREADY <= seq.BREADY;
        intrf.ARADDR <= seq.ARADDR;
        intrf.ARVALID <= seq.ARVALID;
        intrf.RREADY <= seq.RREADY;
    endtask

endclass
