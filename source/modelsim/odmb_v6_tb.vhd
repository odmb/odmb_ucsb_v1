library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.Latches_Flipflops.all;

library UNIMACRO;
use UNIMACRO.vcomponents.all;

library UNISIM;
use UNISIM.vcomponents.all;

library STD;
use STD.TEXTIO.ALL;


--library ieee;
--library work;
--use work.Latches_Flipflops.all;
--use work.CFEBJTAG;
--use work.Command_Module;
--use work.vme_master_fsm;
--use ieee.std_logic_1164.all;
--LIBRARY UNIMACRO;
--USE UNIMACRO.vcomponents.all;
--Library unisim;
--use UNISIM.vcomponents.all;
--use UNISIM.vpck.all;
--use UNISIM.all;
--use IEEE.numeric_std.all;
--library STD;
--use STD.TEXTIO.ALL;


entity ODMB_V6_TB is
  generic (
    NFEB : integer range 1 to 7 := 7  -- Number of DCFEBS, 7 in the final design
    );  
port
	(error : OUT STD_LOGIC);

end ODMB_V6_TB ;


ARCHITECTURE ODMB_V6_TB_arch of ODMB_V6_TB  is

-- Beginning of the Test Bench Section

COMPONENT file_handler IS
	port (
     clk : in std_logic;
     start : out std_logic;
     vme_cmd_reg : out std_logic_vector(31 downto 0);
     vme_dat_reg_in : out std_logic_vector(31 downto 0);
     vme_dat_reg_out : in std_logic_vector(31 downto 0);
     vme_cmd_rd : in std_logic;
     vme_dat_wr : in std_logic
    );

end COMPONENT;

COMPONENT file_handler_event IS
	port (
     clk : in std_logic;
     en : in std_logic;
     l1a : out std_logic;
     lct : out std_logic_vector(7 downto 0)
    );

end COMPONENT;

COMPONENT dcfeb_data_gen is
   port(
  
   clk : in std_logic;
   rst : in std_logic;
   l1a : in std_logic;
   l1a_match : in std_logic;
   dcfeb_addr : in std_logic_vector(3 downto 0);
   dcfeb_dv : out std_logic;
   dcfeb_data : out std_logic_vector(15 downto 0)
	
	);

end COMPONENT;

COMPONENT test_controller is

   port(
  
   clk : in std_logic;
   rstn : in std_logic;
   sw_reset : in std_logic;
	 tc_enable : in STD_LOGIC;

-- From/To SLV_MGT Module

   start : in std_logic;
   start_res : out std_logic;
   stop : in std_logic;
   stop_res : out std_logic;
   mode : in std_logic;
   cmd_n : in std_logic_vector(9 downto 0);
	 busy : out std_logic;
	
   vme_cmd_reg : in std_logic_vector(31 downto 0);
   vme_dat_reg_in : in std_logic_vector(31 downto 0);
   vme_dat_reg_out : out std_logic_vector(31 downto 0);

-- To/From VME Master FSM

   vme_cmd : out std_logic;
   vme_cmd_rd : in std_logic;
	
	 vme_addr : out std_logic_vector(23 downto 1); 
   vme_wr : out std_logic;
	 vme_wr_data : out std_logic_vector(15 downto 0); 
   vme_rd : out std_logic;
	 vme_rd_data : in std_logic_vector(15 downto 0); 
 	 
-- From/To VME_CMD Memory and VME_DAT Memory

   vme_mem_addr : out std_logic_vector(9 downto 0);
   vme_mem_rden : out std_logic;
   vme_cmd_mem_out : in std_logic_vector(31 downto 0);
   vme_dat_mem_out : in std_logic_vector(31 downto 0);
   vme_dat_mem_wren : out std_logic;
   vme_dat_mem_in : out std_logic_vector(31 downto 0)

	);

end COMPONENT;

COMPONENT vme_master is
  
  port (
		clk : IN STD_LOGIC;
		rstn : IN STD_LOGIC;
		sw_reset : IN STD_LOGIC;

		vme_cmd : in STD_LOGIC;
		vme_cmd_rd : out STD_LOGIC;

		vme_addr : in STD_LOGIC_VECTOR(23 downto 1);
		vme_wr : in STD_LOGIC;
		vme_wr_data : in STD_LOGIC_VECTOR(15 downto 0);
		vme_rd : in STD_LOGIC;
		vme_rd_data : out STD_LOGIC_VECTOR(15 downto 0);

		ga : OUT STD_LOGIC_VECTOR(5 downto 0);
		addr : OUT STD_LOGIC_VECTOR(23 downto 1);
		am : OUT STD_LOGIC_VECTOR(5 downto 0);

		as : OUT STD_LOGIC;
		ds0 : OUT STD_LOGIC;
		ds1 : OUT STD_LOGIC;
		lword : OUT STD_LOGIC;
		write_b : OUT STD_LOGIC;
		iack : OUT STD_LOGIC;
		berr : OUT STD_LOGIC;
		sysfail : OUT STD_LOGIC;
		dtack : IN STD_LOGIC;

		data_in : IN STD_LOGIC_VECTOR(15 downto 0);
		data_out : OUT STD_LOGIC_VECTOR(15 downto 0);
		oe_b : OUT STD_LOGIC

		);
		
end COMPONENT;

COMPONENT pon_reg IS
	port (
     pon_en : in std_logic;
     pon_load : in std_logic;
     pon_in : in std_logic_vector(7 downto 0);
     pon_out : out std_logic_vector(7 downto 0)
    );

end COMPONENT;


-- End of the Test Bench Section

COMPONENT odmb_v6 is
	port
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
    
end COMPONENT;


-- clock and reset signals

signal go, goevent : std_logic :='0';

signal clk : std_logic :='0';
signal rst : std_logic := '0';
signal rstn : std_logic := '1';

signal SLOWCLK : std_logic:= '0';
signal SLOWCLK2 : std_logic:= '0';
signal MIDCLK : std_logic:= '0';
signal FASTCLK : std_logic:= '0';
signal SUPERFASTCLK : std_logic:= '0';

-- signals from file_handler_event

signal l1a : std_logic;
signal lct : std_logic_vector(NFEB downto 0);

-- signals from dcfeb_data_gen

signal dcfeb_dv : std_logic;
signal dcfeb_data : std_logic_vector(15 downto 0);

-- signals to/from test_controller (from/to slv_mgt module)

signal start : std_logic;
signal start_res : std_logic;
signal stop : std_logic;
signal stop_res : std_logic;
signal vme_cmd_reg : std_logic_vector(31 downto 0);
signal vme_dat_reg_in : std_logic_vector(31 downto 0);
signal vme_dat_reg_out : std_logic_vector(31 downto 0);
signal mode : std_logic := '1'; -- read commands from file
signal cmd_n : std_logic_vector(9 downto 0) := "0000000000";
signal busy : std_logic;

-- signals to/from test_controller (from/to cmd and dat memories)

signal vme_mem_addr : std_logic_vector(9 downto 0);
signal vme_mem_rden : std_logic;
signal vme_cmd_mem_out : std_logic_vector(31 downto 0);
signal vme_dat_mem_out : std_logic_vector(31 downto 0);
signal vme_dat_mem_wren : std_logic;
signal vme_dat_mem_in : std_logic_vector(31 downto 0);

-- signals between test_controller and vme_master_fsm and command_module

signal vme_cmd : std_logic;
signal vme_cmd_rd : std_logic;
signal vme_addr : std_logic_vector(23 downto 1);
signal vme_wr : std_logic;
signal vme_wr_data : std_logic_vector(15 downto 0);
signal vme_rd : std_logic;
signal vme_rd_data : std_logic_vector(15 downto 0);
signal vme_data : std_logic_vector(15 downto 0);

-- signals between vme_master_fsm and command_module

signal berr : std_logic;
signal berr_out : std_logic;
signal as : std_logic;
-- signal ds0 : std_logic;
-- signal ds1 : std_logic;
signal ds : std_logic_vector(1 downto 0);
signal lword : std_logic;
signal write_b : std_logic; 
signal iack : std_logic;
signal sysfail : std_logic;
signal sysfail_out : std_logic;
signal am : std_logic_vector(5 downto 0);
signal ga : std_logic_vector(5 downto 0);
signal adr : std_logic_vector(23 downto 1);
signal oe_b : std_logic;

-- signals between vme_master_fsm and cfebjtag and lvdbmon modules

signal dtack : std_logic;
signal indata : std_logic_vector(15 downto 0);
signal outdata : std_logic_vector(15 downto 0);
signal outdata_cfebjtag : std_logic_vector(15 downto 0);
signal outdata_mbcjtag : std_logic_vector(15 downto 0);
signal outdata_lvdbmon : std_logic_vector(15 downto 0);
signal outdata_serdac : std_logic_vector(15 downto 0);
signal outdata_seradc : std_logic_vector(15 downto 0);
signal outdata_fifomon : std_logic_vector(15 downto 0);
signal outdata_flfmon : std_logic_vector(15 downto 0);

-- signals between command_module and cfebjtag_module

signal strobe, strobe_procs : std_logic;
signal command, command_procs : std_logic_vector(9 downto 0);
signal device, device_procs : std_logic_vector(15 downto 0);

-- unused output signal from command_module

signal indata_command : std_logic_vector(15 downto 0);
signal diagout_command, diagout_command_procs : std_logic_vector(19 downto 0);
signal led_command, led_command_procs : std_logic_vector(2 downto 0);
signal adrs, adrs_procs : std_logic_vector(17 downto 2);  --NOTE:output of ADRS
signal data : std_logic_vector(15 downto 0);
signal tovme, tovme_b, doe, doe_b : std_logic;

-- unused output signal from cfebjtag_module

signal diagout_cfebjtag : std_logic_vector(17 downto 0);
signal led_cfebjtag : std_logic;


signal ccbinj : std_logic := '0';
signal ccbpls : std_logic := '0';


-- Signals From/To ODMB_V6

-- From/To J6 (J3) connector to ODMB_CTRL

signal ccb_cmd : std_logic_vector(5 downto 0) := "000000"; -- in
signal ccb_cmd_s : std_logic := '1'; -- in
signal ccb_data : std_logic_vector(7 downto 0) := "00000000"; -- in
signal ccb_data_s : std_logic := '1'; -- in
signal ccb_cal : std_logic_vector(2 downto 0) := "000"; -- in
signal ccb_crsv : std_logic_vector(4 downto 0) := "00000"; -- in
signal ccb_drsv : std_logic_vector(1 downto 0) := "00"; -- in
signal ccb_rsvo : std_logic_vector(4 downto 0) := "00000"; -- in
signal ccb_rsvi : std_logic_vector(2 downto 0); -- out
signal ccb_bx0 : std_logic := '0'; -- in
signal ccb_bxrst : std_logic := '0'; -- in
signal ccb_l1arst : std_logic := '0'; -- in
signal ccb_l1acc : std_logic := '0'; -- in
signal ccb_l1rls : std_logic; -- out
signal ccb_clken : std_logic := '0'; -- in
signal ccb_hardrst : std_logic := '0'; -- in
signal ccb_softrst : std_logic := '0'; -- in

-- From J6/J7 (J3/J4) to FIFOs

signal tmb : std_logic_vector(17 downto 0) := "000000000000000000"; -- in
signal alct : std_logic_vector(17 downto 0) := "000000000000000000"; -- in
signal rawlct : std_logic_vector(NFEB downto 0) := "00000000"; -- in
signal tmbffclk : std_logic := '0'; -- in

-- From/To J3/J4 t/fromo ODMB_CTRL

signal lctdav1 : std_logic := '0'; -- in
signal lctdav2 : std_logic := '0'; -- in
signal rsvtd_in : std_logic_vector(4 downto 0) := "00000"; -- in
signal rsvtd_out : std_logic_vector(2 downto 0); -- out
signal lctrqst : std_logic_vector(2 downto 1); -- out

-- From/To QPLL (From/To DAQMBV)

signal qpll_autorestart : std_logic; -- out
signal qpll_mode : std_logic; -- out
signal qpll_extcontrol : std_logic; -- out
signal qpll_reset : std_logic; -- out
signal qpll_f0sel : std_logic_vector(3 downto 0); -- out
signal qpll_locked : std_logic := '1'; -- in
signal qpll_error : std_logic := '1'; -- in
signal qpll_clk40MHz_p : std_logic := '0'; -- in
signal qpll_clk40MHz_n : std_logic := '1'; -- in
signal qpll_clk80MHz_p : std_logic := '0'; -- in
signal qpll_clk80MHz_n : std_logic := '1'; -- in

-- From/To LVMB (From/To DAQMBV and DAQMBC)

signal lvmb_pon : std_logic_vector(7 downto 0); -- out
signal pon_load : std_logic; -- out
signal pon_en : std_logic; -- out
signal r_lvmb_pon : std_logic_vector(7 downto 0) := "10101010"; -- in
signal lvmb_csb : std_logic_vector(6 downto 0); -- out
signal lvmb_sclk : std_logic; -- out
signal lvmb_sdin : std_logic; -- out
signal lvmb_sdout : std_logic := '0'; -- in

-- From/To ADC (From/To DAQMBV)

signal adc_sclk : std_logic; -- out
signal adc_sdain : std_logic; -- out
signal adc_sdaout : std_logic := '0'; -- in
signal adc_cs : std_logic; -- out

-- From/To DAC (From/To DAQMBV)

signal dac_sclk : std_logic; -- out
signal dac_sdain : std_logic; -- out
signal dac_sdaout : std_logic := '0'; -- in
signal dac_cs : std_logic; -- out

-- To LEDs

signal leds : std_logic_vector(11 downto 0); -- out

-- To Frequency Divider FF

signal fd_pre, fd_clr  : std_logic; -- out

-- From Push Buttons

signal pb : std_logic_vector(3 downto 0) := "0000"; -- in

-- From/To Test Connector for Single-Ended signals

signal  d : std_logic_vector(63 downto 0);

-- From/To Test Connector J3 for LVDS signals

signal  gtx0_p : std_logic := '0';
signal  gtx0_n : std_logic := '1';
signal  grx0_p : std_logic;
signal  grx0_n : std_logic;

signal  ck0_p : std_logic := '0';
signal  ck0_n : std_logic := '1';
signal  ck1_p : std_logic := '0';
signal  ck1_n : std_logic := '1';
signal  tclk_p : std_logic := '0';
signal  tclk_n : std_logic := '1';
signal  rxb_p : std_logic;
signal  rxb_n : std_logic;

signal  tx_p : std_logic_vector(10 downto 0);
signal  tx_n : std_logic_vector(10 downto 0);
signal  rx_p : std_logic_vector(10 downto 0) := "00000000000";
signal  rx_n : std_logic_vector(10 downto 0) := "11111111111";

-- To/From TX1 

signal  otx1_p : std_logic_vector(12 downto 1); -- out
signal  otx1_n : std_logic_vector(12 downto 1); -- out
signal  otx1_tx_en : std_logic; -- out
signal  otx1_tx_dis : std_logic; -- out
signal  otx1_reset : std_logic; -- out
signal  otx1_fault : std_logic := '0'; -- in

-- To/From TX2 

signal  otx2_p : std_logic_vector(12 downto 1); -- out
signal  otx2_n : std_logic_vector(12 downto 1); -- out
signal  otx2_tx_en : std_logic; -- out
signal  otx2_tx_dis : std_logic; -- out
signal  otx2_reset : std_logic; -- out
signal  otx2_fault : std_logic := '0'; -- in

-- From/To RX1 

signal  orx1_p : std_logic_vector(12 downto 1) := "000000000000"; -- in
signal  orx1_n : std_logic_vector(12 downto 1) := "111111111111"; -- in
signal  orx1_rx_en : std_logic; -- out
signal  orx1_en_sd : std_logic; -- out
signal  orx1_sd : std_logic := '0'; -- in
signal  orx1_sq_en : std_logic; -- out

-- From/To RX2 

signal  orx2_p : std_logic_vector(12 downto 1) := "000000000000"; -- in
signal  orx2_n : std_logic_vector(12 downto 1) := "111111111111"; -- in
signal  orx2_rx_en : std_logic; -- out
signal  orx2_en_sd : std_logic; -- out
signal  orx2_sd : std_logic := '0'; -- in
signal  orx2_sq_en : std_logic; -- out

-- From/To OT1 (GigaBit Link)

signal gl0_tx_p : std_logic; -- out
signal gl0_tx_n : std_logic; -- out
signal gl0_rx_p : std_logic; -- in
signal gl0_rx_n : std_logic; -- in

-- From/To OT2 (GigaBit Link)

signal gl1_tx_p : std_logic; -- out
signal gl1_tx_n : std_logic; -- out
signal gl1_rx_p : std_logic; -- in
signal gl1_rx_n : std_logic; -- in

-- From IC7 (Clock Driver CDC)

signal cdc_clk_p : std_logic_vector(7 downto 0) := "00000000"; -- in
signal cdc_clk_n : std_logic_vector(7 downto 0) := "00000000"; -- in

-- From IC31 

signal gl0_clk : std_logic := '0'; -- in
signal gl1_clk : std_logic := '0'; -- in

-- Others 

signal done_in : std_logic := '0'; -- in
		
signal LOGIC0 : std_logic := '0';
signal LOGIC1 : std_logic := '1';

signal reset : std_logic := '1';

begin

  reset <= '1' after 200 ns, '0' after 13000 ns;
 
  go <= '1' after 10 us;
  goevent <= '1' after 200 us;
        
  qpll_clk40MHz_p <= not qpll_clk40MHz_p after 10 ns;
  qpll_clk40MHz_n <= not qpll_clk40MHz_n after 10 ns;
  qpll_clk80MHz_p <= not qpll_clk80MHz_p after 5 ns;
  qpll_clk80MHz_n <= not qpll_clk80MHz_n after 5 ns;
  clk <= not clk after 10 ns;

  rst <= '0','1' after 200 ns, '0' after 13000 ns;
  
  rstn <= not rst;
  
  stop <= '0';
  
  dtack <= 'H';

-- Beginning of the Test Bench Section

PMAP_file_handler_event : file_handler_event

   port map(
  
	   clk => clk,
     en => goevent,
     l1a => l1a,
     lct => lct
  );

PMAP_dcfeb_data_gen : dcfeb_data_gen

   port map(
  
	 clk => clk,
   rst => rst,
   l1a => l1a,
   l1a_match => l1a,
   dcfeb_addr => "1111",
   dcfeb_dv => dcfeb_dv,
   dcfeb_data => dcfeb_data
	
	);

PMAP_file_handler : file_handler

   port map(
  
	   clk => clk,
     start => start,
     vme_cmd_reg => vme_cmd_reg,
     vme_dat_reg_in => vme_dat_reg_in,
     vme_dat_reg_out => vme_dat_mem_in,
     vme_cmd_rd => vme_mem_rden,
     vme_dat_wr => vme_dat_mem_wren
  );

vme_cmd_mem_out <= vme_cmd_reg;
vme_dat_mem_out <= vme_dat_reg_in;
  
PMAP_test_controller : test_controller

   port map(
  
	 clk => clk,
   rstn => rstn,
   sw_reset => rst,
   tc_enable => go,

	-- From/To SLV_MGT Module

   start => start,
   start_res => start_res,
   stop => stop,
   stop_res => stop_res,
   mode => mode,
   cmd_n => cmd_n,
	 busy => busy,
	
   vme_cmd_reg => vme_cmd_reg,
   vme_dat_reg_in => vme_dat_reg_in,
   vme_dat_reg_out => vme_dat_reg_out,

-- To/From VME Master

   vme_cmd => vme_cmd,
   vme_cmd_rd => vme_cmd_rd,
	
	 vme_addr => vme_addr,
   vme_wr => vme_wr,
	 vme_wr_data => vme_wr_data, 
   vme_rd => vme_rd,
	 vme_rd_data => vme_rd_data, 
 	 
-- From/To VME_CMD Memory and VME_DAT Memory

   vme_mem_addr => vme_mem_addr,
   vme_mem_rden => vme_mem_rden,
   vme_cmd_mem_out => vme_cmd_mem_out,
   vme_dat_mem_out => vme_dat_mem_out,
   vme_dat_mem_wren => vme_dat_mem_wren,
   vme_dat_mem_in => vme_dat_mem_in

	);
  
PMAP_VME_Master: vme_master
  port map (

	  clk => clk,
    rstn => rstn,
    sw_reset => rst,

		vme_cmd => vme_cmd,
		vme_cmd_rd => vme_cmd_rd,
		vme_wr => vme_cmd,
		vme_addr => vme_addr,
		vme_wr_data => vme_wr_data,
		vme_rd => vme_rd,
		vme_rd_data => vme_rd_data,

		ga => ga,
		addr => adr,
		am => am,

		as => as,
		ds0 => ds(0),
		ds1 => ds(1),
		lword => lword,
		write_b => write_b,
		iack => iack,
		berr => berr,
		sysfail => sysfail,
		dtack => dtack,
		
		oe_b => oe_b,
		data_in => outdata,
		data_out => indata

    );

vme_d00_buf : IOBUF port map (O => outdata(0), IO => data(0), I => indata(0), T => oe_b);     	
vme_d01_buf : IOBUF port map (O => outdata(1), IO => data(1), I => indata(1), T => oe_b);     	
vme_d02_buf : IOBUF port map (O => outdata(2), IO => data(2), I => indata(2), T => oe_b);     	
vme_d03_buf : IOBUF port map (O => outdata(3), IO => data(3), I => indata(3), T => oe_b);     	
vme_d04_buf : IOBUF port map (O => outdata(4), IO => data(4), I => indata(4), T => oe_b);     	
vme_d05_buf : IOBUF port map (O => outdata(5), IO => data(5), I => indata(5), T => oe_b);     	
vme_d06_buf : IOBUF port map (O => outdata(6), IO => data(6), I => indata(6), T => oe_b);     	
vme_d07_buf : IOBUF port map (O => outdata(7), IO => data(7), I => indata(7), T => oe_b);     	
vme_d08_buf : IOBUF port map (O => outdata(8), IO => data(8), I => indata(8), T => oe_b);     	
vme_d09_buf : IOBUF port map (O => outdata(9), IO => data(9), I => indata(9), T => oe_b);     	
vme_d10_buf : IOBUF port map (O => outdata(10), IO => data(10), I => indata(10), T => oe_b);     	
vme_d11_buf : IOBUF port map (O => outdata(11), IO => data(11), I => indata(11), T => oe_b);     	
vme_d12_buf : IOBUF port map (O => outdata(12), IO => data(12), I => indata(12), T => oe_b);     	
vme_d13_buf : IOBUF port map (O => outdata(13), IO => data(13), I => indata(13), T => oe_b);     	
vme_d14_buf : IOBUF port map (O => outdata(14), IO => data(14), I => indata(14), T => oe_b);     	
vme_d15_buf : IOBUF port map (O => outdata(15), IO => data(15), I => indata(15), T => oe_b);     	

PMAP_pon_reg : pon_reg
	port map (
     pon_en => pon_en,
     pon_load => pon_load,
     pon_in => lvmb_pon,
     pon_out => r_lvmb_pon);

-- End of the Test Bench Section

PMAP_odmb_v6 : odmb_v6
   port map(

-- From/To VME connector To/From MBV

		vme_data => data(15 downto 0), -- inout
		vme_addr => adr(23 downto 1), -- in
		vme_am => am(5 DOWNTO 0), -- in
		vme_gap => ga(5), -- in
		vme_ga => ga(4 downto 0), -- in
		vme_bg0 => LOGIC0, -- in
		vme_bg1 => LOGIC0, -- in
		vme_bg2 => LOGIC0, -- in
		vme_bg3 => LOGIC0, -- in
		vme_as_b => as, -- in						
		vme_ds_b => ds,	-- in
		vme_sysreset_b => LOGIC1,	-- in ???
		vme_sysfail_b => sysfail,
		vme_sysfail_out => sysfail_out, -- out
		vme_berr_b => berr, -- in
		vme_berr_out => berr_out, -- out
		vme_iack_b => iack, -- in
		vme_lword_b => lword, -- in
		vme_write_b => write_b, -- in
		vme_clk => LOGIC0, -- in ???
		vme_dtack_v6_b => dtack, -- inout
		vme_tovme => tovme, -- out
		vme_doe => doe, -- out

-- From/To J6 (J3) connector to ODMB_CTRL

		ccb_cmd => ccb_cmd, -- in
		ccb_cmd_s => ccb_cmd_s, -- in
		ccb_data => ccb_data, -- in
		ccb_data_s => ccb_data_s, -- in
		ccb_cal => ccb_cal, -- in
		ccb_crsv => ccb_crsv, -- in
		ccb_drsv => ccb_drsv, -- in
		ccb_rsvo => ccb_rsvo, -- in
		ccb_rsvi => ccb_rsvi, -- in
		ccb_bx0 => ccb_bx0, -- in
		ccb_bxrst => ccb_bxrst, -- in
		ccb_l1arst => ccb_l1arst, -- in
--		ccb_l1acc => ccb_l1acc, -- in
		ccb_l1acc => l1a, -- from file_handler_event
		ccb_l1rls => ccb_l1rls, -- out
		ccb_clken => ccb_clken, -- in
		ccb_hardrst => ccb_hardrst, -- in		
		ccb_softrst => ccb_softrst, -- in

-- From J6/J7 (J3/J4) to FIFOs

		tmb => tmb, -- in
		alct => alct, -- in
--		rawlct => rawlct, -- in
		rawlct => lct,	-- from file_handler_event
		tmbffclk => tmbffclk, -- in

-- From/To J3/J4 t/fromo ODMB_CTRL

		lctdav1 => lctdav1, -- in 
		lctdav2 => lctdav2, -- in 
--		rsvtd : INOUT STD_LOGIC_VECTOR(7 DOWNTO 0);			
		rsvtd_in => rsvtd_in, -- in
		rsvtd_out => rsvtd_out, -- out
		lctrqst => lctrqst, -- out


-- From/To QPLL (From/To DAQMBV)

		qpll_autorestart => qpll_autorestart, -- out
		qpll_mode => qpll_mode, -- out
		qpll_extcontrol => qpll_extcontrol, -- out
		qpll_reset => qpll_reset, -- out
		qpll_f0sel => qpll_f0sel, -- out
		qpll_locked => qpll_locked, -- in
		qpll_error => qpll_error, -- in

		qpll_clk40MHz_p => qpll_clk40MHz_p, -- in 
		qpll_clk40MHz_n => qpll_clk40MHz_n, -- in 
		qpll_clk80MHz_p => qpll_clk80MHz_p, -- in 
		qpll_clk80MHz_n => qpll_clk80MHz_n, -- in 
--		qpll_clk160MHz_p : IN STD_LOGIC;							-- NEW!
--		qpll_clk160MHz_n : IN STD_LOGIC;							-- NEW!
		
-- From/To LVMB (From/To DAQMBV and DAQMBC)

		lvmb_pon => lvmb_pon, -- out
		pon_load => pon_load, -- out
		pon_en => pon_en, -- out
		r_lvmb_pon => r_lvmb_pon, -- in
		lvmb_csb => lvmb_csb, -- out
		lvmb_sclk => lvmb_sclk, -- out
		lvmb_sdin => lvmb_sdin, -- out
		lvmb_sdout => lvmb_sdout, -- out

-- From/To ADC (From/To DAQMBV)

		adc_sclk => adc_sclk, -- out
		adc_sdain => adc_sdain, -- out
		adc_sdaout => adc_sdaout, -- in
		adc_cs => adc_cs, -- out

-- From/To DAC (From/To DAQMBV)

		dac_sclk => dac_sclk, -- out
		dac_sdain => dac_sdain, -- out
		dac_sdaout => dac_sdaout, -- in
		dac_cs => dac_cs, -- out

-- To LEDs

		leds => leds, -- out

-- To Frequency Divider FF

		fd_pre => fd_pre, -- out	
		fd_clr => fd_clr, -- out	

-- From Push Buttons

		pb => pb, -- in

-- From/To Test Connector for Single-Ended signals

		d => d, -- out		

-- From/To Test Connector J3 for LVDS signals

		gtx_0_p => gtx0_p, -- in		
		gtx_0_n => gtx0_n, -- in			
		grx_0_p => grx0_p, -- out					
		grx_0_n => grx0_n, -- out					

		ck_0_p => ck0_p, -- in			
		ck_0_n => ck0_n, -- in			
		ck_1_p => ck1_p, -- in			
		ck_1_n => ck1_n, -- in				
		tclk_p => tclk_p, -- in					
		tclk_n => tclk_n, -- in						
		rxb_p => rxb_p, -- out		
		rxb_n => rxb_n, -- out				
		
		tx_0_p => tx_p(0), -- out			
		tx_0_n => tx_n(0), -- out				
		tx_1_p => tx_p(1), -- out				
		tx_1_n => tx_n(1), -- out						
		tx_2_p => tx_p(2), -- out			
		tx_2_n => tx_n(2), -- out				
		tx_3_p => tx_p(3), -- out			
		tx_3_n => tx_n(3), -- out				
		tx_4_p => tx_p(4), -- out			
		tx_4_n => tx_n(4), -- out				
		tx_5_p => tx_p(5), -- out			
		tx_5_n => tx_n(5), -- out				
		tx_6_p => tx_p(6), -- out			
		tx_6_n => tx_n(6), -- out				
		tx_7_p => tx_p(7), -- out			
		tx_7_n => tx_n(7), -- out				
		tx_8_p => tx_p(8), -- out			
		tx_8_n => tx_n(8), -- out				
		tx_9_p => tx_p(9), -- out			
		tx_9_n => tx_n(9), -- out				
		tx_10_p => tx_p(10), -- out			
		tx_10_n => tx_n(10), -- out				

		rx_0_p => rx_p(0), -- in			
		rx_0_n => rx_n(0), -- in				
		rx_1_p => rx_p(1), -- in				
		rx_1_n => rx_n(1), -- in						
		rx_2_p => rx_p(2), -- in			
		rx_2_n => rx_n(2), -- in				
		rx_3_p => rx_p(3), -- in			
		rx_3_n => rx_n(3), -- in				
		rx_4_p => rx_p(4), -- in			
		rx_4_n => rx_n(4), -- in				
		rx_5_p => rx_p(5), -- in			
		rx_5_n => rx_n(5), -- in				
		rx_6_p => rx_p(6), -- in			
		rx_6_n => rx_n(6), -- in				
		rx_7_p => rx_p(7), -- in			
		rx_7_n => rx_n(7), -- in				
		rx_8_p => rx_p(8), -- in			
		rx_8_n => rx_n(8), -- in				
		rx_9_p => rx_p(9), -- in			
		rx_9_n => rx_n(9), -- in				
		rx_10_p => rx_p(10), -- in			
		rx_10_n => rx_n(10), -- in				

-- To/From TX1 

		otx1_01_p => otx1_p(1), -- out	
		otx1_01_n => otx1_n(1), -- out	
		otx1_02_p => otx1_p(2), -- out	
		otx1_02_n => otx1_n(2), -- out	
		otx1_03_p => otx1_p(3), -- out	
		otx1_03_n => otx1_n(3), -- out	
		otx1_04_p => otx1_p(4), -- out	
		otx1_04_n => otx1_n(4), -- out	
		otx1_05_p => otx1_p(5), -- out	
		otx1_05_n => otx1_n(5), -- out	
		otx1_06_p => otx1_p(6), -- out	
		otx1_06_n => otx1_n(6), -- out	
		otx1_07_p => otx1_p(7), -- out	
		otx1_07_n => otx1_n(7), -- out	
		otx1_08_p => otx1_p(8), -- out	
		otx1_08_n => otx1_n(8), -- out	
		otx1_09_p => otx1_p(9), -- out	
		otx1_09_n => otx1_n(9), -- out	
		otx1_10_p => otx1_p(10), -- out	
		otx1_10_n => otx1_n(10), -- out	
		otx1_11_p => otx1_p(11), -- out	
		otx1_11_n => otx1_n(11), -- out	
		otx1_12_p => otx1_p(12), -- out	
		otx1_12_n => otx1_n(12), -- out	

		otx1_tx_en => otx1_tx_en, -- out
		otx1_tx_dis => otx1_tx_dis, -- out
		otx1_reset => otx1_reset, -- out
		otx1_fault => otx1_fault, -- in
		
-- To/From TX2 

		otx2_01_p => otx2_p(1), -- out	
		otx2_01_n => otx2_n(1), -- out	
		otx2_02_p => otx2_p(2), -- out	
		otx2_02_n => otx2_n(2), -- out	
		otx2_03_p => otx2_p(3), -- out	
		otx2_03_n => otx2_n(3), -- out	
		otx2_04_p => otx2_p(4), -- out	
		otx2_04_n => otx2_n(4), -- out	
		otx2_05_p => otx2_p(5), -- out	
		otx2_05_n => otx2_n(5), -- out	
		otx2_06_p => otx2_p(6), -- out	
		otx2_06_n => otx2_n(6), -- out	
		otx2_07_p => otx2_p(7), -- out	
		otx2_07_n => otx2_n(7), -- out	
		otx2_08_p => otx2_p(8), -- out	
		otx2_08_n => otx2_n(8), -- out	
		otx2_09_p => otx2_p(9), -- out	
		otx2_09_n => otx2_n(9), -- out	
		otx2_10_p => otx2_p(10), -- out	
		otx2_10_n => otx2_n(10), -- out	
		otx2_11_p => otx2_p(11), -- out	
		otx2_11_n => otx2_n(11), -- out	
		otx2_12_p => otx2_p(12), -- out	
		otx2_12_n => otx2_n(12), -- out	

		otx2_tx_en => otx2_tx_en, -- out
		otx2_tx_dis => otx2_tx_dis, -- out
		otx2_reset => otx2_reset, -- out
		otx2_fault => otx2_fault, -- in

-- From/To RX1 

		orx1_01_p => orx1_p(1), -- in	
		orx1_01_n => orx1_n(1), -- in		
		orx1_02_p => orx1_p(2), -- in	
		orx1_02_n => orx1_n(2), -- in		
		orx1_03_p => orx1_p(3), -- in	
		orx1_03_n => orx1_n(3), -- in		
		orx1_04_p => orx1_p(4), -- in	
		orx1_04_n => orx1_n(4), -- in		
		orx1_05_p => orx1_p(5), -- in	
		orx1_05_n => orx1_n(5), -- in		
		orx1_06_p => orx1_p(6), -- in	
		orx1_06_n => orx1_n(6), -- in		
		orx1_07_p => orx1_p(7), -- in	
		orx1_07_n => orx1_n(7), -- in		
		orx1_08_p => orx1_p(8), -- in	
		orx1_08_n => orx1_n(8), -- in		
		orx1_09_p => orx1_p(9), -- in	
		orx1_09_n => orx1_n(9), -- in		
		orx1_10_p => orx1_p(10), -- in	
		orx1_10_n => orx1_n(10), -- in		
		orx1_11_p => orx1_p(11), -- in	
		orx1_11_n => orx1_n(11), -- in		
		orx1_12_p => orx1_p(12), -- in	
		orx1_12_n => orx1_n(12), -- in		

		orx1_rx_en => orx1_rx_en, -- out
		orx1_en_sd => orx1_en_sd, -- out
		orx1_sd => orx1_sd, -- in
		orx1_sq_en => orx1_sq_en, -- out

-- From/To RX2 

		orx2_01_p => orx2_p(1), -- in	
		orx2_01_n => orx2_n(1), -- in		
		orx2_02_p => orx2_p(2), -- in	
		orx2_02_n => orx2_n(2), -- in		
		orx2_03_p => orx2_p(3), -- in	
		orx2_03_n => orx2_n(3), -- in		
		orx2_04_p => orx2_p(4), -- in	
		orx2_04_n => orx2_n(4), -- in		
		orx2_05_p => orx2_p(5), -- in	
		orx2_05_n => orx2_n(5), -- in		
		orx2_06_p => orx2_p(6), -- in	
		orx2_06_n => orx2_n(6), -- in		
		orx2_07_p => orx2_p(7), -- in	
		orx2_07_n => orx2_n(7), -- in		
		orx2_08_p => orx2_p(8), -- in	
		orx2_08_n => orx2_n(8), -- in		
		orx2_09_p => orx2_p(9), -- in	
		orx2_09_n => orx2_n(9), -- in		
		orx2_10_p => orx2_p(10), -- in	
		orx2_10_n => orx2_n(10), -- in		
		orx2_11_p => orx2_p(11), -- in	
		orx2_11_n => orx2_n(11), -- in		
		orx2_12_p => orx2_p(12), -- in	
		orx2_12_n => orx2_n(12), -- in		

		orx2_rx_en => orx2_rx_en, -- out
		orx2_en_sd => orx2_en_sd, -- out
		orx2_sd => orx2_sd, -- in
		orx2_sq_en => orx2_sq_en, -- out

-- From/To OT1 (GigaBit Link)

		gl0_tx_p => gl0_tx_p, -- out
		gl0_tx_n => gl0_tx_n, -- out
		gl0_rx_p => gl0_rx_p, -- in
		gl0_rx_n => gl0_rx_n, -- in

-- From/To OT2 (GigaBit Link)

		gl1_tx_p => gl1_tx_p, -- out
		gl1_tx_n => gl1_tx_n, -- out
		gl1_rx_p => gl1_rx_p, -- in
		gl1_rx_n => gl1_rx_n, -- in

-- From IC7 (Clock Driver CDC)

		cdc_clk_0_p => cdc_clk_p(0), -- in
		cdc_clk_0_n => cdc_clk_n(0), -- in
		cdc_clk_1_p => cdc_clk_p(1), -- in
		cdc_clk_1_n => cdc_clk_n(1), -- in
		cdc_clk_2_p => cdc_clk_p(2), -- in
		cdc_clk_2_n => cdc_clk_n(2), -- in
		cdc_clk_3_p => cdc_clk_p(3), -- in
		cdc_clk_3_n => cdc_clk_n(3), -- in
		cdc_clk_4_p => cdc_clk_p(4), -- in
		cdc_clk_4_n => cdc_clk_n(4), -- in
		cdc_clk_5_p => cdc_clk_p(5), -- in
		cdc_clk_5_n => cdc_clk_n(5), -- in
		cdc_clk_6_p => cdc_clk_p(6), -- in
		cdc_clk_6_n => cdc_clk_n(6), -- in
		cdc_clk_7_p => cdc_clk_p(7), -- in
		cdc_clk_7_n => cdc_clk_n(7), -- in

-- From IC31 

		gl0_clk => gl0_clk, -- in
		gl1_clk => gl1_clk, -- in

		done_in => done_in 
	);
    

  

end ODMB_V6_TB_arch;
