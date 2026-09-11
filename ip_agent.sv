class ip_agent extends uvm_agent;

    `uvm_component_utils(ip_agent)

    my_sequencer sqr;
    my_driver drv;
    ip_mon mon;
    axi_config cfg;

    function new(string name="ip_agent",uvm_component parent = null);
        super.new(name,parent);
    endfunction

    function void build_phase(uvm_phase phase);
        if(!uvm_config_db#(axi_config)::get(this,"","cfg",cfg))
            `uvm_fatal(get_type_name(),"CONFIG FILE FETCH FAIL")
        if(cfg.ip_agent == UVM_ACTIVE)
        begin
            drv = my_driver::type_id::create("driver",this);
            sqr = my_sequencer::type_id::create("sequencer",this);
        end 
        mon = ip_mon::type_id::create("input_monitor",this);
    endfunction

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        drv.seq_item_port.connect(sqr.seq_item_export);
    endfunction

endclass
