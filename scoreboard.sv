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
    endfunction

    task run_phase();
        forever 
        begin
            op_fifo.get(o_seq);
            ip_fifo.get(i_seq);
            ref_task();
            chekkk();
        end
    endtask

    task ref_task();
            //logic for channel status
            //write
            if(i_seq.AWVALID)
            begin
                busy_wa = 1;
            end
            if(i_Seq.AWVALID && o_seq.AWREADY)
            begin
                busy_wa = 0;
            end

            if(i_seq.WVALID)
            begin
                busy_wd = 1;
            end
            if(i_Seq.WVALID && o_seq.WREADY)
            begin
                busy_wd = 0;
            end

            if(o_seq.BVALID)
            begin
                busy_wr = 1;
            end
            if(o_seq.BVALID && i_seq.BREADY)
            begin
                busy_wr = 0;
                first_wr = 0;
                first_wa = 0;
                first_wd = 0;
            end

            //read
            if(i_seq.ARVALID)
            begin
                busy_ra = 1;
            end
            if(i_seq.ARVALID && o_seq.ARREADY)
            begin
                busy_ra = 0;
            end

            if(o_seq.RVALID)
            begin
                busy_rd = 1;
            end
            if(o_seq.RVALID && i_seq.RREAD)
            begin
                busy_rd = 0;
                first_rd = 0;
                first_ra = 0;
            end
            // if(i_seq.AWVALID && o_seq.AWREADY)
            // begin
            //     add = i_seq.AWADDR;
            // end
            // if(i_seq.WVALID && o_seq.WREADY)
            // begin
            //     strb_mask = {8{i_seq.WSTRB[3]},8{i_seq.WSTRB[2]},8{i_seq.WSTRB[1]},8{i_seq.WSTRB[0]}};
            //     data = (strb_mask) & (i_seq.WDATA);
            // end
            

            //logic for internal register updating
            //write channel
            if(busy_wa && !first_wa)
            begin
                ref_var.AWADDR = i_seq.AWADDR;
                first_wa = 1;
            end
            if(busy_wd && !first_wd)
            begin
                ref_var.WDATA = i_Seq.WDATA;
                ref_va.WSTRB = i_seq.WSTRB;
                first_wd = 1;
            end
            if(busy_wr && !first_wr)
            begin
                ref_var.BRESP = i_seq.BRESP;
                first_wr = 1;
            end
            //read channel
            if(busy_ra && !first_ra)
            begin
                ref_var.ARADDR = i_seq.ARADDR;
                first_ra = 1;
            end

            //error logic
            //write channel
            if(first_wa && first_wd)
            begin
                if(((ref_var.AWADDR%4)==0) && (ref_var.AWADDR inside {[0:39],[52:63]}))
                begin
                    mem[ref_var.AWADDR] = ({8{ref_var.WSTRB[3]},8{ref_var.WSTRB[2]},8{ref_var.WSTRB[1]},8{ref_var.WSTRB[0]}}) & (ref_var.WDATA);
                    ref_var.BRESP = 0;
                    ref_var.BVALID = 1;
                end
                else if(!(ref_var.AWADDR inside {[0:63]}))
                begin
                    ref_var.BRESP = 3;
                    ref_var.BVALID = 1;
                end
                else
                begin
                    ref_var.BRESP = 2;
                    ref_var.BVALID = 1;
                end
            end
            //read channel
            if(first_ra)
            begin
                ref_var.ARADDR = i_seq.ARADDR;
                if(o_seq.RVALID)
                begin
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
            `uvm_info(get_type_name(),$sformatf("[%0t]: INPUT: AWADDR=%0d AWVALID=%0d WDATA=%0d WSTRB=%0d WVALID=%0d ARADDR=%0d ARVALID=%0d RREAD=%0d",$time,i_Seq.AWADDR,i_Seq.AWVALID,i_Seq.WDATA,i_Seq.WSTRB,i_Seq.WVALID,i_seq.ARADDR,i_seq.ARVALID,i_seq.RREAD),UVM_MEDIUM);
            `uvm_info(get_type_name(),$sformatf("[%0t]: REF: WRITE_RESPONSE=%0d READ_DATA=%0d READ_RESPONSE=%0d",$time,ref_var.BRESP,ref_var.RDATA,ref_var.RRESP),UVM_MEDIUM);
            `uvm_info(get_type_name(),$sformatf("[%0t]: DUT: WRITE_RESPONSE=%0d READ_DATA=%0d READ_RESPONSE=%0d",$time,o_seq.BRESP,o_seq.RDATA,o_seq.RRESP),UVM_MEDIUM);
            $display("");  
        end
        else 
        begin
            FAIL++;
            $display("-------------------FAIL:[%0d]---------------------------",FAIL);
            `uvm_info(get_type_name(),$sformatf("[%0t]: INPUT: AWADDR=%0d AWVALID=%0d WDATA=%0d WSTRB=%0d WVALID=%0d ARADDR=%0d ARVALID=%0d RREAD=%0d",$time,i_Seq.AWADDR,i_Seq.AWVALID,i_Seq.WDATA,i_Seq.WSTRB,i_Seq.WVALID,i_seq.ARADDR,i_seq.ARVALID,i_seq.RREAD),UVM_MEDIUM);
            `uvm_info(get_type_name(),$sformatf("[%0t]: REF: WRITE_RESPONSE=%0d READ_DATA=%0d READ_RESPONSE=%0d",$time,ref_var.BRESP,ref_var.RDATA,ref_var.RRESP),UVM_MEDIUM);
            `uvm_info(get_type_name(),$sformatf("[%0t]: DUT: WRITE_RESPONSE=%0d READ_DATA=%0d READ_RESPONSE=%0d",$time,o_seq.BRESP,o_seq.RDATA,o_seq.RRESP),UVM_MEDIUM);
            $display("");  
        end
    endtask
endclass
