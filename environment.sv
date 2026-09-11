class environment extends uvm_env;

    `uvm_component_utils(environment)

    ip_agent ia;
    op_agent oa;
    scoreboard scb;  
 
    function new(string name="environment",uvm_component parent = null);
        super.new(name,parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        ia = ip_agent::type_id::create("ip_agent",this);
        oa = op_agent::type_id::create("op_agent",this);
        scb = my_scb::type_id::create("scb",this);
    endfunction

    function void connect_phase(uvm_phase phase);
        ia.mon.ip_analysis_port.connect(scb.ip_fifo.analysis_export);
        oa.mon.op_analysis_port.connect(scb.op_fifo.analysis_export);
    endfunction
    
endclass
