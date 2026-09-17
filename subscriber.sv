class my_coverage extends uvm_subscriber#(seq_item);

	`uvm_component_utils(my_coverage)

	seq_item seq;
	
	covergroup cg;
	c1: coverpoint seq.AWADDR;
	c2: coverpoint seq.AWVALID;
	c3: coverpoint seq.WVALID;
	c4: coverpoint seq.WSTRB;
	c5: coverpoint seq.WDATA
	{
		option.auto_bin_max = 1;
	}

	c6: coverpoint seq.ARADDR;
	c7: coverpoint seq.ARVALID;
	
	c8: cross c1,c2;
	c9: cross c4,c3;

	c10: cross c6,c7;
	endgroup

	function new(string name="my_coverage",uvm_component parent=null);
		super.new(name,parent);
		cg = new;
	endfunction

	function void write(seq_item t);
		seq = t;
		cg.sample();		
	endfunction

endclass
