												library ieee;
use ieee.std_logic_1164.all;
USE IEEE.std_logic_arith.all;
USE IEEE.std_logic_unsigned.all;

ENTITY ODMB_VME IS
  generic (
    NFEB : integer range 1 to 7 := 7  -- Number of DCFEBS, 7 in the final design
    );  
 PORT 	(

-- VME signals

		vme_addr : IN STD_LOGIC_VECTOR (23 downto 1);			-- adr(23 downto 1)
		vme_data_in : IN STD_LOGIC_VECTOR (15 downto 0);		-- data(15 downto 0)
		vme_data_out : OUT STD_LOGIC_VECTOR (15 downto 0);		-- data(15 downto 0)
		vme_am : IN STD_LOGIC_VECTOR (5 downto 0);				-- am(5 downto 0)
		vme_ga : IN STD_LOGIC_VECTOR (4 downto 0);				-- ga*(4 downto 0)
		vme_gap : IN STD_LOGIC;											-- ga*(5)
		vme_ds_b : IN STD_LOGIC_VECTOR(1 DOWNTO 0);				-- ids1*,ids0*
		vme_as_b : IN STD_LOGIC;										-- ias*
		vme_lword_b : IN STD_LOGIC;									-- ilword*
		vme_write_b : IN STD_LOGIC;									-- iwrite*
		vme_iack_b : IN STD_LOGIC;										-- inack*
		vme_sysreset_b : IN STD_LOGIC;								-- isysrst*
		vme_sysfail_b : IN STD_LOGIC;									-- isysfail*
		vme_sysfail_out : OUT STD_LOGIC;								-- NEW
		vme_berr_b : IN STD_LOGIC;										-- iberr*
		vme_berr_out : OUT STD_LOGIC;									-- NEW
		vme_dtack_b : OUT STD_LOGIC;									-- odtack*
		vme_tovme : OUT STD_LOGIC;										-- tovme
		vme_tovme_b : OUT STD_LOGIC;									-- tovme*
		vme_doe : OUT STD_LOGIC;										-- doe
		vme_doe_b : OUT STD_LOGIC;										-- doe*

-- Clock
		
		clk : IN STD_LOGIC;												-- NEW (fastclk -> 40MHz)
		clk_s1 : IN STD_LOGIC;											-- NEW (midclk -> fastclk/4 -> 10MHz)
		clk_s2 : IN STD_LOGIC;											-- NEW (slowclk -> midclk/4 -> 2.5MHz)
		clk_s3 : IN STD_LOGIC;											-- NEW (slowclk2 -> midclk/8 -> 12.5MHz)

-- Reset

		rst : IN STD_LOGIC;												-- iglobalrst

-- JTAG Signals To/From DCFEBs

		dl_jtag_tck : OUT STD_LOGIC_VECTOR (6 downto 0);				
		dl_jtag_tms : OUT STD_LOGIC;				
		dl_jtag_tdi : OUT STD_LOGIC;				
		dl_jtag_tdo : IN STD_LOGIC_VECTOR (6 downto 0);				
		dl_rtn_shft_en  : IN STD_LOGIC_VECTOR (6 downto 0);
		ul_jtag_tck : IN STD_LOGIC_VECTOR (6 downto 0);				
		ul_jtag_tms : IN STD_LOGIC_VECTOR (6 downto 0);				
		ul_jtag_tdi : IN STD_LOGIC_VECTOR (6 downto 0);				
		
-- JTAG Signals To/From DMB_CTRL

		mbc_jtag_tck : OUT STD_LOGIC;				
		mbc_jtag_tms : OUT STD_LOGIC;				
		mbc_jtag_tdi : OUT STD_LOGIC;				
		mbc_jtag_tdo : IN STD_LOGIC;				

--		mbc_rtn_shft_en  : IN STD_LOGIC; -- ????
		
-- Reprogram To DCFEB FPGA (CFEBPRG)

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
 
		fifo_in : OUT STD_LOGIC_VECTOR (15 downto 0);			
		fifo_out : IN STD_LOGIC_VECTOR (15 downto 0);	

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
		flf_data : IN std_logic_vector(15 downto 0);

		tc_l1a : OUT std_logic;
		tc_alct_dav : OUT std_logic;
		tc_tmb_dav : OUT std_logic;
		tc_lct : OUT std_logic_vector(NFEB downto 0);
		ddu_data : IN std_logic_vector(15 downto 0);
		ddu_data_valid : IN std_logic;
		tc_run : OUT std_logic

		

);
	
end ODMB_VME;


ARCHITECTURE ODMB_VME_architecture OF ODMB_VME IS

signal ext_vme_ga  : std_logic_vector(5 downto 0);

signal device : std_logic_vector(9 downto 0);
signal cmd : std_logic_vector(9 downto 0);
signal strobe : std_logic;
signal tovme_b, doe_b : std_logic;

signal diagout_command  : std_logic_vector(19 downto 0);
signal led_command  : std_logic_vector(2 downto 0);

signal outdata_cfebjtag  : std_logic_vector(15 downto 0);
-- signal diagout_cfebjtag  : std_logic_vector(17 downto 0);
signal led_cfebjtag  : std_logic;

signal outdata_mbcjtag  : std_logic_vector(15 downto 0);
signal led_mbcjtag  : std_logic;

signal outdata_lvdbmon  : std_logic_vector(15 downto 0);

signal cmd_adrs  : std_logic_vector(15 downto 0);
signal outdata_fifomon  : std_logic_vector(15 downto 0);

signal outdata_vmemon  : std_logic_vector(15 downto 0);

signal jtag_tck  : std_logic_vector(6 downto 0);

signal outdata_testctrl : std_logic_vector(15 downto 0);

COMPONENT VMEMON is
  
  port (

    SLOWCLK  : in  std_logic;
    RST      : in  std_logic;

    DEVICE   : in  std_logic;
    STROBE   : in  std_logic;
    COMMAND  : in  std_logic_vector(9 downto 0);
 
    INDATA   : in  std_logic_vector(15 downto 0);
    OUTDATA  : out std_logic_vector(15 downto 0);

    DTACK    : out std_logic;

    FLFCTRL  : out std_logic_vector(15 downto 0);
    FLFDATA  : in std_logic_vector(15 downto 0)
 
 );
end COMPONENT;

COMPONENT TESTCTRL is
    generic (
      NFEB : integer range 1 to 7 := 7  -- Number of DCFEBS, 7 in the final design
      );    
  port (
    CLK : in std_logic;
    SLOWCLK : in std_logic;
    RST : in std_logic;

    DEVICE : in std_logic;
    STROBE : in std_logic;
    COMMAND : in std_logic_vector(9 downto 0);
 
    INDATA : in std_logic_vector(15 downto 0);
    OUTDATA : out std_logic_vector(15 downto 0);
    
    DTACK : out std_logic;
 
    L1A : out std_logic;
    ALCT_DAV : out std_logic;
    TMB_DAV : out std_logic;
    LCT : out std_logic_vector(NFEB downto 0);
    DDU_DATA : in std_logic_vector(15 downto 0);
    DDU_DATA_VALID :  in std_logic;
    TC_RUN :  out std_logic
    
    );
    
end COMPONENT;

COMPONENT FIFOMON is
  
  port (

    SLOWCLK : in std_logic;
    RST : in std_logic;

    DEVICE : in std_logic;
    STROBE : in std_logic;
    COMMAND : in std_logic_vector(9 downto 0);
 
    INDATA : in std_logic_vector(15 downto 0);
    OUTDATA : out std_logic_vector(15 downto 0);
    
    DTACK : out std_logic;
 
    FIFO_WR_EN : out std_logic_vector(7 downto 0);
    FIFO_RD_EN : out std_logic_vector(7 downto 0);
    FIFO_SEL : out std_logic_vector(7 downto 0);
    FIFO_MODE : out std_logic;
    FIFO_DATA : in std_logic_vector(15 downto 0);
    FIFO_STR :  in std_logic_vector(15 downto 0);
    FIFO_WRC :  in std_logic_vector(9 downto 0);
    FIFO_RDC :  in std_logic_vector(9 downto 0));

end COMPONENT;

COMPONENT LVDBMON is
  
  port (

    SLOWCLK  : in  std_logic;
    RST      : in  std_logic;

    DEVICE   : in  std_logic;
    STROBE   : in  std_logic;
    COMMAND  : in  std_logic_vector(9 downto 0);
    WRITER   : in  std_logic;

    INDATA   : in  std_logic_vector(15 downto 0);
    OUTDATA  : out std_logic_vector(15 downto 0);

    DTACK    : out std_logic;

    LVADCEN  : out std_logic_vector(6 downto 0);
    ADCCLK   : out std_logic;
    ADCDATA  : out std_logic;
    ADCIN    : in  std_logic;

    LVTURNON : out std_logic_vector(8 downto 1);
    R_LVTURNON : in std_logic_vector(8 downto 1);
    LOADON   : out std_logic;
    
    DIAGLVDB : out std_logic_vector(17 downto 0)
    );

end COMPONENT;

COMPONENT CFEBJTAG is
  
  port (

    FASTCLK : in std_logic;
    SLOWCLK : in std_logic;
    RST : in std_logic;

    DEVICE : in std_logic;
    STROBE : in std_logic;
    COMMAND : in std_logic_vector(9 downto 0);
    WRITER : in std_logic;

    INDATA : in std_logic_vector(15 downto 0);
    OUTDATA : inout std_logic_vector(15 downto 0);

    DTACK : out std_logic;

    INITJTAGS : in std_logic;
    TCK : out std_logic_vector(7 downto 1);
    TDI : out std_logic;
    TMS : out std_logic;
    FEBTDO : in std_logic_vector(7 downto 1);
	 DL_RTN_SHFT_EN  : IN STD_LOGIC_VECTOR (7 downto 1);
	 UL_JTAG_TCK : IN STD_LOGIC_VECTOR (7 downto 1);				

    DIAGOUT : out std_logic_vector(17 downto 0);
    LED : out std_logic
    );

end COMPONENT;

COMPONENT MBCJTAG is
  
  port (
    DEVICE : in std_logic;
    COMMAND : in std_logic_vector(9 downto 0);
    INDATA : in std_logic_vector(15 downto 0);
    STROBE : in std_logic;
    MBCTDO : in std_logic;
    INITJTAGS : in std_logic;
    WRITER : in std_logic;
    FASTCLK : in std_logic;
    SLOWCLK : in std_logic;
    RST : in std_logic;

    OUTDATA : out std_logic_vector(15 downto 0);
    DTACK : out std_logic;
    TDI : out std_logic;
    TMS : out std_logic;
    TCK : out std_logic;
    LED : out std_logic
    );

end COMPONENT;

COMPONENT COMMAND_MODULE is
  
  port (

    FASTCLK: in std_logic;
    SLOWCLK: in std_logic;

    GA : in std_logic_vector(5 downto 0);
    ADR : in std_logic_vector(23 downto 1);
    AM : in std_logic_vector(5 downto 0);

    AS : in std_logic;
    DS0 : in std_logic;
    DS1 : in std_logic;
    LWORD : in std_logic;
    WRITER : in std_logic; 
    IACK : in std_logic;
    BERR : in std_logic;
    SYSFAIL : in std_logic;

    DEVICE   : out std_logic_vector(9 downto 0);
    STROBE   : out std_logic;
    COMMAND  : out std_logic_vector(9 downto 0);
    ADRS     : out std_logic_vector(17 downto 2);  

    TOVME_B    : out std_logic;
    DOE_B    : out std_logic;

    DIAGOUT  : out std_logic_vector(19 downto 0);
    LED      : out std_logic_vector(2 downto 0)

    );
    
end COMPONENT;

COMPONENT vme_outdata_sel IS
  
	PORT
	(

		device : IN STD_LOGIC_VECTOR(9 downto 0);
		device0_outdata : IN STD_LOGIC_VECTOR(15 downto 0);
		device1_outdata : IN STD_LOGIC_VECTOR(15 downto 0);
		device2_outdata : IN STD_LOGIC_VECTOR(15 downto 0);
		device3_outdata : IN STD_LOGIC_VECTOR(15 downto 0);
		device8_outdata : IN STD_LOGIC_VECTOR(15 downto 0);
		device9_outdata : IN STD_LOGIC_VECTOR(15 downto 0);
		outdata : OUT STD_LOGIC_VECTOR(15 downto 0)
		
	);
	
END COMPONENT;


-- Device 0 => VMESTAT

-- Device 1 => CFEBJTAG

-- Device 2 => MBCJTAG

-- Device 3 => CPROMJTAG (REMOVED)			VMEMON

-- Device 4 => VPROMJTAG (REMOVED)

-- Device 5 => SERDAC

-- Device 6 => PORTCNTL

-- Device 7 => SERADC

-- Device 8 => LVDBMON

-- Device 9 => FLASHCNTRL

-- Device A => CFEBADM (NEW)

-- Device B => CFEBTKN (NEW)

-- Device C => CFEBI2C (NEW)

begin

vme_doe_b <= doe_b;

vme_doe <= not doe_b;

vme_tovme_b <= tovme_b;

vme_tovme <= not tovme_b;

vme_sysfail_out <= '0';

vme_berr_out <= '0';

vme_sysfail_out <= '0';

ext_vme_ga <= vme_gap & vme_ga;

COMMAND_PM : COMMAND_MODULE
  
PORT MAP (

    FASTCLK => clk,
    SLOWCLK => clk_s2,

	  GA => ext_vme_ga, -- gap = ga(5)
    ADR => vme_addr,
    AM => vme_am,

    AS => vme_as_b,
    DS0 => vme_ds_b(0),
    DS1 => vme_ds_b(1),
    LWORD => vme_lword_b,
    WRITER => vme_write_b,
    IACK => vme_iack_b,
    BERR => vme_berr_b,
    SYSFAIL => vme_sysfail_b,

    TOVME_B => tovme_b,
    DOE_B => doe_b,

 	  DEVICE => device,
    STROBE => strobe,
    COMMAND => cmd,
    ADRS => cmd_adrs,

    DIAGOUT => diagout_command,
    LED => led_command
    );

VME_OUT_SEL_PM : vme_outdata_sel
  	port map (

		device => device,
		device0_outdata => outdata_testctrl,
		device1_outdata => outdata_cfebjtag,
		device2_outdata => outdata_mbcjtag,
		device3_outdata => outdata_vmemon,
		device8_outdata => outdata_lvdbmon,
		device9_outdata => outdata_fifomon,
		outdata => vme_data_out
	);
	
-- Device 0 => TESTCTRL

-- Device 1 => CFEBJTAG

dl_jtag_tck <= jtag_tck;

CFEBJTAG_PM : CFEBJTAG
	PORT MAP (

    FASTCLK => clk,
    SLOWCLK => clk_s2,
    RST => rst,
    DEVICE => device(1),
    STROBE => strobe,
    COMMAND => cmd,
    WRITER => vme_write_b,

    INDATA => vme_data_in,
    OUTDATA => outdata_cfebjtag,

    DTACK => vme_dtack_b,

    INITJTAGS => '0', -- to be defined
    TCK => jtag_tck,
    TDI => dl_jtag_tdi,
    TMS => dl_jtag_tms,
    FEBTDO => dl_jtag_tdo,
	 DL_RTN_SHFT_EN => dl_rtn_shft_en,
	 UL_JTAG_TCK => jtag_tck,				
	 
    DIAGOUT => diagout_cfebjtag,
    LED => led_cfebjtag
    );

MBCJTAG_PM : MBCJTAG
  PORT MAP (

    FASTCLK => clk,
    SLOWCLK => clk_s2,
    RST => rst,
    DEVICE => device(2),
    STROBE => strobe,
    COMMAND => cmd,
    WRITER => vme_write_b,

    INDATA => vme_data_in,
    OUTDATA => outdata_mbcjtag,

    DTACK => vme_dtack_b,

    INITJTAGS => '0', -- to be defined
    TCK => mbc_jtag_tck,
    TDI => mbc_jtag_tdi,
    TMS => mbc_jtag_tms,
    MBCTDO => mbc_jtag_tdo,

    LED => led_mbcjtag
    );


LVDBMON_PM : LVDBMON
    port map(

    SLOWCLK => clk_s2,
    RST => rst,

    DEVICE => device(8),
    STROBE => strobe,
    COMMAND => cmd,
    WRITER => vme_write_b,

    INDATA => vme_data_in,
    OUTDATA => outdata_lvdbmon,

    DTACK => vme_dtack_b,

    LVADCEN => lvmb_csb,
    ADCCLK => lvmb_sclk,
    ADCDATA => lvmb_sdin,
    ADCIN => lvmb_sdout,

    LVTURNON => lvmb_pon,
    R_LVTURNON => r_lvmb_pon,
    LOADON => pon_load,
    
    DIAGLVDB => diagout_lvdbmon

    );

FIFOMON_PM : FIFOMON
  	port map (

    SLOWCLK => clk_s2,
    RST => rst,

    DEVICE => device(9),
    STROBE => strobe,
    COMMAND => cmd,

    INDATA => vme_data_in,
    OUTDATA => outdata_fifomon,

    DTACK => vme_dtack_b,

    FIFO_WR_EN => tfifo_wr_en, 
    FIFO_RD_EN => tfifo_rd_en, 
    FIFO_SEL => tfifo_sel,
    FIFO_MODE => tfifo_mode,
    FIFO_DATA => tfifo_data,
    FIFO_STR => tfifo_str,
    FIFO_WRC => tfifo_wc,
    FIFO_RDC => tfifo_rc


);

TESTCTRL_PM : TESTCTRL
  generic map (NFEB => NFEB)
 	port map (

    CLK => clk,
    SLOWCLK => clk_s2,
    RST => rst,

    DEVICE => device(0),
    STROBE => strobe,
    COMMAND => cmd,

    INDATA => vme_data_in,
    OUTDATA => outdata_testctrl,
    
    DTACK => vme_dtack_b,
 
    L1A => TC_L1A,
    ALCT_DAV => TC_ALCT_DAV,
    TMB_DAV => TC_TMB_DAV,
    LCT => TC_LCT,
    DDU_DATA => DDU_DATA,
    DDU_DATA_VALID => DDU_DATA_VALID,
    TC_RUN => TC_RUN
   
    );

VMEMON_PM : VMEMON
 	port map (

    SLOWCLK => clk_s2,
    RST => rst,

    DEVICE => device(3),
    STROBE => strobe,
    COMMAND => cmd,

    INDATA => vme_data_in,
    OUTDATA => outdata_vmemon,

    DTACK => vme_dtack_b,

    FLFCTRL => flf_ctrl,
    FLFDATA => flf_data
 
 );

-- From/To LVMB

-- lvmb_pon <= "00000000";
-- pon_load <= '0';
pon_oe_b <= '0';
-- lvmb_csb <= "0000000";		
-- lvmb_sclk <= '0';
-- lvmb_sdin <= '0';			


-- To/From O-DMB ADC

adc_cs <= '0';
adc_sclk <= '0';									
adc_sdain <= '0';									

-- To/From O-DMB DAC

dac_cs <= '0';
dac_sclk <= '0';									
dac_sdain <= '0';									
		
-- To/From DCFEB FIFOs

fifo_wr_ck <= '0';
fifo_wr_en <= "000000000";
fifo_rw_en <= "000000000";
fifo_rm_en <= "000000000";	
fifo_tm_en <= "000000000";		

fifo_in <= (others => '0');				

-- To/From DCFEB ADCs and DACs

dl_spi_cs0 <= "0000000";		
dl_spi_cs1 <= "0000000";			
dl_spi_scl <= "0000000";
dl_spi_sda <= "0000000";			 

-- Token To/From DCFEB FF-EMU 

dl_tkn <= "0000000";				

-- I2C control signals To/From DCFEB FF-EMU (CFEBI2C)

dl_i2c_scl <= "0000000";				
dl_i2c_sda <= "0000000";			

-- reprogram To DCFEB FPGA (CFEBPRG)

dl_reprogram <= "0000000";

-- From/To QPLL

qpll_autorestart <= '0';						
qpll_mode <= '0';									
qpll_extcontrol <= '0';									
qpll_reset <= '0';										
qpll_f0sel <= "0000";		

end ODMB_VME_architecture;

