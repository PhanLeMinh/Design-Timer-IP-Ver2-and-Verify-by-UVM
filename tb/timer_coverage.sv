class timer_coverage extends uvm_subscriber#(apb_transaction);
   `uvm_component_utils(timer_coverage)

    covergroup APB_GROUP with function sample(apb_transaction trans);
       cp_transfer: coverpoint trans.xact_type{
          bins apb_read = {apb_transaction::READ};
          bins apb_write = {apb_transaction::WRITE};
       }
       cp_address: coverpoint trans.addr{
          bins tcr   = {12'h00};
          bins tdr0  = {12'h04};
          bins tdr1  = {12'h08};
          bins tcmp0 = {12'h0C};
          bins tcmp1 = {12'h10};
          bins tier  = {12'h14};
          bins tisr  = {12'h18};
          bins thcsr = {12'h1C};
       }
       cp_data: coverpoint trans.data{
          bins min = {32'h0};
          bins max = {32'hFFFF_FFFF};
          bins others = default;
       }
       cp_pslverr: coverpoint trans.pslverr;
       x_data_kind: cross cp_transfer,cp_address;
       x_addr_data: cross cp_address,cp_data;
    endgroup
    
    covergroup TCR_GROUP with function sample(bit [31:0] data, bit err);
       cp_timer_en: coverpoint data[0];
       cp_div_en  : coverpoint data[1];
       cp_div_mode: coverpoint data[2];
       cp_pwm_en  : coverpoint data[3];
       cp_div_val : coverpoint data[11:8] {
          bins legal[] = {[4'd0:4'd8]};
          bins illegal = {[4'd9:4'd15]};
       }
       cp_prescaler: coverpoint data[31:16] {
          bins p0   = {0};
          bins p1   = {1};
          bins low = {[2:15]};
          bins mid  = {[16:255]};
          bins high = {[256:16'hFFFE]};
          bins ffff = {16'hFFFF};
       }
       cp_rsvd: coverpoint {data[15:12],data[7:4]} {
          bins zero = {0}; 
          bins nz   = {[1:$]}; // write 1 to reserved
       }
       cp_err: coverpoint err;
    
       x_mode: cross cp_div_en, cp_div_mode, cp_pwm_en;
       x_divval_en: cross cp_div_val, cp_div_en;
       x_pre_mode : cross cp_prescaler, cp_div_mode;
       x_illegal_err: cross cp_err, cp_div_val {
          // div_val > 8, error = 1
          illegal_bins bad = binsof(cp_div_val.illegal) && binsof(cp_err) intersect {0};
       }
    endgroup 
    
    covergroup TCMP_GROUP with function sample(bit[31:0] data);
       cp_value: coverpoint data{
          bins zero = {0};
          bins one  = {1};
          bins low  = {[2:15]};
          bins mid  = {[16:300]};
          bins big  = {[301:32'hFFFF_FFFE]};
          bins max  = {32'hFFFF};
       }
       cp_byte0: coverpoint data[7:0] {
          bins zero = {0};
          bins nz   = {[1:$]};
       }
       cp_byte1: coverpoint data[15:8] {
          bins zero = {0};
          bins nz   = {[1:$]};
       }
       cp_byte2: coverpoint data[23:16] {
          bins zero = {0};
          bins nz   = {[1:$]};
       }
       cp_byte3: coverpoint data[31:24] {
          bins zero = {0};
          bins nz   = {[1:$]};
       }
    endgroup
    
    covergroup TIER_GROUP with function sample(bit[31:0] data);
       cp_int_en: coverpoint data[0];
       cp_rsvd  : coverpoint data[31:1] {bins zero = {0}; bins nz = {[1:$]};}
    endgroup
    
    covergroup TISR_GROUP with function sample(bit[31:0] data,bit is_rw);
       cp_kind  : coverpoint is_rw {bins rd = {0}; bins wr = {1};}
       cp_int_st: coverpoint data[0];
       cp_pwm_int_st: coverpoint data[1];
       cp_rsvd  : coverpoint data[31:2] {bins zero = {0}; bins nz = {[1:$]};}
       x_int    : cross cp_kind,cp_int_st; // Write 1 to clear and read status
       x_pwm_int: cross cp_kind,cp_pwm_int_st;
    endgroup
    
    covergroup THCSR_GROUP with function sample(bit[31:0] data, bit is_rw);
       cp_kind  : coverpoint is_rw {bins rd = {0}; bins wr = {1};}
       cp_halt_req: coverpoint data[0];
       cp_ack   : coverpoint data[1] iff(!is_rw);
       x_req_ack: cross cp_kind,cp_ack iff(!is_rw);
    endgroup

    function new(string name = "timer_coverage",uvm_component parent);
       super.new(name,parent);
       APB_GROUP = new();
       TCR_GROUP = new();
       TCMP_GROUP = new();
       TIER_GROUP = new();
       TISR_GROUP = new();
       THCSR_GROUP = new();
    endfunction

    virtual function void write(apb_transaction t);
       bit is_rw = (t.xact_type == apb_transaction::WRITE);
       case(t.addr)
          12'h00: if(is_rw) TCR_GROUP.sample(t.data,t.pslverr);
	  12'h0C,12'h10: if(is_rw) TCMP_GROUP.sample(t.data);
	  12'h14: if(is_rw) TIER_GROUP.sample(t.data);
	  12'h18: if(is_rw) TISR_GROUP.sample(t.data,is_rw);
	  12'h1C: if(is_rw) THCSR_GROUP.sample(t.data,is_rw);
       endcase
       APB_GROUP.sample(t);
    endfunction
endclass
