class ip_mon extends uvm_monitor;

    `uvm_component_utils(ip_mon)

    seq_item seq;
    virtual axi_if.ip_mod intrf;
    uvm_analysis_port#(seq_item) ip_analysis_port;
    axi_config cfg;

    function new(string name = "ip_mon", uvm_component parent);
        super.new(name,parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if(!uvm_config_db#(axi_config)::get(this,"","vif",cfg))
            `uvm_fatal(get_type_name(),"CONFIG FETCHING FAILED")
        ip_analysis_port = new("ip_analysis_port",this);
    endfunction

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        intrf  = cfg.intrf;
    endfunction

    task run_phase(uvm_phase phase);
        repeat(3) @(intrf.ip_cb);
        forever
        begin
            seq = seq_item::type_id::create("seq");
            seq.AWADDR = intrf.ip_cb.AWADDR;
            seq.AWVALID = intrf.ip_cb.AWVALID;
            seq.WDATA = intrf.ip_cb.WDATA;
            seq.WSTRB = intrf.ip_cb.WSTRB;
	    seq.WVALID = intrf.ip_cb.WVALID;
            seq.BREADY = intrf.ip_cb.BREADY;
            seq.ARADDR = intrf.ip_cb.ARADDR;
            seq.ARVALID = intrf.ip_cb.ARVALID;
            seq.RREADY = intrf.ip_cb.RREADY;
            `uvm_info(get_type_name(),$sformatf("[%0t]: INPUT: AWADDR=%0d AWVALID=%0d WDATA=%0d WSTRB=%0d WVALID=%0d BREADY=%0d ARADDR=%0d ARVALID=%0d RREADY=%0d",$time,seq.AWADDR,seq.AWVALID,seq.WDATA,seq.WSTRB,seq.WVALID,seq.BREADY, seq.ARADDR,seq.ARVALID,seq.RREADY),UVM_MEDIUM);
	    ip_analysis_port.write(seq);
            @(intrf.ip_cb);
        end
    endtask

endclass
