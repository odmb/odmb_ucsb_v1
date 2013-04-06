----------------------------------------------------------------------------------
-- Company: UCSB
-- Engineer/Physicists: Guido Magazzu, Frank Golf, Manuel Franco Sevilla, David Nash
--
-- Create Date:     03/03/2013
-- Project Name:    ODMB_UCSB_V1
-- Target Devices:  Virtex-6
-- Tool versions:   ISE 12.3
-- Description:     Official firmware for the ODMB.V1
--
-- Revision 0.01 - File Created
----------------------------------------------------------------------------------

LIBRARY IEEE;
USE IEEE.std_logic_1164.all; 
USE IEEE.std_logic_arith.all;
USE IEEE.std_logic_unsigned.all;
LIBRARY UNISIM;
USE UNISIM.vcomponents.all;
LIBRARY UNIMACRO;
USE UNIMACRO.vcomponents.all;
LIBRARY work;
--USE work.Latches_Flipflops.all;


ENTITY ODMB_V6 IS
  generic (
    NFEB : integer range 1 to 7 := 7  -- Number of DCFEBS, 7 in the final design
    );  
	PORT
	(

-- From/To VME connector To/From MBV

		vme_data : INOUT STD_LOGIC_VECTOR(15 DOWNTO 0);		-- OK		d(15 DOWNTO 0)
		vme_addr : IN STD_LOGIC_VECTOR(23 DOWNTO 1);			-- OK		a(23 DOWNTO 1)
		vme_am : IN STD_LOGIC_VECTOR(5 DOWNTO 0);				-- OK		am(6 DOWNTO 0)
		vme_gap : IN STD_LOGIC;										-- OK		gap = ga(5)
		vme_ga : IN STD_LOGIC_VECTOR(4 DOWNTO 0);				-- OK		ga(4 DOWNTO 0)
		vme_bg0 : IN STD_LOGIC;										-- OK		NEW!
		vme_bg1 : IN STD_LOGIC;										-- OK		NEW!
		vme_bg2 : IN STD_LOGIC;										-- OK		NEW!
		vme_bg3 : IN STD_LOGIC;										-- OK		NEW!
		vme_as_b : IN STD_LOGIC;									-- OK		as*
		vme_ds_b : IN STD_LOGIC_VECTOR(1 DOWNTO 0);			-- OK		ds1*,ds0*
		vme_sysreset_b : IN STD_LOGIC;							-- OK		sysreset*
		vme_sysfail_b : IN STD_LOGIC;								-- OK		sysfail*
		vme_sysfail_out : OUT STD_LOGIC;							-- OK		NEW!
		vme_berr_b : IN STD_LOGIC;									-- OK		berr*
		vme_berr_out : OUT STD_LOGIC;								-- OK		NEW!
		vme_iack_b : IN STD_LOGIC;									-- OK		iack*
		vme_lword_b : IN STD_LOGIC;								-- OK		lword*
		vme_write_b : IN STD_LOGIC;								-- OK		write*
		vme_clk : IN STD_LOGIC;										-- OK		???
		vme_dtack_v6_b : INOUT STD_LOGIC;						-- OK		dtack*
		vme_tovme : OUT STD_LOGIC;									-- OK		not (tovme)
		vme_doe : OUT STD_LOGIC;									-- OK		not (doe*)

-- From/To J6 (J3) connector to ODMB_CTRL

		ccb_cmd : IN STD_LOGIC_VECTOR(5 DOWNTO 0);			-- OK		ccbcmnd(5 DOWNTO 0)
		ccb_cmd_s : IN STD_LOGIC;									-- OK		ccbcmnd(6)
		ccb_data : IN STD_LOGIC_VECTOR(7 DOWNTO 0);			-- OK		ccbdata(7 DOWNTO 0)
		ccb_data_s : IN STD_LOGIC;									-- OK		ccbdata(8)
		ccb_cal : IN STD_LOGIC_VECTOR(2 DOWNTO 0);			-- OK		ccbcal(14 DOWNTO 12)
		ccb_crsv : IN STD_LOGIC_VECTOR(4 DOWNTO 0);			-- OK		nc (J3/B2), ccbrsv(3 DOWNTO 0) = crsv(3 DOWNTO 0)
		ccb_drsv : IN STD_LOGIC_VECTOR(1 DOWNTO 0);			-- OK		ccbrsv(5 DOWNTO 4) = drsv(1 DOWNTO 0)
		ccb_rsvo : IN STD_LOGIC_VECTOR(4 DOWNTO 0);			-- OK		nc (J3/A21), ccbsrv(10 DOWNTO 7) = rsvo(3 DOWNTO 0)
		ccb_rsvi : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);			-- OK		ccbsrv(14 DOWNTO 12)
		ccb_bx0 : IN STD_LOGIC;										-- OK		bx0
		ccb_bxrst : IN STD_LOGIC;									-- OK		bxrst
		ccb_l1arst : IN STD_LOGIC;									-- OK		l1arst
		ccb_l1acc : IN STD_LOGIC;									-- OK		l1acc
		ccb_l1rls : OUT STD_LOGIC;									-- OK		l1rls
		ccb_clken : IN STD_LOGIC;									-- OK		clkena

		ccb_hardrst : IN STD_LOGIC;								-- OK		
		ccb_softrst : IN STD_LOGIC;								-- OK		

-- From J6/J7 (J3/J4) to FIFOs

		tmb : IN STD_LOGIC_VECTOR(17 DOWNTO 0);				-- OK		f6di(17 DOWNTO 0)
		alct : IN STD_LOGIC_VECTOR(17 DOWNTO 0);				-- OK		f7di(17 DOWNTO 0)
		rawlct : IN STD_LOGIC_VECTOR(NFEB DOWNTO 0);				-- OK		???
		tmbffclk : IN STD_LOGIC;									-- OK		tmbffclk

-- From/To J3/J4 t/fromo ODMB_CTRL

		lctdav1 : IN STD_LOGIC;										-- OK		lctdav1
		lctdav2 : IN STD_LOGIC;										-- OK		lctdav2
--		rsvtd : INOUT STD_LOGIC_VECTOR(7 DOWNTO 0);			
		rsvtd_in : IN STD_LOGIC_VECTOR(4	DOWNTO 0);			-- OK		rstvd(7 DOWNTO 4)
		rsvtd_out : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);		-- OK		rstvd(2 DOWNTO 0)
		lctrqst : OUT STD_LOGIC_VECTOR(2 DOWNTO 1);			-- OK		lctrqst(2 DOWNTO 1)


-- From/To QPLL (From/To DAQMBV)

		qpll_autorestart : OUT STD_LOGIC;						-- OK		NEW!
		qpll_mode : OUT STD_LOGIC;									-- OK		NEW!
		qpll_extcontrol : OUT STD_LOGIC;							-- OK		NEW!
		qpll_reset : OUT STD_LOGIC;								-- OK		NEW!
		qpll_f0sel : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);		-- OK		NEW!
		qpll_locked : IN STD_LOGIC;								-- OK		NEW!
		qpll_error : IN STD_LOGIC;									-- OK		NEW!

		qpll_clk40MHz_p : IN STD_LOGIC;							-- OK		NEW!
		qpll_clk40MHz_n : IN STD_LOGIC;							-- OK		NEW!
		qpll_clk80MHz_p : IN STD_LOGIC;							-- OK		NEW!
		qpll_clk80MHz_n : IN STD_LOGIC;							-- OK		NEW!
--		qpll_clk160MHz_p : IN STD_LOGIC;							-- NEW!
--		qpll_clk160MHz_n : IN STD_LOGIC;							-- NEW!
		
-- From/To LVMB (From/To DAQMBV and DAQMBC)

		lvmb_pon : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);		-- OK		pwon(6 DOWNTO 1)
		pon_load : OUT STD_LOGIC;								-- OK		loadpwon
		pon_en : OUT STD_LOGIC;									-- OK		pwon_en*
		r_lvmb_pon : IN STD_LOGIC_VECTOR(7 DOWNTO 0);	-- OK		multi(6 DOWNTO 1) (r_pwon(6 DOWNTO 1))
		lvmb_csb : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);		-- OK		multi(13 DOWNTO 7)
		lvmb_sclk : OUT STD_LOGIC;								-- OK		multi(14)
		lvmb_sdin : OUT STD_LOGIC;								-- OK		multi(15)
		lvmb_sdout : IN STD_LOGIC;								-- OK		multi(16)

-- From/To ADC (From/To DAQMBV)

		adc_sclk : OUT STD_LOGIC;						-- OK		NEW!
		adc_sdain : OUT STD_LOGIC;						-- OK		NEW!
		adc_sdaout : IN STD_LOGIC;						-- OK		NEW!
		adc_cs : OUT STD_LOGIC;							-- OK		NEW!

-- From/To DAC (From/To DAQMBV)

		dac_sclk : OUT STD_LOGIC;						-- OK		NEW!
		dac_sdain : OUT STD_LOGIC;						-- OK		NEW!
		dac_sdaout : IN STD_LOGIC;						-- OK		NEW!
		dac_cs : OUT STD_LOGIC;							-- OK		NEW!

-- To LEDs

		leds : OUT STD_LOGIC_VECTOR(11 DOWNTO 0);	-- OK		NEW!	

-- To Frequency Divider FF

		fd_pre : OUT STD_LOGIC;							-- OK		NEW!	
		fd_clr : OUT STD_LOGIC;							-- OK		NEW!	

-- From Push Buttons

		pb : IN STD_LOGIC_VECTOR(3 DOWNTO 0);		-- OK

-- From/To Test Connector for Single-Ended signals

--		d : INOUT STD_LOGIC_VECTOR(63 DOWNTO 0);	-- OK		
		d : OUT STD_LOGIC_VECTOR(63 DOWNTO 0);	-- OK		


-- From/To Test Connector J3 for LVDS signals

		gtx_0_p : IN STD_LOGIC;					-- OK			
		gtx_0_n : IN STD_LOGIC;					-- OK			
		grx_0_p : OUT STD_LOGIC;				-- OK (out)			
		grx_0_n : OUT STD_LOGIC;				-- OK (out)			

		ck_0_p : IN STD_LOGIC;					-- OK			
		ck_0_n : IN STD_LOGIC;					-- OK			
		ck_1_p : IN STD_LOGIC;					-- OK			
		ck_1_n : IN STD_LOGIC;					-- OK			
		tclk_p : IN STD_LOGIC;					-- OK			
		tclk_n : IN STD_LOGIC;					-- OK			
		rxb_p : OUT STD_LOGIC;					-- OK			
		rxb_n : OUT STD_LOGIC;					-- OK			
		
		tx_0_p : OUT STD_LOGIC;					-- OK			
		tx_0_n : OUT STD_LOGIC;					-- OK			
		tx_1_p : OUT STD_LOGIC;					-- OK			
		tx_1_n : OUT STD_LOGIC;					-- OK			
		tx_2_p : OUT STD_LOGIC;					-- OK			
		tx_2_n : OUT STD_LOGIC;					-- OK			
		tx_3_p : OUT STD_LOGIC;					-- OK			
		tx_3_n : OUT STD_LOGIC;					-- OK			
		tx_4_p : OUT STD_LOGIC;					-- OK			
		tx_4_n : OUT STD_LOGIC;					-- OK			
		tx_5_p : OUT STD_LOGIC;					-- OK			
		tx_5_n : OUT STD_LOGIC;					-- OK			
		tx_6_p : OUT STD_LOGIC;					-- OK			
		tx_6_n : OUT STD_LOGIC;					-- OK			
		tx_7_p : OUT STD_LOGIC;					-- OK			
		tx_7_n : OUT STD_LOGIC;					-- OK			
		tx_8_p : OUT STD_LOGIC;					-- OK			
		tx_8_n : OUT STD_LOGIC;					-- OK			
		tx_9_p : OUT STD_LOGIC;					-- OK			
		tx_9_n : OUT STD_LOGIC;					-- OK			
		tx_10_p : OUT STD_LOGIC;				-- OK			
		tx_10_n : OUT STD_LOGIC;				-- OK			

		rx_0_p : IN STD_LOGIC;					-- OK		
		rx_0_n : IN STD_LOGIC;					-- OK			
		rx_1_p : IN STD_LOGIC;					-- OK				
		rx_1_n : IN STD_LOGIC;					-- OK				
		rx_2_p : IN STD_LOGIC;					-- OK				
		rx_2_n : IN STD_LOGIC;					-- OK				
		rx_3_p : IN STD_LOGIC;					-- OK				
		rx_3_n : IN STD_LOGIC;					-- OK				
		rx_4_p : IN STD_LOGIC;					-- OK			
		rx_4_n : IN STD_LOGIC;					-- OK			
		rx_5_p : IN STD_LOGIC;					-- OK				
		rx_5_n : IN STD_LOGIC;					-- OK				
		rx_6_p : IN STD_LOGIC;					-- OK				
		rx_6_n : IN STD_LOGIC;					-- OK				
		rx_7_p : IN STD_LOGIC;					-- OK				
		rx_7_n : IN STD_LOGIC;					-- OK				
		rx_8_p : IN STD_LOGIC;					-- OK			
		rx_8_n : IN STD_LOGIC;					-- OK			
		rx_9_p : IN STD_LOGIC;					-- OK				
		rx_9_n : IN STD_LOGIC;					-- OK				
		rx_10_p : IN STD_LOGIC;					-- OK				
		rx_10_n : IN STD_LOGIC;					-- OK				

-- To/From TX1 

		otx1_01_p : OUT  STD_LOGIC;			-- OK	
		otx1_01_n : OUT  STD_LOGIC;			-- OK	
		otx1_02_p : OUT  STD_LOGIC;			-- OK	
		otx1_02_n : OUT  STD_LOGIC;			-- OK	
		otx1_03_p : OUT  STD_LOGIC;			-- OK	
		otx1_03_n : OUT  STD_LOGIC;			-- OK	
		otx1_04_p : OUT  STD_LOGIC;			-- OK	
		otx1_04_n : OUT  STD_LOGIC;			-- OK	
		otx1_05_p : OUT  STD_LOGIC;			-- OK	
		otx1_05_n : OUT  STD_LOGIC;			-- OK	
		otx1_06_p : OUT  STD_LOGIC;			-- OK	
		otx1_06_n : OUT  STD_LOGIC;			-- OK	
		otx1_07_p : OUT  STD_LOGIC;			-- OK	
		otx1_07_n : OUT  STD_LOGIC;			-- OK	
		otx1_08_p : OUT  STD_LOGIC;			-- OK	
		otx1_08_n : OUT  STD_LOGIC;			-- OK
		otx1_09_p : OUT  STD_LOGIC;			-- OK	
		otx1_09_n : OUT  STD_LOGIC;			-- OK	
		otx1_10_p : OUT  STD_LOGIC;			-- OK	
		otx1_10_n : OUT  STD_LOGIC;			-- OK	
		otx1_11_p : OUT  STD_LOGIC;			-- OK	
		otx1_11_n : OUT  STD_LOGIC;			-- OK	
		otx1_12_p : OUT  STD_LOGIC;			-- OK	
		otx1_12_n : OUT  STD_LOGIC;			-- OK	

		otx1_tx_en : OUT  STD_LOGIC;			-- OK
		otx1_tx_dis : OUT  STD_LOGIC;			-- OK
		otx1_reset : OUT  STD_LOGIC;			-- OK
		otx1_fault : IN  STD_LOGIC;			-- OK
		
-- To/From TX2 

		otx2_01_p : OUT  STD_LOGIC;			-- OK	
		otx2_01_n : OUT  STD_LOGIC;			-- OK	
		otx2_02_p : OUT  STD_LOGIC;			-- OK	
		otx2_02_n : OUT  STD_LOGIC;			-- OK	
		otx2_03_p : OUT  STD_LOGIC;			-- OK	
		otx2_03_n : OUT  STD_LOGIC;			-- OK	
		otx2_04_p : OUT  STD_LOGIC;			-- OK	
		otx2_04_n : OUT  STD_LOGIC;			-- OK	
		otx2_05_p : OUT  STD_LOGIC;			-- OK	
		otx2_05_n : OUT  STD_LOGIC;			-- OK	
		otx2_06_p : OUT  STD_LOGIC;			-- OK	
		otx2_06_n : OUT  STD_LOGIC;			-- OK	
		otx2_07_p : OUT  STD_LOGIC;			-- OK	
		otx2_07_n : OUT  STD_LOGIC;			-- OK	
		otx2_08_p : OUT  STD_LOGIC;			-- OK	
		otx2_08_n : OUT  STD_LOGIC;			-- OK	
		otx2_09_p : OUT  STD_LOGIC;			-- OK	
		otx2_09_n : OUT  STD_LOGIC;			-- OK	
		otx2_10_p : OUT  STD_LOGIC;			-- OK	
		otx2_10_n : OUT  STD_LOGIC;			-- OK	
		otx2_11_p : OUT  STD_LOGIC;			-- OK	
		otx2_11_n : OUT  STD_LOGIC;			-- OK	
		otx2_12_p : OUT  STD_LOGIC;			-- OK	
		otx2_12_n : OUT  STD_LOGIC;			-- OK	

		otx2_tx_en : OUT  STD_LOGIC;			-- OK	
		otx2_tx_dis : OUT  STD_LOGIC;			-- OK	
		otx2_reset : OUT  STD_LOGIC;			-- OK	
		otx2_fault : IN  STD_LOGIC;			-- OK	

-- From/To RX1 

		orx1_01_p : IN  STD_LOGIC;				-- OK		
		orx1_01_n : IN  STD_LOGIC;				-- OK		
		orx1_02_p : IN  STD_LOGIC;				-- OK	
		orx1_02_n : IN  STD_LOGIC;				-- OK
		orx1_03_p : IN  STD_LOGIC;				-- OK
		orx1_03_n : IN  STD_LOGIC;				-- OK
		orx1_04_p : IN  STD_LOGIC;				-- OK
		orx1_04_n : IN  STD_LOGIC;				-- OK
		orx1_05_p : IN  STD_LOGIC;				-- OK
		orx1_05_n : IN  STD_LOGIC;				-- OK
		orx1_06_p : IN  STD_LOGIC;				-- OK
		orx1_06_n : IN  STD_LOGIC;				-- OK
		orx1_07_p : IN  STD_LOGIC;				-- OK
		orx1_07_n : IN  STD_LOGIC;				-- OK
		orx1_08_p : IN  STD_LOGIC;				-- OK
		orx1_08_n : IN  STD_LOGIC;				-- OK
		orx1_09_p : IN  STD_LOGIC;				-- OK
		orx1_09_n : IN  STD_LOGIC;				-- OK
		orx1_10_p : IN  STD_LOGIC;				-- OK
		orx1_10_n : IN  STD_LOGIC;				-- OK
		orx1_11_p : IN  STD_LOGIC;				-- OK
		orx1_11_n : IN  STD_LOGIC;				-- OK
		orx1_12_p : IN  STD_LOGIC;				-- OK
		orx1_12_n : IN  STD_LOGIC;				-- OK

		orx1_rx_en : OUT  STD_LOGIC;			-- OK
		orx1_en_sd : OUT  STD_LOGIC;			-- OK
		orx1_sd : IN  STD_LOGIC;				-- OK
		orx1_sq_en : OUT  STD_LOGIC;			-- OK

-- From/To RX2 

		orx2_01_p : IN  STD_LOGIC;				-- OK		
		orx2_01_n : IN  STD_LOGIC;				-- OK	
		orx2_02_p : IN  STD_LOGIC;				-- OK	
		orx2_02_n : IN  STD_LOGIC;				-- OK	
		orx2_03_p : IN  STD_LOGIC;				-- OK	
		orx2_03_n : IN  STD_LOGIC;				-- OK	
		orx2_04_p : IN  STD_LOGIC;				-- OK	
		orx2_04_n : IN  STD_LOGIC;				-- OK	
		orx2_05_p : IN  STD_LOGIC;				-- OK	
		orx2_05_n : IN  STD_LOGIC;				-- OK	
		orx2_06_p : IN  STD_LOGIC;				-- OK	
		orx2_06_n : IN  STD_LOGIC;				-- OK	
		orx2_07_p : IN  STD_LOGIC;				-- OK	
		orx2_07_n : IN  STD_LOGIC;				-- OK	
		orx2_08_p : IN  STD_LOGIC;				-- OK	
		orx2_08_n : IN  STD_LOGIC;				-- OK	
		orx2_09_p : IN  STD_LOGIC;				-- OK	
		orx2_09_n : IN  STD_LOGIC;				-- OK	
		orx2_10_p : IN  STD_LOGIC;				-- OK	
		orx2_10_n : IN  STD_LOGIC;				-- OK	
		orx2_11_p : IN  STD_LOGIC;				-- OK	
		orx2_11_n : IN  STD_LOGIC;				-- OK	
		orx2_12_p : IN  STD_LOGIC;				-- OK	
		orx2_12_n : IN  STD_LOGIC;				-- OK	

		orx2_rx_en : OUT  STD_LOGIC;			-- OK	
		orx2_en_sd : OUT  STD_LOGIC;			-- OK	
		orx2_sd : IN  STD_LOGIC;				-- OK	
		orx2_sq_en : OUT  STD_LOGIC;			-- OK	

-- From/To OT1 (GigaBit Link)

		gl0_tx_p : OUT  STD_LOGIC;				-- OK
		gl0_tx_n : OUT  STD_LOGIC;				-- OK
		gl0_rx_p : IN  STD_LOGIC;				-- OK
		gl0_rx_n : IN  STD_LOGIC;				-- OK

-- From/To OT2 (GigaBit Link)

		gl1_tx_p : OUT  STD_LOGIC;				-- OK
		gl1_tx_n : OUT  STD_LOGIC;				-- OK
		gl1_rx_p : IN  STD_LOGIC;				-- OK
		gl1_rx_n : IN  STD_LOGIC;				-- OK

-- From IC7 (Clock Driver CDC)

		cdc_clk_0_p : IN  STD_LOGIC;			-- OK
		cdc_clk_0_n : IN  STD_LOGIC;			-- OK
		cdc_clk_1_p : IN  STD_LOGIC;			-- OK
		cdc_clk_1_n : IN  STD_LOGIC;			-- OK
		cdc_clk_2_p : IN  STD_LOGIC;			-- OK
		cdc_clk_2_n : IN  STD_LOGIC;			-- OK
		cdc_clk_3_p : IN  STD_LOGIC;			-- OK
		cdc_clk_3_n : IN  STD_LOGIC;			-- OK
		cdc_clk_4_p : IN  STD_LOGIC;			-- OK
		cdc_clk_4_n : IN  STD_LOGIC;			-- OK
		cdc_clk_5_p : IN  STD_LOGIC;			-- OK
		cdc_clk_5_n : IN  STD_LOGIC;			-- OK
		cdc_clk_6_p : IN  STD_LOGIC;			-- OK
		cdc_clk_6_n : IN  STD_LOGIC;			-- OK
		cdc_clk_7_p : IN  STD_LOGIC;			-- OK
		cdc_clk_7_n : IN  STD_LOGIC;			-- OK

-- From IC31 

		gl0_clk : IN  STD_LOGIC;				-- OK
		gl1_clk : IN  STD_LOGIC;				-- OK
		
		done_in : IN  STD_LOGIC 
	);
END ODMB_V6;

ARCHITECTURE bdf_type OF ODMB_V6 IS 

COMPONENT fifo_wc_sel IS
  
  port (

		fifo_sel : IN STD_LOGIC_VECTOR(7 downto 0);
		fifo0_wc : IN STD_LOGIC_VECTOR(9 downto 0);
		fifo1_wc : IN STD_LOGIC_VECTOR(9 downto 0);
		fifo2_wc : IN STD_LOGIC_VECTOR(9 downto 0);
		fifo3_wc : IN STD_LOGIC_VECTOR(9 downto 0);
		fifo4_wc : IN STD_LOGIC_VECTOR(9 downto 0);
		fifo5_wc : IN STD_LOGIC_VECTOR(9 downto 0);
		fifo6_wc : IN STD_LOGIC_VECTOR(9 downto 0);
		fifo7_wc : IN STD_LOGIC_VECTOR(9 downto 0);
		fifo_wc : OUT STD_LOGIC_VECTOR(9 downto 0));

end COMPONENT;

COMPONENT fifo_rc_sel IS
  
  port (

		fifo_sel : IN STD_LOGIC_VECTOR(7 downto 0);
		fifo0_rc : IN STD_LOGIC_VECTOR(9 downto 0);
		fifo1_rc : IN STD_LOGIC_VECTOR(9 downto 0);
		fifo2_rc : IN STD_LOGIC_VECTOR(9 downto 0);
		fifo3_rc : IN STD_LOGIC_VECTOR(9 downto 0);
		fifo4_rc : IN STD_LOGIC_VECTOR(9 downto 0);
		fifo5_rc : IN STD_LOGIC_VECTOR(9 downto 0);
		fifo6_rc : IN STD_LOGIC_VECTOR(9 downto 0);
		fifo7_rc : IN STD_LOGIC_VECTOR(9 downto 0);
		fifo_rc : OUT STD_LOGIC_VECTOR(9 downto 0));

end COMPONENT;

COMPONENT fifo_outdata_sel IS
  
  port (

		fifo_sel : IN STD_LOGIC_VECTOR(7 downto 0);
		fifo0_outdata : IN STD_LOGIC_VECTOR(15 downto 0);
		fifo1_outdata : IN STD_LOGIC_VECTOR(15 downto 0);
		fifo2_outdata : IN STD_LOGIC_VECTOR(15 downto 0);
		fifo3_outdata : IN STD_LOGIC_VECTOR(15 downto 0);
		fifo4_outdata : IN STD_LOGIC_VECTOR(15 downto 0);
		fifo5_outdata : IN STD_LOGIC_VECTOR(15 downto 0);
		fifo6_outdata : IN STD_LOGIC_VECTOR(15 downto 0);
		fifo7_outdata : IN STD_LOGIC_VECTOR(15 downto 0);
		fifo_outdata : OUT STD_LOGIC_VECTOR(15 downto 0));

end COMPONENT;

COMPONENT dmb_receiver
	port(
   RST : IN STD_LOGIC;
--	// External signals
	DAQ_SIGDET : IN STD_LOGIC;
	DAQ_RX_N : IN STD_LOGIC;
	DAQ_RX_P : IN STD_LOGIC;
	DAQ_TDIS : OUT STD_LOGIC;
	DAQ_TX_N : OUT STD_LOGIC;
	DAQ_TX_P : OUT STD_LOGIC;
--	// Internal signals
	DAQ_RX_125REFCLK : IN STD_LOGIC;
	DAQ_RX_160REFCLK : IN STD_LOGIC;
	DAQ_RX_WDATA : OUT STD_LOGIC_VECTOR(15 downto 0);
	DAQ_RXD_VLD : OUT STD_LOGIC;
	DAQ_SD : OUT STD_LOGIC;
	DAQ_DATA_CLK : OUT STD_LOGIC
  );
END COMPONENT;

COMPONENT mode_pb_sel IS
	port (

		pb0 : IN STD_LOGIC;
		pb1 : IN STD_LOGIC;
		pb2 : IN STD_LOGIC;
		pb3 : IN STD_LOGIC;
		pb_reset : OUT STD_LOGIC;
		lb_en : OUT STD_LOGIC;
		lb_ff_en : OUT STD_LOGIC;
		tm_en : OUT STD_LOGIC
	);
END COMPONENT;


COMPONENT LVMB_ADC_SDO_MUX IS
	port (
		int_lvmb_adc_en : IN STD_LOGIC;
		int_lvmb_adc_sdo : IN STD_LOGIC_VECTOR(6 downto 0);
		lvmb_adc_sdo : IN STD_LOGIC;
		adc_ce : IN STD_LOGIC_VECTOR(6 downto 0);
		sdo : OUT STD_LOGIC
	);
END COMPONENT;

COMPONENT LVMB_ADC IS
	port (

		scl : IN STD_LOGIC;
		sdi : IN STD_LOGIC;
		sdo : INOUT STD_LOGIC;
		ce : IN STD_LOGIC;
		rst : IN STD_LOGIC;
		device : IN STD_LOGIC_VECTOR(3 downto 0)
	);
END COMPONENT;

COMPONENT DCFEB_V6 is
generic (
    dcfeb_addr : std_logic_vector(3 downto 0) := "1000"  -- DCFEB address
    );  
port 
	(clk: IN STD_LOGIC;
	 rst: IN STD_LOGIC;
	 l1a : IN STD_LOGIC;
	 l1a_match : IN STD_LOGIC;
	 dcfeb_dv : OUT STD_LOGIC;
   dcfeb_data : OUT STD_LOGIC_VECTOR(15 downto 0);
   adc_mask : OUT STD_LOGIC_VECTOR(11 downto 0);
	 dcfeb_fsel : OUT STD_LOGIC_VECTOR(32 downto 0);
	 dcfeb_jtag_ir : OUT STD_LOGIC_VECTOR(9 downto 0);
	 trst : IN STD_LOGIC;
	 tck : IN STD_LOGIC;
 	 tms : IN STD_LOGIC;
 	 tdi : IN STD_LOGIC;
 	 rtn_shft_en : OUT STD_LOGIC;
  	 tdo : OUT STD_LOGIC);
end COMPONENT;

COMPONENT ODMB_CTRL IS
	port (
		mbc_fsel: OUT STD_LOGIC_VECTOR(47 downto 1);
		mbc_jtag_ir: OUT STD_LOGIC_VECTOR(9 downto 0);

		ccb_cmd : IN STD_LOGIC_VECTOR (5 downto 0);				-- ccbcmnd(5 downto 0) - from J3
		ccb_cmd_s : IN STD_LOGIC;										-- ccbcmnd(6) - from J3
		ccb_data : IN STD_LOGIC_VECTOR (7 downto 0);				-- ccbdata(7 downto 0) - from J3
		ccb_data_s : IN STD_LOGIC;										-- ccbdata(8) - from J3
		ccb_cal : IN STD_LOGIC_VECTOR (2 downto 0);				-- ccbcal(2 downto 0) - from J3
		ccb_crsv : IN STD_LOGIC_VECTOR (4 downto 0);				-- NEW [ccbrsv(6)], ccbrsv(3 downto 0) - from J3
		ccb_drsv : IN STD_LOGIC_VECTOR (1 downto 0);				-- ccbrsv(5 downto 4) - from J3
		ccb_rsvo : IN STD_LOGIC_VECTOR (4 downto 0);				-- NEW [ccbrsv(11)], ccbrsv(10 downto 7) - from J3
		ccb_rsvi : OUT STD_LOGIC_VECTOR (2 downto 0);			-- ccbrsv(14 downto 12) - to J3
		ccb_bx0 : IN STD_LOGIC;											-- bx0 - from J3
		ccb_bxrst : IN STD_LOGIC;										-- bxrst - from J3
		ccb_l1acc : IN STD_LOGIC;										-- l1acc - from J3
		ccb_l1arst : IN STD_LOGIC;										-- l1rst - from J3
		ccb_l1rls : OUT STD_LOGIC;										-- l1rls - to J3
		ccb_clken : IN STD_LOGIC;										-- clken - from J3

		rawlct : IN STD_LOGIC_VECTOR (NFEB downto 0);				-- rawlct(5 downto 0) - from J4
		lctdav1 : IN STD_LOGIC;											-- lctdav1 - from J4
		lctdav2 : IN STD_LOGIC;											-- lctdav2 - from J4
		lctrqst : OUT STD_LOGIC_VECTOR (2 downto 1);				-- lctrqst(2 downto 1) - to J4
		rsvtd_in : IN STD_LOGIC_VECTOR(4 DOWNTO 0);				-- spare(7 DOWNTO 3) - to J4
		rsvtd_out : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);			-- spare(2 DOWNTO 0) - from J4

-- From GigaLinks

		grx0_data : IN STD_LOGIC_VECTOR(15 DOWNTO 0);	-- glin(15 downto 0)									  
		grx0_data_valid : IN STD_LOGIC;			 
		grx1_data : IN STD_LOGIC_VECTOR(15 DOWNTO 0);	-- glin(15 downto 0)											  
		grx1_data_valid : IN STD_LOGIC;			 
	
-- From GigaLinks

		gtx0_data : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);	-- dout(15 downto 0)											  
		gtx0_data_valid : OUT STD_LOGIC;			 
		gtx1_data : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);	-- dout(15 downto 0)											  
		gtx1_data_valid : OUT STD_LOGIC;			 
	
-- From/To FIFOs

		fifo_rd_ck : OUT STD_LOGIC;										  
		fifo_rd_en : OUT STD_LOGIC_VECTOR(9 DOWNTO 1);										  
		fifo_sel : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);			 

		fifo_out : IN STD_LOGIC_VECTOR(17 DOWNTO 0);				

		fifo_mrst_b : OUT STD_LOGIC;									-- ok -> fifo_mrst* - to FIFOs 
		fifo_prst_b : OUT STD_LOGIC;									-- ok -> fifo_pst* - to FIFOs 

		fifo_full_b : IN STD_LOGIC_VECTOR(9 DOWNTO 1);			-- full*(7 DOWNTO 1) - from FIFOs 
		fifo_half_b : IN STD_LOGIC_VECTOR(9 DOWNTO 1);			-- half*(7 DOWNTO 1) - from FIFOs 
		fifo_pae_b : IN STD_LOGIC_VECTOR(9 DOWNTO 1);			-- paef*(7 DOWNTO 1) - from FIFOs 
		fifo_empty_b : IN STD_LOGIC_VECTOR(9 DOWNTO 1);			-- emptyf*(7 DOWNTO 1) - from FIFOs 

-- From/To Bs (FF-EMU-MOD)

		ul_dav: IN STD_LOGIC_VECTOR(6 DOWNTO 0);						-- davf(5 DOWNTO 1) - from DCFEBs 
		ul_movlp: IN STD_LOGIC_VECTOR(6 DOWNTO 0);					-- movlp(5 DOWNTO 1) - from DCFEBs

		dcfeb_l1a_match : OUT STD_LOGIC_VECTOR(NFEB DOWNTO 1);					-- lctf(5 DOWNTO 1) - to DCFEBs
		dcfeb_l1a : OUT STD_LOGIC;											-- febrst - to DCFEBs
		dcfeb_injpulse : OUT STD_LOGIC;										-- inject - to DCFEBs
		dcfeb_extpulse : OUT STD_LOGIC;										-- extpulse - to DCFEBs

-- From/To LVMB

		r_lvmb_pon : IN STD_LOGIC_VECTOR(7 DOWNTO 0);		
		lvmb_csb : IN STD_LOGIC_VECTOR(6 DOWNTO 0);			
		lvmb_sclk : IN STD_LOGIC;
		lvmb_sdin : IN STD_LOGIC;			
		lvmb_sdout : IN STD_LOGIC;

		clk40 : IN STD_LOGIC;
		clk80 : IN STD_LOGIC;
		reset : IN STD_LOGIC;

		tck : IN STD_LOGIC;
		tdi : IN STD_LOGIC;
		tms : IN STD_LOGIC;
		tdo : OUT STD_LOGIC;

		test_ccbinj : IN STD_LOGIC;
		test_ccbpls : IN STD_LOGIC;
 
		leds : OUT STD_LOGIC_VECTOR(5 DOWNTO 0)
		
);
	
end COMPONENT;

COMPONENT ODMB_VME IS
	port (

-- VME signals

		vme_addr : IN STD_LOGIC_VECTOR (23 downto 1);			-- adr(23 downto 1)
		vme_data_in : IN STD_LOGIC_VECTOR (15 downto 0);		-- data_in(15 downto 0)
		vme_data_out : OUT STD_LOGIC_VECTOR (15 downto 0);		-- data_out(15 downto 0)
		vme_am : IN STD_LOGIC_VECTOR (5 downto 0);				-- am(5 downto 0)
		vme_ga : IN STD_LOGIC_VECTOR (4 downto 0);				-- iga(4 downto 0) -> ga*(4 downto 0)
		vme_gap : IN STD_LOGIC;											-- iga(5) -> ga*(5)
		vme_ds_b : IN STD_LOGIC_VECTOR(1 DOWNTO 0);				-- ids1* -> ds1*, ids0* -> ds0*
		vme_as_b : IN STD_LOGIC;										-- ias* -> as*
		vme_lword_b : IN STD_LOGIC;									-- ilword* -> lword*
		vme_write_b : IN STD_LOGIC;									-- iwrite* -> write*
		vme_iack_b : IN STD_LOGIC;										-- inack* -> iack*
		vme_sysreset_b : IN STD_LOGIC;								-- isysrst* -> sysrest*
		vme_sysfail_b : IN STD_LOGIC;									-- isysfail* -> sysfail
		vme_sysfail_out : OUT STD_LOGIC;								-- NEW (N.1)
		vme_berr_b : IN STD_LOGIC;										-- iberr* -> berr*
		vme_berr_out : OUT STD_LOGIC;									-- NEW (N.1)
		vme_dtack_b : OUT STD_LOGIC;									-- dtack* -> odtack*
		vme_tovme : OUT STD_LOGIC;										-- tovme
		vme_tovme_b : OUT STD_LOGIC;									-- tovme*
		vme_doe : OUT STD_LOGIC;										-- doe
		vme_doe_b : OUT STD_LOGIC;										-- doe*

-- Clock

		clk : IN STD_LOGIC;												-- fpgaclk (40MHz)
		clk_s1 : IN STD_LOGIC;											-- midclk (10MHz) 
		clk_s2  : IN STD_LOGIC;											-- slowclk (2.5MHz)
		clk_s3  : IN STD_LOGIC; 										-- slowclk2 (1.25MHz)

-- Reset

		rst : IN STD_LOGIC;												-- iglobalrst

-- JTAG signals To/From DCFEBs

		dl_jtag_tck : OUT STD_LOGIC_VECTOR (6 downto 0);				
		dl_jtag_tms : OUT STD_LOGIC;				
		dl_jtag_tdi : OUT STD_LOGIC;				
		dl_jtag_tdo : IN STD_LOGIC_VECTOR (6 downto 0);				
		dl_rtn_shft_en  : IN STD_LOGIC_VECTOR (6 downto 0);
		ul_jtag_tck : IN STD_LOGIC_VECTOR (6 downto 0);				
		ul_jtag_tms : IN STD_LOGIC_VECTOR (6 downto 0);				
		ul_jtag_tdi : IN STD_LOGIC_VECTOR (6 downto 0);

-- JTAG Signals To/From ODMB_CTRL

		mbc_jtag_tck : OUT STD_LOGIC;				
		mbc_jtag_tms : OUT STD_LOGIC;				
		mbc_jtag_tdi : OUT STD_LOGIC;				
		mbc_jtag_tdo : IN STD_LOGIC;				

-- reprogram To DCFEB FPGA (CFEBPRG)

		dl_reprogram : OUT STD_LOGIC_VECTOR(6 downto 0);

-- Done from DCFEB FPGA (CFEBPRG)

		ul_done : IN STD_LOGIC_VECTOR(6 downto 0);


-- To/From O-DMB ADC

		adc_cs : OUT STD_LOGIC;											
		adc_sclk : OUT STD_LOGIC;										
		adc_sdain : OUT STD_LOGIC;										
		adc_sdaout : IN STD_LOGIC;										
		
-- To/From O-DMB DAC

		dac_cs : OUT STD_LOGIC;											
		dac_sclk : OUT STD_LOGIC;										
		dac_sdain : OUT STD_LOGIC;										
		dac_sdaout : IN STD_LOGIC;										
		
-- To/From DCFEB FIFOs

		fifo_wr_ck : OUT STD_LOGIC;	
		fifo_wr_en : OUT STD_LOGIC_VECTOR (9 downto 1);
		fifo_rw_en : OUT STD_LOGIC_VECTOR (9 downto 1);	
		fifo_rm_en : OUT STD_LOGIC_VECTOR (9 downto 1);	
		fifo_tm_en : OUT STD_LOGIC_VECTOR (9 downto 1);	

		fifo_in : OUT STD_LOGIC_VECTOR (17 downto 0);			
		fifo_out : IN STD_LOGIC_VECTOR (17 downto 0);	

-- To/From DCFEB ADCs and DACs

		dl_spi_cs0 : OUT STD_LOGIC_VECTOR(6 downto 0);			
		dl_spi_cs1 : OUT STD_LOGIC_VECTOR(6 downto 0);			
		dl_spi_scl : OUT STD_LOGIC_VECTOR(6 downto 0);			
		dl_spi_sda : OUT STD_LOGIC_VECTOR(6 downto 0);			 
		ul_spi_scl : IN STD_LOGIC_VECTOR(6 downto 0);			
		ul_spi_sda : IN STD_LOGIC_VECTOR(6 downto 0);			 
		ul_spi_busy : IN STD_LOGIC_VECTOR(6 downto 0);			 

-- Token To/From DCFEB FF-EMU 

		dl_tkn : OUT STD_LOGIC_VECTOR(6 downto 0);				
		ul_tkn : IN STD_LOGIC_VECTOR(6 downto 0);					

-- I2C control signals To/From DCFEB FF-EMU (CFEBI2C)

		dl_i2c_scl : OUT STD_LOGIC_VECTOR(6 downto 0);				
		dl_i2c_sda : OUT STD_LOGIC_VECTOR(6 downto 0);				
		ul_i2c_scl : IN STD_LOGIC_VECTOR(6 downto 0);					
		ul_i2c_sda : IN STD_LOGIC_VECTOR(6 downto 0);					

-- From/To QPLL

		qpll_autorestart : OUT STD_LOGIC;						
		qpll_mode : OUT STD_LOGIC;									
		qpll_extcontrol : OUT STD_LOGIC;							
		qpll_reset : OUT STD_LOGIC;								
		qpll_f0sel : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);		
		qpll_locked : IN STD_LOGIC;								
		qpll_error : IN STD_LOGIC;									

-- From/To LVMB

		lvmb_pon : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
		pon_load : OUT STD_LOGIC;
		pon_oe_b : OUT STD_LOGIC;
		r_lvmb_pon : IN STD_LOGIC_VECTOR(7 DOWNTO 0);		
		lvmb_csb : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);			
		lvmb_sclk : OUT STD_LOGIC;
		lvmb_sdin : OUT STD_LOGIC;			
		lvmb_sdout : IN STD_LOGIC;

		diagout_cfebjtag  : OUT std_logic_vector(17 downto 0);
		diagout_lvdbmon  : OUT std_logic_vector(17 downto 0);
		
-- From/To FIFOs

		tfifo_data : IN std_logic_vector(15 downto 0);
		tfifo_wc : IN std_logic_vector(9 downto 0);
		tfifo_rc : IN std_logic_vector(9 downto 0);
		tfifo_str : IN std_logic_vector(15 downto 0);
		tfifo_wr_en : OUT std_logic_vector(7 downto 0);
		tfifo_rd_en : OUT std_logic_vector(7 downto 0);
		tfifo_sel : OUT std_logic_vector(7 downto 0);
		tfifo_mode : OUT std_logic;

		flf_ctrl : OUT std_logic_vector(15 downto 0);
		flf_data : IN std_logic_vector(15 downto 0)
		
);
	
END COMPONENT;

COMPONENT DMB_fifo IS
	port (
	rst: IN std_logic;
	wr_clk: IN std_logic;
	rd_clk: IN std_logic;
	din: IN std_logic_VECTOR(17 downto 0);
	wr_en: IN std_logic;
	rd_en: IN std_logic;
	dout: OUT std_logic_VECTOR(17 downto 0);
	full: OUT std_logic;
	empty: OUT std_logic;
	prog_full: OUT std_logic;
	prog_empty: OUT std_logic);
END COMPONENT;

COMPONENT ot_mgr
	PORT(
		 otx1_tx_en : OUT STD_LOGIC;
		 otx1_tx_dis : OUT STD_LOGIC;
		 otx1_reset : OUT STD_LOGIC;
		 otx1_fault : IN STD_LOGIC;
		 otx2_tx_en : OUT STD_LOGIC;
		 otx2_tx_dis : OUT STD_LOGIC;
		 otx2_reset : OUT STD_LOGIC;
		 otx2_fault : IN STD_LOGIC;
		 orx1_rx_en : OUT STD_LOGIC;
		 orx1_en_sd : OUT STD_LOGIC;
		 orx1_sd : IN STD_LOGIC;
		 orx1_sq_en : OUT STD_LOGIC;
		 orx2_rx_en : OUT STD_LOGIC;
		 orx2_en_sd : OUT STD_LOGIC;
		 orx2_sd : IN STD_LOGIC;
		 orx2_sq_en : OUT STD_LOGIC
	);
END COMPONENT;

-- Test Signals From/To J3

SIGNAL 	d_in, d_out, d_oe : STD_LOGIC_VECTOR(63 DOWNTO 0);		

-- VME Signals

signal	vme_data_out : STD_LOGIC_VECTOR (15 downto 0);
signal	vme_data_in : STD_LOGIC_VECTOR (15 downto 0);
signal	vme_tovme_b : STD_LOGIC;
signal	vme_doe_b : STD_LOGIC; 


signal	vme_test_mode : STD_LOGIC;
signal	test_vme_oe_b : STD_LOGIC;

signal	test_vme_gap, int_vme_gap : STD_LOGIC;	
signal	test_vme_ga, int_vme_ga : STD_LOGIC_VECTOR (4 downto 0); 
signal	test_vme_addr, int_vme_addr : STD_LOGIC_VECTOR (23 downto 1); 
signal	test_vme_as_b, int_vme_as_b : STD_LOGIC;
signal	test_vme_ds_b, int_vme_ds_b : STD_LOGIC_VECTOR (1 downto 0);
signal	test_vme_data_out, int_vme_data_out : STD_LOGIC_VECTOR (15 downto 0);
signal	test_vme_am, int_vme_am : STD_LOGIC_VECTOR (5 downto 0);
signal	test_vme_data_in, int_vme_data_in : STD_LOGIC_VECTOR (15 downto 0);
signal	test_vme_lword_b, int_vme_lword_b : STD_LOGIC;
signal	test_vme_write_b, int_vme_write_b: STD_LOGIC;
signal	test_vme_sysreset_b, int_vme_sysreset_b : STD_LOGIC;
signal	test_vme_berr_b, int_vme_berr_b : STD_LOGIC;
signal	test_vme_berr_out, int_vme_berr_out : STD_LOGIC;
signal	test_vme_sysfail_b, int_vme_sysfail_b : STD_LOGIC;
signal	test_vme_sysfail_out, int_vme_sysfail_out : STD_LOGIC;
signal	test_vme_iack_b, int_vme_iack_b : STD_LOGIC;
signal	test_vme_dtack_v6_b, int_vme_dtack_v6_b : STD_LOGIC;
signal	test_vme_clk, int_vme_clk : STD_LOGIC;

-- To/From FIFOs

signal	dcfeb0_data : STD_LOGIC_VECTOR (15 downto 0);
signal	dcfeb0_fifo_in, dcfeb0_fifo_out : STD_LOGIC_VECTOR (17 downto 0);
signal	dcfeb0_data_valid	: STD_LOGIC;

signal	dcfeb1_data : STD_LOGIC_VECTOR (15 downto 0);
signal	dcfeb1_fifo_in, dcfeb1_fifo_out : STD_LOGIC_VECTOR (17 downto 0);
signal	dcfeb1_data_valid	: STD_LOGIC;

signal	dcfeb2_data : STD_LOGIC_VECTOR (15 downto 0);
signal	dcfeb2_fifo_in, dcfeb2_fifo_out : STD_LOGIC_VECTOR (17 downto 0);
signal	dcfeb2_data_valid	: STD_LOGIC;

signal	dcfeb3_data : STD_LOGIC_VECTOR (15 downto 0);
signal	dcfeb3_fifo_in, dcfeb3_fifo_out : STD_LOGIC_VECTOR (17 downto 0);
signal	dcfeb3_data_valid	: STD_LOGIC;

signal	dcfeb4_data : STD_LOGIC_VECTOR (15 downto 0);
signal	dcfeb4_fifo_in, dcfeb4_fifo_out : STD_LOGIC_VECTOR (17 downto 0);
signal	dcfeb4_data_valid	: STD_LOGIC;

signal	dcfeb5_data : STD_LOGIC_VECTOR (15 downto 0);
signal	dcfeb5_fifo_in, dcfeb5_fifo_out : STD_LOGIC_VECTOR (17 downto 0);
signal	dcfeb5_data_valid	: STD_LOGIC;

signal	dcfeb6_data : STD_LOGIC_VECTOR (15 downto 0);
signal	dcfeb6_fifo_in, dcfeb6_fifo_out : STD_LOGIC_VECTOR (17 downto 0);
signal	dcfeb6_data_valid	: STD_LOGIC;

signal	dcfeb7_data, dcfeb7_fifo_in, dcfeb7_fifo_out : STD_LOGIC_VECTOR (17 downto 0);
signal	dcfeb7_data_valid	: STD_LOGIC;
signal	tmb_data, tmb_fifo_in, tmb_fifo_out : STD_LOGIC_VECTOR (17 downto 0);
signal	tmb_data_valid	: STD_LOGIC;
signal	alct_data, alct_fifo_in, alct_fifo_out : STD_LOGIC_VECTOR (17 downto 0);
signal	alct_data_valid	: STD_LOGIC;

signal	fifo_mrst_b, fifo_prst_b : STD_LOGIC;
signal	fifo_wr_ck, fifo_rd_ck : STD_LOGIC;
signal	fifo_tm_wr_en, fifo_wr_en, fifo_rd_en : STD_LOGIC_VECTOR(9 downto 1);
signal	fifo_rw_en, fifo_rm_en, fifo_tm_en : STD_LOGIC_VECTOR (9 downto 1);
signal	fifo_full, fifo_half, fifo_pae, fifo_empty : STD_LOGIC_VECTOR (9 downto 1);		
signal	fifo_sel : STD_LOGIC_VECTOR (3 downto 0);														
signal	fifo_in, fifo_out : STD_LOGIC_VECTOR (17 downto 0);													
													
-- TTC Signals

signal	dl_jtag_tck, dl_jtag_tdo, dl_rtn_shft_en : STD_LOGIC_VECTOR(7 downto 1);				
signal	dl_jtag_tms, dl_jtag_tdi : STD_LOGIC;				
signal	ul_jtag_tck, ul_jtag_tms, ul_jtag_tdi : STD_LOGIC_VECTOR(7 downto 1);				

signal	dl_spi_cs0, dl_spi_cs1, dl_spi_scl, dl_spi_sda : STD_LOGIC_VECTOR(7 downto 1);				
signal	ul_spi_scl, ul_spi_sda, ul_spi_busy : STD_LOGIC_VECTOR(7 downto 1);				

signal	dl_tkn : STD_LOGIC_VECTOR(7 downto 1);				
signal	ul_tkn : STD_LOGIC_VECTOR(7 downto 1);				

signal	dl_i2c_scl, dl_i2c_sda : STD_LOGIC_VECTOR(7 downto 1);				
signal	ul_i2c_scl, ul_i2c_sda : STD_LOGIC_VECTOR(7 downto 1);				

signal	dcfeb_injpulse, dcfeb_extpulse, dcfeb_l1a : STD_LOGIC;  -- To be sent out to pins in V2
signal	dcfeb_l1a_match : STD_LOGIC_VECTOR (NFEB downto 1); -- To be sent out to pins in V2
signal	dl_global_rst : STD_LOGIC;
signal	dl_resync : STD_LOGIC_VECTOR(7 downto 1);
SIGNAL	dl_reprogram :  STD_LOGIC_VECTOR(7 downto 1);
SIGNAL	ul_dav, ul_movlp, ul_done : STD_LOGIC_VECTOR (7 downto 1);

-- Mode Selection Signals

signal	pb_reset, lb_en, lb_ff_en, tm_en : STD_LOGIC;

-- FLF Test Signals

SIGNAL 	flf_test_en, flf_reset, flf_tx_enable, flf_tx_burst_enable, flf_rx_enable : STD_LOGIC;
SIGNAL 	flf_cnt_sel : STD_LOGIC_VECTOR(4 downto 0);
SIGNAL 	test_flf_p1_tx, test_flf_p2_tx, test_flf_e1_tx, test_flf_e2_tx : STD_LOGIC; 
SIGNAL	tx_flf_p1_cnt, tx_flf_p2_cnt, tx_flf_e1_cnt, tx_flf_e2_cnt: STD_LOGIC_VECTOR(15 downto 0);
SIGNAL 	flf_error : STD_LOGIC_VECTOR(7 downto 1); 
SIGNAL 	flf_ctrl : STD_LOGIC_VECTOR(15 downto 0);
SIGNAL 	flf_data : STD_LOGIC_VECTOR(15 downto 0);

-- TKN Test Signals

SIGNAL 	tkn_test_en, tkn_tx_enable, tkn_rx_enable : STD_LOGIC;
SIGNAL 	test_tkn_tx : STD_LOGIC; 
SIGNAL 	tkn_error : STD_LOGIC_VECTOR(7 downto 1); 


-- DCFEB0 FF_EMU_EMU I/O Signals

SIGNAL	dcfeb0_tx_dat, dcfeb0_rx_dat, dcfeb0_clk_en, dcfeb0_rec_clk : STD_LOGIC;

SIGNAL	dcfeb0_flf_p1_tx, dcfeb0_flf_p2_tx, dcfeb0_flf_e1_tx, dcfeb0_flf_e2_tx: STD_LOGIC;
SIGNAL	dcfeb0_tkn_tx: STD_LOGIC;
SIGNAL	dcfeb0_vlf_e1_tx, dcfeb0_vlf_e2_tx, dcfeb0_vlf_e3_tx: STD_LOGIC; 							-- not used
SIGNAL	dcfeb0_vlf_ta1_tx, dcfeb0_vlf_ta2_tx, dcfeb0_vlf_ta3_tx: STD_LOGIC; 						-- not used
SIGNAL	dcfeb0_vlf_tb1_tx, dcfeb0_vlf_tb2_tx: STD_LOGIC; 												-- not used

SIGNAL	dcfeb0_flf_p1_rx, dcfeb0_flf_p2_rx, dcfeb0_flf_e1_rx, dcfeb0_flf_e2_rx: STD_LOGIC;
SIGNAL	dcfeb0_flf_p1_cnt, dcfeb0_flf_p2_cnt, dcfeb0_flf_e1_cnt, dcfeb0_flf_e2_cnt: STD_LOGIC_VECTOR(15 downto 0);
SIGNAL	dcfeb0_tkn_rx: STD_LOGIC;
SIGNAL	dcfeb0_vlf_e1_rx, dcfeb0_vlf_e2_rx, dcfeb0_vlf_e3_rx: STD_LOGIC; 							-- not used
SIGNAL	dcfeb0_vlf_ta1_rx, dcfeb0_vlf_ta2_rx, dcfeb0_vlf_ta3_rx: STD_LOGIC; 						-- not used
SIGNAL	dcfeb0_vlf_tb1_rx, dcfeb0_vlf_tb2_rx: STD_LOGIC; 												-- not used

-- DCFEB1 FF_EMU_EMU I/O Signals

SIGNAL	dcfeb1_tx_dat, dcfeb1_rx_dat, dcfeb1_clk_en, dcfeb1_rec_clk : STD_LOGIC;

SIGNAL	dcfeb1_flf_p1_tx, dcfeb1_flf_p2_tx, dcfeb1_flf_e1_tx, dcfeb1_flf_e2_tx: STD_LOGIC;
SIGNAL	dcfeb1_tkn_tx: STD_LOGIC;
SIGNAL	dcfeb1_vlf_e1_tx, dcfeb1_vlf_e2_tx, dcfeb1_vlf_e3_tx: STD_LOGIC; 							-- not used
SIGNAL	dcfeb1_vlf_ta1_tx, dcfeb1_vlf_ta2_tx, dcfeb1_vlf_ta3_tx: STD_LOGIC; 						-- not used
SIGNAL	dcfeb1_vlf_tb1_tx, dcfeb1_vlf_tb2_tx: STD_LOGIC; 												-- not used

SIGNAL	dcfeb1_flf_p1_rx, dcfeb1_flf_p2_rx, dcfeb1_flf_e1_rx, dcfeb1_flf_e2_rx: STD_LOGIC;
SIGNAL	dcfeb1_flf_p1_cnt, dcfeb1_flf_p2_cnt, dcfeb1_flf_e1_cnt, dcfeb1_flf_e2_cnt: STD_LOGIC_VECTOR(15 downto 0);
SIGNAL	dcfeb1_tkn_rx: STD_LOGIC;
SIGNAL	dcfeb1_vlf_e1_rx, dcfeb1_vlf_e2_rx, dcfeb1_vlf_e3_rx: STD_LOGIC; 							-- not used
SIGNAL	dcfeb1_vlf_ta1_rx, dcfeb1_vlf_ta2_rx, dcfeb1_vlf_ta3_rx: STD_LOGIC; 						-- not used
SIGNAL	dcfeb1_vlf_tb1_rx, dcfeb1_vlf_tb2_rx: STD_LOGIC; 												-- not used

-- DCFEB2 FF_EMU_EMU I/O Signals

SIGNAL	dcfeb2_tx_dat, dcfeb2_rx_dat, dcfeb2_clk_en, dcfeb2_rec_clk : STD_LOGIC;

SIGNAL	dcfeb2_flf_p1_tx, dcfeb2_flf_p2_tx, dcfeb2_flf_e1_tx, dcfeb2_flf_e2_tx: STD_LOGIC;
SIGNAL	dcfeb2_tkn_tx: STD_LOGIC;
SIGNAL	dcfeb2_vlf_e1_tx, dcfeb2_vlf_e2_tx, dcfeb2_vlf_e3_tx: STD_LOGIC; 							-- not used
SIGNAL	dcfeb2_vlf_ta1_tx, dcfeb2_vlf_ta2_tx, dcfeb2_vlf_ta3_tx: STD_LOGIC; 						-- not used
SIGNAL	dcfeb2_vlf_tb1_tx, dcfeb2_vlf_tb2_tx: STD_LOGIC; 												-- not used

SIGNAL	dcfeb2_flf_p1_rx, dcfeb2_flf_p2_rx, dcfeb2_flf_e1_rx, dcfeb2_flf_e2_rx: STD_LOGIC;
SIGNAL	dcfeb2_flf_p1_cnt, dcfeb2_flf_p2_cnt, dcfeb2_flf_e1_cnt, dcfeb2_flf_e2_cnt: STD_LOGIC_VECTOR(15 downto 0);
SIGNAL	dcfeb2_tkn_rx: STD_LOGIC;
SIGNAL	dcfeb2_vlf_e1_rx, dcfeb2_vlf_e2_rx, dcfeb2_vlf_e3_rx: STD_LOGIC; 							-- not used
SIGNAL	dcfeb2_vlf_ta1_rx, dcfeb2_vlf_ta2_rx, dcfeb2_vlf_ta3_rx: STD_LOGIC; 						-- not used
SIGNAL	dcfeb2_vlf_tb1_rx, dcfeb2_vlf_tb2_rx: STD_LOGIC; 												-- not used

-- DCFEB3 FF_EMU_EMU I/O Signals

SIGNAL	dcfeb3_tx_dat, dcfeb3_rx_dat, dcfeb3_clk_en, dcfeb3_rec_clk : STD_LOGIC;

SIGNAL	dcfeb3_flf_p1_tx, dcfeb3_flf_p2_tx, dcfeb3_flf_e1_tx, dcfeb3_flf_e2_tx: STD_LOGIC;
SIGNAL	dcfeb3_tkn_tx: STD_LOGIC;
SIGNAL	dcfeb3_vlf_e1_tx, dcfeb3_vlf_e2_tx, dcfeb3_vlf_e3_tx: STD_LOGIC; 							-- not used
SIGNAL	dcfeb3_vlf_ta1_tx, dcfeb3_vlf_ta2_tx, dcfeb3_vlf_ta3_tx: STD_LOGIC; 						-- not used
SIGNAL	dcfeb3_vlf_tb1_tx, dcfeb3_vlf_tb2_tx: STD_LOGIC; 												-- not used

SIGNAL	dcfeb3_flf_p1_rx, dcfeb3_flf_p2_rx, dcfeb3_flf_e1_rx, dcfeb3_flf_e2_rx: STD_LOGIC;
SIGNAL	dcfeb3_flf_p1_cnt, dcfeb3_flf_p2_cnt, dcfeb3_flf_e1_cnt, dcfeb3_flf_e2_cnt: STD_LOGIC_VECTOR(15 downto 0);
SIGNAL	dcfeb3_tkn_rx: STD_LOGIC;
SIGNAL	dcfeb3_vlf_e1_rx, dcfeb3_vlf_e2_rx, dcfeb3_vlf_e3_rx: STD_LOGIC; 							-- not used
SIGNAL	dcfeb3_vlf_ta1_rx, dcfeb3_vlf_ta2_rx, dcfeb3_vlf_ta3_rx: STD_LOGIC; 						-- not used
SIGNAL	dcfeb3_vlf_tb1_rx, dcfeb3_vlf_tb2_rx: STD_LOGIC; 												-- not used

-- DCFEB4 FF_EMU_EMU I/O Signals

SIGNAL	dcfeb4_tx_dat, dcfeb4_rx_dat, dcfeb4_clk_en, dcfeb4_rec_clk : STD_LOGIC;

SIGNAL	dcfeb4_flf_p1_tx, dcfeb4_flf_p2_tx, dcfeb4_flf_e1_tx, dcfeb4_flf_e2_tx: STD_LOGIC;
SIGNAL	dcfeb4_tkn_tx: STD_LOGIC;
SIGNAL	dcfeb4_vlf_e1_tx, dcfeb4_vlf_e2_tx, dcfeb4_vlf_e3_tx: STD_LOGIC; 							-- not used
SIGNAL	dcfeb4_vlf_ta1_tx, dcfeb4_vlf_ta2_tx, dcfeb4_vlf_ta3_tx: STD_LOGIC; 						-- not used
SIGNAL	dcfeb4_vlf_tb1_tx, dcfeb4_vlf_tb2_tx: STD_LOGIC; 												-- not used

SIGNAL	dcfeb4_flf_p1_rx, dcfeb4_flf_p2_rx, dcfeb4_flf_e1_rx, dcfeb4_flf_e2_rx: STD_LOGIC;
SIGNAL	dcfeb4_flf_p1_cnt, dcfeb4_flf_p2_cnt, dcfeb4_flf_e1_cnt, dcfeb4_flf_e2_cnt: STD_LOGIC_VECTOR(15 downto 0);
SIGNAL	dcfeb4_tkn_rx: STD_LOGIC;
SIGNAL	dcfeb4_vlf_e1_rx, dcfeb4_vlf_e2_rx, dcfeb4_vlf_e3_rx: STD_LOGIC;							-- not used
SIGNAL	dcfeb4_vlf_ta1_rx, dcfeb4_vlf_ta2_rx, dcfeb4_vlf_ta3_rx: STD_LOGIC;						-- not used
SIGNAL	dcfeb4_vlf_tb1_rx, dcfeb4_vlf_tb2_rx: STD_LOGIC;												-- not used

-- DCFEB5 FF_EMU_EMU I/O Signals

SIGNAL	dcfeb5_tx_dat, dcfeb5_rx_dat, dcfeb5_clk_en, dcfeb5_rec_clk : STD_LOGIC;

SIGNAL	dcfeb5_flf_p1_tx, dcfeb5_flf_p2_tx, dcfeb5_flf_e1_tx, dcfeb5_flf_e2_tx: STD_LOGIC;
SIGNAL	dcfeb5_tkn_tx: STD_LOGIC;
SIGNAL	dcfeb5_vlf_e1_tx, dcfeb5_vlf_e2_tx, dcfeb5_vlf_e3_tx: STD_LOGIC; 							-- not used
SIGNAL	dcfeb5_vlf_ta1_tx, dcfeb5_vlf_ta2_tx, dcfeb5_vlf_ta3_tx: STD_LOGIC; 						-- not used
SIGNAL	dcfeb5_vlf_tb1_tx, dcfeb5_vlf_tb2_tx: STD_LOGIC; 												-- not used

SIGNAL	dcfeb5_flf_p1_rx, dcfeb5_flf_p2_rx, dcfeb5_flf_e1_rx, dcfeb5_flf_e2_rx: STD_LOGIC;
SIGNAL	dcfeb5_flf_p1_cnt, dcfeb5_flf_p2_cnt, dcfeb5_flf_e1_cnt, dcfeb5_flf_e2_cnt: STD_LOGIC_VECTOR(15 downto 0);
SIGNAL	dcfeb5_tkn_rx: STD_LOGIC;
SIGNAL	dcfeb5_vlf_e1_rx, dcfeb5_vlf_e2_rx, dcfeb5_vlf_e3_rx: STD_LOGIC; 							-- not used
SIGNAL	dcfeb5_vlf_ta1_rx, dcfeb5_vlf_ta2_rx, dcfeb5_vlf_ta3_rx: STD_LOGIC; 						-- not used
SIGNAL	dcfeb5_vlf_tb1_rx, dcfeb5_vlf_tb2_rx: STD_LOGIC; 												-- not used

-- DCFEB6 FF_EMU_EMU I/O Signals

SIGNAL	dcfeb6_tx_dat, dcfeb6_rx_dat, dcfeb6_clk_en, dcfeb6_rec_clk : STD_LOGIC;

SIGNAL	dcfeb6_flf_p1_tx, dcfeb6_flf_p2_tx, dcfeb6_flf_e1_tx, dcfeb6_flf_e2_tx: STD_LOGIC;
SIGNAL	dcfeb6_tkn_tx: STD_LOGIC;
SIGNAL	dcfeb6_vlf_e1_tx, dcfeb6_vlf_e2_tx, dcfeb6_vlf_e3_tx: STD_LOGIC; 							-- not used
SIGNAL	dcfeb6_vlf_ta1_tx, dcfeb6_vlf_ta2_tx, dcfeb6_vlf_ta3_tx: STD_LOGIC; 						-- not used
SIGNAL	dcfeb6_vlf_tb1_tx, dcfeb6_vlf_tb2_tx: STD_LOGIC; 												-- not used

SIGNAL	dcfeb6_flf_p1_rx, dcfeb6_flf_p2_rx, dcfeb6_flf_e1_rx, dcfeb6_flf_e2_rx: STD_LOGIC;
SIGNAL	dcfeb6_flf_p1_cnt, dcfeb6_flf_p2_cnt, dcfeb6_flf_e1_cnt, dcfeb6_flf_e2_cnt: STD_LOGIC_VECTOR(15 downto 0);
SIGNAL	dcfeb6_tkn_rx: STD_LOGIC;
SIGNAL	dcfeb6_vlf_e1_rx, dcfeb6_vlf_e2_rx, dcfeb6_vlf_e3_rx: STD_LOGIC; 							-- not used
SIGNAL	dcfeb6_vlf_ta1_rx, dcfeb6_vlf_ta2_rx, dcfeb6_vlf_ta3_rx: STD_LOGIC; 						-- not used
SIGNAL	dcfeb6_vlf_tb1_rx, dcfeb6_vlf_tb2_rx: STD_LOGIC; 												-- not used

-- FF_EMU_EMU I/O Global Signals

SIGNAL	reg_init :  STD_LOGIC_VECTOR(8 DOWNTO 0);
SIGNAL	ta_delay :  STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL	tb_delay :  STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL	vlf_dv, flf_dv, rx_sync, rx_resync :  STD_LOGIC_VECTOR(7 DOWNTO 0);

-- From/To OTs 

signal	otx1_01, otx1_02, otx1_03, otx1_04, otx1_05, otx1_06, otx1_07, otx1_08, otx1_09, otx1_10, otx1_11, otx1_12 : STD_LOGIC;
signal	otx2_01, otx2_02, otx2_03, otx2_04, otx2_05, otx2_06, otx2_07, otx2_08, otx2_09, otx2_10, otx2_11, otx2_12 : STD_LOGIC;
signal	orx1_01, orx1_02, orx1_03, orx1_04, orx1_05, orx1_06, orx1_07, orx1_08, orx1_09, orx1_10, orx1_11, orx1_12 : STD_LOGIC;
signal	orx2_01, orx2_02, orx2_03, orx2_04, orx2_05, orx2_06, orx2_07, orx2_08, orx2_09, orx2_10, orx2_11, orx2_12 : STD_LOGIC;

-- From/To Giga-Bit Links

signal 	gl0_tx, gl0_rx, gl1_tx, gl1_rx : STD_LOGIC;

signal	grx0_data : STD_LOGIC_VECTOR(15 DOWNTO 0) := "0000000000000000";									  
signal	grx0_data_valid : STD_LOGIC := '0';			 
signal	grx1_data : STD_LOGIC_VECTOR(15 DOWNTO 0) := "0000000000000000";												  
signal	grx1_data_valid : STD_LOGIC := '0';	 
	
signal	gtx0_data : STD_LOGIC_VECTOR(15 DOWNTO 0);										  
signal	gtx0_data_valid : STD_LOGIC;			 
signal	gtx1_data : STD_LOGIC_VECTOR(15 DOWNTO 0);											  
signal	gtx1_data_valid : STD_LOGIC;			 

-- From LVDS Test Connector

signal 	ck_0, ck_1, ck_2, clk, tx_0, tx_1, tx_2, tx_3, tx_4, tx_5, tx_6, tx_7, tx_8, tx_9, tx_10 : STD_LOGIC;
signal 	rxb, rx_0, rx_1, rx_2, rx_3, rx_4, rx_5, rx_6, rx_7, rx_8, rx_9, rx_10 : STD_LOGIC;


-- PLL Signals

signal	clkin, qpll_clk40MHz, qpll_clk80MHz, qpll_clk160MHz : STD_LOGIC;

SIGNAL 	pll1_fb, pll1_rst, pll1_pd, pll1_locked : STD_LOGIC;

signal 	pll_clk80, clk80 : STD_LOGIC;			-- reallyfastclk (80MHz) 
signal 	pll_clk40, clk40 : STD_LOGIC;			-- fastclk (40MHz) 
signal 	pll_clk10, clk10 : STD_LOGIC;			-- midclk  (10MHz) 
signal 	pll_clk5, clk5 : STD_LOGIC;			-- Generates clk2p5 and clk1p25
signal 	clk2p5, clk2p5_inv : STD_LOGIC;		-- slowclk (2.5MHz)
signal 	clk1p25, clk1p25_inv : STD_LOGIC;	-- slowclk2 (1.25MHz)


-- Other signals

signal	iob_rsvtd_out : STD_LOGIC_VECTOR (7 downto 0);
-- signal	rsvtd_out : STD_LOGIC_VECTOR (3 downto 0);
signal	iob_rsvtd_in : STD_LOGIC_VECTOR (7 downto 0);
-- signal	rsvtd_in : STD_LOGIC_VECTOR (2 downto 0);

signal	reset : STD_LOGIC;

SIGNAL 	int_dl_jtag_tdo : STD_LOGIC_VECTOR(7 downto 1) := "0000000"; 
SIGNAL 	jtag_dr0 : STD_LOGIC_VECTOR(15 downto 0); 
SIGNAL 	jtag_ir : STD_LOGIC_VECTOR(10 downto 0); 

SIGNAL 	int_lvmb_pon : STD_LOGIC_VECTOR(7 downto 0); 
SIGNAL 	int_lvmb_adc_sdout : STD_LOGIC_VECTOR(6 downto 0); 
SIGNAL 	int_lvmb_csb : STD_LOGIC_VECTOR(6 downto 0); 
SIGNAL 	int_lvmb_sclk,int_lvmb_sdin,int_lvmb_sdout : STD_LOGIC; 

SIGNAL 	leds_in : STD_LOGIC_VECTOR(11 downto 0); 

-- JTAG signals between ODMB_VME and ODMB_CTRL

SIGNAL 	mbc_jtag_tck : STD_LOGIC;			
SIGNAL 	mbc_jtag_tms : STD_LOGIC;			
SIGNAL 	mbc_jtag_tdi : STD_LOGIC;			
SIGNAL 	mbc_jtag_tdo : STD_LOGIC;				

-- Test FIFO (DUAL_CLK)

signal	dcfeb0_gbrx_data : STD_LOGIC_VECTOR(15 downto 0);
signal	dcfeb0_gbrx_data_valid, dcfeb0_gbrx_data_clk	: STD_LOGIC;
signal	dcfeb0_tfifo_in, dcfeb0_tfifo_out : STD_LOGIC_VECTOR(15 downto 0);
signal	dcfeb0_fifo_wr_cnt, dcfeb0_fifo_rd_cnt : STD_LOGIC_VECTOR(9 downto 0);
signal	dcfeb0_fifo_wr_en, dcfeb0_fifo_wr_ck : STD_LOGIC;
signal	dcfeb0_fifo_rd_en, dcfeb0_fifo_rd_ck : STD_LOGIC;

signal	dcfeb1_gbrx_data : STD_LOGIC_VECTOR(15 downto 0);
signal	dcfeb1_gbrx_data_valid, dcfeb1_gbrx_data_clk	: STD_LOGIC;
signal	dcfeb1_tfifo_in, dcfeb1_tfifo_out : STD_LOGIC_VECTOR(15 downto 0);
signal	dcfeb1_fifo_wr_cnt, dcfeb1_fifo_rd_cnt : STD_LOGIC_VECTOR(9 downto 0);
signal	dcfeb1_fifo_wr_en, dcfeb1_fifo_wr_ck : STD_LOGIC;
signal	dcfeb1_fifo_rd_en, dcfeb1_fifo_rd_ck : STD_LOGIC;

signal	dcfeb2_gbrx_data : STD_LOGIC_VECTOR(15 downto 0);
signal	dcfeb2_gbrx_data_valid, dcfeb2_gbrx_data_clk	: STD_LOGIC;
signal	dcfeb2_tfifo_in, dcfeb2_tfifo_out : STD_LOGIC_VECTOR(15 downto 0);
signal	dcfeb2_fifo_wr_cnt, dcfeb2_fifo_rd_cnt : STD_LOGIC_VECTOR(9 downto 0);
signal	dcfeb2_fifo_wr_en, dcfeb2_fifo_wr_ck : STD_LOGIC;
signal	dcfeb2_fifo_rd_en, dcfeb2_fifo_rd_ck : STD_LOGIC;

signal	dcfeb3_gbrx_data : STD_LOGIC_VECTOR(15 downto 0);
signal	dcfeb3_gbrx_data_valid, dcfeb3_gbrx_data_clk	: STD_LOGIC;
signal	dcfeb3_tfifo_in, dcfeb3_tfifo_out : STD_LOGIC_VECTOR(15 downto 0);
signal	dcfeb3_fifo_wr_cnt, dcfeb3_fifo_rd_cnt : STD_LOGIC_VECTOR(9 downto 0);
signal	dcfeb3_fifo_wr_en, dcfeb3_fifo_wr_ck : STD_LOGIC;
signal	dcfeb3_fifo_rd_en, dcfeb3_fifo_rd_ck : STD_LOGIC;

signal	dcfeb4_gbrx_data : STD_LOGIC_VECTOR(15 downto 0);
signal	dcfeb4_gbrx_data_valid, dcfeb4_gbrx_data_clk	: STD_LOGIC;
signal	dcfeb4_tfifo_in, dcfeb4_tfifo_out : STD_LOGIC_VECTOR(15 downto 0);
signal	dcfeb4_fifo_wr_cnt, dcfeb4_fifo_rd_cnt : STD_LOGIC_VECTOR(9 downto 0);
signal	dcfeb4_fifo_wr_en, dcfeb4_fifo_wr_ck : STD_LOGIC;
signal	dcfeb4_fifo_rd_en, dcfeb4_fifo_rd_ck : STD_LOGIC;

signal	dcfeb5_gbrx_data : STD_LOGIC_VECTOR(15 downto 0);
signal	dcfeb5_gbrx_data_valid, dcfeb5_gbrx_data_clk	: STD_LOGIC;
signal	dcfeb5_tfifo_in, dcfeb5_tfifo_out : STD_LOGIC_VECTOR(15 downto 0);
signal	dcfeb5_fifo_wr_cnt, dcfeb5_fifo_rd_cnt : STD_LOGIC_VECTOR(9 downto 0);
signal	dcfeb5_fifo_wr_en, dcfeb5_fifo_wr_ck : STD_LOGIC;
signal	dcfeb5_fifo_rd_en, dcfeb5_fifo_rd_ck : STD_LOGIC;

signal	dcfeb6_gbrx_data : STD_LOGIC_VECTOR(15 downto 0);
signal	dcfeb6_gbrx_data_valid, dcfeb6_gbrx_data_clk	: STD_LOGIC;
signal	dcfeb6_tfifo_in, dcfeb6_tfifo_out : STD_LOGIC_VECTOR(15 downto 0);
signal	dcfeb6_fifo_wr_cnt, dcfeb6_fifo_rd_cnt : STD_LOGIC_VECTOR(9 downto 0);
signal	dcfeb6_fifo_wr_en, dcfeb6_fifo_wr_ck : STD_LOGIC;
signal	dcfeb6_fifo_rd_en, dcfeb6_fifo_rd_ck : STD_LOGIC;

signal	dcfeb7_gbrx_data : STD_LOGIC_VECTOR(15 downto 0);
signal	dcfeb7_gbrx_data_valid, dcfeb7_gbrx_data_clk	: STD_LOGIC;
signal	dcfeb7_tfifo_in, dcfeb7_tfifo_out : STD_LOGIC_VECTOR(15 downto 0);
signal	dcfeb7_fifo_wr_cnt, dcfeb7_fifo_rd_cnt : STD_LOGIC_VECTOR(9 downto 0);
signal	dcfeb7_fifo_wr_en, dcfeb7_fifo_wr_ck : STD_LOGIC;
signal	dcfeb7_fifo_rd_en, dcfeb7_fifo_rd_ck : STD_LOGIC;

signal	empty, a_empty, a_full, full : STD_LOGIC_VECTOR(7 downto 0);

-- FIFOs (SYNC)
signal	dcfeb0_wr_cnt, dcfeb0_rd_cnt : STD_LOGIC_VECTOR(9 downto 0);
signal	dcfeb0_wr_err, dcfeb0_rd_err : STD_LOGIC;
signal	dcfeb1_wr_cnt, dcfeb1_rd_cnt : STD_LOGIC_VECTOR(9 downto 0);
signal	dcfeb1_wr_err, dcfeb1_rd_err : STD_LOGIC;
signal	dcfeb2_wr_cnt, dcfeb2_rd_cnt : STD_LOGIC_VECTOR(9 downto 0);
signal	dcfeb2_wr_err, dcfeb2_rd_err : STD_LOGIC;
signal	dcfeb3_wr_cnt, dcfeb3_rd_cnt : STD_LOGIC_VECTOR(9 downto 0);
signal	dcfeb3_wr_err, dcfeb3_rd_err : STD_LOGIC;
signal	dcfeb4_wr_cnt, dcfeb4_rd_cnt : STD_LOGIC_VECTOR(9 downto 0);
signal	dcfeb4_wr_err, dcfeb4_rd_err : STD_LOGIC;
signal	dcfeb5_wr_cnt, dcfeb5_rd_cnt : STD_LOGIC_VECTOR(9 downto 0);
signal	dcfeb5_wr_err, dcfeb5_rd_err : STD_LOGIC;
signal	dcfeb6_wr_cnt, dcfeb6_rd_cnt : STD_LOGIC_VECTOR(9 downto 0);
signal	dcfeb6_wr_err, dcfeb6_rd_err : STD_LOGIC;
signal	tmb_wr_cnt, tmb_rd_cnt : STD_LOGIC_VECTOR(9 downto 0);
signal	tmb_wr_err, tmb_rd_err : STD_LOGIC;
signal	alct_wr_cnt, alct_rd_cnt : STD_LOGIC_VECTOR(9 downto 0);
signal	alct_wr_err, alct_rd_err : STD_LOGIC;

signal	dcfeb0_adc_mask, dcfeb1_adc_mask, dcfeb2_adc_mask, dcfeb3_adc_mask, dcfeb4_adc_mask, dcfeb5_adc_mask, dcfeb6_adc_mask : STD_LOGIC_VECTOR(11 downto 0);

signal	dcfeb0_fsel, dcfeb1_fsel, dcfeb2_fsel, dcfeb3_fsel, dcfeb4_fsel, dcfeb5_fsel, dcfeb6_fsel: STD_LOGIC_VECTOR(32 downto 0);

signal	dcfeb0_jtag_ir, dcfeb1_jtag_ir, dcfeb2_jtag_ir, dcfeb3_jtag_ir, dcfeb4_jtag_ir, dcfeb5_jtag_ir, dcfeb6_jtag_ir: STD_LOGIC_VECTOR(9 downto 0);

signal	mbc_fsel : STD_LOGIC_VECTOR(47 downto 1);

signal	mbc_jtag_ir : STD_LOGIC_VECTOR(9 downto 0);

signal	dcfeb1t_tx_dat, dcfeb1t_rx_dat, dcfeb1t_rx_clk : STD_LOGIC;
signal	dcfeb1t_tp_tck, dcfeb1t_tp_tms, dcfeb1t_tp_tdi, dcfeb1t_tp_tdo : STD_LOGIC;
signal	dcfeb2t_tx_dat, dcfeb2t_rx_dat, dcfeb2t_rx_clk : STD_LOGIC;
signal	dcfeb2t_tp_tck, dcfeb2t_tp_tms, dcfeb2t_tp_tdi, dcfeb2t_tp_tdo : STD_LOGIC;

signal	diagout_cfebjtag  : std_logic_vector(17 downto 0);
signal	diagout_lvdbmon  : std_logic_vector(17 downto 0);

signal	cdc_clk  : std_logic_vector(7 downto 0);

signal	dcfeb1t_rec_clk,dcfeb2t_rec_clk  : std_logic;

-- Test FIFO Signals

signal  tfifo_data : std_logic_vector(15 downto 0);
signal  tfifo_wc, tfifo_rc : std_logic_vector(9 downto 0);
signal  tfifo_str : std_logic_vector(15 downto 0);
signal  tfifo_wr_en : std_logic_vector(7 downto 0);
signal  tfifo_rd_en : std_logic_vector(7 downto 0);
signal  tfifo_sel : std_logic_vector(7 downto 0);
signal  tfifo_mode : std_logic;

signal 	b_orx2_01_p, b_orx2_01_n : std_logic;

signal 	orx2_01_sd : std_logic;
signal 	orx2_02_sd : std_logic;
signal 	orx2_03_sd : std_logic;
signal 	orx2_04_sd : std_logic;
signal 	orx2_05_sd : std_logic;
signal 	orx2_06_sd : std_logic;
signal 	orx2_07_sd : std_logic;
signal 	orx2_08_sd : std_logic;

signal	por_reg : STD_LOGIC_VECTOR (31 downto 0);
signal	mbc_leds : STD_LOGIC_VECTOR (5 downto 0);

signal   select_diagnostic : integer := 0;
BEGIN 

Select_TestPoints : process(diagout_lvdbmon, diagout_cfebjtag, qpll_clk40MHz)
begin
	if (select_diagnostic=0) then
		d(0) <= diagout_lvdbmon(0);		-- TP58   TP59 SLOWCLK
		d(1) <= diagout_lvdbmon(1);		-- TP60   TP61 CE_ADCDATA
		d(2) <= diagout_lvdbmon(2);		-- TP62   TP63 CLKMON
		d(3) <= diagout_lvdbmon(3);		-- TP64   TP65 ADCCLK_INNER
		d(4) <= diagout_lvdbmon(4);		-- TP66   TP66 BUSY
		d(5) <= diagout_lvdbmon(5);		-- TP68   TP68 L_ADCDATA
		d(6) <= diagout_lvdbmon(6);		-- TP70
		d(7) <= diagout_lvdbmon(7);		-- TP72
		d(8) <= diagout_lvdbmon(8);		-- TP74
		d(32) <= diagout_lvdbmon(9);		-- TP59
		d(33) <= diagout_lvdbmon(10);		-- TP61
		d(34) <= diagout_lvdbmon(11);		-- TP63
		d(35) <= diagout_lvdbmon(12);		-- TP65
		d(36) <= diagout_lvdbmon(13);		-- TP67
		d(37) <= diagout_lvdbmon(14);		-- TP69
		d(38) <= diagout_lvdbmon(15);		-- TP71
		d(39) <= diagout_lvdbmon(16);		-- TP73
		d(40) <= diagout_lvdbmon(17);		-- TP75
	elsif (select_diagnostic=1) then
		d(0) <= diagout_cfebjtag(0);		-- TP58   TP59 TCK(1)
		d(1) <= diagout_cfebjtag(1);		-- TP60   TP61 TDI
		d(2) <= diagout_cfebjtag(2);		-- TP62   TP63 TMS
		d(3) <= diagout_cfebjtag(3);		-- TP64   TP65 DL_RTN_SHFT_EN(1)
		d(4) <= diagout_cfebjtag(4);		-- TP66   TP66 UL_JTAG_TCK(1)
		d(5) <= diagout_cfebjtag(5);		-- TP68   TP68 SELFEB(1)
		d(6) <= diagout_cfebjtag(6);		-- TP70   TP70 FEBTDO(1)
		d(7) <= diagout_cfebjtag(7);		-- TP72   TP72 READTDO
		d(8) <= diagout_cfebjtag(8);		-- TP74
		d(32) <= diagout_cfebjtag(9);		-- TP59
		d(33) <= diagout_cfebjtag(10);	-- TP61
		d(34) <= diagout_cfebjtag(11);	-- TP63
		d(35) <= diagout_cfebjtag(12);	-- TP65   SLOWCLK
		d(36) <= diagout_cfebjtag(13);	-- TP67
		d(37) <= diagout_cfebjtag(14);	-- TP69
		d(38) <= diagout_cfebjtag(15);	-- TP71
		d(39) <= diagout_cfebjtag(16);	-- TP73
		d(40) <= diagout_cfebjtag(17);	-- TP75
	else
		d(0) <= flf_ctrl(15);				-- TP58   TP59 TCK(1)
		d(1) <= flf_ctrl(14);				-- TP60   TP61 TDI
		d(2) <= dcfeb_injpulse;					-- TP62   TP63 TMS
		d(3) <= dcfeb_extpulse;					-- TP64   TP65 DL_RTN_SHFT_EN(1)
		d(4) <= dcfeb_l1a;						-- TP66   TP66 UL_JTAG_TCK(1)
		d(5) <= qpll_clk40MHz;				-- TP68   TP68 SELFEB(1)
		d(6) <= qpll_locked;					-- TP70   TP70 FEBTDO(1)
		d(7) <= diagout_cfebjtag(7);		-- TP72   TP72 READTDO
		d(8)  <= DL_RTN_SHFT_EN(1);		-- TP74
		d(32) <= int_vme_dtack_v6_b;		-- TP59
		d(33) <= diagout_cfebjtag(10);	-- TP61
		d(34) <= diagout_cfebjtag(11);	-- TP63
		d(35) <= diagout_cfebjtag(12);	-- TP65   SLOWCLK
		d(36) <= DL_RTN_SHFT_EN(3);		-- TP67
		d(37) <= DL_RTN_SHFT_EN(4);		-- TP69
		d(38) <= DL_RTN_SHFT_EN(5);		-- TP71
		d(39) <= DL_RTN_SHFT_EN(6);		-- TP73
		d(40) <= DL_RTN_SHFT_EN(7);		-- TP75
	end if;
	d(31 downto 9) <= (others => '0');
	d(63 downto 41) <= (others => '0');
end process Select_TestPoints;

fd_clr <= '0';
fd_pre <= '0';

-- reset <= pb_reset;

-- power on reset

process (clk2p5,pll1_locked)
begin
   if pll1_locked ='0' then 
      por_reg <= x"FFFFFFFF"; 
   elsif clk2p5'event and clk2p5='1' then  
		por_reg <= por_reg(30 downto 0) & '0';
   end if;
end process;
reset <= por_reg(31);


PULLUP_dtack_b : PULLUP
   port map (O => vme_dtack_v6_b);

PULLDOWN_TMS : PULLDOWN
   port map (O => dl_jtag_tms);

vme_d00_buf : IOBUF port map (O => vme_data_in(0), IO => vme_data(0), I => vme_data_out(0), T => vme_tovme_b);     	
vme_d01_buf : IOBUF port map (O => vme_data_in(1), IO => vme_data(1), I => vme_data_out(1), T => vme_tovme_b);     	
vme_d02_buf : IOBUF port map (O => vme_data_in(2), IO => vme_data(2), I => vme_data_out(2), T => vme_tovme_b);     	
vme_d03_buf : IOBUF port map (O => vme_data_in(3), IO => vme_data(3), I => vme_data_out(3), T => vme_tovme_b);     	
vme_d04_buf : IOBUF port map (O => vme_data_in(4), IO => vme_data(4), I => vme_data_out(4), T => vme_tovme_b);     	
vme_d05_buf : IOBUF port map (O => vme_data_in(5), IO => vme_data(5), I => vme_data_out(5), T => vme_tovme_b);     	
vme_d06_buf : IOBUF port map (O => vme_data_in(6), IO => vme_data(6), I => vme_data_out(6), T => vme_tovme_b);     	
vme_d07_buf : IOBUF port map (O => vme_data_in(7), IO => vme_data(7), I => vme_data_out(7), T => vme_tovme_b);     	
vme_d08_buf : IOBUF port map (O => vme_data_in(8), IO => vme_data(8), I => vme_data_out(8), T => vme_tovme_b);     	
vme_d09_buf : IOBUF port map (O => vme_data_in(9), IO => vme_data(9), I => vme_data_out(9), T => vme_tovme_b);     	
vme_d10_buf : IOBUF port map (O => vme_data_in(10), IO => vme_data(10), I => vme_data_out(10), T => vme_tovme_b);     	
vme_d11_buf : IOBUF port map (O => vme_data_in(11), IO => vme_data(11), I => vme_data_out(11), T => vme_tovme_b);     	
vme_d12_buf : IOBUF port map (O => vme_data_in(12), IO => vme_data(12), I => vme_data_out(12), T => vme_tovme_b);     	
vme_d13_buf : IOBUF port map (O => vme_data_in(13), IO => vme_data(13), I => vme_data_out(13), T => vme_tovme_b);     	
vme_d14_buf : IOBUF port map (O => vme_data_in(14), IO => vme_data(14), I => vme_data_out(14), T => vme_tovme_b);     	
vme_d15_buf : IOBUF port map (O => vme_data_in(15), IO => vme_data(15), I => vme_data_out(15), T => vme_tovme_b);     	



-- Initial Assignments

lvmb_csb <= int_lvmb_csb;
lvmb_sclk <= int_lvmb_sclk;									
lvmb_sdin <= int_lvmb_sdin;									

PB_SEL : mode_pb_sel 
	port map (
		pb0 => pb(0),
		pb1 => pb(1),
		pb2 => pb(2),
		pb3 => pb(3),
		pb_reset => pb_reset,
		lb_en => lb_en,
		lb_ff_en => lb_ff_en,
		tm_en => tm_en);

test_vme_oe_b <= '1'; 							-- 3-state output enable for test_vme_data (high=input, low=output) 
-- test_vme_data_out <= "1010101010101010"; 	-- constant output (0xaaaa) for test_vme_data 

-- flf_test_en <= tm_en; 								
tkn_test_en <= tm_en; 							


-- CODE_B (LED CONTROLS)

-- leds_in(7 downto 0) <= int_lvmb_pon(7 downto 0);

lvmb_pon <= int_lvmb_pon(7 downto 0);

--led00_buf : OBUFT port map (O => leds(0), I => '0', T => d(53));    	
--led01_buf : OBUFT port map (O => leds(1), I => '0', T => d(52));    	
--led02_buf : OBUFT port map (O => leds(2), I => '0', T => d(51));    	
--led03_buf : OBUFT port map (O => leds(3), I => '0', T => d(50));    	
--led04_buf : OBUFT port map (O => leds(4), I => '0', T => d(49));    	
--led05_buf : OBUFT port map (O => leds(5), I => '0', T => d(48));    	
--led06_buf : OBUFT port map (O => leds(6), I => '0', T => d(47));    	
--led07_buf : OBUFT port map (O => leds(7), I => '0', T => d(46));    	
--led08_buf : OBUFT port map (O => leds(8), I => '0', T => pb(0));    	
--led09_buf : OBUFT port map (O => leds(9), I => '0', T => pb(1));    	
--led10_buf : OBUFT port map (O => leds(10), I => '0', T => pb(2));    	
--led11_buf : OBUFT port map (O => leds(11), I => '0', T => pb(3));    	

	leds(5 downto 0) <= mbc_leds(5 downto 0) when flf_ctrl(6) = '1' else
							  flf_ctrl(5 downto 0); 
	leds(6) <= not int_vme_dtack_v6_b;
	leds(7) <= not pll1_locked;
	leds(8) <= not qpll_locked; -- PB2
	leds(9) <= not pb(1); -- PB3
	leds(10) <= not pb(2); -- PB4
	leds(11) <= not pb(3); -- PB5

flf_status : process (dcfeb0_adc_mask,dcfeb0_fsel,dcfeb0_jtag_ir,
							 dcfeb1_adc_mask,dcfeb1_fsel,dcfeb1_jtag_ir,
							 dcfeb2_adc_mask,dcfeb2_fsel,dcfeb2_jtag_ir,
							 dcfeb3_adc_mask,dcfeb3_fsel,dcfeb3_jtag_ir,
							 dcfeb4_adc_mask,dcfeb4_fsel,dcfeb4_jtag_ir,
							 dcfeb5_adc_mask,dcfeb5_fsel,dcfeb5_jtag_ir,
							 dcfeb6_adc_mask,dcfeb6_fsel,dcfeb6_jtag_ir,
							 mbc_fsel,mbc_jtag_ir,flf_ctrl)

begin
	
	case flf_ctrl(4 downto 0) is

		when "00000" => flf_data <= "0000" & dcfeb0_adc_mask(11 downto 0); 
		when "00001" => flf_data <= dcfeb0_fsel(15 downto 0); 
		when "00010" => flf_data <= dcfeb0_fsel(31 downto 16);
		when "00011" => flf_data <= "00" & dcfeb0_jtag_ir(9 downto 0) & "000" & dcfeb0_fsel(31);
		when "00100" => flf_data <= "0000" & dcfeb1_adc_mask(11 downto 0); 
		when "00101" => flf_data <= dcfeb1_fsel(15 downto 0); 
		when "00110" => flf_data <= dcfeb1_fsel(31 downto 16);
		when "00111" => flf_data <= "00" & dcfeb1_jtag_ir(9 downto 0) & "000" & dcfeb1_fsel(31);
		when "01000" => flf_data <= "0000" & dcfeb2_adc_mask(11 downto 0); 
		when "01001" => flf_data <= dcfeb2_fsel(15 downto 0); 
		when "01010" => flf_data <= dcfeb2_fsel(31 downto 16);
		when "01011" => flf_data <= "00" & dcfeb2_jtag_ir(9 downto 0) & "000" & dcfeb2_fsel(31);
		when "01100" => flf_data <= "0000" & dcfeb3_adc_mask(11 downto 0); 
		when "01101" => flf_data <= dcfeb3_fsel(15 downto 0); 
		when "01110" => flf_data <= dcfeb3_fsel(31 downto 16);
		when "01111" => flf_data <= "00" & dcfeb3_jtag_ir(9 downto 0) & "000" & dcfeb3_fsel(31);
		when "10000" => flf_data <= "0000" & dcfeb4_adc_mask(11 downto 0); 
		when "10001" => flf_data <= dcfeb4_fsel(15 downto 0); 
		when "10010" => flf_data <= dcfeb4_fsel(31 downto 16);
		when "10011" => flf_data <= "00" & dcfeb4_jtag_ir(9 downto 0) & "000" & dcfeb4_fsel(31);
		when "10100" => flf_data <= "0000" & dcfeb5_adc_mask(11 downto 0); 
		when "10101" => flf_data <= dcfeb5_fsel(15 downto 0); 
		when "10110" => flf_data <= dcfeb5_fsel(31 downto 16);
		when "10111" => flf_data <= "00" & dcfeb5_jtag_ir(9 downto 0) & "000" & dcfeb5_fsel(31);
		when "11000" => flf_data <= "0000" & dcfeb6_adc_mask(11 downto 0); 
		when "11001" => flf_data <= dcfeb6_fsel(15 downto 0); 
		when "11010" => flf_data <= dcfeb6_fsel(31 downto 16);
		when "11011" => flf_data <= "00" & dcfeb6_jtag_ir(9 downto 0) & "000" & dcfeb6_fsel(31);
		when "11100" => flf_data <= mbc_fsel(16 downto 1); 
		when "11101" => flf_data <= mbc_fsel(32 downto 17); 
		when "11110" => flf_data <= '0' & mbc_fsel(47 downto 33);
		when "11111" => flf_data <= "00" & mbc_jtag_ir(9 downto 0) & "0000";
		when others => flf_data <= "0000000000000000";
	end case;
	
end process;
	

-- ------------------------------------------------------------------------------------------------- 

-- CODE_C (LVDS input buffers)

-- From OT1 (GigaBit Link)

-- gl1_rx
gl1_rx_buf : IBUFDS port map (I=>gl0_rx_p, IB=>gl0_rx_n, O=>gl0_rx);

-- From OT2 (GigaBit Link)

-- gl2_rx
gl2_rx_buf : IBUFDS port map (I=>gl1_rx_p, IB=>gl1_rx_n, O=>gl1_rx);


-- From ORX1

-- orx1_01
orx1_01_buf : IBUFDS port map (I=>orx1_01_p, IB=>orx1_01_n, O=>orx1_01);
-- orx1_02
orx1_02_buf : IBUFDS port map (I=>orx1_02_p, IB=>orx1_02_n, O=>orx1_02);
-- orx1_03
orx1_03_buf : IBUFDS port map (I=>orx1_03_p, IB=>orx1_03_n, O=>orx1_03);
-- orx1_04
orx1_04_buf : IBUFDS port map (I=>orx1_04_p, IB=>orx1_04_n, O=>orx1_04);
-- orx1_05
orx1_05_buf : IBUFDS port map (I=>orx1_05_p, IB=>orx1_05_n, O=>orx1_05);
-- orx1_06
orx1_06_buf : IBUFDS port map (I=>orx1_06_p, IB=>orx1_06_n, O=>orx1_06);
-- orx1_07
orx1_07_buf : IBUFDS port map (I=>orx1_07_p, IB=>orx1_07_n, O=>orx1_07);
-- orx1_08
orx1_08_buf : IBUFDS port map (I=>orx1_08_p, IB=>orx1_08_n, O=>orx1_08);
-- orx1_09
orx1_09_buf : IBUFDS port map (I=>orx1_09_p, IB=>orx1_09_n, O=>orx1_09);
-- orx1_10
orx1_10_buf : IBUFDS port map (I=>orx1_10_p, IB=>orx1_10_n, O=>orx1_10);
-- orx1_11
orx1_11_buf : IBUFDS port map (I=>orx1_11_p, IB=>orx1_11_n, O=>orx1_11);
-- orx1_12
orx1_12_buf : IBUFDS port map (I=>orx1_12_p, IB=>orx1_12_n, O=>orx1_12);


-- From ORX2

-- orx2_01
orx2_01_buf : IBUFDS port map (I=>orx2_01_p, IB=>orx2_01_n, O=>orx2_01);
-- orx2_01_buf : IBUFDS_DIFF_OUT port map (I=>orx2_01_p, IB=>orx2_01_n, O=>b_orx2_01_p, OB=>b_orx2_01_n);
-- orx2_02
orx2_02_buf : IBUFDS port map (I=>orx2_02_p, IB=>orx2_02_n, O=>orx2_02);
-- orx2_03
orx2_03_buf : IBUFDS port map (I=>orx2_03_p, IB=>orx2_03_n, O=>orx2_03);
-- orx2_04
orx2_04_buf : IBUFDS port map (I=>orx2_04_p, IB=>orx2_04_n, O=>orx2_04);
-- orx2_05
orx2_05_buf : IBUFDS port map (I=>orx2_05_p, IB=>orx2_05_n, O=>orx2_05);
-- orx2_06
orx2_06_buf : IBUFDS port map (I=>orx2_06_p, IB=>orx2_06_n, O=>orx2_06);
-- orx2_07
orx2_07_buf : IBUFDS port map (I=>orx2_07_p, IB=>orx2_07_n, O=>orx2_07);
-- orx2_08
orx2_08_buf : IBUFDS port map (I=>orx2_08_p, IB=>orx2_08_n, O=>orx2_08);
-- orx2_09
orx2_09_buf : IBUFDS port map (I=>orx2_09_p, IB=>orx2_09_n, O=>orx2_09);
-- orx2_10
orx2_10_buf : IBUFDS port map (I=>orx2_10_p, IB=>orx2_10_n, O=>orx2_10);
-- orx2_11
orx2_11_buf : IBUFDS port map (I=>orx2_11_p, IB=>orx2_11_n, O=>orx2_11);
-- orx2_12
orx2_12_buf : IBUFDS port map (I=>orx2_12_p, IB=>orx2_12_n, O=>orx2_12);


-- From QPLL

-- qpll_clk40MHz
qpll_clk40MHz_buf : IBUFDS port map (I=>qpll_clk40MHz_p, IB=>qpll_clk40MHz_n, O=>qpll_clk40MHz);
-- qpll_clk80MHz
qpll_clk80MHz_buf : IBUFDS port map (I=>qpll_clk80MHz_p, IB=>qpll_clk80MHz_n, O=>qpll_clk80MHz);


-- From Test Connector J3

-- ck_0
ck_0_buf : IBUFDS port map (I=>ck_0_p, IB=>ck_0_n, O=>ck_0);
-- ck_1
ck_1_buf : IBUFDS port map (I=>ck_1_p, IB=>ck_1_n, O=>ck_1);
-- tclk
tclk_buf : IBUFDS port map (I=>tclk_p, IB=>tclk_n, O=>ck_2);

-- rx_0
rx_0_buf : IBUFDS port map (I=>rx_0_p, IB=>rx_0_n, O=>rx_0);
-- rx_1
rx_1_buf : IBUFDS port map (I=>rx_1_p, IB=>rx_1_n, O=>rx_1);
-- rx_2
rx_2_buf : IBUFDS port map (I=>rx_2_p, IB=>rx_2_n, O=>rx_2);
-- rx_3
rx_3_buf : IBUFDS port map (I=>rx_3_p, IB=>rx_3_n, O=>rx_3);
-- rx_4
rx_4_buf : IBUFDS port map (I=>rx_4_p, IB=>rx_4_n, O=>rx_4);
-- rx_5
rx_5_buf : IBUFDS port map (I=>rx_5_p, IB=>rx_5_n, O=>rx_5);
-- rx_6
rx_6_buf : IBUFDS port map (I=>rx_6_p, IB=>rx_6_n, O=>rx_6);
-- rx_7
rx_7_buf : IBUFDS port map (I=>rx_7_p, IB=>rx_7_n, O=>rx_7);
-- rx_8
rx_8_buf : IBUFDS port map (I=>rx_8_p, IB=>rx_8_n, O=>rx_8);
-- rx_9
rx_9_buf : IBUFDS port map (I=>rx_9_p, IB=>rx_9_n, O=>rx_9);
-- rx_10
rx_10_buf : IBUFDS port map (I=>rx_10_p, IB=>rx_10_n, O=>rx_10);


-- ------------------------------------------------------------------------------------------------- 

-- CODE_D (LVDS output buffers)

-- To OT1 (GigaBit Link)

-- gl1_tx
gl1_tx_buf : OBUFDS port map (I=>gl0_tx, O=>gl0_tx_p, OB=>gl0_tx_n);

-- To OT2 (GigaBit Link)

-- gl2_tx
gl2_tx_buf : OBUFDS port map (I=>gl1_tx, O=>gl1_tx_p, OB=>gl1_tx_n);


-- To TX1 

-- otx1_01
otx1_01_buf : OBUFDS port map (I=>otx1_01, O=>otx1_01_p, OB=>otx1_01_n);
-- otx1_02
otx1_02_buf : OBUFDS port map (I=>otx1_02, O=>otx1_02_p, OB=>otx1_02_n);
-- otx1_03
otx1_03_buf : OBUFDS port map (I=>otx1_03, O=>otx1_03_p, OB=>otx1_03_n);
-- otx1_04
otx1_04_buf : OBUFDS port map (I=>otx1_04, O=>otx1_04_p, OB=>otx1_04_n);
-- otx1_05
otx1_05_buf : OBUFDS port map (I=>otx1_05, O=>otx1_05_p, OB=>otx1_05_n);
-- otx1_06
otx1_06_buf : OBUFDS port map (I=>otx1_06, O=>otx1_06_p, OB=>otx1_06_n);
-- otx1_07
otx1_07_buf : OBUFDS port map (I=>otx1_07, O=>otx1_07_p, OB=>otx1_07_n);
-- otx1_08
otx1_08_buf : OBUFDS port map (I=>otx1_08, O=>otx1_08_p, OB=>otx1_08_n);
-- otx1_09
otx1_09_buf : OBUFDS port map (I=>otx1_09, O=>otx1_09_p, OB=>otx1_09_n);
-- otx1_10
otx1_10_buf : OBUFDS port map (I=>otx1_10, O=>otx1_10_p, OB=>otx1_10_n);
-- 
otx1_11_buf : OBUFDS port map (I=>otx1_11, O=>otx1_11_p, OB=>otx1_11_n);
-- otx1_12
otx1_12_buf : OBUFDS port map (I=>otx1_12, O=>otx1_12_p, OB=>otx1_12_n);

-- To TX2 

-- otx2_01
otx2_01_buf : OBUFDS port map (I=>otx2_01, O=>otx2_01_p, OB=>otx2_01_n);
-- otx2_02
otx2_02_buf : OBUFDS port map (I=>otx2_02, O=>otx2_02_p, OB=>otx2_02_n);
-- otx2_03
otx2_03_buf : OBUFDS port map (I=>otx2_03, O=>otx2_03_p, OB=>otx2_03_n);
-- otx2_04
otx2_04_buf : OBUFDS port map (I=>otx2_04, O=>otx2_04_p, OB=>otx2_04_n);
-- otx2_05
otx2_05_buf : OBUFDS port map (I=>otx2_05, O=>otx2_05_p, OB=>otx2_05_n);
-- otx2_06
otx2_06_buf : OBUFDS port map (I=>otx2_06, O=>otx2_06_p, OB=>otx2_06_n);
-- otx2_07
otx2_07_buf : OBUFDS port map (I=>otx2_07, O=>otx2_07_p, OB=>otx2_07_n);
-- otx2_08
otx2_08_buf : OBUFDS port map (I=>otx2_08, O=>otx2_08_p, OB=>otx2_08_n);
-- otx2_09
otx2_09_buf : OBUFDS port map (I=>otx2_09, O=>otx2_09_p, OB=>otx2_09_n);
-- otx2_10
otx2_10_buf : OBUFDS port map (I=>otx2_10, O=>otx2_10_p, OB=>otx2_10_n);
-- otx2_11
otx2_11_buf : OBUFDS port map (I=>otx2_11, O=>otx2_11_p, OB=>otx2_11_n);
-- otx2_12
otx2_12_buf : OBUFDS port map (I=>otx2_12, O=>otx2_12_p, OB=>otx2_12_n);


-- To Test Connector

-- rxb
rxb_buf : OBUFDS port map (I=>rxb, O=>rxb_p, OB=>rxb_n);
-- tx_0
tx_0_buf : OBUFDS port map (I=>tx_0, O=>tx_0_p, OB=>tx_0_n);
-- tx_1
tx_1_buf : OBUFDS port map (I=>tx_1, O=>tx_1_p, OB=>tx_1_n);
-- tx_2
tx_2_buf : OBUFDS port map (I=>tx_2, O=>tx_2_p, OB=>tx_2_n);
-- tx_1
tx_3_buf : OBUFDS port map (I=>tx_3, O=>tx_3_p, OB=>tx_3_n);
-- tx_1
tx_4_buf : OBUFDS port map (I=>tx_4, O=>tx_4_p, OB=>tx_4_n);
-- tx_1
tx_5_buf : OBUFDS port map (I=>tx_5, O=>tx_5_p, OB=>tx_5_n);
-- tx_1
tx_6_buf : OBUFDS port map (I=>tx_6, O=>tx_6_p, OB=>tx_6_n);
-- tx_1
tx_7_buf : OBUFDS port map (I=>tx_7, O=>tx_7_p, OB=>tx_7_n);
-- tx_1
tx_8_buf : OBUFDS port map (I=>tx_8, O=>tx_8_p, OB=>tx_8_n);
-- tx_1
tx_9_buf : OBUFDS port map (I=>tx_9, O=>tx_9_p, OB=>tx_9_n);
-- tx_1
tx_10_buf : OBUFDS port map (I=>tx_10, O=>tx_10_p, OB=>tx_10_n);

-- ------------------------------------------------------------------------------------------------- 

-- CODE_E (Buffers for DIFFERENTIAL CLOCK LINES for GTX CORES)
 
--  IBUFGDS_CDC_CLK_0 : IBUFGDS
--  generic map (
--      DIFF_TERM => FALSE, -- Differential Termination 
--      IBUF_LOW_PWR => TRUE, -- Low power (TRUE) vs. performance (FALSE) setting for refernced I/O standards
--      IOSTANDARD => "DEFAULT")
--   port map (
--      O => cdc_clk(0),  -- Clock buffer output
--      I => cdc_clk_0_p,  -- Diff_p clock buffer input (connect directly to top-level port)
--      IB => cdc_clk_0_n -- Diff_n clock buffer input (connect directly to top-level port)
--   );

	IBUFGDS_CDC_CLK_0 : IBUFDS_GTXE1
   port map (
      O => cdc_clk(0),  	-- Clock buffer output
      ODIV2 => open, 
      CEB => '0',  
      I => cdc_clk_0_p,  	-- Diff_p clock buffer input (connect directly to top-level port)
      IB => cdc_clk_0_n 	-- Diff_n clock buffer input (connect directly to top-level port)
   );

--  IBUFGDS_CDC_CLK_1 : IBUFGDS
--   generic map (
--      DIFF_TERM => FALSE, -- Differential Termination 
--      IBUF_LOW_PWR => TRUE, -- Low power (TRUE) vs. performance (FALSE) setting for refernced I/O standards
--      IOSTANDARD => "DEFAULT")
--   port map (
--      O => cdc_clk(1),  -- Clock buffer output
--      I => cdc_clk_1_p,  -- Diff_p clock buffer input (connect directly to top-level port)
--      IB => cdc_clk_1_n -- Diff_n clock buffer input (connect directly to top-level port)
--   );

	IBUFGDS_CDC_CLK_1 : IBUFDS_GTXE1
   port map (
      O => cdc_clk(1),  	-- Clock buffer output
      ODIV2 => open, 
      CEB => '0',  
      I => cdc_clk_1_p,  	-- Diff_p clock buffer input (connect directly to top-level port)
      IB => cdc_clk_1_n 	-- Diff_n clock buffer input (connect directly to top-level port)
   );

--  IBUFGDS_CDC_CLK_2 : IBUFGDS
--   generic map (
--      DIFF_TERM => FALSE, -- Differential Termination 
--      IBUF_LOW_PWR => TRUE, -- Low power (TRUE) vs. performance (FALSE) setting for refernced I/O standards
--      IOSTANDARD => "DEFAULT")
--   port map (
--      O => cdc_clk(2),  -- Clock buffer output
--      I => cdc_clk_2_p,  -- Diff_p clock buffer input (connect directly to top-level port)
--      IB => cdc_clk_2_n -- Diff_n clock buffer input (connect directly to top-level port)
--   );

	IBUFGDS_CDC_CLK_2 : IBUFDS_GTXE1
   port map (
      O => cdc_clk(2),  	-- Clock buffer output
      ODIV2 => open, 
      CEB => '0',  
      I => cdc_clk_2_p,  	-- Diff_p clock buffer input (connect directly to top-level port)
      IB => cdc_clk_2_n 	-- Diff_n clock buffer input (connect directly to top-level port)
   );

--  IBUFGDS_CDC_CLK_3 : IBUFGDS
--   generic map (
--      DIFF_TERM => FALSE, -- Differential Termination 
--      IBUF_LOW_PWR => TRUE, -- Low power (TRUE) vs. performance (FALSE) setting for refernced I/O standards
--      IOSTANDARD => "DEFAULT")
--   port map (
--      O => cdc_clk(3),  -- Clock buffer output
--      I => cdc_clk_3_p,  -- Diff_p clock buffer input (connect directly to top-level port)
--      IB => cdc_clk_3_n -- Diff_n clock buffer input (connect directly to top-level port)
--   );

	IBUFGDS_CDC_CLK_3 : IBUFDS_GTXE1
   port map (
      O => cdc_clk(3),  	-- Clock buffer output
      ODIV2 => open, 
      CEB => '0',  
      I => cdc_clk_3_p,  	-- Diff_p clock buffer input (connect directly to top-level port)
      IB => cdc_clk_3_n 	-- Diff_n clock buffer input (connect directly to top-level port)
   );

--  IBUFGDS_CDC_CLK_4 : IBUFGDS
--   generic map (
--      DIFF_TERM => FALSE, -- Differential Termination 
--      IBUF_LOW_PWR => TRUE, -- Low power (TRUE) vs. performance (FALSE) setting for refernced I/O standards
--      IOSTANDARD => "DEFAULT")
--   port map (
--      O => cdc_clk(4),  -- Clock buffer output
--      I => cdc_clk_4_p,  -- Diff_p clock buffer input (connect directly to top-level port)
--      IB => cdc_clk_4_n -- Diff_n clock buffer input (connect directly to top-level port)
--   );

	IBUFGDS_CDC_CLK_4 : IBUFDS_GTXE1
   port map (
      O => cdc_clk(4),  	-- Clock buffer output
      ODIV2 => open, 
      CEB => '0',  
      I => cdc_clk_4_p,  	-- Diff_p clock buffer input (connect directly to top-level port)
      IB => cdc_clk_4_n 	-- Diff_n clock buffer input (connect directly to top-level port)
   );

--  IBUFGDS_CDC_CLK_5 : IBUFGDS
--   generic map (
--      DIFF_TERM => FALSE, -- Differential Termination 
--      IBUF_LOW_PWR => TRUE, -- Low power (TRUE) vs. performance (FALSE) setting for refernced I/O standards
--      IOSTANDARD => "DEFAULT")
--   port map (
--      O => cdc_clk(5),  -- Clock buffer output
--      I => cdc_clk_5_p,  -- Diff_p clock buffer input (connect directly to top-level port)
--      IB => cdc_clk_5_n -- Diff_n clock buffer input (connect directly to top-level port)
--   );

	IBUFGDS_CDC_CLK_5 : IBUFDS_GTXE1
   port map (
      O => cdc_clk(5),  	-- Clock buffer output
      ODIV2 => open, 
      CEB => '0',  
      I => cdc_clk_5_p,  	-- Diff_p clock buffer input (connect directly to top-level port)
      IB => cdc_clk_5_n 	-- Diff_n clock buffer input (connect directly to top-level port)
   );

--  IBUFGDS_CDC_CLK_6 : IBUFGDS
--   generic map (
--      DIFF_TERM => FALSE, -- Differential Termination 
--      IBUF_LOW_PWR => TRUE, -- Low power (TRUE) vs. performance (FALSE) setting for refernced I/O standards
--      IOSTANDARD => "DEFAULT")
--   port map (
--      O => cdc_clk(6),  -- Clock buffer output
--      I => cdc_clk_6_p,  -- Diff_p clock buffer input (connect directly to top-level port)
--      IB => cdc_clk_6_n -- Diff_n clock buffer input (connect directly to top-level port)
--   );

	IBUFGDS_CDC_CLK_6 : IBUFDS_GTXE1
   port map (
      O => cdc_clk(6),  	-- Clock buffer output
      ODIV2 => open, 
      CEB => '0',  
      I => cdc_clk_6_p,  	-- Diff_p clock buffer input (connect directly to top-level port)
      IB => cdc_clk_6_n 	-- Diff_n clock buffer input (connect directly to top-level port)
   );

--  IBUFGDS_CDC_CLK_7 : IBUFGDS
--   generic map (
--      DIFF_TERM => FALSE, -- Differential Termination 
--      IBUF_LOW_PWR => TRUE, -- Low power (TRUE) vs. performance (FALSE) setting for refernced I/O standards
--      IOSTANDARD => "DEFAULT")
--   port map (
--      O => cdc_clk(7),  -- Clock buffer output
--      I => cdc_clk_7_p,  -- Diff_p clock buffer input (connect directly to top-level port)
--      IB => cdc_clk_7_n -- Diff_n clock buffer input (connect directly to top-level port)
--   );

	IBUFGDS_CDC_CLK_7 : IBUFDS_GTXE1
   port map (
      O => cdc_clk(7),  	-- Clock buffer output
      ODIV2 => open, 
      CEB => '0',  
      I => cdc_clk_7_p,  	-- Diff_p clock buffer input (connect directly to top-level port)
      IB => cdc_clk_7_n 	-- Diff_n clock buffer input (connect directly to top-level port)
   );

-- ------------------------------------------------------------------------------------------------- 

-- CODE_F (Clock Management)

-- Input clock selection

-- Stand Alone Test Bench (Clock from Stratix)
-- clkin <= ck_0;

-- Clock from QPLL
-- clkin <= qpll_clk40MHz;
 
pll1_rst <= '0';
pll1_pd <= '0';

-- Start of MMCM_BASE_inst instantiation

MMCM_BASE_PLL1 : MMCM_BASE
   generic map (
      BANDWIDTH => "OPTIMIZED",  -- Jitter programming ("HIGH","LOW","OPTIMIZED")
      CLKFBOUT_MULT_F => 16.0,    -- Multiply value for all CLKOUT (5.0-64.0).
      CLKFBOUT_PHASE => 0.0,     -- Phase offset in degrees of CLKFB (0.00-360.00).
      CLKIN1_PERIOD => 25.0,      -- Input clock period in ns to ps resolution (i.e. 33.333 is 30 MHz).
      CLKOUT0_DIVIDE_F => 1.0,   -- Divide amount for CLKOUT0 (1.000-128.000).
      -- CLKOUT0_DUTY_CYCLE - CLKOUT6_DUTY_CYCLE: Duty cycle for each CLKOUT (0.01-0.99).
      CLKOUT0_DUTY_CYCLE => 0.5,
      CLKOUT1_DUTY_CYCLE => 0.5,
      CLKOUT2_DUTY_CYCLE => 0.5,
      CLKOUT3_DUTY_CYCLE => 0.5,
      CLKOUT4_DUTY_CYCLE => 0.5,
      CLKOUT5_DUTY_CYCLE => 0.5,
      CLKOUT6_DUTY_CYCLE => 0.5,
      -- CLKOUT0_PHASE - CLKOUT6_PHASE: Phase offset for each CLKOUT (-360.000-360.000).
      CLKOUT0_PHASE => 0.0,
      CLKOUT1_PHASE => 0.0,
      CLKOUT2_PHASE => 0.0,
      CLKOUT3_PHASE => 0.0,
      CLKOUT4_PHASE => 0.0,
      CLKOUT5_PHASE => 0.0,
      CLKOUT6_PHASE => 0.0,
      -- CLKOUT1_DIVIDE - CLKOUT6_DIVIDE: Divide amount for each CLKOUT (1-128)
      CLKOUT1_DIVIDE => 16, 		-- clk40 = CMSCLK(40 MHz)
      CLKOUT2_DIVIDE => 64, 		-- clk10 = MIDCLK(10 MHz)		
      CLKOUT3_DIVIDE => 128, 		-- clk5 - generates clk2p5 and clk1p25
      CLKOUT4_DIVIDE => 128, 		-- Not used
      CLKOUT5_DIVIDE => 16,		-- Not used
      CLKOUT6_DIVIDE => 16, 		-- Not used
      CLKOUT4_CASCADE => FALSE,  -- Cascase CLKOUT4 counter with CLKOUT6 (TRUE/FALSE)
      CLOCK_HOLD => FALSE,       -- Hold VCO Frequency (TRUE/FALSE)
      DIVCLK_DIVIDE => 1,        -- Master division value (1-80)
      REF_JITTER1 => 0.0,        -- Reference input jitter in UI (0.000-0.999).
      STARTUP_WAIT => FALSE      -- Not supported. Must be set to FALSE.
   )
   port map (
      -- Clock Outputs: 1-bit (each) User configurable clock outputs
      CLKOUT0 => pll_clk80,     				-- 1-bit CLKOUT0 output
      CLKOUT0B => open,   					-- 1-bit Inverted CLKOUT0 output
      CLKOUT1 => pll_clk40,     			-- 1-bit CLKOUT1 output
      CLKOUT1B => open,   					-- 1-bit Inverted CLKOUT1 output
      CLKOUT2 => pll_clk10,    		   -- 1-bit CLKOUT2 output
      CLKOUT2B => open,   					-- 1-bit Inverted CLKOUT2 output
      CLKOUT3 => pll_clk5,    	-- 1-bit CLKOUT3 output
      CLKOUT3B => open,   					-- 1-bit Inverted CLKOUT3 output
      CLKOUT4 => open,    -- 1-bit CLKOUT4 output
      CLKOUT5 => open,    -- 1-bit CLKOUT5 output
      CLKOUT6 => open,    -- 1-bit CLKOUT6 output
      -- Feedback Clocks: 1-bit (each) Clock feedback ports
      CLKFBOUT => pll1_fb,   				-- 1-bit Feedback clock output
      CLKFBOUTB => open, 					-- 1-bit Inverted CLKFBOUT output
      -- Status Port: 1-bit (each) MMCM status ports
      LOCKED => pll1_locked,  			-- 1-bit LOCK output
      -- Clock Input: 1-bit (each) Clock input
      CLKIN1 => qpll_clk40MHz, -- qpll_clk40MHz,
      -- Control Ports: 1-bit (each) MMCM control ports
      PWRDWN => pll1_pd,       			-- 1-bit Power-down input
      RST => pll1_rst,             		-- 1-bit Reset input
      -- Feedback Clocks: 1-bit (each) Clock feedback ports
      CLKFBIN => pll1_fb      			-- 1-bit Feedback clock input
   );


-- End of MMCM_BASE_inst instantiation
				
---- Global Clock Buffers

clk80_buf : BUFG port map (I=>pll_clk80, O=>clk80);
clk40_buf : BUFG port map (I=>pll_clk40, O=>clk40);
clk10_buf : BUFG port map (I=>pll_clk10, O=>clk10);
clk5_buf  : BUFG port map (I=>pll_clk5,  O=>clk5);

-- Frequency dividers for the 2.5 and 1.25 MHz clocks which are too slow for the PLL 
clk2p5_inv <= not clk2p5;
clk1p25_inv <= not clk1p25;
-- FD(clk2p5_inv, clk5, clk2p5);
-- FD(clk1p25_inv, clk2p5, clk1p25);
FD1 : FD port map (D => clk2p5_inv, C => clk5, Q => clk2p5);
FD2 : FD port map (D => clk1p25_inv, C => clk2p5, Q => clk1p25);


-- ------------------------------------------------------------------------------------------------- 

-- CODE_G (FF-LYNX Management)

-- TX_CLK to DCFEBs

otx2_01 <= '0';
otx2_02 <= '0';
otx2_03 <= '0';
otx2_04 <= '0';
otx2_05 <= '0';
otx2_06 <= '0';
otx2_07 <= '0';
otx2_08 <= '0';
otx2_09 <= '0';
otx2_10 <= '0'; 
otx2_11 <= '0'; 
otx2_12 <= '0'; 

-- TX_DAT to DCFEBs
 
otx1_01 <= '0'; 	
otx1_02 <= '0'; 
otx1_03 <= '0'; 
otx1_04 <= '0'; 
otx1_05 <= '0'; 
otx1_06 <= '0'; 
otx1_07 <= '0'; 
otx1_08 <= '0';
otx1_09 <= '0';
-- otx1_10 <= '0'; 
-- otx1_11 <= '0'; 
-- otx1_12 <= '0';

-- dcfeb0_rx_dat <= orx1_01;
dcfeb0_rx_dat <= dcfeb0_tx_dat;
-- dcfeb1_rx_dat <= orx1_02; 	
-- dcfeb2_rx_dat <= orx1_03;
dcfeb3_rx_dat <= orx1_04;
dcfeb4_rx_dat <= orx1_05;
dcfeb5_rx_dat <= orx1_06;
dcfeb6_rx_dat <= orx1_07;



vme_dtack_v6_b <= int_vme_dtack_v6_b;  

MBV : ODMB_VME
PORT MAP (

-- VME signals 

--		vme_addr => int_vme_addr,									-- input
--		vme_data_in => int_vme_data_in,							-- input
--		vme_data_out => vme_data_out,								-- output
--		vme_am => int_vme_am,											-- input
--		vme_gap => int_vme_gap,										-- input
--		vme_ga => int_vme_ga,											-- input
--		vme_ds_b => int_vme_ds_b,									-- input
--		vme_as_b => int_vme_as_b,									-- input
--		vme_lword_b => int_vme_lword_b,							-- input
--		vme_write_b => int_vme_write_b,							-- input
--		vme_iack_b => int_vme_iack_b,								-- input
--		vme_sysreset_b => int_vme_sysreset_b,					-- input
--		vme_sysfail_b => int_vme_sysfail_b,						-- input
--		vme_sysfail_out => int_vme_sysfail_out,				-- output
--		vme_berr_b => int_vme_berr_b,								-- input
--		vme_berr_out => int_vme_berr_out,						-- output
--		vme_dtack_b => int_vme_dtack_v6_b,							-- output
--		vme_tovme => int_vme_tovme,										-- tovme
--		vme_tovme_b => int_vme_tovme_b,										-- tovme*
--		vme_doe => int_vme_doe,									-- doe
--		vme_doe_b => int_vme_doe_b,									-- doe*

		vme_addr => vme_addr,									-- input
		vme_data_in => vme_data_in,							-- input
		vme_data_out => vme_data_out,								-- output
		vme_am => vme_am,											-- input
		vme_gap => vme_gap,										-- input
		vme_ga => vme_ga,											-- input
		vme_ds_b => vme_ds_b,									-- input
		vme_as_b => vme_as_b,									-- input
		vme_lword_b => vme_lword_b,							-- input
		vme_write_b => vme_write_b,							-- input
		vme_iack_b => vme_iack_b,								-- input
		vme_sysreset_b => vme_sysreset_b,					-- input
		vme_sysfail_b => vme_sysfail_b,						-- input
		vme_sysfail_out => vme_sysfail_out,				-- output
		vme_berr_b => vme_berr_b,								-- input
		vme_berr_out => vme_berr_out,						-- output
		vme_dtack_b => int_vme_dtack_v6_b,							-- output
		vme_tovme => vme_tovme,										-- tovme
		vme_tovme_b => vme_tovme_b,										-- tovme*
		vme_doe => vme_doe,									-- doe
		vme_doe_b => vme_doe_b,									-- doe*

-- Clock

		clk => clk40,										-- fpgaclk (40MHz)
		clk_s1 => clk10,									-- midclk (10MHz) 
		clk_s2 => clk2p5,									-- slowclk (2.5MHz)
		clk_s3 => clk1p25, 									-- slowclk2 (1.25MHz)

-- Reset

		rst => reset,
		
-- JTAG signals To/From DCFEBs

		dl_jtag_tck => dl_jtag_tck,			
		dl_jtag_tms => dl_jtag_tms,					
		dl_jtag_tdi => dl_jtag_tdi,						
		dl_jtag_tdo => dl_jtag_tdo,					
		dl_rtn_shft_en => dl_rtn_shft_en,
		ul_jtag_tck => ul_jtag_tck,					
		ul_jtag_tms => ul_jtag_tms,				
		ul_jtag_tdi => ul_jtag_tdi,						

-- JTAG Signals To/From ODMB_CTRL

		mbc_jtag_tck => mbc_jtag_tck,				
		mbc_jtag_tms => mbc_jtag_tms,				
		mbc_jtag_tdi => mbc_jtag_tdi,				
		mbc_jtag_tdo => mbc_jtag_tdo,				

-- Reprogram To DCFEB FPGA (CFEBPRG)

		dl_reprogram => dl_reprogram,

-- Done from DCFEB FPGA (CFEBPRG)

		ul_done => ul_done,

-- To/From O-DMB ADC

		adc_cs => adc_cs,									
		adc_sclk =>	adc_sclk,								
		adc_sdain => adc_sdain,								
		adc_sdaout => adc_sdaout,							
		
-- To/From O-DMB DAC

		dac_cs => dac_cs,								
		dac_sclk => dac_sclk,										
		dac_sdain => dac_sdain,									
		dac_sdaout => dac_sdaout,										

-- To/From DCFEB FIFOs

		fifo_wr_ck => fifo_wr_ck,
		fifo_wr_en => fifo_tm_wr_en,	
		fifo_rw_en => fifo_rw_en,	
		fifo_rm_en => fifo_rm_en,	
		fifo_tm_en => fifo_tm_en,	

		fifo_in => fifo_in,
		fifo_out => fifo_out,

-- SPI signals To/From DCFEBs (ADCs and DACs)

		dl_spi_cs0 => dl_spi_cs0,
		dl_spi_cs1 => dl_spi_cs1,		
		dl_spi_scl => dl_spi_scl,			
		dl_spi_sda => dl_spi_sda,		 
		ul_spi_scl => ul_spi_scl,	
		ul_spi_sda => ul_spi_sda,	 
		ul_spi_busy => ul_spi_busy,		 

-- Token signals To/From DCFEBs

		dl_tkn => dl_tkn,				
		ul_tkn => ul_tkn,				

-- I2C signals To/From DCFEBs (FF-EMU ASICs)

		dl_i2c_scl => dl_i2c_scl,				
		dl_i2c_sda => dl_i2c_sda,				
		ul_i2c_scl => ul_i2c_scl,				
		ul_i2c_sda => ul_i2c_sda,			

-- From/To QPLL

		qpll_autorestart => qpll_autorestart,						-- NEW!
		qpll_mode => qpll_mode,											-- NEW!
		qpll_extcontrol => qpll_extcontrol,							-- NEW!
		qpll_reset => qpll_reset,										-- NEW!
		qpll_f0sel => qpll_f0sel,										-- NEW!
		qpll_locked => qpll_locked,									-- NEW!
		qpll_error => qpll_error,										-- NEW!

-- From/To LVMB

		lvmb_pon => int_lvmb_pon,
		pon_load => pon_load,
		pon_oe_b => pon_en,
		r_lvmb_pon => r_lvmb_pon,		
		lvmb_csb => int_lvmb_csb,			
		lvmb_sclk => int_lvmb_sclk,
		lvmb_sdin => int_lvmb_sdin,			
		lvmb_sdout => int_lvmb_sdout,
		
		diagout_cfebjtag => diagout_cfebjtag,
		diagout_lvdbmon => diagout_lvdbmon,

-- From/To FIFOs

		tfifo_data => tfifo_data,
		tfifo_wc => tfifo_wc,
		tfifo_rc => tfifo_rc,
		tfifo_str => tfifo_str,
		tfifo_wr_en => tfifo_wr_en,
		tfifo_rd_en => tfifo_rd_en,
		tfifo_sel => tfifo_sel,
		tfifo_mode => tfifo_mode,
		
		flf_ctrl => flf_ctrl,
		flf_data => flf_data
		
);


-- ODMB_CTRL FPGA

MBC : ODMB_CTRL
PORT MAP (

		mbc_fsel => mbc_fsel,
		mbc_jtag_ir => mbc_jtag_ir,

		ccb_cmd => ccb_cmd,												-- ccbcmnd(5 downto 0) - from J3
		ccb_cmd_s => ccb_cmd_s,											-- ccbcmnd(6) - from J3
		ccb_data => ccb_data,											-- ccbdata(7 downto 0) - from J3
		ccb_data_s => ccb_data_s,										-- ccbdata(8) - from J3
		ccb_cal => ccb_cal,												-- ccbcal(2 downto 0) - from J3
		ccb_crsv => ccb_crsv,											-- NEW [ccbrsv(6)], ccbrsv(3 downto 0) - from J3
		ccb_drsv => ccb_drsv,											-- ccbrsv(5 downto 4) - from J3
		ccb_rsvo => ccb_rsvo,											-- NEW [ccbrsv(11)], ccbrsv(10 downto 7) - from J3
		ccb_rsvi => ccb_rsvi,											-- ccbrsv(14 downto 12) - to J3
		ccb_bx0 => ccb_bx0,												-- bx0 - from J3
		ccb_bxrst => ccb_bxrst,											-- bxrst - from J3
		ccb_l1acc => ccb_l1acc,											-- l1acc - from J3
		ccb_l1arst => ccb_l1arst,										-- l1rst - from J3
		ccb_l1rls => ccb_l1rls,											-- l1rls - to J3
		ccb_clken => ccb_clken,											-- clken - from J3

		rawlct => rawlct,													-- rawlct(NFEB downto 0) - from J4
		lctdav1 => lctdav1,												-- lctdav1 - from J4
		lctdav2 => lctdav2,												-- lctdav2 - from J4
		lctrqst => lctrqst,												-- lctrqst(2 downto 1) - to J4
		rsvtd_in => rsvtd_in,											-- spare(7 DOWNTO 3) - to J4
--		rsvtd_out => rsvtd_out(6 downto 3),											-- spare(7 DOWNTO 3) - from J4
		rsvtd_out => rsvtd_out,											-- spare(2 DOWNTO 0) - from J4

-- From GigaLinks

		grx0_data => "0000000000000000",								-- glin(15 downto 0)									  
		grx0_data_valid => '0',		 
		grx1_data => "0000000000000000",								-- glin(15 downto 0)											  
		grx1_data_valid => '0',			 
	
-- To GigaLinks

		gtx0_data => gtx0_data,											-- dout(15 downto 0)											  
		gtx0_data_valid => gtx0_data_valid,												
		gtx1_data => gtx1_data,													-- dout(15 downto 0)											  
		gtx1_data_valid => gtx1_data_valid,												
	
-- From/To FIFOs

		fifo_rd_ck => fifo_rd_ck,										  
		fifo_rd_en => fifo_rd_en,										  
		fifo_sel => fifo_sel,			 

		fifo_out => fifo_out,				

		fifo_mrst_b => fifo_mrst_b,									-- ok -> fifo_mrst* - to FIFOs 
		fifo_prst_b => fifo_prst_b,									-- ok -> fifo_prst* - to FIFOs 

		fifo_full_b => fifo_full,									-- full*(7 DOWNTO 1) - from FIFOs 
		fifo_half_b => fifo_half,									-- half*(7 DOWNTO 1) - from FIFOs 
		fifo_pae_b => fifo_pae,										-- paef*(7 DOWNTO 1) - from FIFOs 
		fifo_empty_b => fifo_empty,									-- emptyf*(7 DOWNTO 1) - from FIFOs 

-- From/To DCFEBs (FF-EMU-MOD)

		ul_dav => ul_dav,															-- davf(5 DOWNTO 1) - from DCFEBs 
		ul_movlp => ul_movlp,													-- movlp(5 DOWNTO 1) - from DCFEBs

		dcfeb_l1a_match => dcfeb_l1a_match, 														-- lctf(5 DOWNTO 1) - to DCFEBs
		dcfeb_l1a =>	dcfeb_l1a,													-- febrst - to DCFEBs
		dcfeb_injpulse => dcfeb_injpulse,											-- inject - to DCFEBs
		dcfeb_extpulse => dcfeb_extpulse,											-- extpulse - to DCFEBs

-- From/To LVMB

		r_lvmb_pon => r_lvmb_pon,		
		lvmb_csb => int_lvmb_csb,			
		lvmb_sclk => int_lvmb_sclk,
		lvmb_sdin => int_lvmb_sdin,		
		lvmb_sdout => int_lvmb_sdout,

-- From/To ODMB_VME

		clk40 => clk40,
		clk80 => clk80,
		reset => reset, 

		tck => mbc_jtag_tck,
		tdi => mbc_jtag_tdi,
		tms => mbc_jtag_tms,
		tdo => mbc_jtag_tdo,
		
		test_ccbinj => flf_ctrl(15),
		test_ccbpls => flf_ctrl(14),
 
		leds => mbc_leds
	
);

-- OT Manager
	  
OT_MANAGER : ot_mgr
PORT MAP (
		 otx1_tx_en => otx1_tx_en,
		 otx1_tx_dis => otx1_tx_dis,
		 otx1_reset => otx1_reset,
		 otx1_fault => otx1_fault,
		 otx2_tx_en => otx2_tx_en,
		 otx2_tx_dis => otx2_tx_dis,
		 otx2_reset => otx2_reset,
		 otx2_fault => otx2_fault,
		 orx1_rx_en => orx1_rx_en,
		 orx1_en_sd => orx1_en_sd,
		 orx1_sd => orx1_sd,
		 orx1_sq_en => orx1_sq_en,
		 orx2_rx_en => orx2_rx_en,
		 orx2_en_sd => orx2_en_sd,
		 orx2_sd => orx2_sd,
		 orx2_sq_en => orx2_sq_en);

orx2_01_sd <= orx2_sd;
orx2_02_sd <= orx2_sd;
orx2_03_sd <= orx2_sd;
orx2_04_sd <= orx2_sd;
orx2_05_sd <= orx2_sd;
orx2_06_sd <= orx2_sd;
orx2_07_sd <= orx2_sd;
orx2_08_sd <= orx2_sd;

-- FIFO MUX

fifo_mux_out_proc : process(fifo_sel, dcfeb0_fifo_out, dcfeb1_fifo_out, dcfeb2_fifo_out, dcfeb3_fifo_out,
									 dcfeb4_fifo_out, dcfeb5_fifo_out, dcfeb6_fifo_out, tmb_fifo_out, alct_fifo_out)

begin

	case fifo_sel is

		when "0000" => fifo_out <= dcfeb0_fifo_out;
		when "0001" => fifo_out <= dcfeb1_fifo_out;
		when "0010" => fifo_out <= dcfeb2_fifo_out;
		when "0011" => fifo_out <= dcfeb3_fifo_out;
		when "0100" => fifo_out <= dcfeb4_fifo_out;
		when "0101" => fifo_out <= dcfeb5_fifo_out;
		when "0110" => fifo_out <= dcfeb6_fifo_out;
		when "0111" => fifo_out <= tmb_fifo_out;
		when "1000" => fifo_out <= alct_fifo_out;
		when others => fifo_out <= (OTHERS => '0');
	end case;
	
end process;

-- DCFEB FIFO WR_EN GENERATION

-- fifo_wr_en_proc : process(dcfeb0_data_valid,dcfeb1_data_valid,dcfeb2_data_valid,dcfeb3_data_valid,
--										dcfeb4_data_valid,dcfeb5_data_valid,dcfeb6_data_valid,tmb_data_valid,
--										alct_data_valid,fifo_rm_en,fifo_tm_en,fifo_tm_wr_en,fifo_rw_en)
--begin
--	fifo_wr_en(1) <= (dcfeb0_data_valid and fifo_rm_en(1)) or (fifo_tm_wr_en(1) and fifo_tm_en(1));
--	fifo_wr_en(2) <= (dcfeb1_data_valid and fifo_rm_en(2)) or (fifo_tm_wr_en(2) and fifo_tm_en(2));
--	fifo_wr_en(3) <= (dcfeb2_data_valid and fifo_rm_en(3)) or (fifo_tm_wr_en(3) and fifo_tm_en(3));
--	fifo_wr_en(4) <= (dcfeb3_data_valid and fifo_rm_en(4)) or (fifo_tm_wr_en(4) and fifo_tm_en(4));
--	fifo_wr_en(5) <= (dcfeb4_data_valid and fifo_rm_en(5)) or (fifo_tm_wr_en(5) and fifo_tm_en(5));
--	fifo_wr_en(6) <= (dcfeb5_data_valid and fifo_rm_en(6)) or (fifo_tm_wr_en(6) and fifo_tm_en(6));
--	fifo_wr_en(7) <= (dcfeb6_data_valid and fifo_rm_en(7)) or (fifo_tm_wr_en(7) and fifo_tm_en(7));
--	fifo_wr_en(8) <= (tmb_data_valid and fifo_rm_en(8)) or (fifo_tm_wr_en(8) and fifo_tm_en(8));
--	fifo_wr_en(9) <= (alct_data_valid and fifo_rm_en(9)) or (fifo_tm_wr_en(9) and fifo_tm_en(9));
--end process;

fifo_wr_en <= "000000000"; -- to remove error 528!!!

-- FIFO Management

FIFO_OUT_SEL_PM : fifo_outdata_sel
  
	port map (

		fifo_sel  => tfifo_sel,
		fifo0_outdata => dcfeb0_tfifo_out,
		fifo1_outdata => dcfeb1_tfifo_out,
		fifo2_outdata => dcfeb2_tfifo_out,
		fifo3_outdata => dcfeb3_tfifo_out,
		fifo4_outdata => dcfeb4_tfifo_out,
		fifo5_outdata => dcfeb5_tfifo_out,
		fifo6_outdata => dcfeb6_tfifo_out,
		fifo7_outdata => dcfeb7_tfifo_out,
		fifo_outdata => tfifo_data

);

FIFO_WC_SEL_PM : fifo_wc_sel
  
	port map (

		fifo_sel  => tfifo_sel,
		fifo0_wc => dcfeb0_fifo_wr_cnt,
		fifo1_wc => dcfeb1_fifo_wr_cnt,
		fifo2_wc => dcfeb2_fifo_wr_cnt,
		fifo3_wc => dcfeb3_fifo_wr_cnt,
		fifo4_wc => dcfeb4_fifo_wr_cnt,
		fifo5_wc => dcfeb5_fifo_wr_cnt,
		fifo6_wc => dcfeb6_fifo_wr_cnt,
		fifo7_wc => dcfeb7_fifo_wr_cnt,
		fifo_wc => tfifo_wc

);

FIFO_RC_SEL_PM : fifo_rc_sel
  
	port map (

		fifo_sel  => tfifo_sel,
		fifo0_rc => dcfeb0_fifo_rd_cnt,
		fifo1_rc => dcfeb1_fifo_rd_cnt,
		fifo2_rc => dcfeb2_fifo_rd_cnt,
		fifo3_rc => dcfeb3_fifo_rd_cnt,
		fifo4_rc => dcfeb4_fifo_rd_cnt,
		fifo5_rc => dcfeb5_fifo_rd_cnt,
		fifo6_rc => dcfeb6_fifo_rd_cnt,
		fifo7_rc => dcfeb7_fifo_rd_cnt,
		fifo_rc => tfifo_rc

);

fifo_status : process (empty, full)
    
begin		
  tfifo_str(0) <= empty(0);
  tfifo_str(1) <= full(0);
--  tfifo_str(15 downto 2) <= "00000000000000";
  tfifo_str(2) <= empty(1);
  tfifo_str(3) <= full(1);
  tfifo_str(4) <= empty(2);
  tfifo_str(5) <= full(2);
  tfifo_str(6) <= empty(3);
  tfifo_str(7) <= full(3);
  tfifo_str(8) <= empty(4);
  tfifo_str(9) <= full(4);
  tfifo_str(10) <= empty(5);
  tfifo_str(11) <= full(5);
  tfifo_str(12) <= empty(6);
  tfifo_str(13) <= full(6);
  tfifo_str(14) <= empty(7);
  tfifo_str(15) <= full(7);
end process;

dcfeb0_gbrx_test : process(tfifo_mode, dcfeb0_gbrx_data, dcfeb0_gbrx_data_valid, dcfeb0_gbrx_data_clk,
									vme_data_in, tfifo_wr_en, tfifo_rd_en, clk2p5)
begin
	if (tfifo_mode = '1') then
		dcfeb0_tfifo_in <= dcfeb0_gbrx_data;
		dcfeb0_fifo_wr_en <= dcfeb0_gbrx_data_valid;
--		dcfeb0_fifo_wr_ck <= dcfeb0_gbrx_data_clk;
		dcfeb0_fifo_wr_ck <= clk2p5;
		dcfeb0_fifo_rd_en <= tfifo_rd_en(0);
		dcfeb0_fifo_rd_ck <= clk2p5;
	else
		dcfeb0_tfifo_in <= vme_data_in;
		dcfeb0_fifo_wr_en <= tfifo_wr_en(0);
		dcfeb0_fifo_wr_ck <= clk2p5;
		dcfeb0_fifo_rd_en <= tfifo_rd_en(0);
		dcfeb0_fifo_rd_ck <= clk2p5;
	end if;

end process;
	
dcfeb1_gbrx_test : process(tfifo_mode, dcfeb1_gbrx_data, dcfeb1_gbrx_data_valid, dcfeb1_gbrx_data_clk,
									vme_data_in, tfifo_wr_en, tfifo_rd_en, clk2p5)
begin
	if (tfifo_mode = '1') then
		dcfeb1_tfifo_in <= dcfeb1_gbrx_data;
		dcfeb1_fifo_wr_en <= dcfeb1_gbrx_data_valid;
--		dcfeb1_fifo_wr_ck <= dcfeb1_gbrx_data_clk;
		dcfeb1_fifo_wr_ck <= clk2p5;
		dcfeb1_fifo_rd_en <= tfifo_rd_en(1);
		dcfeb1_fifo_rd_ck <= clk2p5;
	else
		dcfeb1_tfifo_in <= vme_data_in;
		dcfeb1_fifo_wr_en <= tfifo_wr_en(1);
		dcfeb1_fifo_wr_ck <= clk2p5;
		dcfeb1_fifo_rd_en <= tfifo_rd_en(1);
		dcfeb1_fifo_rd_ck <= clk2p5;
	end if;
	
end process;

dcfeb2_gbrx_test : process(tfifo_mode, dcfeb2_gbrx_data, dcfeb2_gbrx_data_valid, dcfeb2_gbrx_data_clk,
									vme_data_in, tfifo_wr_en, tfifo_rd_en, clk2p5)
begin
	if (tfifo_mode = '1') then
		dcfeb2_tfifo_in <= dcfeb2_gbrx_data;
		dcfeb2_fifo_wr_en <= dcfeb2_gbrx_data_valid;
--		dcfeb2_fifo_wr_ck <= dcfeb2_gbrx_data_clk;
		dcfeb2_fifo_wr_ck <= clk2p5;
		dcfeb2_fifo_rd_en <= tfifo_rd_en(2);
		dcfeb2_fifo_rd_ck <= clk2p5;
	else
		dcfeb2_tfifo_in <= vme_data_in;
		dcfeb2_fifo_wr_en <= tfifo_wr_en(2);
		dcfeb2_fifo_wr_ck <= clk2p5;
		dcfeb2_fifo_rd_en <= tfifo_rd_en(2);
		dcfeb2_fifo_rd_ck <= clk2p5;
	end if;
	
end process;

dcfeb3_gbrx_test : process(tfifo_mode, dcfeb3_gbrx_data, dcfeb3_gbrx_data_valid, dcfeb3_gbrx_data_clk,
									vme_data_in, tfifo_wr_en, tfifo_rd_en, clk2p5)
begin
	if (tfifo_mode = '1') then
		dcfeb3_tfifo_in <= dcfeb3_gbrx_data;
		dcfeb3_fifo_wr_en <= dcfeb3_gbrx_data_valid;
--		dcfeb3_fifo_wr_ck <= dcfeb3_gbrx_data_clk;
		dcfeb3_fifo_wr_ck <= clk2p5;
		dcfeb3_fifo_rd_en <= tfifo_rd_en(3);
		dcfeb3_fifo_rd_ck <= clk2p5;
	else
		dcfeb3_tfifo_in <= vme_data_in;
		dcfeb3_fifo_wr_en <= tfifo_wr_en(3);
		dcfeb3_fifo_wr_ck <= clk2p5;
		dcfeb3_fifo_rd_en <= tfifo_rd_en(3);
		dcfeb3_fifo_rd_ck <= clk2p5;
	end if;
	
end process;

dcfeb4_gbrx_test : process(tfifo_mode, dcfeb4_gbrx_data, dcfeb4_gbrx_data_valid, dcfeb4_gbrx_data_clk,
									vme_data_in, tfifo_wr_en, tfifo_rd_en, clk2p5)
begin
	if (tfifo_mode = '1') then
--		dcfeb4_tfifo_in <= dcfeb4_gbrx_data;
--		dcfeb4_fifo_wr_en <= dcfeb4_gbrx_data_valid;
--		dcfeb4_fifo_wr_ck <= dcfeb4_gbrx_data_clk;
--		dcfeb4_fifo_rd_en <= tfifo_rd_en(4);
--		dcfeb4_fifo_rd_ck <= clk2p5;
		dcfeb4_tfifo_in <= vme_data_in;
		dcfeb4_fifo_wr_en <= tfifo_wr_en(4);
--		dcfeb4_fifo_wr_ck <= dcfeb4_gbrx_data_clk;
		dcfeb4_fifo_wr_ck <= clk2p5;
		dcfeb4_fifo_rd_en <= tfifo_rd_en(4);
		dcfeb4_fifo_rd_ck <= clk2p5;
	else
		dcfeb4_tfifo_in <= vme_data_in;
		dcfeb4_fifo_wr_en <= tfifo_wr_en(4);
		dcfeb4_fifo_wr_ck <= clk2p5;
		dcfeb4_fifo_rd_en <= tfifo_rd_en(4);
		dcfeb4_fifo_rd_ck <= clk2p5;
	end if;
	
end process;

dcfeb5_gbrx_test : process(tfifo_mode, dcfeb5_gbrx_data, dcfeb5_gbrx_data_valid, dcfeb5_gbrx_data_clk,
									vme_data_in, tfifo_wr_en, tfifo_rd_en, clk2p5)
begin
	if (tfifo_mode = '1') then
--		dcfeb5_tfifo_in <= dcfeb5_gbrx_data;
--		dcfeb5_fifo_wr_en <= dcfeb5_gbrx_data_valid;
--		dcfeb5_fifo_wr_ck <= dcfeb5_gbrx_data_clk;
--		dcfeb5_fifo_rd_en <= tfifo_rd_en(5);
--		dcfeb5_fifo_rd_ck <= clk2p5;
		dcfeb5_tfifo_in <= vme_data_in;
		dcfeb5_fifo_wr_en <= tfifo_wr_en(5);
		dcfeb5_fifo_wr_ck <= clk2p5;
		dcfeb5_fifo_rd_en <= tfifo_rd_en(5);
		dcfeb5_fifo_rd_ck <= clk2p5;
	else
		dcfeb5_tfifo_in <= vme_data_in;
		dcfeb5_fifo_wr_en <= tfifo_wr_en(5);
		dcfeb5_fifo_wr_ck <= clk2p5;
		dcfeb5_fifo_rd_en <= tfifo_rd_en(5);
		dcfeb5_fifo_rd_ck <= clk2p5;
	end if;
	
end process;

dcfeb6_gbrx_test : process(tfifo_mode, dcfeb6_gbrx_data, dcfeb6_gbrx_data_valid, dcfeb6_gbrx_data_clk,
									vme_data_in, tfifo_wr_en, tfifo_rd_en, clk2p5)
begin
	if (tfifo_mode = '1') then
--		dcfeb6_tfifo_in <= dcfeb6_gbrx_data;
--		dcfeb6_fifo_wr_en <= dcfeb6_gbrx_data_valid;
--		dcfeb6_fifo_wr_ck <= dcfeb6_gbrx_data_clk;
--		dcfeb6_fifo_rd_en <= tfifo_rd_en(6);
--		dcfeb6_fifo_rd_ck <= clk2p5;
		dcfeb6_tfifo_in <= vme_data_in;
		dcfeb6_fifo_wr_en <= tfifo_wr_en(6);
		dcfeb6_fifo_wr_ck <= clk2p5;
		dcfeb6_fifo_rd_en <= tfifo_rd_en(6);
		dcfeb6_fifo_rd_ck <= clk2p5;
	else
		dcfeb6_tfifo_in <= vme_data_in;
		dcfeb6_fifo_wr_en <= tfifo_wr_en(6);
		dcfeb6_fifo_wr_ck <= clk2p5;
		dcfeb6_fifo_rd_en <= tfifo_rd_en(6);
		dcfeb6_fifo_rd_ck <= clk2p5;
	end if;
	
end process;

dcfeb7_gbrx_test : process(tfifo_mode, dcfeb7_gbrx_data, dcfeb7_gbrx_data_valid, dcfeb7_gbrx_data_clk,
									vme_data_in, tfifo_wr_en, tfifo_rd_en, clk2p5)
begin
	if (tfifo_mode = '1') then
--		dcfeb7_tfifo_in <= dcfeb7_gbrx_data;
--		dcfeb7_fifo_wr_en <= dcfeb7_gbrx_data_valid;
--		dcfeb7_fifo_wr_ck <= dcfeb7_gbrx_data_clk;
--		dcfeb7_fifo_rd_en <= tfifo_rd_en(7);
--		dcfeb7_fifo_rd_ck <= clk2p5;
		dcfeb7_tfifo_in <= vme_data_in;
		dcfeb7_fifo_wr_en <= tfifo_wr_en(7);
		dcfeb7_fifo_wr_ck <= clk2p5;
		dcfeb7_fifo_rd_en <= tfifo_rd_en(7);
		dcfeb7_fifo_rd_ck <= clk2p5;
	else
		dcfeb7_tfifo_in <= vme_data_in;
		dcfeb7_fifo_wr_en <= tfifo_wr_en(7);
		dcfeb7_fifo_wr_ck <= clk2p5;
		dcfeb7_fifo_rd_en <= tfifo_rd_en(7);
		dcfeb7_fifo_rd_ck <= clk2p5;
	end if;
	
end process;


-- DCFEB0

-- b2v_dcfeb0_gbrx : dmb_receiver
--   port map (
--   RST => reset,
----	// External signals
--	DAQ_SIGDET => orx2_01_sd,
--	DAQ_RX_N => orx2_01_n,
--	DAQ_RX_P => orx2_01_p,
--	DAQ_TDIS => open,
--	DAQ_TX_N => open,
--	DAQ_TX_P => open,
----	// Internal signals
--	DAQ_RX_125REFCLK => '0',
--	DAQ_RX_160REFCLK => cdc_clk(4),
--	DAQ_RX_WDATA => dcfeb0_gbrx_data(15 downto 0),
--	DAQ_RXD_VLD => dcfeb0_gbrx_data_valid,
--	DAQ_SD => open,
--	DAQ_DATA_CLK => dcfeb0_gbrx_data_clk
--  );

dcfeb0_gbrx_data(15 downto 0) <= (OTHERS => '0');
dcfeb0_gbrx_data_valid <= '0';
dcfeb0_gbrx_data_clk <= '0';

FIFO_DUALCLOCK_MACRO_dcfeb0 : FIFO_DUALCLOCK_MACRO
   generic map (
      DEVICE => "VIRTEX6",            		-- Target Device: "VIRTEX5", "VIRTEX6" 
      ALMOST_FULL_OFFSET => X"0080",  		-- Sets almost full threshold
      ALMOST_EMPTY_OFFSET => X"0080", 		-- Sets the almost empty threshold
      DATA_WIDTH => 16,   						-- Valid values are 1-72 (37-72 only valid when FIFO_SIZE="36Kb")
      FIFO_SIZE => "18Kb",            		-- Target BRAM, "18Kb" or "36Kb" 
      FIRST_WORD_FALL_THROUGH => FALSE) 	-- Sets the FIFO FWFT to TRUE or FALSE

   port map (
      ALMOSTEMPTY => a_empty(0),   			-- Output almost empty 
      ALMOSTFULL => a_full(0),     			-- Output almost full
      DO => dcfeb0_tfifo_out,        		-- Output data
      EMPTY => empty(0),               	-- Output empty
      FULL => full(0),                 	-- Output full
      RDCOUNT => dcfeb0_fifo_rd_cnt,      -- Output read count
      RDERR => open,               			-- Output read error
      WRCOUNT => dcfeb0_fifo_wr_cnt,      -- Output write count
      WRERR => open,               			-- Output write error
      DI => dcfeb0_tfifo_in,              -- Input data
      RDCLK => dcfeb0_fifo_rd_ck,         -- Input read clock
      RDEN => dcfeb0_fifo_rd_en,          -- Input read enable
      RST => reset,                   		-- Input reset
      WRCLK => dcfeb0_fifo_wr_ck,         -- Input write clock
      WREN => dcfeb0_fifo_wr_en           -- Input write enable
   );

dl_resync(1) <= dl_global_rst;

dcfeb0_fifo_in_proc : process(fifo_rm_en,dcfeb0_data_valid,fifo_tm_en,fifo_tm_wr_en,fifo_rw_en,dcfeb0_data,fifo_out,fifo_in)
begin
	if (fifo_rm_en(1) = '1') then
		dcfeb0_fifo_in <= "00" & dcfeb0_data;
	elsif (fifo_rw_en(1) = '1') then
		dcfeb0_fifo_in <= fifo_out;
	else
		dcfeb0_fifo_in <= fifo_in;
	end if;

end process;

b2v_dcfeb0_fifo : FIFO_SYNC_MACRO
   generic map (
      DEVICE => "VIRTEX6",            -- Target Device: "VIRTEX5, "VIRTEX6" 
      ALMOST_FULL_OFFSET => X"0080",  -- Sets almost full threshold
      ALMOST_EMPTY_OFFSET => X"0080", -- Sets the almost empty threshold
      DATA_WIDTH => 18,   -- Valid values are 1-72 (37-72 only valid when FIFO_SIZE="36Kb")
      FIFO_SIZE => "18Kb")            -- Target BRAM, "18Kb" or "36Kb" 
   port map (
      ALMOSTEMPTY => fifo_pae(1),   -- Output almost empty 
      ALMOSTFULL => fifo_half(1),     -- Output almost full
      DO => dcfeb0_fifo_out,                     -- Output data
      EMPTY => fifo_empty(1),               -- Output empty
      FULL => fifo_full(1),                 -- Output full
      RDCOUNT => dcfeb0_rd_cnt,           -- Output read count
      RDERR => dcfeb0_rd_err,               -- Output read error
      WRCOUNT => dcfeb0_wr_cnt,           -- Output write count
      WRERR => dcfeb0_wr_err,               -- Output write error
      CLK => fifo_wr_ck,                   -- Input clock
      DI => dcfeb0_fifo_in,                     -- Input data
      RDEN => fifo_rd_en(1),                 -- Input read enable
      RST => reset,                   -- Input reset
      WREN => fifo_wr_en(1)                  -- Input write enable
   );

DCFEB0_V6_PM : DCFEB_V6
	GENERIC MAP(
	  dcfeb_addr => "1000")
	PORT MAP(
	  clk => clk40,
	  rst => reset, 
	  l1a => ccb_l1acc,
	  l1a_match => ccb_l1acc,
	  dcfeb_dv => dcfeb0_data_valid,
    dcfeb_data => dcfeb0_data,
		adc_mask => dcfeb0_adc_mask,
		dcfeb_fsel => dcfeb0_fsel,
		dcfeb_jtag_ir => dcfeb0_jtag_ir,
		trst => reset,
		tck => dl_jtag_tck(1), 	
		tms => dl_jtag_tms,
		tdi => dl_jtag_tdi,
		rtn_shft_en => dl_rtn_shft_en(1),
		tdo => dl_jtag_tdo(1));

-- DCFEB1


--b2v_dcfeb1_gbrx : dmb_receiver
--   port map (
--   RST => reset,
----	// External signals
--	DAQ_SIGDET => orx2_02_sd,
--	DAQ_RX_N => orx2_02_n,
--	DAQ_RX_P => orx2_02_p,
--	DAQ_TDIS => open,
--	DAQ_TX_N => open,
--	DAQ_TX_P => open,
----	// Internal signals
--	DAQ_RX_125REFCLK => cdc_clk(3),
--	DAQ_RX_160REFCLK => cdc_clk(3),
--	DAQ_RX_WDATA => dcfeb1_gbrx_data(15 downto 0),
--	DAQ_RXD_VLD => dcfeb1_gbrx_data_valid,
--	DAQ_SD => open,
--	DAQ_DATA_CLK => dcfeb1_gbrx_data_clk
--  );

dcfeb1_gbrx_data(15 downto 0) <= (OTHERS => '0');
dcfeb1_gbrx_data_valid <= '0';
dcfeb1_gbrx_data_clk <= '0';

FIFO_DUALCLOCK_MACRO_dcfeb1 : FIFO_DUALCLOCK_MACRO
   generic map (
      DEVICE => "VIRTEX6",            		-- Target Device: "VIRTEX5", "VIRTEX6" 
      ALMOST_FULL_OFFSET => X"0080",  		-- Sets almost full threshold
      ALMOST_EMPTY_OFFSET => X"0080", 		-- Sets the almost empty threshold
      DATA_WIDTH => 16,   						-- Valid values are 1-72 (37-72 only valid when FIFO_SIZE="36Kb")
      FIFO_SIZE => "18Kb",            		-- Target BRAM, "18Kb" or "36Kb" 
      FIRST_WORD_FALL_THROUGH => FALSE) 	-- Sets the FIFO FWFT to TRUE or FALSE
	port map (
      ALMOSTEMPTY => a_empty(1),   			-- Output almost empty 
      ALMOSTFULL => a_full(1),     			-- Output almost full
      DO => dcfeb1_tfifo_out,        		-- Output data
      EMPTY => empty(1),               	-- Output empty
      FULL => full(1),                 	-- Output full
      RDCOUNT => dcfeb1_fifo_rd_cnt,      -- Output read count
      RDERR => open,               			-- Output read error
      WRCOUNT => dcfeb1_fifo_wr_cnt,      -- Output write count
      WRERR => open,               			-- Output write error
      DI => dcfeb1_tfifo_in,              -- Input data
      RDCLK => dcfeb1_fifo_rd_ck,         -- Input read clock
      RDEN => dcfeb1_fifo_rd_en,          -- Input read enable
      RST => reset,                   		-- Input reset
      WRCLK => dcfeb1_fifo_wr_ck,         -- Input write clock
      WREN => dcfeb1_fifo_wr_en           -- Input write enable
   );

dl_resync(2) <= dl_global_rst;

dcfeb1_fifo_in_proc : process(fifo_rm_en,dcfeb1_data_valid,fifo_tm_en,fifo_tm_wr_en,fifo_rw_en,dcfeb1_data,fifo_out,fifo_in)

begin
	if (fifo_rm_en(2) = '1') then
		dcfeb1_fifo_in <= "00" & dcfeb1_data;
	elsif (fifo_rw_en(2) = '1') then
		dcfeb1_fifo_in <= fifo_out;
	else
		dcfeb1_fifo_in <= fifo_in;
	end if;

end process;

b2v_dcfeb1_fifo : FIFO_SYNC_MACRO
   generic map (
      DEVICE => "VIRTEX6",            -- Target Device: "VIRTEX5, "VIRTEX6" 
      ALMOST_FULL_OFFSET => X"0080",  -- Sets almost full threshold
      ALMOST_EMPTY_OFFSET => X"0080", -- Sets the almost empty threshold
      DATA_WIDTH => 18,   -- Valid values are 1-72 (37-72 only valid when FIFO_SIZE="36Kb")
      FIFO_SIZE => "18Kb")            -- Target BRAM, "18Kb" or "36Kb" 
   port map (
      ALMOSTEMPTY => fifo_pae(2),   -- Output almost empty 
      ALMOSTFULL => fifo_half(2),     -- Output almost full
      DO => dcfeb1_fifo_out,                     -- Output data
      EMPTY => fifo_empty(2),               -- Output empty
      FULL => fifo_full(2),                 -- Output full
      RDCOUNT => dcfeb1_rd_cnt,           -- Output read count
      RDERR => dcfeb1_rd_err,               -- Output read error
      WRCOUNT => dcfeb1_wr_cnt,           -- Output write count
      WRERR => dcfeb1_wr_err,               -- Output write error
      CLK => fifo_wr_ck,                   -- Input clock
      DI => dcfeb1_fifo_in,                     -- Input data
      RDEN => fifo_rd_en(2),                 -- Input read enable
      RST => reset,                   -- Input reset
      WREN => fifo_wr_en(2)                  -- Input write enable
   );

DCFEB1_V6_PM : DCFEB_V6
	GENERIC MAP(
	  dcfeb_addr => "1001")
	PORT MAP(
	  clk => clk40,
	  rst => reset, 
	  l1a => ccb_l1acc,
	  l1a_match => ccb_l1acc,
	  dcfeb_dv => dcfeb1_data_valid,
    dcfeb_data => dcfeb1_data,
		adc_mask => dcfeb1_adc_mask,
		dcfeb_fsel => dcfeb1_fsel,
		dcfeb_jtag_ir => dcfeb1_jtag_ir,
		trst => reset,
		tck => dl_jtag_tck(2), 	
		tms => dl_jtag_tms,
		tdi => dl_jtag_tdi,
		rtn_shft_en => dl_rtn_shft_en(2),
		tdo => dl_jtag_tdo(2));

-- DCFEB2

-- b2v_dcfeb2_gbrx : dmb_receiver
--    port map (
--    RST => reset,
-- --	// External signals
-- 	DAQ_SIGDET => orx2_03_sd,
-- 	DAQ_RX_N => orx2_03_n,
-- 	DAQ_RX_P => orx2_03_p,
-- 	DAQ_TDIS => open,
-- 	DAQ_TX_N => open,
-- 	DAQ_TX_P => open,
-- --	// Internal signals
-- 	DAQ_RX_125REFCLK => cdc_clk(2),
-- 	DAQ_RX_160REFCLK => cdc_clk(2),
-- 	DAQ_RX_WDATA => dcfeb2_gbrx_data(15 downto 0),
-- 	DAQ_RXD_VLD => dcfeb2_gbrx_data_valid,
-- 	DAQ_SD => open,
-- 	DAQ_DATA_CLK => dcfeb2_gbrx_data_clk
--   );

dcfeb2_gbrx_data(15 downto 0) <= (OTHERS => '0');
dcfeb2_gbrx_data_valid <= '0';
dcfeb2_gbrx_data_clk <= '0';

FIFO_DUALCLOCK_MACRO_dcfeb2 : FIFO_DUALCLOCK_MACRO
   generic map (
      DEVICE => "VIRTEX6",            		-- Target Device: "VIRTEX5", "VIRTEX6" 
      ALMOST_FULL_OFFSET => X"0080",  		-- Sets almost full threshold
      ALMOST_EMPTY_OFFSET => X"0080", 		-- Sets the almost empty threshold
      DATA_WIDTH => 16,   						-- Valid values are 1-72 (37-72 only valid when FIFO_SIZE="36Kb")
      FIFO_SIZE => "18Kb",            		-- Target BRAM, "18Kb" or "36Kb" 
      FIRST_WORD_FALL_THROUGH => FALSE) 	-- Sets the FIFO FWFT to TRUE or FALSE
   port map (
      ALMOSTEMPTY => a_empty(2),   			-- Output almost empty 
      ALMOSTFULL => a_full(2),     			-- Output almost full
      DO => dcfeb2_tfifo_out,        		-- Output data
      EMPTY => empty(2),               	-- Output empty
      FULL => full(2),                 	-- Output full
      RDCOUNT => dcfeb2_fifo_rd_cnt,      -- Output read count
      RDERR => open,               			-- Output read error
      WRCOUNT => dcfeb2_fifo_wr_cnt,      -- Output write count
      WRERR => open,               			-- Output write error
      DI => dcfeb2_tfifo_in,              -- Input data
      RDCLK => dcfeb2_fifo_rd_ck,         -- Input read clock
      RDEN => dcfeb2_fifo_rd_en,          -- Input read enable
      RST => reset,                   		-- Input reset
      WRCLK => dcfeb2_fifo_wr_ck,         -- Input write clock
      WREN => dcfeb2_fifo_wr_en           -- Input write enable
   );

dl_resync(3) <= dl_global_rst;

dcfeb2_fifo_in_proc : process(fifo_rm_en,dcfeb2_data_valid,fifo_tm_en,fifo_tm_wr_en,fifo_rw_en,dcfeb2_data,fifo_out,fifo_in)

begin
	if (fifo_rm_en(3) = '1') then
		dcfeb2_fifo_in <= "00" & dcfeb2_data;
	elsif (fifo_rw_en(3) = '1') then
		dcfeb2_fifo_in <= fifo_out;
	else
		dcfeb2_fifo_in <= fifo_in;
	end if;

end process;

b2v_dcfeb2_fifo : FIFO_SYNC_MACRO
   generic map (
      DEVICE => "VIRTEX6",            -- Target Device: "VIRTEX5, "VIRTEX6" 
      ALMOST_FULL_OFFSET => X"0080",  -- Sets almost full threshold
      ALMOST_EMPTY_OFFSET => X"0080", -- Sets the almost empty threshold
      DATA_WIDTH => 18,   -- Valid values are 1-72 (37-72 only valid when FIFO_SIZE="36Kb")
      FIFO_SIZE => "18Kb")            -- Target BRAM, "18Kb" or "36Kb" 
   port map (
      ALMOSTEMPTY => fifo_pae(3),   -- Output almost empty 
      ALMOSTFULL => fifo_half(3),     -- Output almost full
      DO => dcfeb2_fifo_out,                     -- Output data
      EMPTY => fifo_empty(3),               -- Output empty
      FULL => fifo_full(3),                 -- Output full
      RDCOUNT => dcfeb2_rd_cnt,           -- Output read count
      RDERR => dcfeb2_rd_err,               -- Output read error
      WRCOUNT => dcfeb2_wr_cnt,           -- Output write count
      WRERR => dcfeb2_wr_err,               -- Output write error
      CLK => fifo_wr_ck,                   -- Input clock
      DI => dcfeb2_fifo_in,                     -- Input data
      RDEN => fifo_rd_en(3),                 -- Input read enable
      RST => reset,                   -- Input reset
      WREN => fifo_wr_en(3)                  -- Input write enable
   );

DCFEB2_V6_PM : DCFEB_V6
	GENERIC MAP(
	  dcfeb_addr => "1010")
	PORT MAP(
	  clk => clk40,
	  rst => reset, 
	  l1a => ccb_l1acc,
	  l1a_match => ccb_l1acc,
	  dcfeb_dv => dcfeb2_data_valid,
    dcfeb_data => dcfeb2_data,
		adc_mask => dcfeb2_adc_mask,
		dcfeb_fsel => dcfeb2_fsel,
		dcfeb_jtag_ir => dcfeb2_jtag_ir,
		trst => reset,
		tck => dl_jtag_tck(3), 	
		tms => dl_jtag_tms,
		tdi => dl_jtag_tdi,
		rtn_shft_en => dl_rtn_shft_en(3),
		tdo => dl_jtag_tdo(3));

-- DCFEB3

--	b2v_dcfeb3_gbrx : dmb_receiver
--	   port map (
--	   RST => reset,
--	--	// External signals
--		DAQ_SIGDET => orx2_04_sd,
--		DAQ_RX_N => orx2_04_n,
--		DAQ_RX_P => orx2_04_p,
--		DAQ_TDIS => open,
--		DAQ_TX_N => open,
--		DAQ_TX_P => open,
--	--	// Internal signals
--		DAQ_RX_125REFCLK => cdc_clk(3),
--		DAQ_RX_160REFCLK => cdc_clk(3),
--		DAQ_RX_WDATA => dcfeb3_gbrx_data(15 downto 0),
--		DAQ_RXD_VLD => dcfeb3_gbrx_data_valid,
--		DAQ_SD => open,
--		DAQ_DATA_CLK => dcfeb3_gbrx_data_clk
--	  );

dcfeb3_gbrx_data(15 downto 0) <= (OTHERS => '0');
dcfeb3_gbrx_data_valid <= '0';
dcfeb3_gbrx_data_clk <= '0';

FIFO_DUALCLOCK_MACRO_dcfeb3 : FIFO_DUALCLOCK_MACRO
   generic map (
      DEVICE => "VIRTEX6",            		-- Target Device: "VIRTEX5", "VIRTEX6" 
      ALMOST_FULL_OFFSET => X"0080",  		-- Sets almost full threshold
      ALMOST_EMPTY_OFFSET => X"0080", 		-- Sets the almost empty threshold
      DATA_WIDTH => 16,   						-- Valid values are 1-72 (37-72 only valid when FIFO_SIZE="36Kb")
      FIFO_SIZE => "18Kb",            		-- Target BRAM, "18Kb" or "36Kb" 
      FIRST_WORD_FALL_THROUGH => FALSE) 	-- Sets the FIFO FWFT to TRUE or FALSE
   port map (
      ALMOSTEMPTY => a_empty(3),   			-- Output almost empty 
      ALMOSTFULL => a_full(3),     			-- Output almost full
      DO => dcfeb3_tfifo_out,        		-- Output data
      EMPTY => empty(3),               	-- Output empty
      FULL => full(3),                 	-- Output full
      RDCOUNT => dcfeb3_fifo_rd_cnt,      -- Output read count
      RDERR => open,               			-- Output read error
      WRCOUNT => dcfeb3_fifo_wr_cnt,      -- Output write count
      WRERR => open,               			-- Output write error
      DI => dcfeb3_tfifo_in,              -- Input data
      RDCLK => dcfeb3_fifo_rd_ck,         -- Input read clock
      RDEN => dcfeb3_fifo_rd_en,          -- Input read enable
      RST => reset,                   		-- Input reset
      WRCLK => dcfeb3_fifo_wr_ck,         -- Input write clock
      WREN => dcfeb3_fifo_wr_en           -- Input write enable
   );

dl_resync(4) <= dl_global_rst;

dcfeb3_fifo_in_proc : process(fifo_rm_en,dcfeb3_data_valid,fifo_tm_en,fifo_tm_wr_en,fifo_rw_en,dcfeb3_data,fifo_out,fifo_in)

begin
	if (fifo_rm_en(4) = '1') then
		dcfeb3_fifo_in <= "00" & dcfeb3_data;
	elsif (fifo_rw_en(4) = '1') then
		dcfeb3_fifo_in <= fifo_out;
	else
		dcfeb3_fifo_in <= fifo_in;
	end if;

end process;

b2v_dcfeb3_fifo : FIFO_SYNC_MACRO
   generic map (
      DEVICE => "VIRTEX6",            -- Target Device: "VIRTEX5, "VIRTEX6" 
      ALMOST_FULL_OFFSET => X"0080",  -- Sets almost full threshold
      ALMOST_EMPTY_OFFSET => X"0080", -- Sets the almost empty threshold
      DATA_WIDTH => 18,   -- Valid values are 1-72 (37-72 only valid when FIFO_SIZE="36Kb")
      FIFO_SIZE => "18Kb")            -- Target BRAM, "18Kb" or "36Kb" 
   port map (
      ALMOSTEMPTY => fifo_pae(4),   -- Output almost empty 
      ALMOSTFULL => fifo_half(4),     -- Output almost full
      DO => dcfeb3_fifo_out,                     -- Output data
      EMPTY => fifo_empty(4),               -- Output empty
      FULL => fifo_full(4),                 -- Output full
      RDCOUNT => dcfeb3_rd_cnt,           -- Output read count
      RDERR => dcfeb3_rd_err,               -- Output read error
      WRCOUNT => dcfeb3_wr_cnt,           -- Output write count
      WRERR => dcfeb3_wr_err,               -- Output write error
      CLK => fifo_wr_ck,                   -- Input clock
      DI => dcfeb3_fifo_in,                     -- Input data
      RDEN => fifo_rd_en(4),                 -- Input read enable
      RST => reset,                   -- Input reset
      WREN => fifo_wr_en(4)                  -- Input write enable
   );

DCFEB3_V6_PM : DCFEB_V6
	GENERIC MAP(
	  dcfeb_addr => "1011")
	PORT MAP(
	  clk => clk40,
	  rst => reset, 
	  l1a => ccb_l1acc,
	  l1a_match => ccb_l1acc,
	  dcfeb_dv => dcfeb3_data_valid,
    dcfeb_data => dcfeb3_data,
		adc_mask => dcfeb3_adc_mask,
		dcfeb_fsel => dcfeb3_fsel,
		dcfeb_jtag_ir => dcfeb3_jtag_ir,
		trst => reset,
		tck => dl_jtag_tck(4), 	
		tms => dl_jtag_tms,
		tdi => dl_jtag_tdi,
		rtn_shft_en => dl_rtn_shft_en(4),
		tdo => dl_jtag_tdo(4));

-- DCFEB4

FIFO_DUALCLOCK_MACRO_dcfeb4 : FIFO_DUALCLOCK_MACRO
   generic map (
      DEVICE => "VIRTEX6",            		-- Target Device: "VIRTEX5", "VIRTEX6" 
      ALMOST_FULL_OFFSET => X"0080",  		-- Sets almost full threshold
      ALMOST_EMPTY_OFFSET => X"0080", 		-- Sets the almost empty threshold
      DATA_WIDTH => 16,   						-- Valid values are 1-72 (37-72 only valid when FIFO_SIZE="36Kb")
      FIFO_SIZE => "18Kb",            		-- Target BRAM, "18Kb" or "36Kb" 
      FIRST_WORD_FALL_THROUGH => FALSE) 	-- Sets the FIFO FWFT to TRUE or FALSE
   port map (
      ALMOSTEMPTY => a_empty(4),   			-- Output almost empty 
      ALMOSTFULL => a_full(4),     			-- Output almost full
      DO => dcfeb4_tfifo_out,        		-- Output data
      EMPTY => empty(4),               	-- Output empty
      FULL => full(4),                 	-- Output full
      RDCOUNT => dcfeb4_fifo_rd_cnt,      -- Output read count
      RDERR => open,               			-- Output read error
      WRCOUNT => dcfeb4_fifo_wr_cnt,      -- Output write count
      WRERR => open,               			-- Output write error
      DI => dcfeb4_tfifo_in,              -- Input data
      RDCLK => dcfeb4_fifo_rd_ck,         -- Input read clock
      RDEN => dcfeb4_fifo_rd_en,          -- Input read enable
      RST => reset,                   		-- Input reset
      WRCLK => dcfeb4_fifo_wr_ck,         -- Input write clock
      WREN => dcfeb4_fifo_wr_en           -- Input write enable
   );

dl_resync(5) <= dl_global_rst;

dcfeb4_fifo_in_proc : process(fifo_rm_en,dcfeb4_data_valid,fifo_tm_en,fifo_tm_wr_en,fifo_rw_en,dcfeb4_data,fifo_out,fifo_in)

begin
	if (fifo_rm_en(5) = '1') then
		dcfeb4_fifo_in <= "00" & dcfeb4_data;
	elsif (fifo_rw_en(5) = '1') then
		dcfeb4_fifo_in <= fifo_out;
	else
		dcfeb4_fifo_in <= fifo_in;
	end if;

end process;

b2v_dcfeb4_fifo : FIFO_SYNC_MACRO
   generic map (
      DEVICE => "VIRTEX6",            -- Target Device: "VIRTEX5, "VIRTEX6" 
      ALMOST_FULL_OFFSET => X"0080",  -- Sets almost full threshold
      ALMOST_EMPTY_OFFSET => X"0080", -- Sets the almost empty threshold
      DATA_WIDTH => 18,   -- Valid values are 1-72 (37-72 only valid when FIFO_SIZE="36Kb")
      FIFO_SIZE => "18Kb")            -- Target BRAM, "18Kb" or "36Kb" 
   port map (
      ALMOSTEMPTY => fifo_pae(5),   -- Output almost empty 
      ALMOSTFULL => fifo_half(5),     -- Output almost full
      DO => dcfeb4_fifo_out,                     -- Output data
      EMPTY => fifo_empty(5),               -- Output empty
      FULL => fifo_full(5),                 -- Output full
      RDCOUNT => dcfeb4_rd_cnt,           -- Output read count
      RDERR => dcfeb4_rd_err,               -- Output read error
      WRCOUNT => dcfeb4_wr_cnt,           -- Output write count
      WRERR => dcfeb4_wr_err,               -- Output write error
      CLK => fifo_wr_ck,                   -- Input clock
      DI => dcfeb4_fifo_in,                     -- Input data
      RDEN => fifo_rd_en(5),                 -- Input read enable
      RST => reset,                   -- Input reset
      WREN => fifo_wr_en(5)                  -- Input write enable
   );

DCFEB4_V6_PM : DCFEB_V6
	GENERIC MAP(
	  dcfeb_addr => "1100")
	PORT MAP(
	  clk => clk40,
	  rst => reset, 
	  l1a => ccb_l1acc,
	  l1a_match => ccb_l1acc,
	  dcfeb_dv => dcfeb4_data_valid,
    dcfeb_data => dcfeb4_data,
		adc_mask => dcfeb4_adc_mask,
		dcfeb_fsel => dcfeb4_fsel,
		dcfeb_jtag_ir => dcfeb4_jtag_ir,
		trst => reset,
		tck => dl_jtag_tck(5), 	
		tms => dl_jtag_tms,
		tdi => dl_jtag_tdi,
		rtn_shft_en => dl_rtn_shft_en(5),
		tdo => dl_jtag_tdo(5));

-- DCFEB5

FIFO_DUALCLOCK_MACRO_dcfeb5 : FIFO_DUALCLOCK_MACRO
   generic map (
      DEVICE => "VIRTEX6",            		-- Target Device: "VIRTEX5", "VIRTEX6" 
      ALMOST_FULL_OFFSET => X"0080",  		-- Sets almost full threshold
      ALMOST_EMPTY_OFFSET => X"0080", 		-- Sets the almost empty threshold
      DATA_WIDTH => 16,   						-- Valid values are 1-72 (37-72 only valid when FIFO_SIZE="36Kb")
      FIFO_SIZE => "18Kb",            		-- Target BRAM, "18Kb" or "36Kb" 
      FIRST_WORD_FALL_THROUGH => FALSE) 	-- Sets the FIFO FWFT to TRUE or FALSE
   port map (
      ALMOSTEMPTY => a_empty(5),   			-- Output almost empty 
      ALMOSTFULL => a_full(5),     			-- Output almost full
      DO => dcfeb5_tfifo_out,        		-- Output data
      EMPTY => empty(5),               	-- Output empty
      FULL => full(5),                 	-- Output full
      RDCOUNT => dcfeb5_fifo_rd_cnt,      -- Output read count
      RDERR => open,               			-- Output read error
      WRCOUNT => dcfeb5_fifo_wr_cnt,      -- Output write count
      WRERR => open,               			-- Output write error
      DI => dcfeb5_tfifo_in,              -- Input data
      RDCLK => dcfeb5_fifo_rd_ck,         -- Input read clock
      RDEN => dcfeb5_fifo_rd_en,          -- Input read enable
      RST => reset,                   		-- Input reset
      WRCLK => dcfeb5_fifo_wr_ck,         -- Input write clock
      WREN => dcfeb5_fifo_wr_en           -- Input write enable
   );

dl_resync(6) <= dl_global_rst;

dcfeb5_fifo_in_proc : process(fifo_rm_en,dcfeb5_data_valid,fifo_tm_en,fifo_tm_wr_en,fifo_rw_en,dcfeb5_data,fifo_out,fifo_in)

begin
	if (fifo_rm_en(6) = '1') then
		dcfeb5_fifo_in <= "00" & dcfeb5_data;
	elsif (fifo_rw_en(6) = '1') then
		dcfeb5_fifo_in <= fifo_out;
	else
		dcfeb5_fifo_in <= fifo_in;
	end if;

end process;

b2v_dcfeb5_fifo : FIFO_SYNC_MACRO
   generic map (
      DEVICE => "VIRTEX6",            -- Target Device: "VIRTEX5, "VIRTEX6" 
      ALMOST_FULL_OFFSET => X"0080",  -- Sets almost full threshold
      ALMOST_EMPTY_OFFSET => X"0080", -- Sets the almost empty threshold
      DATA_WIDTH => 18,   -- Valid values are 1-72 (37-72 only valid when FIFO_SIZE="36Kb")
      FIFO_SIZE => "18Kb")            -- Target BRAM, "18Kb" or "36Kb" 
   port map (
      ALMOSTEMPTY => fifo_pae(6),   -- Output almost empty 
      ALMOSTFULL => fifo_half(6),     -- Output almost full
      DO => dcfeb5_fifo_out,                     -- Output data
      EMPTY => fifo_empty(6),               -- Output empty
      FULL => fifo_full(6),                 -- Output full
      RDCOUNT => dcfeb5_rd_cnt,           -- Output read count
      RDERR => dcfeb5_rd_err,               -- Output read error
      WRCOUNT => dcfeb5_wr_cnt,           -- Output write count
      WRERR => dcfeb5_wr_err,               -- Output write error
      CLK => fifo_wr_ck,                   -- Input clock
      DI => dcfeb5_fifo_in,                     -- Input data
      RDEN => fifo_rd_en(6),                 -- Input read enable
      RST => reset,                   -- Input reset
      WREN => fifo_wr_en(6)                  -- Input write enable
   );

DCFEB5_V6_PM : DCFEB_V6
	GENERIC MAP(
	  dcfeb_addr => "1101")
	PORT MAP(
	  clk => clk40,
	  rst => reset, 
	  l1a => ccb_l1acc,
	  l1a_match => ccb_l1acc,
	  dcfeb_dv => dcfeb5_data_valid,
    dcfeb_data => dcfeb5_data,
		adc_mask => dcfeb5_adc_mask,
		dcfeb_fsel => dcfeb5_fsel,
		dcfeb_jtag_ir => dcfeb5_jtag_ir,
		trst => reset,
		tck => dl_jtag_tck(6), 	
		tms => dl_jtag_tms,
		tdi => dl_jtag_tdi,
		rtn_shft_en => dl_rtn_shft_en(6),
		tdo => dl_jtag_tdo(6));

-- DCFEB6

 FIFO_DUALCLOCK_MACRO_dcfeb6 : FIFO_DUALCLOCK_MACRO
   generic map (
      DEVICE => "VIRTEX6",            		-- Target Device: "VIRTEX5", "VIRTEX6" 
      ALMOST_FULL_OFFSET => X"0080",  		-- Sets almost full threshold
      ALMOST_EMPTY_OFFSET => X"0080", 		-- Sets the almost empty threshold
      DATA_WIDTH => 16,   						-- Valid values are 1-72 (37-72 only valid when FIFO_SIZE="36Kb")
      FIFO_SIZE => "18Kb",            		-- Target BRAM, "18Kb" or "36Kb" 
      FIRST_WORD_FALL_THROUGH => FALSE) 	-- Sets the FIFO FWFT to TRUE or FALSE
   port map (
      ALMOSTEMPTY => a_empty(6),   			-- Output almost empty 
      ALMOSTFULL => a_full(6),     			-- Output almost full
      DO => dcfeb6_tfifo_out,        		-- Output data
      EMPTY => empty(6),               	-- Output empty
      FULL => full(6),                 	-- Output full
      RDCOUNT => dcfeb6_fifo_rd_cnt,      -- Output read count
      RDERR => open,               			-- Output read error
      WRCOUNT => dcfeb6_fifo_wr_cnt,      -- Output write count
      WRERR => open,               			-- Output write error
      DI => dcfeb6_tfifo_in,              -- Input data
      RDCLK => dcfeb6_fifo_rd_ck,         -- Input read clock
      RDEN => dcfeb6_fifo_rd_en,          -- Input read enable
      RST => reset,                   		-- Input reset
      WRCLK => dcfeb6_fifo_wr_ck,         -- Input write clock
      WREN => dcfeb6_fifo_wr_en           -- Input write enable
   );

dl_resync(7) <= dl_global_rst;

dcfeb6_fifo_in_proc : process(fifo_rm_en,dcfeb6_data_valid,fifo_tm_en,fifo_tm_wr_en,fifo_rw_en,dcfeb6_data,fifo_out,fifo_in)

begin
--	fifo_wr_en(7) <= (dcfeb6_data_valid and fifo_rm_en(7)) or (fifo_tm_wr_en(7) and fifo_tm_en(7));
	if (fifo_rm_en(7) = '1') then
		dcfeb6_fifo_in <= "00" & dcfeb6_data;
	elsif (fifo_rw_en(7) = '1') then
		dcfeb6_fifo_in <= fifo_out;
	else
		dcfeb6_fifo_in <= fifo_in;
	end if;

end process;

--b2v_dcfeb6_fifo : fifo_generator_v6_2
--PORT MAP(
--	rst => reset,
--	wr_clk => fifo_wr_ck,
--	rd_clk => fifo_rd_ck,
--	din => dcfeb6_fifo_in,
--	wr_en => fifo_wr_en(7),
--	rd_en => fifo_rd_en(7),
--	dout => dcfeb6_fifo_out,
--	full => fifo_full(7),
--	empty => fifo_empty(7),
--	prog_full => fifo_half(7),
--	prog_empty => fifo_pae(7));

b2v_dcfeb6_fifo : FIFO_SYNC_MACRO
   generic map (
      DEVICE => "VIRTEX6",            -- Target Device: "VIRTEX5, "VIRTEX6" 
      ALMOST_FULL_OFFSET => X"0080",  -- Sets almost full threshold
      ALMOST_EMPTY_OFFSET => X"0080", -- Sets the almost empty threshold
      DATA_WIDTH => 18,   -- Valid values are 1-72 (37-72 only valid when FIFO_SIZE="36Kb")
      FIFO_SIZE => "18Kb")            -- Target BRAM, "18Kb" or "36Kb" 
   port map (
      ALMOSTEMPTY => fifo_pae(7),   -- Output almost empty 
      ALMOSTFULL => fifo_half(7),     -- Output almost full
      DO => dcfeb6_fifo_out,                     -- Output data
      EMPTY => fifo_empty(7),               -- Output empty
      FULL => fifo_full(7),                 -- Output full
      RDCOUNT => dcfeb6_rd_cnt,           -- Output read count
      RDERR => dcfeb6_rd_err,               -- Output read error
      WRCOUNT => dcfeb6_wr_cnt,           -- Output write count
      WRERR => dcfeb6_wr_err,               -- Output write error
      CLK => fifo_wr_ck,                   -- Input clock
      DI => dcfeb6_fifo_in,                     -- Input data
      RDEN => fifo_rd_en(7),                 -- Input read enable
      RST => reset,                   -- Input reset
      WREN => fifo_wr_en(7)                  -- Input write enable
   );

DCFEB6_V6_PM : DCFEB_V6
	GENERIC MAP(
	  dcfeb_addr => "1110")
	PORT MAP(
	  clk => clk40,
	  rst => reset, 
	  l1a => ccb_l1acc,
	  l1a_match => ccb_l1acc,
	  dcfeb_dv => dcfeb6_data_valid,
    dcfeb_data => dcfeb6_data,
		adc_mask => dcfeb6_adc_mask,
		dcfeb_fsel => dcfeb6_fsel,
		dcfeb_jtag_ir => dcfeb6_jtag_ir,
		trst => reset,
		tck => dl_jtag_tck(7), 	
		tms => dl_jtag_tms,
		tdi => dl_jtag_tdi,
		rtn_shft_en => dl_rtn_shft_en(7),
		tdo => dl_jtag_tdo(7));

-- DCFEB7 (dummy - for GBRX test only)

 FIFO_DUALCLOCK_MACRO_dcfeb7 : FIFO_DUALCLOCK_MACRO
   generic map (
      DEVICE => "VIRTEX6",            		-- Target Device: "VIRTEX5", "VIRTEX6" 
      ALMOST_FULL_OFFSET => X"0080",  		-- Sets almost full threshold
      ALMOST_EMPTY_OFFSET => X"0080", 		-- Sets the almost empty threshold
      DATA_WIDTH => 16,   						-- Valid values are 1-72 (37-72 only valid when FIFO_SIZE="36Kb")
      FIFO_SIZE => "18Kb",            		-- Target BRAM, "18Kb" or "36Kb" 
      FIRST_WORD_FALL_THROUGH => FALSE) 	-- Sets the FIFO FWFT to TRUE or FALSE
   port map (
      ALMOSTEMPTY => a_empty(7),   			-- Output almost empty 
      ALMOSTFULL => a_full(7),     			-- Output almost full
      DO => dcfeb7_tfifo_out,        		-- Output data
      EMPTY => empty(7),               	-- Output empty
      FULL => full(7),                 	-- Output full
      RDCOUNT => dcfeb7_fifo_rd_cnt,      -- Output read count
      RDERR => open,               			-- Output read error
      WRCOUNT => dcfeb7_fifo_wr_cnt,      -- Output write count
      WRERR => open,               			-- Output write error
      DI => dcfeb7_tfifo_in,              -- Input data
      RDCLK => dcfeb7_fifo_rd_ck,         -- Input read clock
      RDEN => dcfeb7_fifo_rd_en,          -- Input read enable
      RST => reset,                   		-- Input reset
      WRCLK => dcfeb7_fifo_wr_ck,         -- Input write clock
      WREN => dcfeb7_fifo_wr_en           -- Input write enable
   );

-- TMB0

tmb_data(16 downto 0) <= tmb(16 downto 0);
tmb_data(17) <= '0';
tmb_data_valid <= tmb(17);

tmb_fifo_in_proc : process(fifo_rm_en,tmb_data_valid,fifo_tm_en,fifo_tm_wr_en,fifo_rw_en,tmb_data,fifo_out,fifo_in)

begin
--	fifo_wr_en(8) <= (tmb_data_valid and fifo_rm_en(8)) or (fifo_tm_wr_en(8) and fifo_tm_en(8));
	if (fifo_rm_en(8) = '1') then
		tmb_fifo_in <= tmb_data;
	elsif (fifo_rw_en(8) = '1') then
		tmb_fifo_in <= fifo_out;
	else
		tmb_fifo_in <= fifo_in;
	end if;

end process;


--b2v_tmb_fifo : fifo_generator_v6_2
--PORT MAP(
--	rst => reset,
--	wr_clk => fifo_wr_ck,
--	rd_clk => fifo_rd_ck,
--	din => tmb_fifo_in,
--	wr_en => fifo_wr_en(8),
--	rd_en => fifo_rd_en(8),
--	dout => tmb_fifo_out,
--	full => fifo_full(8),
--	empty => fifo_empty(8),
--	prog_full => fifo_half(8),
--	prog_empty => fifo_pae(8));

b2v_tmb_fifo : FIFO_SYNC_MACRO
   generic map (
      DEVICE => "VIRTEX6",            -- Target Device: "VIRTEX5, "VIRTEX6" 
      ALMOST_FULL_OFFSET => X"0080",  -- Sets almost full threshold
      ALMOST_EMPTY_OFFSET => X"0080", -- Sets the almost empty threshold
      DATA_WIDTH => 18,   -- Valid values are 1-72 (37-72 only valid when FIFO_SIZE="36Kb")
      FIFO_SIZE => "18Kb")            -- Target BRAM, "18Kb" or "36Kb" 
   port map (
      ALMOSTEMPTY => fifo_pae(8),   -- Output almost empty 
      ALMOSTFULL => fifo_half(8),     -- Output almost full
      DO => tmb_fifo_out,                     -- Output data
      EMPTY => fifo_empty(8),               -- Output empty
      FULL => fifo_full(8),                 -- Output full
      RDCOUNT => tmb_rd_cnt,           -- Output read count
      RDERR => tmb_rd_err,               -- Output read error
      WRCOUNT => tmb_wr_cnt,           -- Output write count
      WRERR => tmb_wr_err,               -- Output write error
      CLK => fifo_wr_ck,                   -- Input clock
      DI => tmb_fifo_in,                     -- Input data
      RDEN => fifo_rd_en(8),                 -- Input read enable
      RST => reset,                   -- Input reset
      WREN => fifo_wr_en(8)                  -- Input write enable
   );

-- TMB1

alct_data(16 downto 0) <= alct(16 downto 0);
alct_data(17) <= '0';
alct_data_valid <= alct(17);

alct_fifo_in_proc : process(fifo_rm_en,alct_data_valid,fifo_tm_en,fifo_tm_wr_en,fifo_rw_en,alct_data,fifo_out,fifo_in)

begin
--	fifo_wr_en(9) <= (alct_data_valid and fifo_rm_en(9)) or (fifo_tm_wr_en(9) and fifo_tm_en(9));
	if (fifo_rm_en(9) = '1') then
		alct_fifo_in <= alct_data;
	elsif (fifo_rw_en(9) = '1') then
		alct_fifo_in <= fifo_out;
	else
		alct_fifo_in <= fifo_in;
	end if;

end process;


--b2v_alct_fifo : fifo_generator_v6_2
--PORT MAP(
--	rst => reset,
--	wr_clk => fifo_wr_ck,
--	rd_clk => fifo_rd_ck,
--	din => alct_fifo_in,
--	wr_en => fifo_wr_en(9),
--	rd_en => fifo_rd_en(9),
--	dout => alct_fifo_out,
--	full => fifo_full(9),
--	empty => fifo_empty(9),
--	prog_full => fifo_half(9),
--	prog_empty => fifo_pae(9));

b2v_alct_fifo : FIFO_SYNC_MACRO
   generic map (
      DEVICE => "VIRTEX6",            -- Target Device: "VIRTEX5, "VIRTEX6" 
      ALMOST_FULL_OFFSET => X"0080",  -- Sets almost full threshold
      ALMOST_EMPTY_OFFSET => X"0080", -- Sets the almost empty threshold
      DATA_WIDTH => 18,   -- Valid values are 1-72 (37-72 only valid when FIFO_SIZE="36Kb")
      FIFO_SIZE => "18Kb")            -- Target BRAM, "18Kb" or "36Kb" 
   port map (
      ALMOSTEMPTY => fifo_pae(9),   -- Output almost empty 
      ALMOSTFULL => fifo_half(9),     -- Output almost full
      DO => alct_fifo_out,                     -- Output data
      EMPTY => fifo_empty(9),               -- Output empty
      FULL => fifo_full(9),                 -- Output full
      RDCOUNT => alct_rd_cnt,           -- Output read count
      RDERR => alct_rd_err,               -- Output read error
      WRCOUNT => alct_wr_cnt,           -- Output write count
      WRERR => alct_wr_err,               -- Output write error
      CLK => fifo_wr_ck,                   -- Input clock
      DI => alct_fifo_in,                     -- Input data
      RDEN => fifo_rd_en(9),                 -- Input read enable
      RST => reset,                   -- Input reset
      WREN => fifo_wr_en(9)                  -- Input write enable
   );

-- Dummy JTAG Slave

--  PMAP_JTAG_SLAVE: jtag_slave
--  port map (
--		tck => dl_jtag_tck(1),
--		reset => reset,
--		tdi => dl_jtag_tdi,
--		tms => dl_jtag_tms,
--		tdo => dl_jtag_tdo(1),
--		dreg0 => jtag_dr0,
--		dreg1 => open,
--		dreg2 => open,
--		dreg3 => open,
--		ireg => jtag_ir
 --   );

--d_out(0) <= dl_jtag_tck(1);
--d_out(1) <= dl_jtag_tms;
--d_out(2) <= dl_jtag_tdi;
--d_out(3) <= dl_jtag_tdo(1);
--d_out(8 downto 4) <= jtag_ir(4 downto 0);
--d_out(40 downto 32) <= jtag_dr0(8 downto 0);

-- LVMB ADCs

LVMB_ADC1_PM : LVMB_ADC
   port map (
		scl => int_lvmb_sclk,
		sdi => int_lvmb_sdin,
		sdo => int_lvmb_adc_sdout(0),
		ce => int_lvmb_csb(0),
		rst => reset,
		device => "0001");

LVMB_ADC2_PM : LVMB_ADC
   port map (
		scl => int_lvmb_sclk,
		sdi => int_lvmb_sdin,
		sdo => int_lvmb_adc_sdout(1),
		ce => int_lvmb_csb(1),
		rst => reset,
		device => "0010");

LVMB_ADC3_PM : LVMB_ADC
   port map (
		scl => int_lvmb_sclk,
		sdi => int_lvmb_sdin,
		sdo => int_lvmb_adc_sdout(2),
		ce => int_lvmb_csb(2),
		rst => reset,
		device => "0011");

LVMB_ADC4_PM : LVMB_ADC
   port map (
		scl => int_lvmb_sclk,
		sdi => int_lvmb_sdin,
		sdo => int_lvmb_adc_sdout(3),
		ce => int_lvmb_csb(3),
		rst => reset,
		device => "0100");

LVMB_ADC5_PM : LVMB_ADC
   port map (
		scl => int_lvmb_sclk,
		sdi => int_lvmb_sdin,
		sdo => int_lvmb_adc_sdout(4),
		ce => int_lvmb_csb(4),
		rst => reset,
		device => "0101");

LVMB_ADC6_PM : LVMB_ADC
   port map (
		scl => int_lvmb_sclk,
		sdi => int_lvmb_sdin,
		sdo => int_lvmb_adc_sdout(5),
		ce => int_lvmb_csb(5),
		rst => reset,
		device => "0110");

LVMB_ADC7_PM : LVMB_ADC
   port map (
		scl => int_lvmb_sclk,
		sdi => int_lvmb_sdin,
		sdo => int_lvmb_adc_sdout(6),
		ce => int_lvmb_csb(6),
		rst => reset,
		device => "0111");

LVMB_ADC_SDO_MUX_PM : LVMB_ADC_SDO_MUX
	port map (
		int_lvmb_adc_en => flf_ctrl(7),
		int_lvmb_adc_sdo => int_lvmb_adc_sdout,
		lvmb_adc_sdo => lvmb_sdout,
		adc_ce => int_lvmb_csb,
		sdo => int_lvmb_sdout);


END bdf_type;
