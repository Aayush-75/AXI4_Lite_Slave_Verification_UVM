class axi_config extends uvm_object;

    `uvm_object_utils(axi_config)

    function new(string name="axi_config");
        super.new(name);
    endfunction

    virtual axi_if intrf;

    uvm_active_passive_enum ip_agent;
    uvm_active_passive_enum op_agent;

endclass
