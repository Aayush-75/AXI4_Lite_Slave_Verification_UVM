class my_sequence extends uvm_sequence#(seq_item);

    `uvm_object_utils(my_sequence)

    function new(string name="my_sequence",uvm_component parent=null);
        super.new(name,parent);
        req = seq_item::type_id::create("req");
    endfunction
    
    task body();
        start_item(req);
        if(!req.randomize());
            `uvm_fatal(get_type_name(),"RANDOMIZATION FAILED");
        finish_item(req);
    endtask

endclass
