class op_mon extends uvm_monitor;

    `uvm_component_utils(op_mon)

    seq_item seq;
    virtual axi_if.op_mod intrf;
    uvm_analysis_port#(seq_item) op_analysis_port;
    axi_config cfg;

    function new(string name = "op_mon", uvm_component parent);
        super.new(name,parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if(!uvm_config_db#(axi_config)::get(this,"","cfg",cfg))
            `uvm_fatal(get_type_name,"CONFIG FETCHING FAILED")
        op_analysis_port = new("op_analysis_port",this);
    endfunction

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        intrf  = cfg.intrf;
    endfunction

    task run_phase(uvm_phase phase);
        repeat(4) @(intrf.ip_cb);
        forever
        begin
            seq = seq_item::create("seq",this);
            seq.AWREADY = intrf.AWREADY;
            seq.WREADY = intrf.WREADY;
            seq.BRESP = intrf.BRESP;
            seq.BVALID = intrf.BVALID;
            seq.ARREADY = intrf.ARREADY;
            seq.RDATA = intrf.RDATA;
            seq.RRESP = intrf.RRESP;
            seq.RVALID = intrf.RVALID;
            @(intrf.ip_cb);
        end
    endtask

endclass