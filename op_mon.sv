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
        if(!uvm_config_db#(axi_config)::get(this,"","vif",cfg))
            `uvm_fatal(get_type_name(),"CONFIG FETCHING FAILED")
        op_analysis_port = new("op_analysis_port",this);
    endfunction

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        intrf  = cfg.intrf;
    endfunction

    task run_phase(uvm_phase phase);
        repeat(4) @(intrf.op_cb);
        forever
        begin
            seq = seq_item::type_id::create("seq");
            seq.AWREADY = intrf.op_cb.AWREADY;
            seq.WREADY = intrf.op_cb.WREADY;
            //`uvm_info(get_type_name(),$sformatf("[%0t]: DUT: AWREADY=%0d AWREADY=%0d",$time,intrf.op_cb.AWREADY,seq.AWREADY),UVM_MEDIUM);
            seq.BRESP = intrf.op_cb.BRESP;
            seq.BVALID = intrf.op_cb.BVALID;
            seq.ARREADY = intrf.op_cb.ARREADY;
            seq.RDATA = intrf.op_cb.RDATA;
            seq.RRESP = intrf.op_cb.RRESP;
            seq.RVALID = intrf.op_cb.RVALID;
            //`uvm_info(get_type_name(),$sformatf("[%0t]: op_mon: AWREADY=%0d WREADY=%0d BRESP=%0d BVALID=%0d ARREADY=%0d RDATA=%0d RRESP=%0d RVALID=%0d",$time,seq.AWREADY,seq.WREADY,seq.BRESP,seq.BVALID,seq.ARREADY,seq.RDATA,seq.RRESP,seq.RVALID),UVM_MEDIUM);
	    op_analysis_port.write(seq);
            @(intrf.op_cb);
        end
    endtask

endclass
