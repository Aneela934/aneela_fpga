`include "arpel_defines.v"
module adc_spi_read_top_module_v1
  (
    input clkp_asrtm_tin,
    input clkn_asrtm_tin,
    input sdain_asrtm_tin,
    input busy_asrtm_tin,
    input frst_data_asrtm_tin,
  
    output sdaout_asrtm_tout,
	output scl_asrtm_tout,
    output cs_asrtm_tout,
    output rstn_asrtm_tout,
    output convst_adc_asrtm_tout,
    output os0_adc_asrtm_tout,
    output os1_adc_asrtm_tout,
    output os2_adc_asrtm_tout
  );
  //----------------------------------INTEGRATION_INTERNAL_WIRES_DECLARATIONS--------------------
   
    //----------------------------------freq_by_divided_logic_v1_INTERFACE----------------------
      wire lclk_fbdl_in;

      wire clock_pulse_fbdl_negreg_out; 
	    wire clock_100mhz_fbdl_negreg_out;
    //-----------------------------------------------------------------------------------------

    //-----------------------------adc_read_pcm_encoder_logic_v1_INTERFACE---------------------
      wire lclk_arpel_in;
      wire lrst_arpel_in;
      wire adc_enable_arpel_in;
      wire sdain_adc_arpel_in;
      wire busy_adc_arpel_in;
      wire frst_data_adc_arpel_in;

      wire sdo_adc_arpel_negreg_out;
      wire cs_adc_arpel_negreg_out;
      wire sclk_adc_arpel_negreg_out;
      wire rstn_adc_arpel_negreg_out;
      wire convst_adc_arpel_negreg_out;
      wire os0_adc_arpel_negreg_out;
      wire os1_adc_arpel_negreg_out;
      wire os2_adc_arpel_negreg_out;	
      wire [15:0] ch1_data_arpel_negreg_out;
      wire [15:0] ch2_data_arpel_negreg_out;
      wire [15:0] pdata_one_arpel_negreg_out;
      wire [15:0] pdata_two_arpel_negreg_out;
      wire done_arpel_negreg_out;
      wire [`state_arpel_width_minus1:0] state_debug_arpel_out;
    //-------------------------------------------------------------------------------------------
   
    //----------------------------------IBUFDS_INTERFACE-----------------------------------------
      wire clkp_ibufds_in;
      wire clkn_ibufds_in;

      wire clko_ibufds_out;
    //-------------------------------------------------------------------------------------------

    //----------------------------------VIO_INTERFACE--------------------------------------------
      wire clk_vio_in;

      wire reset_vio_out;
      wire enable_vio_out;
    //-------------------------------------------------------------------------------------------

  //--------------------------------------------------------------------------------------------- 
 
  //----------------------------------INTEGRATION_OUTPUTS_DEFINATIONS----------------------------

    //----------------------------------INTEGRATION_INTERNAL_WIRES_DEFNATIONS--------------------
      assign sdaout_asrtm_tout = sdo_adc_arpel_negreg_out;
      assign scl_asrtm_tout = sclk_adc_arpel_negreg_out;
	    assign cs_asrtm_tout = cs_adc_arpel_negreg_out;
      assign rstn_asrtm_tout = rstn_adc_arpel_negreg_out;
      assign convst_adc_asrtm_tout = convst_adc_arpel_negreg_out;
      assign os0_adc_asrtm_tout = os0_adc_arpel_negreg_out;
      assign os1_adc_asrtm_tout = os1_adc_arpel_negreg_out;
      assign os2_adc_asrtm_tout = os2_adc_arpel_negreg_out;
    //-------------------------------------------------------------------------------------------
     
    //----------------------------------freq_by_divided_logic_v1_INTERFACE----------------------
      assign lclk_fbdl_in = clko_ibufds_out;
    //-----------------------------------------------------------------------------------------

    //-----------------------------adc_read_pcm_encoder_logic_v1_INTERFACE-----------------------
      assign lclk_arpel_in = clock_pulse_fbdl_negreg_out;
      assign lrst_arpel_in = reset_vio_out;
      assign adc_enable_arpel_in = enable_vio_out;
      assign sdain_adc_arpel_in = sdain_asrtm_tin;
    //-------------------------------------------------------------------------------------------

    //----------------------------------IBUFDS_INTERFACE-----------------------------------------
      assign clkp_ibufds_in = clkp_asrtm_tin;
      assign clkn_ibufds_in = clkn_asrtm_tin;
    //-------------------------------------------------------------------------------------------

    //----------------------------------VIO_INTERFACE--------------------------------------------
      assign clk_vio_in = clko_ibufds_out;
    //-------------------------------------------------------------------------------------------

  //---------------------------------------------------------------------------------------------

  //----------------------------------INTEGRATION_INTERNAL_WIRES_DEFNATIONS--------------------
       
    //----------------------------------freq_by_divided_logic_v1_INTERFACE----------------------
       freq_by_divided_logic_v1  fbdl_inst
        (
          .lclk_fbdl_in(lclk_fbdl_in),
				
          .clock_pulse_fbdl_negreg_out(clock_pulse_fbdl_negreg_out),
		      .clock_100mhz_fbdl_negreg_out(clock_100mhz_fbdl_negreg_out)
        ); 
    //-------------------------------------------------------------------------------------------
	
    //-----------------------------adc_read_pcm_encoder_logic_v1_INTERFACE-----------------------
      adc_read_pcm_encoder_logic_v1  arpel_inst
        (
          .lclk_arpel_in(lclk_arpel_in),
          .lrst_arpel_in(lrst_arpel_in),
          .adc_enable_arpel_in(adc_enable_arpel_in),
          .sdain_adc_arpel_in(sdain_adc_arpel_in),

		  .sdo_adc_arpel_negreg_out(sdo_adc_arpel_negreg_out),
          .cs_adc_arpel_negreg_out(cs_adc_arpel_negreg_out),
          .sclk_adc_arpel_negreg_out(sclk_adc_arpel_negreg_out),
          .rstn_adc_arpel_negreg_out(rstn_adc_arpel_negreg_out),
          .convst_adc_arpel_negreg_out(convst_adc_arpel_negreg_out),
          .os0_adc_arpel_negreg_out(os0_adc_arpel_negreg_out),
          .os1_adc_arpel_negreg_out(os1_adc_arpel_negreg_out),
          .os2_adc_arpel_negreg_out(os2_adc_arpel_negreg_out),
          .ch1_data_arpel_negreg_out(ch1_data_arpel_negreg_out),
          .ch2_data_arpel_negreg_out(ch2_data_arpel_negreg_out),
          .pdata_one_arpel_negreg_out(pdata_one_arpel_negreg_out),
          .pdata_two_arpel_negreg_out(pdata_two_arpel_negreg_out),
          .done_arpel_negreg_out(done_arpel_negreg_out),
          .state_debug_arpel_out(state_debug_arpel_out)
        );
    //-------------------------------------------------------------------------------------------
    
    //----------------------------------IBUFDS_INTERFACE-----------------------------------------
       IBUFDS  ibufds_inst 
        (
          .I(clkp_ibufds_in),
          .IB(clkn_ibufds_in),

          .O(clko_ibufds_out)
        );
    //-------------------------------------------------------------------------------------------

    //----------------------------------VIO_INTERFACE--------------------------------------------
       vio_0  vio_0_inst 
        (
          .clk(clk_vio_in),

          .probe_out0(reset_vio_out),
          .probe_out1(enable_vio_out)
        );
    //-------------------------------------------------------------------------------------------

    //----------------------------------ILA_ADC_INTERFACE----------------------------------------
        ila_adc  ila_adc_inst
        (
         .clk(clock_100mhz_fbdl_negreg_out),

	       .probe0(ch1_data_arpel_negreg_out), //16 bits
	       .probe1(sdain_asrtm_tin), 
	       .probe2(sdaout_asrtm_tout),
	       .probe3(scl_asrtm_tout),
	       .probe4(cs_asrtm_tout),
	       .probe5(busy_asrtm_tin),
	       .probe6(rstn_asrtm_tout),
	       .probe7(done_arpel_negreg_out),
	       .probe8(state_debug_arpel_out), //7 bits
         .probe9(frst_data_asrtm_tin),
         .probe10(ch2_data_arpel_negreg_out),
         .probe11(pdata_one_arpel_negreg_out),
         .probe12(pdata_two_arpel_negreg_out)
        );
    //-------------------------------------------------------------------------------------------;

  //---------------------------------------------------------------------------------------------
endmodule
