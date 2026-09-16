`include "define.sv"

class scoreboard extends uvm_scoreboard;

    `uvm_component_utils(scoreboard)

    seq_item i_seq;
    seq_item o_seq;
    
    seq_item ref_var;
 
    uvm_tlm_analysis_fifo#(seq_item) ip_fifo;
    uvm_tlm_analysis_fifo#(seq_item) op_fifo;

    bit [`DATA_WIDTH-1:0]mem[`DEPTH];
    // bit [`ADDR_WIDTH-1:0]add;
    // bit [`DATA_WIDTH-1:0]data;
    // bit [`DATA_WIDTH-1:0]strb_mask;
    // bit [`RESP_WIDTH-1:0]rsp;

    bit busy_wa;
    bit busy_wd;
    bit busy_wr;
    bit busy_ra;
    bit busy_rd;

    bit first_wa;
    bit first_wd;
    bit first_wr;
    bit first_ra;
    bit first_rd;

    longint PASS,FAIL;
    //longint FC,SC;

    function new(string name="scoreboard",uvm_component parent=null);
        super.new(name,parent);
        ip_fifo = new("ip_fifo",this);
        op_fifo = new("op_fifo",this);
	ref_var = new("seq");
    endfunction

    task run_phase(uvm_phase phase);
        forever 
        begin
            op_fifo.get(o_seq);
            ip_fifo.get(i_seq);
            ref_task();
            chekkk();
        end
    endtask

    task ref_task();
            //read
	    //$display("ARVALID=%0d ARREADY=%0d",i_seq.ARVALID,o_seq.ARREADY);
	    //$display("RVALID%0d RREADY%0d",o_seq.RVALID,i_seq.RREADY);
            if(i_seq.ARVALID && !first_ra)
            begin
                busy_ra = 1;
            end
            if(busy_ra && !first_ra)
            begin
		//$display("first_Ra=%0d Busy_ra=%0d",first_ra,busy_ra);
		//$display("%0t got address %0d",$time,i_seq.ARADDR);
                ref_var.ARADDR = i_seq.ARADDR;
                first_ra = 1;
            end
            if(i_seq.ARVALID && o_seq.ARREADY)
            begin
                busy_ra = 0;
		//$display("Channel Free");
            end

            if(o_seq.RVALID)
            begin
		//$display("Inside 5th channel");
		//$display("first_Ra=%0d Busy_ra=%0d",first_ra,busy_ra);
                busy_rd = 1;
                if(first_ra && busy_ra==0)
                begin
		    //$display("Figuring out resp");
                    if(((ref_var.ARADDR%4)==0) && (ref_var.ARADDR inside {[0:47],[60:63]}))
                        begin
                            ref_var.RDATA = mem[ref_var.ARADDR];
                            ref_var.RRESP = 0;
                        end
                    else if(!(ref_var.ARADDR inside {[0:63]}))
                        begin
                            ref_var.RRESP = 3;
                        end
                    else
                        begin
                            ref_var.RRESP = 2;
                        end
                end
            end
            if(o_seq.RVALID && i_seq.RREADY && first_ra && busy_ra==0)
            begin
                busy_rd = 0;
                first_rd = 0;
                first_ra = 0;
            end


            //write
            if(i_seq.AWVALID)
            begin
                busy_wa = 1;
            end
            if(busy_wa && !first_wa)
            begin
                ref_var.AWADDR = i_seq.AWADDR;
                first_wa = 1;
            end
            if(i_seq.AWVALID && o_seq.AWREADY)
            begin
                busy_wa = 0;
            end

            if(i_seq.WVALID)
            begin
                busy_wd = 1;
            end
            if(busy_wd && !first_wd)
            begin
                ref_var.WDATA = i_seq.WDATA;
                ref_var.WSTRB = i_seq.WSTRB;
                first_wd = 1;
            end
            if(i_seq.WVALID && o_seq.WREADY)
            begin
                busy_wd = 0;
            end

            if(first_wa && first_wd && busy_wa==0 &&& busy_wd==0)
            begin
                if(((ref_var.AWADDR%4)==0) && (ref_var.AWADDR inside {[0:39],[52:63]}))
                begin
                    mem[ref_var.AWADDR] = ({{8{ref_var.WSTRB[3]}},{8{ref_var.WSTRB[2]}},{8{ref_var.WSTRB[1]}},{8{ref_var.WSTRB[0]}}}) & (ref_var.WDATA);
                    // ref_var.BRESP = 0;
                    // ref_var.BVALID = 1;
                end
                // else if(!(ref_var.AWADDR inside {[0:63]}))
                // begin
                //     ref_var.BRESP = 3;
                //     ref_var.BVALID = 1;
                // end
                // else
                // begin
                //     ref_var.BRESP = 2;
                //     ref_var.BVALID = 1;
                // end
            end

            if(o_seq.BVALID && first_wa && first_wd)
            begin
                busy_wr = 1;
                if(((ref_var.AWADDR%4)==0) && (ref_var.AWADDR inside {[0:39],[52:63]}))
                    begin
                        ref_var.BRESP = 0;
                        //ref_var.BVALID = 1;
                    end
                else if(!(ref_var.AWADDR inside {[0:63]}))
                    begin
                        ref_var.BRESP = 3;
                        //ref_var.BVALID = 1;
                    end
                else
                    begin
                        ref_var.BRESP = 2;
                        //ref_var.BVALID = 1;
                    end
            end
            if(busy_wr && !first_wr)
            begin
                first_wr = 1;
            end
            if(o_seq.BVALID && i_seq.BREADY)
            begin
                busy_wr = 0;
                first_wr = 0;
                first_wa = 0;
                first_wd = 0;
            end
    endtask

    task chekkk();
        //if(ref_var.BRESP && ref_var.ARADDR && ref_var.RDATA && ref_var.RRESP)

        // if(o_seq.BVALID)
        // begin
        //     if(ref_var.BRESP == o_seq.BRESP)
        //     begin
        //     end
        //     else 
        //     begin
        //         FC++;    
        //     end
        // end
        // if(o_seq.RVALID)
        // begin
        //     if(o_seq.RDATA == ref_var.RDATA && o_seq.RRESP == ref_var.RRESP)
        //     begin
        //     end
        //     else 
        //     begin
        //         SC++;    
        //     end
        // end

        // if((FC!=0) || (SC!=0))
        // begin
        //     FAIL++;
        //     FC=0;
        //     SC=0;
        //     $display("-------------------FAIL:[%0d]---------------------------",FAIL);
        //     `uvm_info(get_type_name(),$sformatf("[%0t]: INPUT: AWADDR=%0d AWVALID=%0d WDATA=%0d WSTRB=%0d WVALID=%0d ARADDR=%0d ARVALID=%0d RREAD=%0d",$time,i_Seq.AWADDR,i_Seq.AWVALID,i_Seq.WDATA,i_Seq.WSTRB,i_Seq.WVALID,i_seq.ARADDR,i_seq.ARVALID,i_seq.RREAD),UVM_MEDIUM);
        //     `uvm_info(get_type_name(),$sformatf("[%0t]: REF: WRITE_RESPONSE=%0d READ_DATA=%0d READ_RESPONSE=%0d",$time,ref_var.BRESP,ref_var.RDATA,ref_var.RRESP),UVM_MEDIUM);
        //     `uvm_info(get_type_name(),$sformatf("[%0t]: DUT: WRITE_RESPONSE=%0d READ_DATA=%0d READ_RESPONSE=%0d",$time,o_seq.BRESP,o_seq.RDATA,o_seq.RRESP),UVM_MEDIUM);
        //     $display("");  
        // end
        // else 
        // begin
        //     PASS++;  
        //     $display("-------------------PASS:[%0d]---------------------------",PASS);
        //     `uvm_info(get_type_name(),$sformatf("[%0t]: INPUT: AWADDR=%0d AWVALID=%0d WDATA=%0d WSTRB=%0d WVALID=%0d ARADDR=%0d ARVALID=%0d RREAD=%0d",$time,i_Seq.AWADDR,i_Seq.AWVALID,i_Seq.WDATA,i_Seq.WSTRB,i_Seq.WVALID,i_seq.ARADDR,i_seq.ARVALID,i_seq.RREAD),UVM_MEDIUM);
        //     `uvm_info(get_type_name(),$sformatf("[%0t]: REF: WRITE_RESPONSE=%0d READ_DATA=%0d READ_RESPONSE=%0d",$time,ref_var.BRESP,ref_var.RDATA,ref_var.RRESP),UVM_MEDIUM);
        //     `uvm_info(get_type_name(),$sformatf("[%0t]: DUT: WRITE_RESPONSE=%0d READ_DATA=%0d READ_RESPONSE=%0d",$time,o_seq.BRESP,o_seq.RDATA,o_seq.RRESP),UVM_MEDIUM);
        //     $display("");  
        // end

        if(o_seq.BRESP == ref_var.BRESP && o_seq.RDATA == ref_var.RDATA && o_seq.RRESP == ref_var.RRESP)
        begin
            PASS++;  
            $display("-------------------PASS:[%0d]---------------------------",PASS);
            //`uvm_info(get_type_name(),$sformatf("[%0t]: INPUT: AWADDR=%0d AWVALID=%0d AWREADY=%0d WDATA=%0d WSTRB=%0d WVALID=%0d WREADY=%0d BVALID=%0d BREADY=%0d ARADDR=%0d ARVALID=%0d ARREADY=%0d RVALID=%0d RREADY=%0d",$time,i_seq.AWADDR,i_seq.AWVALID,i_seq.WDATA,i_seq.WSTRB,i_seq.WVALID,i_seq.ARADDR,i_seq.ARVALID,i_seq.RREADY),UVM_MEDIUM);
	    //`uvm_info(get_type_name(),$sformatf("[%0t] INPUT",$time),UVM_MEDIUM);
	    //`uvm_info(get_type_name(),$sformatf("AWVALID=%0d AWREADY=%0d AWADDR=%0d",i_seq.AWVALID,o_seq.AWREADY,i_seq.AWADDR),UVM_MEDIUM);
	    //`uvm_info(get_type_name(),$sformatf("WVALID =%0d WREADY =%0d WDATA=%0d WSTRB=%0d",i_seq.WVALID,o_seq.WREADY,i_seq.WDATA,i_seq.WSTRB),UVM_MEDIUM);
	    //`uvm_info(get_type_name(),$sformatf("BVALID =%0d BREADY =%0d",o_seq.BVALID,i_seq.BREADY),UVM_MEDIUM);
	    //`uvm_info(get_type_name(),$sformatf("ARVALID=%0d ARREADY=%0d ARADDR=%0d",i_seq.ARVALID,o_seq.ARREADY,i_seq.ARADDR),UVM_MEDIUM);
	    //`uvm_info(get_type_name(),$sformatf("RVALID =%0d RREADY =%0d",o_seq.RVALID,i_seq.RREADY),UVM_MEDIUM);            
	    //`uvm_info(get_type_name(),$sformatf("[%0t]: REF: WRITE_RESPONSE=%0d READ_DATA=%0d READ_RESPONSE=%0d",$time,ref_var.BRESP,ref_var.RDATA,ref_var.RRESP),UVM_MEDIUM);
            //`uvm_info(get_type_name(),$sformatf("[%0t]: DUT: WRITE_RESPONSE=%0d READ_DATA=%0d READ_RESPONSE=%0d",$time,o_seq.BRESP,o_seq.RDATA,o_seq.RRESP),UVM_MEDIUM);
            $display("");  
        end
        else 
        begin
            FAIL++;
            $display("-------------------FAIL:[%0d]---------------------------",FAIL);
            //`uvm_info(get_type_name(),$sformatf("[%0t]: INPUT: AWADDR=%0d AWVALID=%0d WDATA=%0d WSTRB=%0d WVALID=%0d ARADDR=%0d ARVALID=%0d RREAD=%0d",$time,i_seq.AWADDR,i_seq.AWVALID,i_seq.WDATA,i_seq.WSTRB,i_seq.WVALID,i_seq.ARADDR,i_seq.ARVALID,i_seq.RREADY),UVM_MEDIUM);
	    //`uvm_info(get_type_name(),$sformatf("[%0t] INPUT",$time),UVM_MEDIUM);
	    //`uvm_info(get_type_name(),$sformatf("AWVALID=%0d AWREADY=%0d AWADDR=%0d",i_seq.AWVALID,o_seq.AWREADY,i_seq.AWADDR),UVM_MEDIUM);
	    //`uvm_info(get_type_name(),$sformatf("WVALID =%0d WREADY =%0d WDATA=%0d WSTRB=%0d",i_seq.WVALID,o_seq.WREADY,i_seq.WDATA,i_seq.WSTRB),UVM_MEDIUM);
	    //`uvm_info(get_type_name(),$sformatf("BVALID =%0d BREADY =%0d",o_seq.BVALID,i_seq.BREADY),UVM_MEDIUM);
	    //`uvm_info(get_type_name(),$sformatf("ARVALID=%0d ARREADY=%0d ARADDR=%0d",i_seq.ARVALID,o_seq.ARREADY,i_seq.ARADDR),UVM_MEDIUM);
	    //`uvm_info(get_type_name(),$sformatf("RVALID =%0d RREADY =%0d",o_seq.RVALID,i_seq.RREADY),UVM_MEDIUM);            
	    //`uvm_info(get_type_name(),$sformatf("[%0t]: REF: WRITE_RESPONSE=%0d READ_DATA=%0d READ_RESPONSE=%0d",$time,ref_var.BRESP,ref_var.RDATA,ref_var.RRESP),UVM_MEDIUM);
            //`uvm_info(get_type_name(),$sformatf("[%0t]: DUT: WRITE_RESPONSE=%0d READ_DATA=%0d READ_RESPONSE=%0d",$time,o_seq.BRESP,o_seq.RDATA,o_seq.RRESP),UVM_MEDIUM);
            $display("");  
        end
    endtask
endclass
