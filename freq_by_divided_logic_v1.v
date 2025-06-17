// freqency divided by 200 mhz from 50mhz and 25mhz clock phase
module freq_by_divided_logic_v1
  (
    input lclk_fbdl_in,

    output reg clock_pulse_fbdl_negreg_out,
    output reg clock_100mhz_fbdl_negreg_out = 1'd0
  );
  //----------------------------------NEGEDGE_REG_DEPENDENT_OUTPUT_WIRES_DECLARATIONS-----------
    reg clock_pulse_upcoming_fbdl_negwr_out;
    wire clock_100mhz_upcoming_fbdl_negwr_out;
  //--------------------------------------------------------------------------------------------

  //----------------------------------NEGEDGE_INTERNAL_REGS_DECLARATIONS------------------------
    reg [2:0] count_fbdl_negreg = 3'd0;
  //--------------------------------------------------------------------------------------------

  //----------------------------------NEGEDGE_REG_DEPENDENT_INTERNAL_WIRES_DECLARATIONS---------
    reg [2:0] count_upcoming_fbdl_negwr;
  //--------------------------------------------------------------------------------------------
      
  //----------------------------------NEGEDGE_SEQUENTIAL_BLOCK----------------------------------
    always@(negedge lclk_fbdl_in)
      begin
        clock_pulse_fbdl_negreg_out <= clock_pulse_upcoming_fbdl_negwr_out; 
        count_fbdl_negreg <= count_upcoming_fbdl_negwr; 
       clock_100mhz_fbdl_negreg_out <= clock_100mhz_upcoming_fbdl_negwr_out;
      end
  //--------------------------------------------------------------------------------------------
    
  //------------------------------------clock_100mhz_upcoming_fbdl_negwr_out---------------------
    assign clock_100mhz_upcoming_fbdl_negwr_out = ~clock_100mhz_fbdl_negreg_out;
  //---------------------------------------------------------------------------------------------

  //----------------------------------NEGEDGE_REG_DEPENDENT_INTERNAL_WIRES_DEFINATIONS----------
    always@*
      begin
        if (count_fbdl_negreg < 3'd7)
          begin
            count_upcoming_fbdl_negwr <= count_fbdl_negreg + 3'd1; 
          end
        else
          begin 
            count_upcoming_fbdl_negwr <= 3'd0;
          end
      end
  //--------------------------------------------------------------------------------------------
    
  //----------------------------------NEGEDGE_REG_DEPENDENT_OUTPUT_WIRES_DEFINATIONS------------

    //----------------------------------clock_pulse_upcoming_fbdl_negwr_out----------------------
      always@*
        begin
          if (count_fbdl_negreg < 3'd7)
            begin
              clock_pulse_upcoming_fbdl_negwr_out <= 1'b1;
            end
          else 
            begin
              clock_pulse_upcoming_fbdl_negwr_out <= 1'b0;
            end
        end
    //-------------------------------------------------------------------------------------------
    
  //---------------------------------------------------------------------------------------------
endmodule 