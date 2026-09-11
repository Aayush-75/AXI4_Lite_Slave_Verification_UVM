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
        if(!uvm_config_db#(axi_config)::get(this,"","cfg",cfg))
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
            seq = seq_item::create("seq");
            seq.AWADDR = intrf.AWADDR;
            seq.AWVALID = intrf.AWVALID;
            seq.WDATA = intrf.WDATA;
            seq.WSTRB = intrf.WSTRB;
            seq.BREADY = intrf.BREADY;
            seq.ARADDR = intrf.ARADDR;
            seq.ARVALID = intrf.ARVALID;
            seq.RREADY = intrf.RREADY;
            @(intrf.ip_cb);
        end
    endtask

endclass
