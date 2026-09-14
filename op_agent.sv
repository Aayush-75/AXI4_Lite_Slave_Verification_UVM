class op_agent extends uvm_agent;

    `uvm_component_utils(op_agent)

    op_mon mon;
    axi_config cfg;

    function new(string name="op_agent",uvm_component parent = null);
        super.new(name,parent);
    endfunction

    function void build_phase(uvm_phase phase);
        if(!uvm_config_db#(axi_config)::get(this,"","vif",cfg))
            `uvm_fatal(get_type_name(),"CONFIG FILE FETCH FAIL")
        if(cfg.op_agent == UVM_PASSIVE)
            mon = op_mon::type_id::create("output_monitor",this);
    endfunction

endclass
