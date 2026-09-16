class test extends uvm_test;

    `uvm_component_utils(test)
    
    axi_config my_config;
    my_sequence seq;
    environment env;
    
    function new(string name="test",uvm_component parent = null);
        super.new(name,parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
	    my_config = axi_config::type_id::create("my_config");
        if(!uvm_config_db#(virtual axi_if)::get(this,"","vif",my_config.intrf))
            `uvm_fatal(get_type_name(),"FAILED TO GET CONFIG FILE");
        env = environment::type_id::create("env",this);
        my_config.ip_agent = UVM_ACTIVE;
        my_config.op_agent = UVM_PASSIVE;
	uvm_config_db#(axi_config)::set(this,"*","vif",my_config);
    endfunction

    function void end_of_elaboration_phase(uvm_phase phase);
        super.end_of_elaboration_phase(phase);
        uvm_top.print_topology();
    endfunction

    task run_phase(uvm_phase phase);
        phase.raise_objection(this);
        seq = my_sequence::type_id::create("seq");
        seq_item::type_id::set_type_override(seq1::get_type());
        repeat(200) seq.start(env.ia.sqr);
        //seq_item::type_id::set_type_override(seq2::get_type());
        //repeat(100) seq.start(env.ia.sqr);
        //seq_item::type_id::set_type_override(seq1::get_type());
        //repeat(50) seq.start(env.ia.sqr);
        //seq_item::type_id::set_type_override(seq3::get_type());
        //repeat(50) seq.start(env.ia.sqr);
	#30ns;
        phase.drop_objection(this);
    endtask
endclass
