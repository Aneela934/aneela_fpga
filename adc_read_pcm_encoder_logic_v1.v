`include "arpel_defines.v"
module adc_read_pcm_encoder_logic_v1
  (
    input lclk_arpel_in,
    input lrst_arpel_in,
    input adc_enable_arpel_in,
    input sdain_adc_arpel_in,  // MOSI from ADC(not needed for ADC7606) 
    input busy_adc_arpel_in,
    input frst_data_adc_arpel_in,

    output reg sdo_adc_arpel_negreg_out,   // MISO from ADC
	  output reg cs_adc_arpel_negreg_out,
    output reg sclk_adc_arpel_negreg_out,	
    output reg rstn_adc_arpel_negreg_out,
    output reg convst_adc_arpel_negreg_out,
    output reg os0_adc_arpel_negreg_out,
    output reg os1_adc_arpel_negreg_out,
    output reg os2_adc_arpel_negreg_out,			
    output reg [15:0] ch1_data_arpel_negreg_out,
    output reg [15:0] ch2_data_arpel_negreg_out,
    output reg [15:0] pdata_one_arpel_negreg_out,
    output reg [15:0] pdata_two_arpel_negreg_out,
    output reg done_arpel_negreg_out,
     //----------------------------------DEBUG_PORTS---------------------------------------------
      output [`state_arpel_width_minus1:0] state_debug_arpel_out
    //-------------------------------------------------------------------------------------------
  );  
   //------------------------------NEGEDGE_REG_DEPENDENT_OUTPUT_WIRES_DECLARATIONS---------------
     wire sdo_adc_upcoming_arpel_negwr_out;
     reg cs_adc_upcoming_arpel_negwr_out;
     reg sclk_adc_upcoming_arpel_negwr_out;
     wire rstn_adc_upcoming_arpel_negwr_out;
     reg convst_adc_upcoming_arpel_negwr_out;
     wire os0_adc_upcoming_arpel_negwr_out;
     wire os1_adc_upcoming_arpel_negwr_out;
     wire os2_adc_upcoming_arpel_negwr_out;

     reg [15:0] ch1_data_upcoming_arpel_negwr_out;
     reg [15:0] ch2_data_upcoming_arpel_negwr_out;
     reg [15:0] pdata_one_upcoming_arpel_negwr_out;
     reg [15:0] pdata_two_upcoming_arpel_negwr_out;
     reg done_upcoming_arpel_negwr_out;
   //---------------------------------------------------------------------------------------------
  
   //----------------------------------NEGEDGE_INTERNAL_REGS_DECLARATIONS------------------------
     reg [`state_arpel_width_minus1:0] state_arpel_negreg;
     reg [3:0] counter_arpel_negreg;
   //--------------------------------------------------------------------------------------------
  
   //-------------------------------NEGEDGE_INTERNAL_WIRE_DECLARATIONS----------------------------
     reg [`state_arpel_width_minus1:0] state_upcoming_arpel_negwr;
     reg [3:0] counter_upcoming_arpel_negwr;
   //---------------------------------------------------------------------------------------------

   //----------------------------------NEGEDGE_SEQUENTIAL_BLOCK----------------------------------
      always@(negedge lclk_arpel_in)
        begin
          if(lrst_arpel_in)
            begin
              sdo_adc_arpel_negreg_out <= 1'd0;
              sclk_adc_arpel_negreg_out <= 1'd1;
              cs_adc_arpel_negreg_out <= 1'd1; 
	            rstn_adc_arpel_negreg_out <= 1'd1;
	            convst_adc_arpel_negreg_out <= 1'd1;
              os0_adc_arpel_negreg_out <= 1'd0;
              os1_adc_arpel_negreg_out <= 1'd0;
              os2_adc_arpel_negreg_out <= 1'd0;
              ch1_data_arpel_negreg_out <= 16'd0;
              ch2_data_arpel_negreg_out <= 16'd0;					   
              done_arpel_negreg_out <= 1'd0;

              state_arpel_negreg <= `reset_arpel_state;
              pdata_one_arpel_negreg_out <= 16'd0;
              pdata_two_arpel_negreg_out <= 16'd0;
              counter_arpel_negreg <= 4'd0;
            end 
          else
            begin
              sdo_adc_arpel_negreg_out <= sdo_adc_upcoming_arpel_negwr_out;
              sclk_adc_arpel_negreg_out <= sclk_adc_upcoming_arpel_negwr_out;
              cs_adc_arpel_negreg_out <= cs_adc_upcoming_arpel_negwr_out; 
	            rstn_adc_arpel_negreg_out <= rstn_adc_upcoming_arpel_negwr_out;
	            convst_adc_arpel_negreg_out <= convst_adc_upcoming_arpel_negwr_out;							   
              os0_adc_arpel_negreg_out <= os0_adc_upcoming_arpel_negwr_out;
              os1_adc_arpel_negreg_out <= os1_adc_upcoming_arpel_negwr_out;
              os2_adc_arpel_negreg_out <= os2_adc_upcoming_arpel_negwr_out;
              ch1_data_arpel_negreg_out <= ch1_data_upcoming_arpel_negwr_out;
              ch2_data_arpel_negreg_out <= ch2_data_upcoming_arpel_negwr_out;
              done_arpel_negreg_out <= done_upcoming_arpel_negwr_out;

              state_arpel_negreg <= state_upcoming_arpel_negwr;
              pdata_one_arpel_negreg_out <= pdata_one_upcoming_arpel_negwr_out;
              pdata_two_arpel_negreg_out <= pdata_two_upcoming_arpel_negwr_out;
              counter_arpel_negreg <= counter_upcoming_arpel_negwr;
            end
        end
   //--------------------------------------------------------------------------------------------

   //------------------------------NEGEDGE_REG_DEPENDENT_INTERNAL_WIRES_DEFINATIONS--------------
      
      //----------------------------------state_upcoming_arpel_negwr------------------------------
        always@*
          begin
            case(state_arpel_negreg)
              `reset_arpel_state:
                begin
                  state_upcoming_arpel_negwr <= `check_enable_arpel_state;
                end
              `check_enable_arpel_state:
                begin
                  if(adc_enable_arpel_in) 
                    begin
                      state_upcoming_arpel_negwr <= `chip_select_high_to_low_arpel_state;
                    end 
                  else 
                    begin 
                      state_upcoming_arpel_negwr <= `check_enable_arpel_state;
                    end
                end
              `chip_select_high_to_low_arpel_state: 
                begin
                  state_upcoming_arpel_negwr <= `convst_low_arpel_state;
                end
              `convst_low_arpel_state:
                begin
                  if(counter_arpel_negreg < 4'd15)
                    begin
                      state_upcoming_arpel_negwr <= `convst_low_arpel_state;
                    end
                  else
                    begin
                      state_upcoming_arpel_negwr <= `busy_wait_arpel_state;
                    end
                end
              `busy_wait_arpel_state:
                begin
                  state_upcoming_arpel_negwr <= `busy_high_arpel_state;
                end
              `busy_high_arpel_state:
                begin
                  if(busy_adc_arpel_in == 1'd1)
                    begin
                      state_upcoming_arpel_negwr <= `busy_high_arpel_state;
                    end
                  else
                    begin
                      state_upcoming_arpel_negwr <= `ch1_data_read_150_arpel_state;
                    end
                end
              `ch1_data_read_150_arpel_state:
                begin
                  state_upcoming_arpel_negwr <= `ch1_data_read_151_arpel_state;
                end
              `ch1_data_read_151_arpel_state:
                begin
                  state_upcoming_arpel_negwr <= `ch1_data_read_140_arpel_state;
                end
              `ch1_data_read_140_arpel_state:
                begin
                  state_upcoming_arpel_negwr <= `ch1_data_read_141_arpel_state;
                end
              `ch1_data_read_141_arpel_state:
                begin
                  state_upcoming_arpel_negwr <= `ch1_data_read_130_arpel_state;
                end
              `ch1_data_read_130_arpel_state:
                begin
                  state_upcoming_arpel_negwr <= `ch1_data_read_131_arpel_state;
                end
              `ch1_data_read_131_arpel_state:
                begin
                  state_upcoming_arpel_negwr <= `ch1_data_read_120_arpel_state;
                end
              `ch1_data_read_120_arpel_state:
                begin
                  state_upcoming_arpel_negwr <= `ch1_data_read_121_arpel_state;
                end
              `ch1_data_read_121_arpel_state:
                begin
                  state_upcoming_arpel_negwr <= `ch1_data_read_110_arpel_state;
                end
              `ch1_data_read_110_arpel_state:
                begin
                  state_upcoming_arpel_negwr <= `ch1_data_read_111_arpel_state;
                end
              `ch1_data_read_111_arpel_state:
                begin
                  state_upcoming_arpel_negwr <= `ch1_data_read_100_arpel_state;
                end
              `ch1_data_read_100_arpel_state:
                begin
                  state_upcoming_arpel_negwr <= `ch1_data_read_101_arpel_state;
                end
              `ch1_data_read_101_arpel_state:
                begin
                  state_upcoming_arpel_negwr <= `ch1_data_read_90_arpel_state;
                end
              `ch1_data_read_90_arpel_state:
                begin
                  state_upcoming_arpel_negwr <= `ch1_data_read_91_arpel_state;
                end
              `ch1_data_read_91_arpel_state:
                begin
                  state_upcoming_arpel_negwr <= `ch1_data_read_80_arpel_state;
                end
              `ch1_data_read_80_arpel_state:
                begin
                  state_upcoming_arpel_negwr <= `ch1_data_read_81_arpel_state;
                end
              `ch1_data_read_81_arpel_state:
                begin
                  state_upcoming_arpel_negwr <= `ch1_data_read_70_arpel_state;
                end
              `ch1_data_read_70_arpel_state:
                begin
                  state_upcoming_arpel_negwr <= `ch1_data_read_71_arpel_state;
                end
              `ch1_data_read_71_arpel_state:
                begin
                  state_upcoming_arpel_negwr <= `ch1_data_read_60_arpel_state;
                end  
              `ch1_data_read_60_arpel_state:
                begin
                  state_upcoming_arpel_negwr <= `ch1_data_read_61_arpel_state;
                end
              `ch1_data_read_61_arpel_state:
                begin
                  state_upcoming_arpel_negwr <= `ch1_data_read_50_arpel_state;
                end
              `ch1_data_read_50_arpel_state:
                begin
                  state_upcoming_arpel_negwr <= `ch1_data_read_51_arpel_state;
                end  
              `ch1_data_read_51_arpel_state:
                begin
                  state_upcoming_arpel_negwr <= `ch1_data_read_40_arpel_state;
                end
              `ch1_data_read_40_arpel_state:
                begin
                  state_upcoming_arpel_negwr <= `ch1_data_read_41_arpel_state;
                end
              `ch1_data_read_41_arpel_state:
                begin
                  state_upcoming_arpel_negwr <= `ch1_data_read_30_arpel_state;
                end  
              `ch1_data_read_30_arpel_state:
                begin
                  state_upcoming_arpel_negwr <= `ch1_data_read_31_arpel_state;
                end
              `ch1_data_read_31_arpel_state:
                begin
                  state_upcoming_arpel_negwr <= `ch1_data_read_20_arpel_state;
                end  
              `ch1_data_read_20_arpel_state:
                begin
                  state_upcoming_arpel_negwr <= `ch1_data_read_21_arpel_state;
                end
              `ch1_data_read_21_arpel_state:
                begin
                  state_upcoming_arpel_negwr <= `ch1_data_read_10_arpel_state;
                end  
              `ch1_data_read_10_arpel_state:
                begin
                  state_upcoming_arpel_negwr <= `ch1_data_read_11_arpel_state;
                end
              `ch1_data_read_11_arpel_state:
                begin
                  state_upcoming_arpel_negwr <= `ch1_data_read_00_arpel_state;
                end  
              `ch1_data_read_00_arpel_state:
                begin
                  state_upcoming_arpel_negwr <= `ch1_data_read_01_arpel_state;
                end
              `ch1_data_read_01_arpel_state:
                begin
                  state_upcoming_arpel_negwr <= `wait_next_channel_arpel_state;
                end
              `wait_next_channel_arpel_state:
                begin
                  state_upcoming_arpel_negwr <= `ch2_data_read_150_arpel_state;
                end
              `ch2_data_read_150_arpel_state:
                begin
                  state_upcoming_arpel_negwr <= `ch2_data_read_151_arpel_state;
                end
              `ch2_data_read_151_arpel_state:
                begin
                  state_upcoming_arpel_negwr <= `ch2_data_read_140_arpel_state;
                end
              `ch2_data_read_140_arpel_state:
                begin
                  state_upcoming_arpel_negwr <= `ch2_data_read_141_arpel_state;
                end
              `ch2_data_read_141_arpel_state:
                begin
                  state_upcoming_arpel_negwr <= `ch2_data_read_130_arpel_state;
                end
              `ch2_data_read_130_arpel_state:
                begin
                  state_upcoming_arpel_negwr <= `ch2_data_read_131_arpel_state;
                end
              `ch2_data_read_131_arpel_state:
                begin
                  state_upcoming_arpel_negwr <= `ch2_data_read_120_arpel_state;
                end
              `ch2_data_read_120_arpel_state:
                begin
                  state_upcoming_arpel_negwr <= `ch2_data_read_121_arpel_state;
                end
              `ch2_data_read_121_arpel_state:
                begin
                  state_upcoming_arpel_negwr <= `ch2_data_read_110_arpel_state;
                end
              `ch2_data_read_110_arpel_state:
                begin
                  state_upcoming_arpel_negwr <= `ch2_data_read_111_arpel_state;
                end
              `ch2_data_read_111_arpel_state:
                begin
                  state_upcoming_arpel_negwr <= `ch2_data_read_100_arpel_state;
                end
              `ch2_data_read_100_arpel_state:
                begin
                  state_upcoming_arpel_negwr <= `ch2_data_read_101_arpel_state;
                end
              `ch2_data_read_101_arpel_state:
                begin
                  state_upcoming_arpel_negwr <= `ch2_data_read_90_arpel_state;
                end
              `ch2_data_read_90_arpel_state:
                begin
                  state_upcoming_arpel_negwr <= `ch2_data_read_91_arpel_state;
                end
              `ch2_data_read_91_arpel_state:
                begin
                  state_upcoming_arpel_negwr <= `ch2_data_read_80_arpel_state;
                end
              `ch2_data_read_80_arpel_state:
                begin
                  state_upcoming_arpel_negwr <= `ch2_data_read_81_arpel_state;
                end
              `ch2_data_read_81_arpel_state:
                begin
                  state_upcoming_arpel_negwr <= `ch2_data_read_70_arpel_state;
                end
              `ch2_data_read_70_arpel_state:
                begin
                  state_upcoming_arpel_negwr <= `ch2_data_read_71_arpel_state;
                end
              `ch2_data_read_71_arpel_state:
                begin
                  state_upcoming_arpel_negwr <= `ch2_data_read_60_arpel_state;
                end
              `ch2_data_read_60_arpel_state:
                begin
                  state_upcoming_arpel_negwr <= `ch2_data_read_61_arpel_state;
                end
              `ch2_data_read_61_arpel_state:
                begin
                  state_upcoming_arpel_negwr <= `ch2_data_read_50_arpel_state;
                end
              `ch2_data_read_50_arpel_state:
                begin
                  state_upcoming_arpel_negwr <= `ch2_data_read_51_arpel_state;
                end
              `ch2_data_read_51_arpel_state:
                begin
                  state_upcoming_arpel_negwr <= `ch2_data_read_40_arpel_state;
                end
              `ch2_data_read_40_arpel_state:
                begin
                  state_upcoming_arpel_negwr <= `ch2_data_read_41_arpel_state;
                end
              `ch2_data_read_41_arpel_state:
                begin
                  state_upcoming_arpel_negwr <= `ch2_data_read_30_arpel_state;
                end
              `ch2_data_read_30_arpel_state:
                begin
                  state_upcoming_arpel_negwr <= `ch2_data_read_31_arpel_state;
                end
              `ch2_data_read_31_arpel_state:
                begin
                  state_upcoming_arpel_negwr <= `ch2_data_read_20_arpel_state;
                end
              `ch2_data_read_20_arpel_state:
                begin
                  state_upcoming_arpel_negwr <= `ch2_data_read_21_arpel_state;
                end
              `ch2_data_read_21_arpel_state:
                begin
                  state_upcoming_arpel_negwr <= `ch2_data_read_10_arpel_state;
                end
              `ch2_data_read_10_arpel_state:
                begin
                  state_upcoming_arpel_negwr <= `ch2_data_read_11_arpel_state;
                end
              `ch2_data_read_11_arpel_state:
                begin
                  state_upcoming_arpel_negwr <= `ch2_data_read_00_arpel_state;
                end
              `ch2_data_read_00_arpel_state:
                begin
                  state_upcoming_arpel_negwr <= `ch2_data_read_01_arpel_state;
                end
              `ch2_data_read_01_arpel_state:
                begin
                  state_upcoming_arpel_negwr <= `chip_select_low_to_high_arpel_state;
                end
              `chip_select_low_to_high_arpel_state:
                begin 
                  state_upcoming_arpel_negwr <= `done_arpel_state;
                end
              `done_arpel_state:
                begin
                  state_upcoming_arpel_negwr <= `check_enable_arpel_state;
                end
              default:
                begin
                  state_upcoming_arpel_negwr <= `reset_arpel_state;
                end    
            endcase
          end
      //-----------------------------------------------------------------------------------------

      //---------------------------------cs_adc_upcoming_arpel_negwr_out-------------------------
        always @*
          begin
            case(state_arpel_negreg)
              `reset_arpel_state:
                begin
                  cs_adc_upcoming_arpel_negwr_out <= 1'd1;
                end
              `check_enable_arpel_state:
                begin
                  cs_adc_upcoming_arpel_negwr_out <= 1'd1;
                end
              `wait_next_channel_arpel_state:
                begin
                  cs_adc_upcoming_arpel_negwr_out <= 1'd1;
                end
              `chip_select_low_to_high_arpel_state:
                begin
                  cs_adc_upcoming_arpel_negwr_out <= 1'd1;
                end
              `done_arpel_state:
                begin
                  cs_adc_upcoming_arpel_negwr_out <= 1'd1;
                end 
              default:
                begin
                  cs_adc_upcoming_arpel_negwr_out <= 1'd0;
                end    
            endcase
          end
      //-----------------------------------------------------------------------------------------
      
      //---------------------------------sclk_adc_upcoming_arpel_negwr_out-----------------------
         always@*
          begin
            case(state_arpel_negreg) 
              `ch1_data_read_150_arpel_state:
                begin
                  sclk_adc_upcoming_arpel_negwr_out <= 1'd0;
                end
              `ch1_data_read_140_arpel_state:
                begin
                  sclk_adc_upcoming_arpel_negwr_out <= 1'd0;
                end
              `ch1_data_read_130_arpel_state:
                begin
                  sclk_adc_upcoming_arpel_negwr_out <= 1'd0;
                end
              `ch1_data_read_120_arpel_state:
                begin
                  sclk_adc_upcoming_arpel_negwr_out <= 1'd0;
                end
              `ch1_data_read_110_arpel_state:
                begin
                  sclk_adc_upcoming_arpel_negwr_out <= 1'd0;
                end
              `ch1_data_read_100_arpel_state:
                begin
                  sclk_adc_upcoming_arpel_negwr_out <= 1'd0;
                end
              `ch1_data_read_90_arpel_state:
                begin
                  sclk_adc_upcoming_arpel_negwr_out <= 1'd0;
                end
              `ch1_data_read_80_arpel_state:
                begin
                  sclk_adc_upcoming_arpel_negwr_out <= 1'd0;
                end
              `ch1_data_read_70_arpel_state:
                begin
                  sclk_adc_upcoming_arpel_negwr_out <= 1'd0;
                end
              `ch1_data_read_60_arpel_state:
                begin
                  sclk_adc_upcoming_arpel_negwr_out <= 1'd0;
                end
              `ch1_data_read_50_arpel_state:
                begin
                  sclk_adc_upcoming_arpel_negwr_out <= 1'd0;
                end  
              `ch1_data_read_40_arpel_state:
                begin
                  sclk_adc_upcoming_arpel_negwr_out <= 1'd0;
                end
              `ch1_data_read_30_arpel_state:
                begin
                  sclk_adc_upcoming_arpel_negwr_out <= 1'd0;
                end
              `ch1_data_read_20_arpel_state:
                begin
                  sclk_adc_upcoming_arpel_negwr_out <= 1'd0;
                end
              `ch1_data_read_10_arpel_state:
                begin
                  sclk_adc_upcoming_arpel_negwr_out <= 1'd0;
                end
              `ch1_data_read_00_arpel_state:
                begin
                  sclk_adc_upcoming_arpel_negwr_out <= 1'd0;
                end
              `ch2_data_read_150_arpel_state:
                begin
                  sclk_adc_upcoming_arpel_negwr_out <= 1'd0;
                end
              `ch2_data_read_140_arpel_state:
                begin
                  sclk_adc_upcoming_arpel_negwr_out <= 1'd0;
                end          
              `ch2_data_read_130_arpel_state:
                begin
                  sclk_adc_upcoming_arpel_negwr_out <= 1'd0;
                end           
              `ch2_data_read_120_arpel_state:
                begin
                  sclk_adc_upcoming_arpel_negwr_out <= 1'd0;
                end           
              `ch2_data_read_110_arpel_state:
                begin
                  sclk_adc_upcoming_arpel_negwr_out <= 1'd0;
                end           
              `ch2_data_read_100_arpel_state:
                begin
                  sclk_adc_upcoming_arpel_negwr_out <= 1'd0;
                end         
              `ch2_data_read_90_arpel_state:
                begin
                  sclk_adc_upcoming_arpel_negwr_out <= 1'd0;
                end           
              `ch2_data_read_80_arpel_state:
                begin
                  sclk_adc_upcoming_arpel_negwr_out <= 1'd0;
                end            
              `ch2_data_read_70_arpel_state:
                begin
                  sclk_adc_upcoming_arpel_negwr_out <= 1'd0;
                end       
              `ch2_data_read_60_arpel_state:
                begin
                  sclk_adc_upcoming_arpel_negwr_out <= 1'd0;
                end
              `ch2_data_read_50_arpel_state:
                begin
                  sclk_adc_upcoming_arpel_negwr_out <= 1'd0;
                end
              `ch2_data_read_40_arpel_state:
                begin
                  sclk_adc_upcoming_arpel_negwr_out <= 1'd0;
                end             
              `ch2_data_read_30_arpel_state:
                begin
                  sclk_adc_upcoming_arpel_negwr_out <= 1'd0;
                end            
              `ch2_data_read_20_arpel_state:
                begin
                  sclk_adc_upcoming_arpel_negwr_out <= 1'd0;
                end           
              `ch2_data_read_10_arpel_state:
                begin
                  sclk_adc_upcoming_arpel_negwr_out <= 1'd0;
                end           
              `ch2_data_read_00_arpel_state:
                begin
                  sclk_adc_upcoming_arpel_negwr_out <= 1'd0;
                end
              default:
                begin
                  sclk_adc_upcoming_arpel_negwr_out <= 1'd1;
                end    
            endcase
          end
      //-----------------------------------------------------------------------------------------	

      //-----------------------------sdo_adc_upcoming_arpel_negwr_out----------------------------
        assign sdo_adc_upcoming_arpel_negwr_out = 1'd0;
      //-----------------------------------------------------------------------------------------
      
      //----------------------------------pdata_one_upcoming_arpel_negwr_out-----------------------------
        always @*
          begin
            case(state_arpel_negreg) 
              `ch1_data_read_151_arpel_state:
                begin
                  pdata_one_upcoming_arpel_negwr_out  <= {pdata_one_arpel_negreg_out[14:0],sdain_adc_arpel_in};
                end  
              `ch1_data_read_141_arpel_state:
                begin
                  pdata_one_upcoming_arpel_negwr_out  <= {pdata_one_arpel_negreg_out[14:0],sdain_adc_arpel_in};
                end  
              `ch1_data_read_131_arpel_state:
                begin
                  pdata_one_upcoming_arpel_negwr_out  <= {pdata_one_arpel_negreg_out[14:0],sdain_adc_arpel_in};
                end
              `ch1_data_read_121_arpel_state:
                begin
                  pdata_one_upcoming_arpel_negwr_out  <= {pdata_one_arpel_negreg_out[14:0],sdain_adc_arpel_in};
                end  
              `ch1_data_read_111_arpel_state:
                begin
                  pdata_one_upcoming_arpel_negwr_out  <= {pdata_one_arpel_negreg_out[14:0],sdain_adc_arpel_in};
                end  
              `ch1_data_read_101_arpel_state:
                begin
                  pdata_one_upcoming_arpel_negwr_out  <= {pdata_one_arpel_negreg_out[14:0],sdain_adc_arpel_in};
                end  
              `ch1_data_read_91_arpel_state:
                begin
                  pdata_one_upcoming_arpel_negwr_out  <= {pdata_one_arpel_negreg_out[14:0],sdain_adc_arpel_in};
                end  
              `ch1_data_read_81_arpel_state:
                begin
                  pdata_one_upcoming_arpel_negwr_out  <= {pdata_one_arpel_negreg_out[14:0],sdain_adc_arpel_in};
                end  
              `ch1_data_read_71_arpel_state:
                begin
                  pdata_one_upcoming_arpel_negwr_out  <= {pdata_one_arpel_negreg_out[14:0],sdain_adc_arpel_in};
                end  
              `ch1_data_read_61_arpel_state:
                begin
                  pdata_one_upcoming_arpel_negwr_out  <= {pdata_one_arpel_negreg_out[14:0],sdain_adc_arpel_in};
                end  
              `ch1_data_read_51_arpel_state:
                begin
                  pdata_one_upcoming_arpel_negwr_out  <= {pdata_one_arpel_negreg_out[14:0],sdain_adc_arpel_in};
                end
              `ch1_data_read_41_arpel_state:
                begin
                  pdata_one_upcoming_arpel_negwr_out  <= {pdata_one_arpel_negreg_out[14:0],sdain_adc_arpel_in};
                end
              `ch1_data_read_31_arpel_state:
                begin
                  pdata_one_upcoming_arpel_negwr_out  <= {pdata_one_arpel_negreg_out[14:0],sdain_adc_arpel_in};
                end
              `ch1_data_read_21_arpel_state:
                begin
                  pdata_one_upcoming_arpel_negwr_out  <= {pdata_one_arpel_negreg_out[14:0],sdain_adc_arpel_in};
                end  
              `ch1_data_read_11_arpel_state:
                begin
                  pdata_one_upcoming_arpel_negwr_out  <= {pdata_one_arpel_negreg_out[14:0],sdain_adc_arpel_in};
                end  
              `ch1_data_read_01_arpel_state:
                begin
                  pdata_one_upcoming_arpel_negwr_out  <= {pdata_one_arpel_negreg_out[14:0],sdain_adc_arpel_in};
                end
              default:
                begin
                  pdata_one_upcoming_arpel_negwr_out <= pdata_one_arpel_negreg_out;
                end    
            endcase
          end
      //-----------------------------------------------------------------------------------------
      
      //----------------------------------pdata_two_upcoming_arpel_negwr_out-----------------------------
        always @*
          begin
            case(state_arpel_negreg) 
              `ch2_data_read_151_arpel_state:
                begin
                  pdata_two_upcoming_arpel_negwr_out  <= {pdata_two_arpel_negreg_out[14:0],sdain_adc_arpel_in};
                end  
              `ch2_data_read_141_arpel_state:
                begin
                  pdata_two_upcoming_arpel_negwr_out  <= {pdata_two_arpel_negreg_out[14:0],sdain_adc_arpel_in};
                end  
              `ch2_data_read_131_arpel_state:
                begin
                  pdata_two_upcoming_arpel_negwr_out  <= {pdata_two_arpel_negreg_out[14:0],sdain_adc_arpel_in};
                end
              `ch2_data_read_121_arpel_state:
                begin
                  pdata_two_upcoming_arpel_negwr_out  <= {pdata_two_arpel_negreg_out[14:0],sdain_adc_arpel_in};
                end  
              `ch2_data_read_111_arpel_state:
                begin
                  pdata_two_upcoming_arpel_negwr_out  <= {pdata_two_arpel_negreg_out[14:0],sdain_adc_arpel_in};
                end  
              `ch2_data_read_101_arpel_state:
                begin
                  pdata_two_upcoming_arpel_negwr_out  <= {pdata_two_arpel_negreg_out[14:0],sdain_adc_arpel_in};
                end  
              `ch2_data_read_91_arpel_state:
                begin
                  pdata_two_upcoming_arpel_negwr_out  <= {pdata_two_arpel_negreg_out[14:0],sdain_adc_arpel_in};
                end  
              `ch2_data_read_81_arpel_state:
                begin
                  pdata_two_upcoming_arpel_negwr_out  <= {pdata_two_arpel_negreg_out[14:0],sdain_adc_arpel_in};
                end  
              `ch2_data_read_71_arpel_state:
                begin
                  pdata_two_upcoming_arpel_negwr_out  <= {pdata_two_arpel_negreg_out[14:0],sdain_adc_arpel_in};
                end  
              `ch2_data_read_61_arpel_state:
                begin
                  pdata_two_upcoming_arpel_negwr_out  <= {pdata_two_arpel_negreg_out[14:0],sdain_adc_arpel_in};
                end  
              `ch2_data_read_51_arpel_state:
                begin
                  pdata_two_upcoming_arpel_negwr_out  <= {pdata_two_arpel_negreg_out[14:0],sdain_adc_arpel_in};
                end
              `ch2_data_read_41_arpel_state:
                begin
                  pdata_two_upcoming_arpel_negwr_out  <= {pdata_two_arpel_negreg_out[14:0],sdain_adc_arpel_in};
                end
              `ch2_data_read_31_arpel_state:
                begin
                  pdata_two_upcoming_arpel_negwr_out  <= {pdata_two_arpel_negreg_out[14:0],sdain_adc_arpel_in};
                end
              `ch2_data_read_21_arpel_state:
                begin
                  pdata_two_upcoming_arpel_negwr_out  <= {pdata_two_arpel_negreg_out[14:0],sdain_adc_arpel_in};
                end  
              `ch2_data_read_11_arpel_state:
                begin
                  pdata_two_upcoming_arpel_negwr_out  <= {pdata_two_arpel_negreg_out[14:0],sdain_adc_arpel_in};
                end  
              `ch2_data_read_01_arpel_state:
                begin
                  pdata_two_upcoming_arpel_negwr_out  <= {pdata_two_arpel_negreg_out[14:0],sdain_adc_arpel_in};
                end
              default:
                begin
                  pdata_two_upcoming_arpel_negwr_out <= pdata_two_arpel_negreg_out;
                end    
            endcase
          end
      //-----------------------------------------------------------------------------------------

      //-----------------------------rstn_adc_upcoming_arpel_negwr_out---------------------------
        assign rstn_adc_upcoming_arpel_negwr_out = 1'd0;
      //-----------------------------------------------------------------------------------------
        
      //---------------------------------convst_adc_upcoming_arpel_negwr_out-------------------
         always@*
          begin
            case(state_arpel_negreg) 
              `convst_low_arpel_state:
                begin
                  convst_adc_upcoming_arpel_negwr_out <= 1'd0;
                end
              default:
                begin
                  convst_adc_upcoming_arpel_negwr_out <= 1'd1;
                end    
            endcase
          end
      //-----------------------------------------------------------------------------------------	

      //-----------------------------ch1_data_upcoming_arpel_negwr_out--------------------------
        always @*
          begin
            case(state_arpel_negreg)
              `done_arpel_state:
                begin
                  ch1_data_upcoming_arpel_negwr_out <= pdata_one_arpel_negreg_out;
                end 
              default:
                begin
                  ch1_data_upcoming_arpel_negwr_out <= ch1_data_arpel_negreg_out;
                end    
            endcase
          end
      //-----------------------------------------------------------------------------------------

      //-----------------------------ch2_data_upcoming_arpel_negwr_out---------------------------
        always @*
          begin
            case(state_arpel_negreg)
              `done_arpel_state:
                begin
                  ch2_data_upcoming_arpel_negwr_out <= pdata_two_arpel_negreg_out;
                end
              default:
                begin
                  ch2_data_upcoming_arpel_negwr_out <= ch2_data_arpel_negreg_out;
                end    
            endcase
          end
      //-----------------------------------------------------------------------------------------
          
      //----------------------------counter_upcoming_arpel_negwr---------------------------------
         always@*
          begin
            case(state_arpel_negreg) 
             `convst_low_arpel_state:
                begin
                  counter_upcoming_arpel_negwr <= counter_arpel_negreg + 4'd1;
                end
              default:
                begin
                  counter_upcoming_arpel_negwr <= counter_arpel_negreg;
                end    
            endcase
          end
      //-----------------------------------------------------------------------------------------

      //-----------------------------os0_adc_upcoming_arpel_negwr_out-----------------------------
        assign os0_adc_upcoming_arpel_negwr_out = 1'd0;
      //-------------------------------------------------------------------------------------------
      
      //-----------------------------os1_adc_upcoming_arpel_negwr_out-----------------------------
        assign os1_adc_upcoming_arpel_negwr_out = 1'd0;
      //-------------------------------------------------------------------------------------------
      
      //-----------------------------os2_adc_upcoming_arpel_negwr_out-----------------------------
        assign os2_adc_upcoming_arpel_negwr_out = 1'd0;
      //-------------------------------------------------------------------------------------------

      //-------------------------------done_upcoming_arpel_negwr_out------------------------------
         always@*
          begin
            case(state_arpel_negreg)
              `done_arpel_state:
                begin
                  done_upcoming_arpel_negwr_out <= 1'd1;
                end
            default:
              begin
                done_upcoming_arpel_negwr_out <= 1'd0;
              end    
            endcase
          end
      //-----------------------------------------------------------------------------------------
   
     //----------------------------------DEBUG_PORTS---------------------------------------------
       assign state_debug_arpel_out = state_arpel_negreg;
    //-------------------------------------------------------------------------------------------
  
  //---------------------------------------------------------------------------------------------
endmodule


   