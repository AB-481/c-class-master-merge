// See LICENSE.iitm for license details
/*

Author : IIT Madras
--------------------------------------------------------------------------------------------------
*/

interface IFC_ingress;
      method ActionValue#(Tuple7#(Bit#(3),Bit#(4),Bit#(64),Bit#(2),Bit#(64),Bit#(1),Bit#(1))) mva_encoder_input (Bit#(14) meta_data,Bit#(3) funct3,Bit#(5) rd_addr, Bit#(4) cause, Bit#(64) tval, Bit#(2) priv, Bit#(64) iaddr, Bit#(1) cause_type, Bit#(1) trap);        	      
endinterface

module mkingress(IFC_ingress);

    Reg#(Bit#(1)) prev_inst_is_exp_or_int <- mkReg(0);

    method ActionValue#(Tuple7#(Bit#(3),Bit#(4),Bit#(64),Bit#(2),Bit#(64),Bit#(1),Bit#(1))) mva_encoder_input (Bit#(14) meta_data,Bit#(3) funct3,Bit#(5) rd_addr, Bit#(4) cause, Bit#(64) tval, Bit#(2) priv, Bit#(64) iaddr, Bit#(1) cause_type, Bit#(1) trap);

      let lv_opcode   = meta_data[6:0];
      let lv_compress = meta_data[7];
      let lv_rs1      = meta_data[12:8];
      let lv_btaken   = meta_data[13];
      let lv_funct3   = funct3;

      // let lv_cause = (trap ==1 )? cause : 0;
      // let lv_tval  = (trap ==1 )? tval  : 0;

      Bit#(3) itype = 0;
      Bit#(1) iretire = 1;
      Bit#(1) ilastsize = ~lv_compress;

      // BRANCH_INSTR
      Bool is_branch = (lv_opcode == 7'b1100011);

      // JALR_INSTR return detection
      Bool is_ret =
          ((lv_opcode == 7'b1100111) &&
          (rd_addr != 1) && (rd_addr != 5) &&
          ((lv_rs1 == 1) || (lv_rs1 == 5)));

      /* Note : is_uninferable_jmp has is_ret as subset condition */
      // JALR_INSTR with nonzero rs1
      Bool is_uninferable_jmp = (lv_opcode == 7'b1100111 && lv_rs1 != 0);

      /*
      * Note : The trap is getting reported means no need 
      * to include ECALL, EBREAK or C.EBREAK in is_uninferable_discon
      */
      // mret/sret
      Bool is_uninferable_discon =
          (is_uninferable_jmp ||
          (lv_opcode == 7'b1110011 && lv_funct3 == 0));

      //$display("lv_opcode = %h ,lv_compress  = %h  ,lv_rs1  = %h ,lv_btaken  = %h ,cause  = %h ,cause_type  = %h ,trap  = %h , rd_addr  = %h ",
      //         lv_opcode ,lv_compress ,lv_rs1 ,lv_btaken ,cause ,cause_type ,trap , rd_addr);

      // is_interrupt
      if (cause_type == 1 && trap == 1) begin
          itype = 2;
          prev_inst_is_exp_or_int <= 1;
      end

      // is_exception
      else if (cause_type == 0 && trap == 1) begin
          itype = 1;
          prev_inst_is_exp_or_int <= 1;
      end

      else if (prev_inst_is_exp_or_int == 1) begin
          prev_inst_is_exp_or_int <= 0;

          // is_ret
          if (is_ret) begin
              itype = 3;
          end
      end

      else if (trap == 0) begin

          // is_branch
          if (is_branch) begin
              prev_inst_is_exp_or_int <= 0;

              // is_taken_branch
              if (lv_btaken == 1) begin
                  itype = 5;
              end
              else begin
                  itype = 4;
              end
          end

          // uninferable_jump and call
          else if (is_uninferable_discon) begin
              prev_inst_is_exp_or_int <= 0;
              itype = 6;
          end

          else begin
              itype = 0;
          end
      end

      return tuple7(itype, cause, tval, priv, iaddr, iretire, ilastsize);

    endmethod

endmodule
