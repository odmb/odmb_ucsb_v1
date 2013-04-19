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

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;
library UNISIM;
use UNISIM.vcomponents.all;
use UNISIM.VPKG.all;
library UNIMACRO;
use UNIMACRO.vcomponents.all;
library work;
--USE work.Latches_Flipflops.all;


entity ODMB_V6 is
  generic (
    NFEB : integer range 1 to 7 := 7  -- Number of DCFEBS, 7 in the final design
    );  
  port
    (

-- From/To VME connector To/From MBV

      vme_data        : inout std_logic_vector(15 downto 0);  -- OK           d(15 DOWNTO 0)
      vme_addr        : in    std_logic_vector(23 downto 1);  -- OK           a(23 DOWNTO 1)
      vme_am          : in    std_logic_vector(5 downto 0);  -- OK           am(6 DOWNTO 0)
      vme_gap         : in    std_logic;  -- OK           gap = ga(5)
      vme_ga          : in    std_logic_vector(4 downto 0);  -- OK           ga(4 DOWNTO 0)
      vme_bg0         : in    std_logic;  -- OK           NEW!
      vme_bg1         : in    std_logic;  -- OK           NEW!
      vme_bg2         : in    std_logic;  -- OK           NEW!
      vme_bg3         : in    std_logic;  -- OK           NEW!
      vme_as_b        : in    std_logic;  -- OK           as*
      vme_ds_b        : in    std_logic_vector(1 downto 0);  -- OK           ds1*,ds0*
      vme_sysreset_b  : in    std_logic;  -- OK           sysreset*
      vme_sysfail_b   : in    std_logic;  -- OK           sysfail*
      vme_sysfail_out : out   std_logic;  -- OK           NEW!
      vme_berr_b      : in    std_logic;  -- OK           berr*
      vme_berr_out    : out   std_logic;  -- OK           NEW!
      vme_iack_b      : in    std_logic;  -- OK           iack*
      vme_lword_b     : in    std_logic;  -- OK           lword*
      vme_write_b     : in    std_logic;  -- OK           write*
      vme_clk         : in    std_logic;  -- OK           ???
      vme_dtack_v6_b  : inout std_logic;  -- OK           dtack*
      vme_tovme       : out   std_logic;  -- OK           not (tovme)
      vme_doe         : out   std_logic;  -- OK           not (doe*)

-- From/To J6 (J3) connector to ODMB_CTRL

      ccb_cmd    : in  std_logic_vector(5 downto 0);  -- OK           ccbcmnd(5 DOWNTO 0)
      ccb_cmd_s  : in  std_logic;       -- OK           ccbcmnd(6)
      ccb_data   : in  std_logic_vector(7 downto 0);  -- OK           ccbdata(7 DOWNTO 0)
      ccb_data_s : in  std_logic;       -- OK           ccbdata(8)
      ccb_cal    : in  std_logic_vector(2 downto 0);  -- OK           ccbcal(14 DOWNTO 12)
      ccb_crsv   : in  std_logic_vector(4 downto 0);  -- OK           nc (J3/B2), ccbrsv(3 DOWNTO 0) = crsv(3 DOWNTO 0)
      ccb_drsv   : in  std_logic_vector(1 downto 0);  -- OK           ccbrsv(5 DOWNTO 4) = drsv(1 DOWNTO 0)
      ccb_rsvo   : in  std_logic_vector(4 downto 0);  -- OK           nc (J3/A21), ccbsrv(10 DOWNTO 7) = rsvo(3 DOWNTO 0)
      ccb_rsvi   : out std_logic_vector(2 downto 0);  -- OK           ccbsrv(14 DOWNTO 12)
      ccb_bx0    : in  std_logic;       -- OK           bx0
      ccb_bxrst  : in  std_logic;       -- OK           bxrst
      ccb_l1arst : in  std_logic;       -- OK           l1arst
      ccb_l1acc  : in  std_logic;       -- OK           l1acc
      ccb_l1rls  : out std_logic;       -- OK           l1rls
      ccb_clken  : in  std_logic;       -- OK           clkena

      ccb_hardrst : in std_logic;       -- OK           
      ccb_softrst : in std_logic;       -- OK           

-- From J6/J7 (J3/J4) to FIFOs

      tmb      : in std_logic_vector(17 downto 0);  -- OK           f6di(17 DOWNTO 0)
      alct     : in std_logic_vector(17 downto 0);  -- OK           f7di(17 DOWNTO 0)
      rawlct   : in std_logic_vector(NFEB downto 0);  -- OK           ???
      tmbffclk : in std_logic;          -- OK           tmbffclk

-- From/To J3/J4 t/fromo ODMB_CTRL

      lctdav1   : in  std_logic;        -- OK           lctdav1
      lctdav2   : in  std_logic;        -- OK           lctdav2
--              rsvtd : INOUT STD_LOGIC_VECTOR(7 DOWNTO 0);                     
      rsvtd_in  : in  std_logic_vector(4 downto 0);  -- OK           rstvd(7 DOWNTO 4)
      rsvtd_out : out std_logic_vector(2 downto 0);  -- OK           rstvd(2 DOWNTO 0)
      lctrqst   : out std_logic_vector(2 downto 1);  -- OK           lctrqst(2 DOWNTO 1)

-- From/To QPLL (From/To DAQMBV)

      qpll_autorestart : out std_logic;  -- OK           NEW!
      qpll_mode        : out std_logic;  -- OK           NEW!
      qpll_extcontrol  : out std_logic;  -- OK           NEW!
      qpll_reset       : out std_logic;  -- OK           NEW!
      qpll_f0sel       : out std_logic_vector(3 downto 0);  -- OK           NEW!
      qpll_locked      : in  std_logic;  -- OK           NEW!
      qpll_error       : in  std_logic;  -- OK           NEW!

      qpll_clk40MHz_p : in std_logic;   -- OK           NEW!
      qpll_clk40MHz_n : in std_logic;   -- OK           NEW!
      qpll_clk80MHz_p : in std_logic;   -- OK           NEW!
      qpll_clk80MHz_n : in std_logic;   -- OK           NEW!
--              qpll_clk160MHz_p : IN STD_LOGIC;                                                        -- NEW!
--              qpll_clk160MHz_n : IN STD_LOGIC;                                                        -- NEW!

-- From/To LVMB (From/To DAQMBV and DAQMBC)

      lvmb_pon   : out std_logic_vector(7 downto 0);  -- OK           pwon(6 DOWNTO 1)
      pon_load   : out std_logic;       -- OK           loadpwon
      pon_en     : out std_logic;       -- OK           pwon_en*
      r_lvmb_pon : in  std_logic_vector(7 downto 0);  -- OK           multi(6 DOWNTO 1) (r_pwon(6 DOWNTO 1))
      lvmb_csb   : out std_logic_vector(6 downto 0);  -- OK           multi(13 DOWNTO 7)
      lvmb_sclk  : out std_logic;       -- OK           multi(14)
      lvmb_sdin  : out std_logic;       -- OK           multi(15)
      lvmb_sdout : in  std_logic;       -- OK           multi(16)

-- From/To ADC (From/To DAQMBV)

      adc_sclk   : out std_logic;       -- OK           NEW!
      adc_sdain  : out std_logic;       -- OK           NEW!
      adc_sdaout : in  std_logic;       -- OK           NEW!
      adc_cs     : out std_logic;       -- OK           NEW!

-- From/To DAC (From/To DAQMBV)

      dac_sclk   : out std_logic;       -- OK           NEW!
      dac_sdain  : out std_logic;       -- OK           NEW!
      dac_sdaout : in  std_logic;       -- OK           NEW!
      dac_cs     : out std_logic;       -- OK           NEW!

-- To LEDs

      leds : out std_logic_vector(11 downto 0);  -- OK           NEW!    

-- To Frequency Divider FF

      fd_pre : out std_logic;           -- OK           NEW!    
      fd_clr : out std_logic;           -- OK           NEW!    

-- From Push Buttons

      pb : in std_logic_vector(3 downto 0);  -- OK

-- From/To Test Connector for Single-Ended signals

--              d : INOUT STD_LOGIC_VECTOR(63 DOWNTO 0);        -- OK           
      d : out std_logic_vector(63 downto 0);  -- OK           


-- From/To Test Connector J3 for LVDS signals

      gtx_0_p : in  std_logic;          -- OK                   
      gtx_0_n : in  std_logic;          -- OK                   
      grx_0_p : out std_logic;          -- OK (out)                     
      grx_0_n : out std_logic;          -- OK (out)                     

      ck_0_p : in  std_logic;           -- OK                   
      ck_0_n : in  std_logic;           -- OK                   
      ck_1_p : in  std_logic;           -- OK                   
      ck_1_n : in  std_logic;           -- OK                   
      tclk_p : in  std_logic;           -- OK                   
      tclk_n : in  std_logic;           -- OK                   
      rxb_p  : out std_logic;           -- OK                   
      rxb_n  : out std_logic;           -- OK                   

      tx_0_p  : out std_logic;          -- OK                   
      tx_0_n  : out std_logic;          -- OK                   
      tx_1_p  : out std_logic;          -- OK                   
      tx_1_n  : out std_logic;          -- OK                   
      tx_2_p  : out std_logic;          -- OK                   
      tx_2_n  : out std_logic;          -- OK                   
      tx_3_p  : out std_logic;          -- OK                   
      tx_3_n  : out std_logic;          -- OK                   
      tx_4_p  : out std_logic;          -- OK                   
      tx_4_n  : out std_logic;          -- OK                   
      tx_5_p  : out std_logic;          -- OK                   
      tx_5_n  : out std_logic;          -- OK                   
      tx_6_p  : out std_logic;          -- OK                   
      tx_6_n  : out std_logic;          -- OK                   
      tx_7_p  : out std_logic;          -- OK                   
      tx_7_n  : out std_logic;          -- OK                   
      tx_8_p  : out std_logic;          -- OK                   
      tx_8_n  : out std_logic;          -- OK                   
      tx_9_p  : out std_logic;          -- OK                   
      tx_9_n  : out std_logic;          -- OK                   
      tx_10_p : out std_logic;          -- OK                   
      tx_10_n : out std_logic;          -- OK                   

      rx_0_p  : in std_logic;           -- OK           
      rx_0_n  : in std_logic;           -- OK                   
      rx_1_p  : in std_logic;           -- OK                           
      rx_1_n  : in std_logic;           -- OK                           
      rx_2_p  : in std_logic;           -- OK                           
      rx_2_n  : in std_logic;           -- OK                           
      rx_3_p  : in std_logic;           -- OK                           
      rx_3_n  : in std_logic;           -- OK                           
      rx_4_p  : in std_logic;           -- OK                   
      rx_4_n  : in std_logic;           -- OK                   
      rx_5_p  : in std_logic;           -- OK                           
      rx_5_n  : in std_logic;           -- OK                           
      rx_6_p  : in std_logic;           -- OK                           
      rx_6_n  : in std_logic;           -- OK                           
      rx_7_p  : in std_logic;           -- OK                           
      rx_7_n  : in std_logic;           -- OK                           
      rx_8_p  : in std_logic;           -- OK                   
      rx_8_n  : in std_logic;           -- OK                   
      rx_9_p  : in std_logic;           -- OK                           
      rx_9_n  : in std_logic;           -- OK                           
      rx_10_p : in std_logic;           -- OK                           
      rx_10_n : in std_logic;           -- OK                           

-- To/From TX1 

      otx1_p : out std_logic_vector(12 downto 1);               
      otx1_n : out std_logic_vector(12 downto 1);               
      otx1_tx_en  : out std_logic;      
      otx1_tx_dis : out std_logic;      
      otx1_reset  : out std_logic;      
      otx1_fault  : in  std_logic;      

-- To/From TX2 

      otx2_p : out std_logic_vector(12 downto 1);               
      otx2_n : out std_logic_vector(12 downto 1);               
      otx2_tx_en  : out std_logic;         
      otx2_tx_dis : out std_logic;         
      otx2_reset  : out std_logic;        
      otx2_fault  : in  std_logic;        

-- From/To RX1 

      orx1_p : in std_logic_vector(12 downto 1);               
      orx1_n : in std_logic_vector(12 downto 1);               
      orx1_rx_en : out std_logic;       
      orx1_en_sd : out std_logic;       
      orx1_sd    : in  std_logic;       
      orx1_sq_en : out std_logic;       

-- From/To RX2 

      orx2_p : in std_logic_vector(12 downto 1);               
      orx2_n : in std_logic_vector(12 downto 1);               
      orx2_rx_en : out std_logic;          
      orx2_en_sd : out std_logic;          
      orx2_sd    : in  std_logic;        
      orx2_sq_en : out std_logic;          

-- From/To OT1 (GigaBit Link)

      gl0_tx_p : out std_logic;         -- OK
      gl0_tx_n : out std_logic;         -- OK
      gl0_rx_p : in  std_logic;         -- OK
      gl0_rx_n : in  std_logic;         -- OK

-- From/To OT2 (GigaBit Link)

      gl1_tx_p : out std_logic;         -- OK
      gl1_tx_n : out std_logic;         -- OK
      gl1_rx_p : in  std_logic;         -- OK
      gl1_rx_n : in  std_logic;         -- OK

-- From IC7 (Clock Driver CDC)

      cdc_clk_0_p : in std_logic;       -- OK
      cdc_clk_0_n : in std_logic;       -- OK
      cdc_clk_1_p : in std_logic;       -- OK
      cdc_clk_1_n : in std_logic;       -- OK
      cdc_clk_2_p : in std_logic;       -- OK
      cdc_clk_2_n : in std_logic;       -- OK
      cdc_clk_3_p : in std_logic;       -- OK
      cdc_clk_3_n : in std_logic;       -- OK
      cdc_clk_4_p : in std_logic;       -- OK
      cdc_clk_4_n : in std_logic;       -- OK
      cdc_clk_5_p : in std_logic;       -- OK
      cdc_clk_5_n : in std_logic;       -- OK
      cdc_clk_6_p : in std_logic;       -- OK
      cdc_clk_6_n : in std_logic;       -- OK
      cdc_clk_7_p : in std_logic;       -- OK
      cdc_clk_7_n : in std_logic;       -- OK

-- From IC31 

      gl0_clk : in std_logic;           -- OK
      gl1_clk : in std_logic;           -- OK

      done_in : in std_logic
      );
end ODMB_V6;

architecture bdf_type of ODMB_V6 is

  component alct_tmb_data_gen is
    port(

      clk            : in  std_logic;
      rst            : in  std_logic;
      l1a            : in  std_logic;
      alct_l1a_match : in  std_logic;
      tmb_l1a_match  : in  std_logic;
      alct_dv        : out std_logic;
      alct_data      : out std_logic_vector(15 downto 0);
      tmb_dv         : out std_logic;
      tmb_data       : out std_logic_vector(15 downto 0));

  end component;


  component fifo_wc_sel is
    
    port (

      fifo_sel : in  std_logic_vector(7 downto 0);
      fifo0_wc : in  std_logic_vector(9 downto 0);
      fifo1_wc : in  std_logic_vector(9 downto 0);
      fifo2_wc : in  std_logic_vector(9 downto 0);
      fifo3_wc : in  std_logic_vector(9 downto 0);
      fifo4_wc : in  std_logic_vector(9 downto 0);
      fifo5_wc : in  std_logic_vector(9 downto 0);
      fifo6_wc : in  std_logic_vector(9 downto 0);
      fifo7_wc : in  std_logic_vector(9 downto 0);
      fifo_wc  : out std_logic_vector(9 downto 0));

  end component;

  component fifo_rc_sel is
    
    port (

      fifo_sel : in  std_logic_vector(7 downto 0);
      fifo0_rc : in  std_logic_vector(9 downto 0);
      fifo1_rc : in  std_logic_vector(9 downto 0);
      fifo2_rc : in  std_logic_vector(9 downto 0);
      fifo3_rc : in  std_logic_vector(9 downto 0);
      fifo4_rc : in  std_logic_vector(9 downto 0);
      fifo5_rc : in  std_logic_vector(9 downto 0);
      fifo6_rc : in  std_logic_vector(9 downto 0);
      fifo7_rc : in  std_logic_vector(9 downto 0);
      fifo_rc  : out std_logic_vector(9 downto 0));

  end component;

  component fifo_outdata_sel is
    
    port (

      fifo_sel      : in  std_logic_vector(7 downto 0);
      fifo0_outdata : in  std_logic_vector(15 downto 0);
      fifo1_outdata : in  std_logic_vector(15 downto 0);
      fifo2_outdata : in  std_logic_vector(15 downto 0);
      fifo3_outdata : in  std_logic_vector(15 downto 0);
      fifo4_outdata : in  std_logic_vector(15 downto 0);
      fifo5_outdata : in  std_logic_vector(15 downto 0);
      fifo6_outdata : in  std_logic_vector(15 downto 0);
      fifo7_outdata : in  std_logic_vector(15 downto 0);
      fifo_outdata  : out std_logic_vector(15 downto 0));

  end component;

  component daq_optical_out is
    generic (
      USE_CHIPSCOPE : integer := 1;
      SIM_SPEEDUP   : integer := 1
      );
    port (
      DAQ_TX_VIO_CNTRL     : inout std_logic_vector(35 downto 0);  --Chip Scope Pro control signals for virtual I/O
      DAQ_TX_LA_CNTRL      : inout std_logic_vector(35 downto 0);  --Chip Scope Pro control signals for logic analyzer
      RST                  : in    std_logic;
      -- External signals
      DAQ_RX_N             : in    std_logic;  -- GTX receive data in - signal
      DAQ_RX_P             : in    std_logic;  -- GTX receive data in + signal
      DAQ_TDIS             : out   std_logic;  -- optical transceiver transmit disable signal
      DAQ_TX_N             : out   std_logic;  -- GTX transmit data out - signal
      DAQ_TX_P             : out   std_logic;  -- GTX transmit data out + signal
      -- Reference clocks ideally straight from the IBUFDS_GTXE1 output 
      DAQ_TX_125REFCLK     : in    std_logic;  -- 125 MHz for 1 GbE
      DAQ_TX_125REFCLK_DV2 : in    std_logic;  -- 62.5 MHz user clock for 1 GbE
      DAQ_TX_160REFCLK     : in    std_logic;  -- 160 MHz for  2.56 GbE
      -- Internal signals
      L1A_MATCH            : in    std_logic;  -- Currently only for logic analyzer input
      TXD                  : in    std_logic_vector(15 downto 0);  -- Data to be transmitted
      TXD_VLD              : in    std_logic;  -- Flag for valid data; initiates data transfer
      JDAQ_RATE            : in    std_logic;  -- requested DAQ rate from JTAG interface
      RATE_1_25            : out   std_logic;  -- Flag to indicate 1.25 Gbps line rate operation
      RATE_3_2             : out   std_logic;  -- Flag to indicate 3.2 Gbps line rate operation
      TX_ACK               : out   std_logic;  -- Handshake signal indicates preamble has been sent, data flow should start
      DAQ_DATA_CLK         : out   std_logic  -- Clock that should be used for passing data and controls to this module    
      );
  end component;

  component dmb_receiver is
    generic (
      USE_2p56GbE : integer := 0;
      SIM_SPEEDUP : integer := 0
      );
    port (
      -- Chip Scope Pro Logic Analyzer control -- bgb
      CSP_GTX_MAC_LA_CTRL : inout std_logic_vector(35 downto 0);
      CSP_PKT_FRM_LA_CTRL : inout std_logic_vector(35 downto 0);
      CSP_FIFO_LA_CTRL    : inout std_logic_vector(35 downto 0);

      --External signals
      RST              : in  std_logic;
      ORX2_01_N        : in  std_logic;
      ORX2_01_P        : in  std_logic;
      ORX2_02_N        : in  std_logic;
      ORX2_02_P        : in  std_logic;
      ORX2_03_N        : in  std_logic;
      ORX2_03_P        : in  std_logic;
      ORX2_04_N        : in  std_logic;
      ORX2_04_P        : in  std_logic;
      ORX2_05_N        : in  std_logic;
      ORX2_05_P        : in  std_logic;
      ORX2_06_N        : in  std_logic;
      ORX2_06_P        : in  std_logic;
      ORX2_07_N        : in  std_logic;
      ORX2_07_P        : in  std_logic;
      ORX2_08_N        : in  std_logic;
      ORX2_08_P        : in  std_logic;
      ORX2_09_N        : in  std_logic;
      ORX2_09_P        : in  std_logic;
      ORX2_10_N        : in  std_logic;
      ORX2_10_P        : in  std_logic;
      ORX2_11_N        : in  std_logic;
      ORX2_11_P        : in  std_logic;
      ORX2_12_N        : in  std_logic;
      ORX2_12_P        : in  std_logic;
      DCFEB1_DATA      : out std_logic_vector(15 downto 0);
      DCFEB2_DATA      : out std_logic_vector(15 downto 0);
      DCFEB3_DATA      : out std_logic_vector(15 downto 0);
      DCFEB4_DATA      : out std_logic_vector(15 downto 0);
      DCFEB5_DATA      : out std_logic_vector(15 downto 0);
      DCFEB6_DATA      : out std_logic_vector(15 downto 0);
      DCFEB7_DATA      : out std_logic_vector(15 downto 0);
      DCFEB_DATA_VALID : out std_logic_vector(NFEB downto 1);

      --Internal signals
      FIFO_VME_MODE          : in  std_logic;
      FIFO_SEL               : in  std_logic_vector(8 downto 1);
      RD_EN_FF               : in  std_logic_vector(8 downto 1);
      WR_EN_FF               : in  std_logic_vector(8 downto 1);
      FF_DATA_IN             : in  std_logic_vector(15 downto 0);
      FF_DATA_OUT            : out std_logic_vector(15 downto 0);
      FF_WRD_CNT             : out std_logic_vector(11 downto 0);
      FF_STATUS              : out std_logic_vector(15 downto 0);
      DMBVME_CLK_S2          : in  std_logic;
      DAQ_RX_125REFCLK       : in  std_logic;
      DAQ_RX_160REFCLK_115_0 : in  std_logic
      );
  end component;


  component mode_pb_sel is
    port (

      pb0      : in  std_logic;
      pb1      : in  std_logic;
      pb2      : in  std_logic;
      pb3      : in  std_logic;
      pb_reset : out std_logic;
      lb_en    : out std_logic;
      lb_ff_en : out std_logic;
      tm_en    : out std_logic
      );
  end component;


  component LVMB_ADC_SDO_MUX is
    port (
      int_lvmb_adc_en  : in  std_logic;
      int_lvmb_adc_sdo : in  std_logic_vector(6 downto 0);
      lvmb_adc_sdo     : in  std_logic;
      adc_ce           : in  std_logic_vector(6 downto 0);
      sdo              : out std_logic
      );
  end component;

  component LVMB_ADC is
    port (

      scl    : in    std_logic;
      sdi    : in    std_logic;
      sdo    : inout std_logic;
      ce     : in    std_logic;
      rst    : in    std_logic;
      device : in    std_logic_vector(3 downto 0)
      );
  end component;

  component DCFEB_V6 is
    generic (
      dcfeb_addr : std_logic_vector(3 downto 0) := "1000"  -- DCFEB address
      );  
    port
      (clk           : in  std_logic;
       clk80           : in  std_logic;
       rst           : in  std_logic;
       l1a           : in  std_logic;
       l1a_match     : in  std_logic;
       tx_ack        : in  std_logic;
       dcfeb_dv      : out std_logic;
       dcfeb_data    : out std_logic_vector(15 downto 0);
       adc_mask      : out std_logic_vector(11 downto 0);
       dcfeb_fsel    : out std_logic_vector(32 downto 0);
       dcfeb_jtag_ir : out std_logic_vector(9 downto 0);
       trst          : in  std_logic;
       tck           : in  std_logic;
       tms           : in  std_logic;
       tdi           : in  std_logic;
       rtn_shft_en   : out std_logic;
       tdo           : out std_logic);
  end component;

  component ODMB_CTRL is
    port (
      ga : in std_logic_vector(4 downto 0);

      mbc_fsel    : out std_logic_vector(47 downto 1);
      mbc_jtag_ir : out std_logic_vector(9 downto 0);

      ccb_cmd    : in  std_logic_vector (5 downto 0);  -- ccbcmnd(5 downto 0) - from J3
      ccb_cmd_s  : in  std_logic;       -- ccbcmnd(6) - from J3
      ccb_data   : in  std_logic_vector (7 downto 0);  -- ccbdata(7 downto 0) - from J3
      ccb_data_s : in  std_logic;       -- ccbdata(8) - from J3
      ccb_cal    : in  std_logic_vector (2 downto 0);  -- ccbcal(2 downto 0) - from J3
      ccb_crsv   : in  std_logic_vector (4 downto 0);  -- NEW [ccbrsv(6)], ccbrsv(3 downto 0) - from J3
      ccb_drsv   : in  std_logic_vector (1 downto 0);  -- ccbrsv(5 downto 4) - from J3
      ccb_rsvo   : in  std_logic_vector (4 downto 0);  -- NEW [ccbrsv(11)], ccbrsv(10 downto 7) - from J3
      ccb_rsvi   : out std_logic_vector (2 downto 0);  -- ccbrsv(14 downto 12) - to J3
      ccb_bx0    : in  std_logic;       -- bx0 - from J3
      ccb_bxrst  : in  std_logic;       -- bxrst - from J3
      ccb_l1acc  : in  std_logic;       -- l1acc - from J3
      ccb_l1arst : in  std_logic;       -- l1rst - from J3
      ccb_l1rls  : out std_logic;       -- l1rls - to J3
      ccb_clken  : in  std_logic;       -- clken - from J3

      rawlct    : in  std_logic_vector (NFEB downto 0);  -- rawlct(5 downto 0) - from J4
      alct_dav  : in  std_logic;        -- lctdav1 - from J4
      tmb_dav   : in  std_logic;        -- lctdav2 - from J4
      lctrqst   : out std_logic_vector (2 downto 1);  -- lctrqst(2 downto 1) - to J4
      rsvtd_in  : in  std_logic_vector(4 downto 0);  -- spare(7 DOWNTO 3) - to J4
      rsvtd_out : out std_logic_vector(2 downto 0);  -- spare(2 DOWNTO 0) - from J4

-- From GigaLinks

      grx0_data       : in std_logic_vector(15 downto 0);  -- glin(15 downto 0)                                                                      
      grx0_data_valid : in std_logic;
      grx1_data       : in std_logic_vector(15 downto 0);  -- glin(15 downto 0)                                                                                      
      grx1_data_valid : in std_logic;

-- From GigaLinks

      gtx0_data       : out std_logic_vector(15 downto 0);  -- dout(15 downto 0)                                                                                      
      gtx0_data_valid : out std_logic;
      gtx1_data       : out std_logic_vector(15 downto 0);  -- dout(15 downto 0)                                                                                      
      gtx1_data_valid : out std_logic;

-- From/To FIFOs

      fifo_rd_ck   : out std_logic;
      data_fifo_re : out std_logic_vector(NFEB+2 downto 1);
      data_fifo_oe : out std_logic_vector(NFEB+2 downto 1);

      fifo_out : in std_logic_vector(15 downto 0);

      fifo_mrst_b : out std_logic;      -- ok -> fifo_mrst* - to FIFOs 
      fifo_prst_b : out std_logic;      -- ok -> fifo_pst* - to FIFOs 

      fifo_full_b  : in std_logic_vector(NFEB+2 downto 1);  -- full*(7 DOWNTO 1) - from FIFOs 
      fifo_half_b  : in std_logic_vector(NFEB+2 downto 1);  -- half*(7 DOWNTO 1) - from FIFOs 
      fifo_pae_b   : in std_logic_vector(NFEB+2 downto 1);  -- paef*(7 DOWNTO 1) - from FIFOs 
      fifo_empty_b : in std_logic_vector(NFEB+2 downto 1);  -- emptyf*(7 DOWNTO 1) - from FIFOs 

-- From CAFIFO to Data FIFOs
      dcfeb_fifo_wr_en : out std_logic_vector(NFEB downto 1);
      alct_fifo_wr_en  : out std_logic;
      tmb_fifo_wr_en   : out std_logic;
      cafifo_l1a_match : out std_logic_vector(NFEB+2 downto 0);  -- L1A_MATCH from TRGCNTRL to CAFIFO sent to generate Data  

-- From ALCT,TMB,DCFEBs to CAFIFO
      alct_dv     : in std_logic;
      tmb_dv      : in std_logic;
      dcfeb0_dv   : in std_logic;
      dcfeb0_data : in std_logic_vector(15 downto 0);
      dcfeb1_dv   : in std_logic;
      dcfeb1_data : in std_logic_vector(15 downto 0);
      dcfeb2_dv   : in std_logic;
      dcfeb2_data : in std_logic_vector(15 downto 0);
      dcfeb3_dv   : in std_logic;
      dcfeb3_data : in std_logic_vector(15 downto 0);
      dcfeb4_dv   : in std_logic;
      dcfeb4_data : in std_logic_vector(15 downto 0);
      dcfeb5_dv   : in std_logic;
      dcfeb5_data : in std_logic_vector(15 downto 0);
      dcfeb6_dv   : in std_logic;
      dcfeb6_data : in std_logic_vector(15 downto 0);

-- From/To DCFEBs (FF-EMU-MOD)

      ul_dav   : in std_logic_vector(6 downto 0);  -- davf(5 DOWNTO 1) - from DCFEBs 
      ul_movlp : in std_logic_vector(6 downto 0);  -- movlp(5 DOWNTO 1) - from DCFEBs

      dcfeb_injpulse  : out std_logic;  -- inject - to DCFEBs
      dcfeb_extpulse  : out std_logic;  -- extpulse - to DCFEBs
      dcfeb_l1a       : out std_logic;
      dcfeb_l1a_match : out std_logic_vector(NFEB downto 1);

-- From/To LVMB

      r_lvmb_pon : in std_logic_vector(7 downto 0);
      lvmb_csb   : in std_logic_vector(6 downto 0);
      lvmb_sclk  : in std_logic;
      lvmb_sdin  : in std_logic;
      lvmb_sdout : in std_logic;

      clk40 : in std_logic;
      clk80 : in std_logic;
      reset : in std_logic;

      tck : in  std_logic;
      tdi : in  std_logic;
      tms : in  std_logic;
      tdo : out std_logic;

      test_ccbinj : in std_logic;
      test_ccbpls : in std_logic;

      leds : out std_logic_vector(5 downto 0)

      );

  end component;

  component ODMB_VME is
    port (

-- VME signals

      vme_addr        : in  std_logic_vector (23 downto 1);  -- adr(23 downto 1)
      vme_data_in     : in  std_logic_vector (15 downto 0);  -- data_in(15 downto 0)
      vme_data_out    : out std_logic_vector (15 downto 0);  -- data_out(15 downto 0)
      vme_am          : in  std_logic_vector (5 downto 0);  -- am(5 downto 0)
      vme_ga          : in  std_logic_vector (4 downto 0);  -- iga(4 downto 0) -> ga*(4 downto 0)
      vme_gap         : in  std_logic;  -- iga(5) -> ga*(5)
      vme_ds_b        : in  std_logic_vector(1 downto 0);  -- ids1* -> ds1*, ids0* -> ds0*
      vme_as_b        : in  std_logic;  -- ias* -> as*
      vme_lword_b     : in  std_logic;  -- ilword* -> lword*
      vme_write_b     : in  std_logic;  -- iwrite* -> write*
      vme_iack_b      : in  std_logic;  -- inack* -> iack*
      vme_sysreset_b  : in  std_logic;  -- isysrst* -> sysrest*
      vme_sysfail_b   : in  std_logic;  -- isysfail* -> sysfail
      vme_sysfail_out : out std_logic;  -- NEW (N.1)
      vme_berr_b      : in  std_logic;  -- iberr* -> berr*
      vme_berr_out    : out std_logic;  -- NEW (N.1)
      vme_dtack_b     : out std_logic;  -- dtack* -> odtack*
      vme_tovme       : out std_logic;  -- tovme
      vme_tovme_b     : out std_logic;  -- tovme*
      vme_doe         : out std_logic;  -- doe
      vme_doe_b       : out std_logic;  -- doe*

-- Clock

      clk    : in std_logic;            -- fpgaclk (40MHz)
      clk_s1 : in std_logic;            -- midclk (10MHz) 
      clk_s2 : in std_logic;            -- slowclk (2.5MHz)
      clk_s3 : in std_logic;            -- slowclk2 (1.25MHz)

-- Reset

      rst : in std_logic;               -- iglobalrst

-- JTAG signals To/From DCFEBs

      dl_jtag_tck    : out std_logic_vector (6 downto 0);
      dl_jtag_tms    : out std_logic;
      dl_jtag_tdi    : out std_logic;
      dl_jtag_tdo    : in  std_logic_vector (6 downto 0);
      dl_rtn_shft_en : in  std_logic_vector (6 downto 0);
      ul_jtag_tck    : in  std_logic_vector (6 downto 0);
      ul_jtag_tms    : in  std_logic_vector (6 downto 0);
      ul_jtag_tdi    : in  std_logic_vector (6 downto 0);

-- JTAG Signals To/From ODMB_CTRL

      mbc_jtag_tck : out std_logic;
      mbc_jtag_tms : out std_logic;
      mbc_jtag_tdi : out std_logic;
      mbc_jtag_tdo : in  std_logic;

-- reprogram To DCFEB FPGA (CFEBPRG)

      dl_reprogram : out std_logic_vector(6 downto 0);

-- Done from DCFEB FPGA (CFEBPRG)

      ul_done : in std_logic_vector(6 downto 0);


-- To/From O-DMB ADC

      adc_cs     : out std_logic;
      adc_sclk   : out std_logic;
      adc_sdain  : out std_logic;
      adc_sdaout : in  std_logic;

-- To/From O-DMB DAC

      dac_cs     : out std_logic;
      dac_sclk   : out std_logic;
      dac_sdain  : out std_logic;
      dac_sdaout : in  std_logic;

-- To/From DCFEB FIFOs

      fifo_wr_ck : out std_logic;
      fifo_wr_en : out std_logic_vector (9 downto 1);
      fifo_rw_en : out std_logic_vector (9 downto 1);
      fifo_rm_en : out std_logic_vector (9 downto 1);
      fifo_tm_en : out std_logic_vector (9 downto 1);

      fifo_in  : out std_logic_vector (15 downto 0);
      fifo_out : in  std_logic_vector (15 downto 0);

-- To/From DCFEB ADCs and DACs

      dl_spi_cs0  : out std_logic_vector(6 downto 0);
      dl_spi_cs1  : out std_logic_vector(6 downto 0);
      dl_spi_scl  : out std_logic_vector(6 downto 0);
      dl_spi_sda  : out std_logic_vector(6 downto 0);
      ul_spi_scl  : in  std_logic_vector(6 downto 0);
      ul_spi_sda  : in  std_logic_vector(6 downto 0);
      ul_spi_busy : in  std_logic_vector(6 downto 0);

-- Token To/From DCFEB FF-EMU 

      dl_tkn : out std_logic_vector(6 downto 0);
      ul_tkn : in  std_logic_vector(6 downto 0);

-- I2C control signals To/From DCFEB FF-EMU (CFEBI2C)

      dl_i2c_scl : out std_logic_vector(6 downto 0);
      dl_i2c_sda : out std_logic_vector(6 downto 0);
      ul_i2c_scl : in  std_logic_vector(6 downto 0);
      ul_i2c_sda : in  std_logic_vector(6 downto 0);

-- From/To QPLL

      qpll_autorestart : out std_logic;
      qpll_mode        : out std_logic;
      qpll_extcontrol  : out std_logic;
      qpll_reset       : out std_logic;
      qpll_f0sel       : out std_logic_vector(3 downto 0);
      qpll_locked      : in  std_logic;
      qpll_error       : in  std_logic;

-- From/To LVMB

      lvmb_pon   : out std_logic_vector(7 downto 0);
      pon_load   : out std_logic;
      pon_oe_b   : out std_logic;
      r_lvmb_pon : in  std_logic_vector(7 downto 0);
      lvmb_csb   : out std_logic_vector(6 downto 0);
      lvmb_sclk  : out std_logic;
      lvmb_sdin  : out std_logic;
      lvmb_sdout : in  std_logic;

      diagout_cfebjtag : out std_logic_vector(17 downto 0);
      diagout_lvdbmon  : out std_logic_vector(17 downto 0);

-- From/To FIFOs

      tfifo_data  : in  std_logic_vector(15 downto 0);
      tfifo_wc    : in  std_logic_vector(9 downto 0);
      tfifo_rc    : in  std_logic_vector(9 downto 0);
      tfifo_str   : in  std_logic_vector(15 downto 0);
      tfifo_wr_en : out std_logic_vector(8 downto 1);
      tfifo_rd_en : out std_logic_vector(8 downto 1);
      tfifo_sel   : out std_logic_vector(8 downto 1);
      tfifo_mode  : out std_logic;

      flf_ctrl : out std_logic_vector(15 downto 0);
      flf_data : in  std_logic_vector(15 downto 0)

      );

  end component;

  component DMB_fifo is
    port (
      rst        : in  std_logic;
      wr_clk     : in  std_logic;
      rd_clk     : in  std_logic;
      din        : in  std_logic_vector(17 downto 0);
      wr_en      : in  std_logic;
      rd_en      : in  std_logic;
      dout       : out std_logic_vector(17 downto 0);
      full       : out std_logic;
      empty      : out std_logic;
      prog_full  : out std_logic;
      prog_empty : out std_logic);
  end component;

  component ot_mgr
    port(
      otx1_tx_en  : out std_logic;
      otx1_tx_dis : out std_logic;
      otx1_reset  : out std_logic;
      otx1_fault  : in  std_logic;
      otx2_tx_en  : out std_logic;
      otx2_tx_dis : out std_logic;
      otx2_reset  : out std_logic;
      otx2_fault  : in  std_logic;
      orx1_rx_en  : out std_logic;
      orx1_en_sd  : out std_logic;
      orx1_sd     : in  std_logic;
      orx1_sq_en  : out std_logic;
      orx2_rx_en  : out std_logic;
      orx2_en_sd  : out std_logic;
      orx2_sd     : in  std_logic;
      orx2_sq_en  : out std_logic
      );
  end component;

-- Global signals
  signal LOGICL   : std_logic                     := '0';
  signal LOGICH   : std_logic                     := '1';
  signal LOGIC36L : std_logic_vector(35 downto 0) := (others => '0');
  signal LOGIC36H : std_logic_vector(35 downto 0) := (others => '1');

-- Test Signals From/To J3

  signal d_in, d_out, d_oe : std_logic_vector(63 downto 0);

-- VME Signals

  signal vme_data_out : std_logic_vector (15 downto 0);
  signal vme_data_in  : std_logic_vector (15 downto 0);
  signal vme_tovme_b  : std_logic;
  signal vme_doe_b    : std_logic;


  signal vme_test_mode : std_logic;
  signal test_vme_oe_b : std_logic;

  signal test_vme_gap, int_vme_gap                 : std_logic;
  signal test_vme_ga, int_vme_ga                   : std_logic_vector (4 downto 0);
  signal test_vme_addr, int_vme_addr               : std_logic_vector (23 downto 1);
  signal test_vme_as_b, int_vme_as_b               : std_logic;
  signal test_vme_ds_b, int_vme_ds_b               : std_logic_vector (1 downto 0);
  signal test_vme_data_out, int_vme_data_out       : std_logic_vector (15 downto 0);
  signal test_vme_am, int_vme_am                   : std_logic_vector (5 downto 0);
  signal test_vme_data_in, int_vme_data_in         : std_logic_vector (15 downto 0);
  signal test_vme_lword_b, int_vme_lword_b         : std_logic;
  signal test_vme_write_b, int_vme_write_b         : std_logic;
  signal test_vme_sysreset_b, int_vme_sysreset_b   : std_logic;
  signal test_vme_berr_b, int_vme_berr_b           : std_logic;
  signal test_vme_berr_out, int_vme_berr_out       : std_logic;
  signal test_vme_sysfail_b, int_vme_sysfail_b     : std_logic;
  signal test_vme_sysfail_out, int_vme_sysfail_out : std_logic;
  signal test_vme_iack_b, int_vme_iack_b           : std_logic;
  signal test_vme_dtack_v6_b, int_vme_dtack_v6_b   : std_logic;
  signal test_vme_clk, int_vme_clk                 : std_logic;

-- To/From FIFOs


  signal dcfeb0_data                     : std_logic_vector (15 downto 0);
  signal dcfeb0_fifo_in, dcfeb0_fifo_out : std_logic_vector (15 downto 0);
  signal dcfeb0_data_valid               : std_logic;

  signal dcfeb1_data                     : std_logic_vector (15 downto 0);
  signal dcfeb1_fifo_in, dcfeb1_fifo_out : std_logic_vector (15 downto 0);
  signal dcfeb1_data_valid               : std_logic;

  signal dcfeb2_data                     : std_logic_vector (15 downto 0);
  signal dcfeb2_fifo_in, dcfeb2_fifo_out : std_logic_vector (15 downto 0);
  signal dcfeb2_data_valid               : std_logic;

  signal dcfeb3_data                     : std_logic_vector (15 downto 0);
  signal dcfeb3_fifo_in, dcfeb3_fifo_out : std_logic_vector (15 downto 0);
  signal dcfeb3_data_valid               : std_logic;

  signal dcfeb4_data                     : std_logic_vector (15 downto 0);
  signal dcfeb4_fifo_in, dcfeb4_fifo_out : std_logic_vector (15 downto 0);
  signal dcfeb4_data_valid               : std_logic;

  signal dcfeb5_data                     : std_logic_vector (15 downto 0);
  signal dcfeb5_fifo_in, dcfeb5_fifo_out : std_logic_vector (15 downto 0);
  signal dcfeb5_data_valid               : std_logic;

  signal dcfeb6_data                     : std_logic_vector (15 downto 0);
  signal dcfeb6_fifo_in, dcfeb6_fifo_out : std_logic_vector (15 downto 0);
  signal dcfeb6_data_valid               : std_logic;

  signal dcfeb7_fifo_in, dcfeb7_fifo_out        : std_logic_vector (15 downto 0);
  signal tmb_data, tmb_fifo_in, tmb_fifo_out    : std_logic_vector (15 downto 0);
  signal tmb_data_valid                         : std_logic;
  signal alct_data, alct_fifo_in, alct_fifo_out : std_logic_vector (15 downto 0);
  signal alct_data_valid                        : std_logic;

  signal fifo_mrst_b, fifo_prst_b                   : std_logic;
  signal fifo_wr_ck, fifo_rd_ck                     : std_logic;
  signal fifo_tm_wr_en, fifo_wr_en, fifo_rd_en      : std_logic_vector(9 downto 1);
  signal fifo_rw_en, fifo_rm_en, fifo_tm_en         : std_logic_vector (9 downto 1);
  signal fifo_full, fifo_half, fifo_pae, fifo_empty : std_logic_vector (9 downto 1);
  signal fifo_oe                                    : std_logic_vector (NFEB+2 downto 1);
  signal fifo_in, fifo_out                          : std_logic_vector (15 downto 0);

-- TTC Signals

  signal dl_jtag_tck, dl_jtag_tdo, dl_rtn_shft_en : std_logic_vector(7 downto 1);
  signal dl_jtag_tms, dl_jtag_tdi                 : std_logic;
  signal ul_jtag_tck, ul_jtag_tms, ul_jtag_tdi    : std_logic_vector(7 downto 1);

  signal dl_spi_cs0, dl_spi_cs1, dl_spi_scl, dl_spi_sda : std_logic_vector(7 downto 1);
  signal ul_spi_scl, ul_spi_sda, ul_spi_busy            : std_logic_vector(7 downto 1);

  signal dl_tkn : std_logic_vector(7 downto 1);
  signal ul_tkn : std_logic_vector(7 downto 1);

  signal dl_i2c_scl, dl_i2c_sda : std_logic_vector(7 downto 1);
  signal ul_i2c_scl, ul_i2c_sda : std_logic_vector(7 downto 1);

  signal dcfeb_injpulse, dcfeb_extpulse, dcfeb_l1a : std_logic;  -- To be sent out to pins in V2
  signal dcfeb_l1a_match                           : std_logic_vector (NFEB downto 1);  -- To be sent out to pins in V2
  signal dl_global_rst                             : std_logic;
  signal dl_resync                                 : std_logic_vector(7 downto 1);
  signal dl_reprogram                              : std_logic_vector(7 downto 1);
  signal ul_dav, ul_movlp, ul_done                 : std_logic_vector (7 downto 1);

-- Mode Selection Signals

  signal pb_reset, lb_en, lb_ff_en, tm_en : std_logic;

-- FLF Test Signals

  signal flf_test_en, flf_reset, flf_tx_enable, flf_tx_burst_enable, flf_rx_enable : std_logic;
  signal flf_cnt_sel                                                               : std_logic_vector(4 downto 0);
  signal test_flf_p1_tx, test_flf_p2_tx, test_flf_e1_tx, test_flf_e2_tx            : std_logic;
  signal tx_flf_p1_cnt, tx_flf_p2_cnt, tx_flf_e1_cnt, tx_flf_e2_cnt                : std_logic_vector(15 downto 0);
  signal flf_error                                                                 : std_logic_vector(7 downto 1);
  signal flf_ctrl                                                                  : std_logic_vector(15 downto 0);
  signal flf_data                                                                  : std_logic_vector(15 downto 0);

-- TKN Test Signals

  signal tkn_test_en, tkn_tx_enable, tkn_rx_enable : std_logic;
  signal test_tkn_tx                               : std_logic;
  signal tkn_error                                 : std_logic_vector(7 downto 1);

  -- dmb_receiver
  signal FIFO_VME_MODE    : std_logic                    := '0';
  signal FIFO_SEL         : std_logic_vector(8 downto 1) := (others => '0');
  signal RD_EN_FF         : std_logic_vector(8 downto 1) := (others => '0');
  signal WR_EN_FF         : std_logic_vector(8 downto 1) := (others => '0');
  signal FF_DATA_IN       : std_logic_vector(15 downto 0);
  signal FF_DATA_OUT      : std_logic_vector(15 downto 0);
  signal FF_WRD_CNT       : std_logic_vector(11 downto 0);
  signal FF_STATUS        : std_logic_vector(15 downto 0);
  signal DMBVME_CLK_S2    : std_logic                    := '0';
  signal DAQ_RX_125REFCLK : std_logic                    := '0';



-- DCFEB I/O Signals

  type dcfeb_data_type is array (NFEB downto 1) of std_logic_vector(15 downto 0);
  signal gen_dcfeb_data                                   : dcfeb_data_type;
  signal rx_dcfeb_data                                    : dcfeb_data_type;
  signal dcfeb_data                                       : dcfeb_data_type;
  signal orx_dcfeb_data_n, orx_dcfeb_data_p : std_logic_vector(12 downto 1);
  signal gen_dcfeb_data_p, rx_dcfeb_data_p : std_logic_vector(NFEB downto 1);
  signal gen_dcfeb_data_n, rx_dcfeb_data_n : std_logic_vector(NFEB downto 1);
  signal gen_dcfeb_data_valid                             : std_logic_vector(NFEB downto 1);
  signal rx_dcfeb_data_valid                              : std_logic_vector(NFEB downto 1);
  signal dcfeb_data_valid                                 : std_logic_vector(NFEB downto 1);

  signal rx_dcfeb_sel, opt_dcfeb_sel : std_logic;
  type dcfeb_addr_type is array (NFEB downto 1) of std_logic_vector(3 downto 0);
  constant dcfeb_addr                : dcfeb_addr_type := ("1000", "1001", "1010", "1011", "1100", "1101", "1110");


  signal dcfeb0_data_p, dcfeb0_data_n                                                           : std_logic;
  signal dcfeb0_daq_tdis, dcfeb0_rate_1_25, dcfeb0_rate_3_2, dcfeb0_tx_ack, dcfeb0_daq_data_clk : std_logic;


-- From/To OTs 

  signal otx1 : std_logic_vector(12 DOWNTO 1);
  signal otx2 : std_logic_vector(12 DOWNTO 1);
  signal orx1 : std_logic_vector(12 DOWNTO 1);
  signal orx2 : std_logic_vector(12 DOWNTO 1);

-- From/To Giga-Bit Links

  signal gl0_tx, gl0_rx, gl1_tx, gl1_rx : std_logic;

  signal grx0_data       : std_logic_vector(15 downto 0) := "0000000000000000";
  signal grx0_data_valid : std_logic                     := '0';
  signal grx1_data       : std_logic_vector(15 downto 0) := "0000000000000000";
  signal grx1_data_valid : std_logic                     := '0';

  signal gtx0_data       : std_logic_vector(15 downto 0);
  signal gtx0_data_valid : std_logic;
  signal gtx1_data       : std_logic_vector(15 downto 0);
  signal gtx1_data_valid : std_logic;

-- From LVDS Test Connector

  signal ck_0, ck_1, ck_2, clk, tx_0, tx_1, tx_2, tx_3, tx_4, tx_5, tx_6, tx_7, tx_8, tx_9, tx_10 : std_logic;
  signal rxb, rx_0, rx_1, rx_2, rx_3, rx_4, rx_5, rx_6, rx_7, rx_8, rx_9, rx_10                   : std_logic;


-- PLL Signals

  signal clkin, qpll_clk40MHz, qpll_clk80MHz, qpll_clk160MHz : std_logic;

  signal pll1_fb, pll1_rst, pll1_pd, pll1_locked : std_logic;

  signal pll_clk80, clk80     : std_logic;  -- reallyfastclk (80MHz) 
  signal pll_clk40, clk40     : std_logic;  -- fastclk (40MHz) 
  signal pll_clk10, clk10     : std_logic;  -- midclk  (10MHz) 
  signal pll_clk5, clk5       : std_logic;  -- Generates clk2p5 and clk1p25
  signal clk2p5, clk2p5_inv   : std_logic;  -- slowclk (2.5MHz)
  signal clk1p25, clk1p25_inv : std_logic;  -- slowclk2 (1.25MHz)


-- Other signals

  signal iob_rsvtd_out : std_logic_vector (7 downto 0);
-- signal       rsvtd_out : STD_LOGIC_VECTOR (3 downto 0);
  signal iob_rsvtd_in  : std_logic_vector (7 downto 0);
-- signal       rsvtd_in : STD_LOGIC_VECTOR (2 downto 0);

  signal reset : std_logic;

  signal int_dl_jtag_tdo : std_logic_vector(7 downto 1) := "0000000";
  signal jtag_dr0        : std_logic_vector(15 downto 0);
  signal jtag_ir         : std_logic_vector(10 downto 0);

  signal int_lvmb_pon                                 : std_logic_vector(7 downto 0);
  signal int_lvmb_adc_sdout                           : std_logic_vector(6 downto 0);
  signal int_lvmb_csb                                 : std_logic_vector(6 downto 0);
  signal int_lvmb_sclk, int_lvmb_sdin, int_lvmb_sdout : std_logic;

  signal leds_in : std_logic_vector(11 downto 0);

-- JTAG signals between ODMB_VME and ODMB_CTRL

  signal mbc_jtag_tck : std_logic;
  signal mbc_jtag_tms : std_logic;
  signal mbc_jtag_tdi : std_logic;
  signal mbc_jtag_tdo : std_logic;

-- Test FIFOs

  type dcfeb_gbrx_data_type is array (NFEB+1 downto 1) of std_logic_vector(15 downto 0);
  signal dcfeb_gbrx_data : dcfeb_gbrx_data_type;

  signal dcfeb_gbrx_data_valid : std_logic_vector(NFEB+1 downto 1) := (others => '0');
  signal dcfeb_gbrx_data_clk   : std_logic_vector(NFEB+1 downto 1) := (others => '0');

  signal dcfeb_tfifo_empty  : std_logic_vector(NFEB+1 downto 1);
  signal dcfeb_tfifo_aempty : std_logic_vector(NFEB+1 downto 1);
  signal dcfeb_tfifo_afull  : std_logic_vector(NFEB+1 downto 1);
  signal dcfeb_tfifo_full   : std_logic_vector(NFEB+1 downto 1);

  type dcfeb_tfifo_data_type is array (NFEB+1 downto 1) of std_logic_vector(15 downto 0);
  signal dcfeb_tfifo_in  : dcfeb_tfifo_data_type;
  signal dcfeb_tfifo_out : dcfeb_tfifo_data_type;

  type dcfeb_tfifo_cnt_type is array (NFEB+1 downto 1) of std_logic_vector(9 downto 0);
  signal dcfeb_tfifo_wr_cnt : dcfeb_tfifo_cnt_type;
  signal dcfeb_tfifo_rd_cnt : dcfeb_tfifo_cnt_type;

  signal dcfeb_tfifo_wr_en : std_logic_vector(NFEB+1 downto 1) := (others => '0');
  signal dcfeb_tfifo_wr_ck : std_logic_vector(NFEB+1 downto 1) := (others => '0');
  signal dcfeb_tfifo_rd_en : std_logic_vector(NFEB+1 downto 1) := (others => '0');
  signal dcfeb_tfifo_rd_ck : std_logic_vector(NFEB+1 downto 1) := (others => '0');

-- FIFOs (SYNC)

  signal dcfeb0_wr_cnt, dcfeb0_rd_cnt : std_logic_vector(9 downto 0);
  signal dcfeb0_wr_err, dcfeb0_rd_err : std_logic;
  signal dcfeb1_wr_cnt, dcfeb1_rd_cnt : std_logic_vector(9 downto 0);
  signal dcfeb1_wr_err, dcfeb1_rd_err : std_logic;
  signal dcfeb2_wr_cnt, dcfeb2_rd_cnt : std_logic_vector(9 downto 0);
  signal dcfeb2_wr_err, dcfeb2_rd_err : std_logic;
  signal dcfeb3_wr_cnt, dcfeb3_rd_cnt : std_logic_vector(9 downto 0);
  signal dcfeb3_wr_err, dcfeb3_rd_err : std_logic;
  signal dcfeb4_wr_cnt, dcfeb4_rd_cnt : std_logic_vector(9 downto 0);
  signal dcfeb4_wr_err, dcfeb4_rd_err : std_logic;
  signal dcfeb5_wr_cnt, dcfeb5_rd_cnt : std_logic_vector(9 downto 0);
  signal dcfeb5_wr_err, dcfeb5_rd_err : std_logic;
  signal dcfeb6_wr_cnt, dcfeb6_rd_cnt : std_logic_vector(9 downto 0);
  signal dcfeb6_wr_err, dcfeb6_rd_err : std_logic;
  signal tmb_wr_cnt, tmb_rd_cnt       : std_logic_vector(9 downto 0);
  signal tmb_wr_err, tmb_rd_err       : std_logic;
  signal alct_wr_cnt, alct_rd_cnt     : std_logic_vector(9 downto 0);
  signal alct_wr_err, alct_rd_err     : std_logic;

  type dcfeb_adc_mask_type is array (NFEB downto 1) of std_logic_vector(11 downto 0);
  signal dcfeb_adc_mask : dcfeb_adc_mask_type;

  type dcfeb_fsel_type is array (NFEB downto 1) of std_logic_vector(32 downto 0);
  signal dcfeb_fsel : dcfeb_fsel_type;

  type dcfeb_jtag_ir_type is array (NFEB downto 1) of std_logic_vector(9 downto 0);
  signal dcfeb_jtag_ir : dcfeb_jtag_ir_type;

  signal mbc_fsel : std_logic_vector(47 downto 1);

  signal mbc_jtag_ir : std_logic_vector(9 downto 0);

  signal dcfeb1t_tx_dat, dcfeb1t_rx_dat, dcfeb1t_rx_clk                 : std_logic;
  signal dcfeb1t_tp_tck, dcfeb1t_tp_tms, dcfeb1t_tp_tdi, dcfeb1t_tp_tdo : std_logic;
  signal dcfeb2t_tx_dat, dcfeb2t_rx_dat, dcfeb2t_rx_clk                 : std_logic;
  signal dcfeb2t_tp_tck, dcfeb2t_tp_tms, dcfeb2t_tp_tdi, dcfeb2t_tp_tdo : std_logic;

  signal diagout_cfebjtag : std_logic_vector(17 downto 0);
  signal diagout_lvdbmon  : std_logic_vector(17 downto 0);

  signal cdc_clk : std_logic_vector(7 downto 0);

  signal dcfeb1t_rec_clk, dcfeb2t_rec_clk : std_logic;

-- Test FIFO Signals

  signal tfifo_data         : std_logic_vector(15 downto 0);
  signal tfifo_wc, tfifo_rc : std_logic_vector(9 downto 0);
  signal tfifo_str          : std_logic_vector(15 downto 0);
  signal tfifo_wr_en        : std_logic_vector(8 downto 1);
  signal tfifo_rd_en        : std_logic_vector(8 downto 1);
  signal tfifo_sel          : std_logic_vector(8 downto 1);
  signal tfifo_mode         : std_logic;

  signal b_orx2_01_p, b_orx2_01_n : std_logic;

  signal orx2_01_sd : std_logic;
  signal orx2_02_sd : std_logic;
  signal orx2_03_sd : std_logic;
  signal orx2_04_sd : std_logic;
  signal orx2_05_sd : std_logic;
  signal orx2_06_sd : std_logic;
  signal orx2_07_sd : std_logic;
  signal orx2_08_sd : std_logic;

  signal por_reg  : std_logic_vector (31 downto 0);
  signal mbc_leds : std_logic_vector (5 downto 0);

  signal select_diagnostic : integer := 0;

-- CAFIFO related signals
  signal data_fifo_oe     : std_logic_vector(NFEB+2 downto 1) := (others => '0');
  signal data_fifo_re     : std_logic_vector(NFEB+2 downto 1) := (others => '0');
  signal data_fifo_re_b   : std_logic_vector(NFEB+2 downto 1) := (others => '0');
  signal dcfeb_fifo_wr_en : std_logic_vector(NFEB downto 1)   := (others => '0');
  signal alct_fifo_wr_en  : std_logic                         := '0';
  signal tmb_fifo_wr_en   : std_logic                         := '0';

  signal cafifo_l1a_match : std_logic_vector(NFEB+2 downto 1);  -- L1A_MATCH from TRGCNTRL to CAFIFO sent to generate Data



  signal gen_alct_data : std_logic_vector(15 downto 0);
  signal gen_tmb_data  : std_logic_vector(15 downto 0);

  signal gen_alct_data_valid : std_logic;
  signal gen_tmb_data_valid  : std_logic;

  type dcfeb_fifo_data_type is array (NFEB downto 1) of std_logic_vector(15 downto 0);
  signal dcfeb_fifo_in  : dcfeb_fifo_data_type;
  signal dcfeb_fifo_out : dcfeb_fifo_data_type;

  signal gen_alct_fifo_in, gen_tmb_fifo_in   : std_logic_vector(15 downto 0);
  signal gen_alct_fifo_out, gen_tmb_fifo_out : std_logic_vector(15 downto 0);

  type dcfeb_fifo_cnt_type is array (NFEB downto 1) of std_logic_vector(9 downto 0);
  signal dcfeb_fifo_wr_cnt : dcfeb_fifo_cnt_type;
  signal dcfeb_fifo_rd_cnt : dcfeb_fifo_cnt_type;

  signal alct_fifo_wr_cnt, tmb_fifo_wr_cnt : std_logic_vector(9 downto 0);
  signal alct_fifo_rd_cnt, tmb_fifo_rd_cnt : std_logic_vector(9 downto 0);

  signal dcfeb_fifo_empty  : std_logic_vector(NFEB downto 1);
  signal dcfeb_fifo_aempty : std_logic_vector(NFEB downto 1);
  signal dcfeb_fifo_afull  : std_logic_vector(NFEB downto 1);
  signal dcfeb_fifo_full   : std_logic_vector(NFEB downto 1);

  signal data_fifo_empty_b                 : std_logic_vector(NFEB+2 downto 1);
  signal alct_fifo_empty, tmb_fifo_empty   : std_logic;
  signal alct_fifo_aempty, tmb_fifo_aempty : std_logic;
  signal alct_fifo_afull, tmb_fifo_afull   : std_logic;
  signal alct_fifo_full, tmb_fifo_full     : std_logic;

  signal dcfeb_daq_tdis     : std_logic_vector(NFEB downto 1);
  signal dcfeb_tx_ack       : std_logic_vector(NFEB downto 1);
  signal dcfeb_daq_data_clk : std_logic_vector(NFEB downto 1);


begin

  Select_TestPoints : process(diagout_lvdbmon, diagout_cfebjtag, qpll_clk40MHz)
  begin
    if (select_diagnostic = 0) then
      d(0)  <= diagout_lvdbmon(0);      -- TP58   TP59 SLOWCLK
      d(1)  <= diagout_lvdbmon(1);      -- TP60   TP61 CE_ADCDATA
      d(2)  <= diagout_lvdbmon(2);      -- TP62   TP63 CLKMON
      d(3)  <= diagout_lvdbmon(3);      -- TP64   TP65 ADCCLK_INNER
      d(4)  <= diagout_lvdbmon(4);      -- TP66   TP66 BUSY
      d(5)  <= diagout_lvdbmon(5);      -- TP68   TP68 L_ADCDATA
      d(6)  <= diagout_lvdbmon(6);      -- TP70
      d(7)  <= diagout_lvdbmon(7);      -- TP72
      d(8)  <= diagout_lvdbmon(8);      -- TP74
      d(32) <= diagout_lvdbmon(9);      -- TP59
      d(33) <= diagout_lvdbmon(10);     -- TP61
      d(34) <= diagout_lvdbmon(11);     -- TP63
      d(35) <= diagout_lvdbmon(12);     -- TP65
      d(36) <= diagout_lvdbmon(13);     -- TP67
      d(37) <= diagout_lvdbmon(14);     -- TP69
      d(38) <= diagout_lvdbmon(15);     -- TP71
      d(39) <= diagout_lvdbmon(16);     -- TP73
      d(40) <= diagout_lvdbmon(17);     -- TP75
    elsif (select_diagnostic = 1) then
      d(0)  <= diagout_cfebjtag(0);     -- TP58   TP59 TCK(1)
      d(1)  <= diagout_cfebjtag(1);     -- TP60   TP61 TDI
      d(2)  <= diagout_cfebjtag(2);     -- TP62   TP63 TMS
      d(3)  <= diagout_cfebjtag(3);     -- TP64   TP65 DL_RTN_SHFT_EN(1)
      d(4)  <= diagout_cfebjtag(4);     -- TP66   TP66 UL_JTAG_TCK(1)
      d(5)  <= diagout_cfebjtag(5);     -- TP68   TP68 SELFEB(1)
      d(6)  <= diagout_cfebjtag(6);     -- TP70   TP70 FEBTDO(1)
      d(7)  <= diagout_cfebjtag(7);     -- TP72   TP72 READTDO
      d(8)  <= diagout_cfebjtag(8);     -- TP74
      d(32) <= diagout_cfebjtag(9);     -- TP59
      d(33) <= diagout_cfebjtag(10);    -- TP61
      d(34) <= diagout_cfebjtag(11);    -- TP63
      d(35) <= diagout_cfebjtag(12);    -- TP65   SLOWCLK
      d(36) <= diagout_cfebjtag(13);    -- TP67
      d(37) <= diagout_cfebjtag(14);    -- TP69
      d(38) <= diagout_cfebjtag(15);    -- TP71
      d(39) <= diagout_cfebjtag(16);    -- TP73
      d(40) <= diagout_cfebjtag(17);    -- TP75
    else
      d(0)  <= flf_ctrl(15);            -- TP58   TP59 TCK(1)
      d(1)  <= flf_ctrl(14);            -- TP60   TP61 TDI
      d(2)  <= dcfeb_injpulse;          -- TP62   TP63 TMS
      d(3)  <= dcfeb_extpulse;          -- TP64   TP65 DL_RTN_SHFT_EN(1)
      d(4)  <= dcfeb_l1a;               -- TP66   TP66 UL_JTAG_TCK(1)
      d(5)  <= qpll_clk40MHz;           -- TP68   TP68 SELFEB(1)
      d(6)  <= qpll_locked;             -- TP70   TP70 FEBTDO(1)
      d(7)  <= diagout_cfebjtag(7);     -- TP72   TP72 READTDO
      d(8)  <= DL_RTN_SHFT_EN(1);       -- TP74
      d(32) <= int_vme_dtack_v6_b;      -- TP59
      d(33) <= diagout_cfebjtag(10);    -- TP61
      d(34) <= diagout_cfebjtag(11);    -- TP63
      d(35) <= diagout_cfebjtag(12);    -- TP65   SLOWCLK
      d(36) <= DL_RTN_SHFT_EN(3);       -- TP67
      d(37) <= DL_RTN_SHFT_EN(4);       -- TP69
      d(38) <= DL_RTN_SHFT_EN(5);       -- TP71
      d(39) <= DL_RTN_SHFT_EN(6);       -- TP73
      d(40) <= DL_RTN_SHFT_EN(7);       -- TP75
    end if;
    d(31 downto 9)  <= (others => '0');
    d(63 downto 41) <= (others => '0');
  end process Select_TestPoints;

  fd_clr <= '0';
  fd_pre <= '0';

-- reset <= pb_reset;

-- power on reset

  process (clk2p5, pll1_locked)
  begin
    if pll1_locked = '0' then
      por_reg <= x"0FFFFFFF";
    elsif clk2p5'event and clk2p5 = '1' then
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

  lvmb_csb  <= int_lvmb_csb;
  lvmb_sclk <= int_lvmb_sclk;
  lvmb_sdin <= int_lvmb_sdin;

  PB_SEL : mode_pb_sel
    port map (
      pb0      => pb(0),
      pb1      => pb(1),
      pb2      => pb(2),
      pb3      => pb(3),
      pb_reset => pb_reset,
      lb_en    => lb_en,
      lb_ff_en => lb_ff_en,
      tm_en    => tm_en);

  test_vme_oe_b <= '1';  -- 3-state output enable for test_vme_data (high=input, low=output) 
-- test_vme_data_out <= "1010101010101010";     -- constant output (0xaaaa) for test_vme_data 

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
  leds(6)  <= not int_vme_dtack_v6_b;
  leds(7)  <= not pll1_locked;
  leds(8)  <= not qpll_locked;          -- PB2
  leds(9)  <= not pb(1);                -- PB3
  leds(10) <= not pb(2);                -- PB4
  leds(11) <= not pb(3);                -- PB5

  flf_status : process (dcfeb_adc_mask, dcfeb_fsel, dcfeb_jtag_ir, mbc_fsel, mbc_jtag_ir, flf_ctrl)

  begin
    
    case flf_ctrl(4 downto 0) is

      when "00000" => flf_data <= "0000" & dcfeb_adc_mask(1);
      when "00001" => flf_data <= dcfeb_fsel(1)(15 downto 0);
      when "00010" => flf_data <= dcfeb_fsel(1)(31 downto 16);
      when "00011" => flf_data <= "00" & dcfeb_jtag_ir(1) & "000" & dcfeb_fsel(1)(31);

      when "00100" => flf_data <= "0000" & dcfeb_adc_mask(2);
      when "00101" => flf_data <= dcfeb_fsel(2)(15 downto 0);
      when "00110" => flf_data <= dcfeb_fsel(2)(31 downto 16);
      when "00111" => flf_data <= "00" & dcfeb_jtag_ir(2) & "000" & dcfeb_fsel(2)(31);

      when "01000" => flf_data <= "0000" & dcfeb_adc_mask(3);
      when "01001" => flf_data <= dcfeb_fsel(3)(15 downto 0);
      when "01010" => flf_data <= dcfeb_fsel(3)(31 downto 16);
      when "01011" => flf_data <= "00" & dcfeb_jtag_ir(3) & "000" & dcfeb_fsel(3)(31);

      when "01100" => flf_data <= "0000" & dcfeb_adc_mask(4);
      when "01101" => flf_data <= dcfeb_fsel(4)(15 downto 0);
      when "01110" => flf_data <= dcfeb_fsel(4)(31 downto 16);
      when "01111" => flf_data <= "00" & dcfeb_jtag_ir(4) & "000" & dcfeb_fsel(4)(31);

      when "10000" => flf_data <= "0000" & dcfeb_adc_mask(5);
      when "10001" => flf_data <= dcfeb_fsel(5)(15 downto 0);
      when "10010" => flf_data <= dcfeb_fsel(5)(31 downto 16);
      when "10011" => flf_data <= "00" & dcfeb_jtag_ir(5) & "000" & dcfeb_fsel(5)(31);

      when "10100" => flf_data <= "0000" & dcfeb_adc_mask(6);
      when "10101" => flf_data <= dcfeb_fsel(6)(15 downto 0);
      when "10110" => flf_data <= dcfeb_fsel(6)(31 downto 16);
      when "10111" => flf_data <= "00" & dcfeb_jtag_ir(6) & "000" & dcfeb_fsel(6)(31);

      when "11000" => flf_data <= "0000" & dcfeb_adc_mask(7);
      when "11001" => flf_data <= dcfeb_fsel(7)(15 downto 0);
      when "11010" => flf_data <= dcfeb_fsel(7)(31 downto 16);
      when "11011" => flf_data <= "00" & dcfeb_jtag_ir(7) & "000" & dcfeb_fsel(7)(31);

      when "11100" => flf_data <= mbc_fsel(16 downto 1);
      when "11101" => flf_data <= mbc_fsel(32 downto 17);
      when "11110" => flf_data <= '0' & mbc_fsel(47 downto 33);
      when "11111" => flf_data <= "00" & mbc_jtag_ir(9 downto 0) & "0000";

      when others  => flf_data <= "0000000000000000";
    end case;
    
  end process;


-- ------------------------------------------------------------------------------------------------- 

-- CODE_C (LVDS input buffers)

-- From OT1 (GigaBit Link)

-- gl1_rx
  gl1_rx_buf : IBUFDS port map (I => gl0_rx_p, IB => gl0_rx_n, O => gl0_rx);

-- From OT2 (GigaBit Link)

-- gl2_rx
  gl2_rx_buf : IBUFDS port map (I => gl1_rx_p, IB => gl1_rx_n, O => gl1_rx);


-- From ORX1

  GEN_ORX1 : for I in 12 downto 1 generate  
  begin
    orx1_buf : IBUFDS port map (I => orx1_p(I), IB => orx1_n(I), O => orx1(I));
  end generate GEN_ORX1;

-- From ORX2

  GEN_ORX2 : for I in 12 downto 1 generate  
  begin
    orx2_buf : IBUFDS port map (I => orx2_p(I), IB => orx2_n(I), O => orx2(I));
  end generate GEN_ORX2;


-- From QPLL

-- qpll_clk40MHz
  qpll_clk40MHz_buf : IBUFDS port map (I => qpll_clk40MHz_p, IB => qpll_clk40MHz_n, O => qpll_clk40MHz);
-- qpll_clk80MHz
  qpll_clk80MHz_buf : IBUFDS port map (I => qpll_clk80MHz_p, IB => qpll_clk80MHz_n, O => qpll_clk80MHz);


-- From Test Connector J3

-- ck_0
  ck_0_buf : IBUFDS port map (I => ck_0_p, IB => ck_0_n, O => ck_0);
-- ck_1
  ck_1_buf : IBUFDS port map (I => ck_1_p, IB => ck_1_n, O => ck_1);
-- tclk
  tclk_buf : IBUFDS port map (I => tclk_p, IB => tclk_n, O => ck_2);

-- rx_0
  rx_0_buf  : IBUFDS port map (I => rx_0_p, IB => rx_0_n, O => rx_0);
-- rx_1
  rx_1_buf  : IBUFDS port map (I => rx_1_p, IB => rx_1_n, O => rx_1);
-- rx_2
  rx_2_buf  : IBUFDS port map (I => rx_2_p, IB => rx_2_n, O => rx_2);
-- rx_3
  rx_3_buf  : IBUFDS port map (I => rx_3_p, IB => rx_3_n, O => rx_3);
-- rx_4
  rx_4_buf  : IBUFDS port map (I => rx_4_p, IB => rx_4_n, O => rx_4);
-- rx_5
  rx_5_buf  : IBUFDS port map (I => rx_5_p, IB => rx_5_n, O => rx_5);
-- rx_6
  rx_6_buf  : IBUFDS port map (I => rx_6_p, IB => rx_6_n, O => rx_6);
-- rx_7
  rx_7_buf  : IBUFDS port map (I => rx_7_p, IB => rx_7_n, O => rx_7);
-- rx_8
  rx_8_buf  : IBUFDS port map (I => rx_8_p, IB => rx_8_n, O => rx_8);
-- rx_9
  rx_9_buf  : IBUFDS port map (I => rx_9_p, IB => rx_9_n, O => rx_9);
-- rx_10
  rx_10_buf : IBUFDS port map (I => rx_10_p, IB => rx_10_n, O => rx_10);


-- ------------------------------------------------------------------------------------------------- 

-- CODE_D (LVDS output buffers)

-- To OT1 (GigaBit Link)

-- gl1_tx
  gl1_tx_buf : OBUFDS port map (I => gl0_tx, O => gl0_tx_p, OB => gl0_tx_n);

-- To OT2 (GigaBit Link)

-- gl2_tx
  gl2_tx_buf : OBUFDS port map (I => gl1_tx, O => gl1_tx_p, OB => gl1_tx_n);


-- To TX1 

  GEN_OTX1 : for I in 12 downto 1 generate  
  begin
    otx1_buf : OBUFDS port map (I => otx1(I), O => otx1_p(I), OB => otx1_n(I));
  end generate GEN_OTX1;

-- To TX2 

  GEN_OTX2 : for I in 12 downto 1 generate  
  begin
    otx2_buf : OBUFDS port map (I => otx2(I), O => otx2_p(I), OB => otx2_n(I));
  end generate GEN_OTX2;

-- To Test Connector

-- rxb
  rxb_buf   : OBUFDS port map (I => rxb, O => rxb_p, OB => rxb_n);
-- tx_0
  tx_0_buf  : OBUFDS port map (I => tx_0, O => tx_0_p, OB => tx_0_n);
-- tx_1
  tx_1_buf  : OBUFDS port map (I => tx_1, O => tx_1_p, OB => tx_1_n);
-- tx_2
  tx_2_buf  : OBUFDS port map (I => tx_2, O => tx_2_p, OB => tx_2_n);
-- tx_1
  tx_3_buf  : OBUFDS port map (I => tx_3, O => tx_3_p, OB => tx_3_n);
-- tx_1
  tx_4_buf  : OBUFDS port map (I => tx_4, O => tx_4_p, OB => tx_4_n);
-- tx_1
  tx_5_buf  : OBUFDS port map (I => tx_5, O => tx_5_p, OB => tx_5_n);
-- tx_1
  tx_6_buf  : OBUFDS port map (I => tx_6, O => tx_6_p, OB => tx_6_n);
-- tx_1
  tx_7_buf  : OBUFDS port map (I => tx_7, O => tx_7_p, OB => tx_7_n);
-- tx_1
  tx_8_buf  : OBUFDS port map (I => tx_8, O => tx_8_p, OB => tx_8_n);
-- tx_1
  tx_9_buf  : OBUFDS port map (I => tx_9, O => tx_9_p, OB => tx_9_n);
-- tx_1
  tx_10_buf : OBUFDS port map (I => tx_10, O => tx_10_p, OB => tx_10_n);

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
      O     => cdc_clk(0),              -- Clock buffer output
      ODIV2 => open,
      CEB   => '0',
      I     => cdc_clk_0_p,  -- Diff_p clock buffer input (connect directly to top-level port)
      IB    => cdc_clk_0_n  -- Diff_n clock buffer input (connect directly to top-level port)
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
      O     => cdc_clk(1),              -- Clock buffer output
      ODIV2 => open,
      CEB   => '0',
      I     => cdc_clk_1_p,  -- Diff_p clock buffer input (connect directly to top-level port)
      IB    => cdc_clk_1_n  -- Diff_n clock buffer input (connect directly to top-level port)
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
      O     => cdc_clk(2),              -- Clock buffer output
      ODIV2 => open,
      CEB   => '0',
      I     => cdc_clk_2_p,  -- Diff_p clock buffer input (connect directly to top-level port)
      IB    => cdc_clk_2_n  -- Diff_n clock buffer input (connect directly to top-level port)
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
      O     => cdc_clk(3),              -- Clock buffer output
      ODIV2 => open,
      CEB   => '0',
      I     => cdc_clk_3_p,  -- Diff_p clock buffer input (connect directly to top-level port)
      IB    => cdc_clk_3_n  -- Diff_n clock buffer input (connect directly to top-level port)
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
      O     => cdc_clk(4),              -- Clock buffer output
      ODIV2 => open,
      CEB   => '0',
      I     => cdc_clk_4_p,  -- Diff_p clock buffer input (connect directly to top-level port)
      IB    => cdc_clk_4_n  -- Diff_n clock buffer input (connect directly to top-level port)
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
      O     => cdc_clk(5),              -- Clock buffer output
      ODIV2 => open,
      CEB   => '0',
      I     => cdc_clk_5_p,  -- Diff_p clock buffer input (connect directly to top-level port)
      IB    => cdc_clk_5_n  -- Diff_n clock buffer input (connect directly to top-level port)
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
      O     => cdc_clk(6),              -- Clock buffer output
      ODIV2 => open,
      CEB   => '0',
      I     => cdc_clk_6_p,  -- Diff_p clock buffer input (connect directly to top-level port)
      IB    => cdc_clk_6_n  -- Diff_n clock buffer input (connect directly to top-level port)
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
      O     => cdc_clk(7),              -- Clock buffer output
      ODIV2 => open,
      CEB   => '0',
      I     => cdc_clk_7_p,  -- Diff_p clock buffer input (connect directly to top-level port)
      IB    => cdc_clk_7_n  -- Diff_n clock buffer input (connect directly to top-level port)
      );

-- ------------------------------------------------------------------------------------------------- 

-- CODE_F (Clock Management)

-- Input clock selection

-- Stand Alone Test Bench (Clock from Stratix)
-- clkin <= ck_0;

-- Clock from QPLL
-- clkin <= qpll_clk40MHz;
  
  pll1_rst <= '0';
  pll1_pd  <= '0';

-- Start of MMCM_BASE_inst instantiation

  MMCM_BASE_PLL1 : MMCM_BASE
    generic map (
      BANDWIDTH          => "OPTIMIZED",  -- Jitter programming ("HIGH","LOW","OPTIMIZED")
      CLKFBOUT_MULT_F    => 16.0,  -- Multiply value for all CLKOUT (5.0-64.0).
      CLKFBOUT_PHASE     => 0.0,  -- Phase offset in degrees of CLKFB (0.00-360.00).
      CLKIN1_PERIOD      => 25.0,  -- Input clock period in ns to ps resolution (i.e. 33.333 is 30 MHz).
      CLKOUT0_DIVIDE_F   => 1.0,  -- Divide amount for CLKOUT0 (1.000-128.000).
      -- CLKOUT0_DUTY_CYCLE - CLKOUT6_DUTY_CYCLE: Duty cycle for each CLKOUT (0.01-0.99).
      CLKOUT0_DUTY_CYCLE => 0.5,
      CLKOUT1_DUTY_CYCLE => 0.5,
      CLKOUT2_DUTY_CYCLE => 0.5,
      CLKOUT3_DUTY_CYCLE => 0.5,
      CLKOUT4_DUTY_CYCLE => 0.5,
      CLKOUT5_DUTY_CYCLE => 0.5,
      CLKOUT6_DUTY_CYCLE => 0.5,
      -- CLKOUT0_PHASE - CLKOUT6_PHASE: Phase offset for each CLKOUT (-360.000-360.000).
      CLKOUT0_PHASE      => 0.0,
      CLKOUT1_PHASE      => 0.0,
      CLKOUT2_PHASE      => 0.0,
      CLKOUT3_PHASE      => 0.0,
      CLKOUT4_PHASE      => 0.0,
      CLKOUT5_PHASE      => 0.0,
      CLKOUT6_PHASE      => 0.0,
      -- CLKOUT1_DIVIDE - CLKOUT6_DIVIDE: Divide amount for each CLKOUT (1-128)
      CLKOUT1_DIVIDE     => 16,         -- clk40 = CMSCLK(40 MHz)
      CLKOUT2_DIVIDE     => 64,   -- clk10 = MIDCLK(10 MHz)               
      CLKOUT3_DIVIDE     => 128,        -- clk5 - generates clk2p5 and clk1p25
      CLKOUT4_DIVIDE     => 8,          -- Not used
      CLKOUT5_DIVIDE     => 16,         -- Not used
      CLKOUT6_DIVIDE     => 16,         -- Not used
      CLKOUT4_CASCADE    => false,  -- Cascase CLKOUT4 counter with CLKOUT6 (TRUE/FALSE)
      CLOCK_HOLD         => false,      -- Hold VCO Frequency (TRUE/FALSE)
      DIVCLK_DIVIDE      => 1,          -- Master division value (1-80)
      REF_JITTER1        => 0.0,  -- Reference input jitter in UI (0.000-0.999).
      STARTUP_WAIT       => false       -- Not supported. Must be set to FALSE.
      )
    port map (
      -- Clock Outputs: 1-bit (each) User configurable clock outputs
      CLKOUT0   => open,                -- 1-bit CLKOUT0 output
      --CLKOUT0   => pll_clk80,           -- 1-bit CLKOUT0 output
      CLKOUT0B  => open,                -- 1-bit Inverted CLKOUT0 output
      CLKOUT1   => pll_clk40,           -- 1-bit CLKOUT1 output
      CLKOUT1B  => open,                -- 1-bit Inverted CLKOUT1 output
      CLKOUT2   => pll_clk10,           -- 1-bit CLKOUT2 output
      CLKOUT2B  => open,                -- 1-bit Inverted CLKOUT2 output
      CLKOUT3   => pll_clk5,            -- 1-bit CLKOUT3 output
      CLKOUT3B  => open,                -- 1-bit Inverted CLKOUT3 output
      CLKOUT4   => pll_clk80,           -- 1-bit CLKOUT4 output
      CLKOUT5   => open,                -- 1-bit CLKOUT5 output
      CLKOUT6   => open,                -- 1-bit CLKOUT6 output
      -- Feedback Clocks: 1-bit (each) Clock feedback ports
      CLKFBOUT  => pll1_fb,             -- 1-bit Feedback clock output
      CLKFBOUTB => open,                -- 1-bit Inverted CLKFBOUT output
      -- Status Port: 1-bit (each) MMCM status ports
      LOCKED    => pll1_locked,         -- 1-bit LOCK output
      -- Clock Input: 1-bit (each) Clock input
      CLKIN1    => qpll_clk40MHz,       -- qpll_clk40MHz,
      -- Control Ports: 1-bit (each) MMCM control ports
      PWRDWN    => pll1_pd,             -- 1-bit Power-down input
      RST       => pll1_rst,            -- 1-bit Reset input
      -- Feedback Clocks: 1-bit (each) Clock feedback ports
      CLKFBIN   => pll1_fb              -- 1-bit Feedback clock input
      );


-- End of MMCM_BASE_inst instantiation

---- Global Clock Buffers

  clk80_buf : BUFG port map (I => pll_clk80, O => clk80);
  clk40_buf : BUFG port map (I => pll_clk40, O => clk40);
  clk10_buf : BUFG port map (I => pll_clk10, O => clk10);
  clk5_buf  : BUFG port map (I => pll_clk5, O => clk5);

-- Frequency dividers for the 2.5 and 1.25 MHz clocks which are too slow for the PLL 
  clk2p5_inv  <= not clk2p5;
  clk1p25_inv <= not clk1p25;
-- FD(clk2p5_inv, clk5, clk2p5);
-- FD(clk1p25_inv, clk2p5, clk1p25);
  FD1 : FD port map (D => clk2p5_inv, C => clk5, Q => clk2p5);
  FD2 : FD port map (D => clk1p25_inv, C => clk2p5, Q => clk1p25);


-- ------------------------------------------------------------------------------------------------- 

-- CODE_G (FF-LYNX Management - O-DMB-V1)

-- TX_DAT to DCFEBs

  otx1 <= (others => '0');

-- TX_CLK to DCFEBs

  otx2 <= (others => '0');

  vme_dtack_v6_b <= int_vme_dtack_v6_b;

  MBV : ODMB_VME
    port map (

-- VME signals 

--              vme_addr => int_vme_addr,                                                                       -- input
--              vme_data_in => int_vme_data_in,                                                 -- input
--              vme_data_out => vme_data_out,                                                           -- output
--              vme_am => int_vme_am,                                                                                   -- input
--              vme_gap => int_vme_gap,                                                                         -- input
--              vme_ga => int_vme_ga,                                                                                   -- input
--              vme_ds_b => int_vme_ds_b,                                                                       -- input
--              vme_as_b => int_vme_as_b,                                                                       -- input
--              vme_lword_b => int_vme_lword_b,                                                 -- input
--              vme_write_b => int_vme_write_b,                                                 -- input
--              vme_iack_b => int_vme_iack_b,                                                           -- input
--              vme_sysreset_b => int_vme_sysreset_b,                                   -- input
--              vme_sysfail_b => int_vme_sysfail_b,                                             -- input
--              vme_sysfail_out => int_vme_sysfail_out,                         -- output
--              vme_berr_b => int_vme_berr_b,                                                           -- input
--              vme_berr_out => int_vme_berr_out,                                               -- output
--              vme_dtack_b => int_vme_dtack_v6_b,                                                      -- output
--              vme_tovme => int_vme_tovme,                                                                             -- tovme
--              vme_tovme_b => int_vme_tovme_b,                                                                         -- tovme*
--              vme_doe => int_vme_doe,                                                                 -- doe
--              vme_doe_b => int_vme_doe_b,                                                                     -- doe*

      vme_addr        => vme_addr,            -- input
      vme_data_in     => vme_data_in,         -- input
      vme_data_out    => vme_data_out,        -- output
      vme_am          => vme_am,              -- input
      vme_gap         => vme_gap,             -- input
      vme_ga          => vme_ga,              -- input
      vme_ds_b        => vme_ds_b,            -- input
      vme_as_b        => vme_as_b,            -- input
      vme_lword_b     => vme_lword_b,         -- input
      vme_write_b     => vme_write_b,         -- input
      vme_iack_b      => vme_iack_b,          -- input
      vme_sysreset_b  => vme_sysreset_b,      -- input
      vme_sysfail_b   => vme_sysfail_b,       -- input
      vme_sysfail_out => vme_sysfail_out,     -- output
      vme_berr_b      => vme_berr_b,          -- input
      vme_berr_out    => vme_berr_out,        -- output
      vme_dtack_b     => int_vme_dtack_v6_b,  -- output
      vme_tovme       => vme_tovme,           -- tovme
      vme_tovme_b     => vme_tovme_b,         -- tovme*
      vme_doe         => vme_doe,             -- doe
      vme_doe_b       => vme_doe_b,           -- doe*

-- Clock

      clk    => clk40,                  -- fpgaclk (40MHz)
      clk_s1 => clk10,                  -- midclk (10MHz) 
      clk_s2 => clk2p5,                 -- slowclk (2.5MHz)
      clk_s3 => clk1p25,                -- slowclk2 (1.25MHz)

-- Reset

      rst => reset,

-- JTAG signals To/From DCFEBs

      dl_jtag_tck    => dl_jtag_tck,
      dl_jtag_tms    => dl_jtag_tms,
      dl_jtag_tdi    => dl_jtag_tdi,
      dl_jtag_tdo    => dl_jtag_tdo,
      dl_rtn_shft_en => dl_rtn_shft_en,
      ul_jtag_tck    => ul_jtag_tck,
      ul_jtag_tms    => ul_jtag_tms,
      ul_jtag_tdi    => ul_jtag_tdi,

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

      adc_cs     => adc_cs,
      adc_sclk   => adc_sclk,
      adc_sdain  => adc_sdain,
      adc_sdaout => adc_sdaout,

-- To/From O-DMB DAC

      dac_cs     => dac_cs,
      dac_sclk   => dac_sclk,
      dac_sdain  => dac_sdain,
      dac_sdaout => dac_sdaout,

-- To/From DCFEB FIFOs

      fifo_wr_ck => fifo_wr_ck,
      fifo_wr_en => fifo_tm_wr_en,
      fifo_rw_en => fifo_rw_en,
      fifo_rm_en => fifo_rm_en,
      fifo_tm_en => fifo_tm_en,

      fifo_in  => fifo_in,
      fifo_out => fifo_out,

-- SPI signals To/From DCFEBs (ADCs and DACs)

      dl_spi_cs0  => dl_spi_cs0,
      dl_spi_cs1  => dl_spi_cs1,
      dl_spi_scl  => dl_spi_scl,
      dl_spi_sda  => dl_spi_sda,
      ul_spi_scl  => ul_spi_scl,
      ul_spi_sda  => ul_spi_sda,
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

      qpll_autorestart => qpll_autorestart,  -- NEW!
      qpll_mode        => qpll_mode,         -- NEW!
      qpll_extcontrol  => qpll_extcontrol,   -- NEW!
      qpll_reset       => qpll_reset,        -- NEW!
      qpll_f0sel       => qpll_f0sel,        -- NEW!
      qpll_locked      => qpll_locked,       -- NEW!
      qpll_error       => qpll_error,        -- NEW!

-- From/To LVMB

      lvmb_pon   => int_lvmb_pon,
      pon_load   => pon_load,
      pon_oe_b   => pon_en,
      r_lvmb_pon => r_lvmb_pon,
      lvmb_csb   => int_lvmb_csb,
      lvmb_sclk  => int_lvmb_sclk,
      lvmb_sdin  => int_lvmb_sdin,
      lvmb_sdout => int_lvmb_sdout,

      diagout_cfebjtag => diagout_cfebjtag,
      diagout_lvdbmon  => diagout_lvdbmon,

-- From/To FIFOs

      tfifo_data  => tfifo_data,
      tfifo_wc    => tfifo_wc,
      tfifo_rc    => tfifo_rc,
      tfifo_str   => tfifo_str,
      tfifo_wr_en => tfifo_wr_en,
      tfifo_rd_en => tfifo_rd_en,
      tfifo_sel   => tfifo_sel,
      tfifo_mode  => tfifo_mode,

      flf_ctrl => flf_ctrl,
      flf_data => flf_data

      );



-- ODMB_CTRL FPGA

  MBC : ODMB_CTRL
    port map (

      ga => vme_ga,

      mbc_fsel    => mbc_fsel,
      mbc_jtag_ir => mbc_jtag_ir,

      ccb_cmd    => ccb_cmd,            -- ccbcmnd(5 downto 0) - from J3
      ccb_cmd_s  => ccb_cmd_s,          -- ccbcmnd(6) - from J3
      ccb_data   => ccb_data,           -- ccbdata(7 downto 0) - from J3
      ccb_data_s => ccb_data_s,         -- ccbdata(8) - from J3
      ccb_cal    => ccb_cal,            -- ccbcal(2 downto 0) - from J3
      ccb_crsv   => ccb_crsv,  -- NEW [ccbrsv(6)], ccbrsv(3 downto 0) - from J3
      ccb_drsv   => ccb_drsv,           -- ccbrsv(5 downto 4) - from J3
      ccb_rsvo   => ccb_rsvo,  -- NEW [ccbrsv(11)], ccbrsv(10 downto 7) - from J3
      ccb_rsvi   => ccb_rsvi,           -- ccbrsv(14 downto 12) - to J3
      ccb_bx0    => ccb_bx0,            -- bx0 - from J3
      ccb_bxrst  => ccb_bxrst,          -- bxrst - from J3
      ccb_l1acc  => ccb_l1acc,          -- l1acc - from J3
      ccb_l1arst => ccb_l1arst,         -- l1rst - from J3
      ccb_l1rls  => ccb_l1rls,          -- l1rls - to J3
      ccb_clken  => ccb_clken,          -- clken - from J3

      rawlct    => rawlct,              -- rawlct(NFEB downto 0) - from J4
      tmb_dav   => lctdav1,             -- lctdav1 - from J4
      alct_dav  => lctdav2,             -- lctdav2 - from J4
      lctrqst   => lctrqst,             -- lctrqst(2 downto 1) - to J4
      rsvtd_in  => rsvtd_in,            -- spare(7 DOWNTO 3) - to J4
--              rsvtd_out => rsvtd_out(6 downto 3),                                                                                     -- spare(7 DOWNTO 3) - from J4
      rsvtd_out => rsvtd_out,           -- spare(2 DOWNTO 0) - from J4

-- From GigaLinks

      grx0_data       => "0000000000000000",  -- glin(15 downto 0)                                                                      
      grx0_data_valid => '0',
      grx1_data       => "0000000000000000",  -- glin(15 downto 0)                                                                                      
      grx1_data_valid => '0',

-- To GigaLinks

      gtx0_data       => gtx0_data,  -- dout(15 downto 0)                                                                                      
      gtx0_data_valid => gtx0_data_valid,
      gtx1_data       => gtx1_data,  -- dout(15 downto 0)                                                                                      
      gtx1_data_valid => gtx1_data_valid,

-- From/To FIFOs

      fifo_rd_ck   => fifo_rd_ck,
      data_fifo_re => data_fifo_re_b,
      data_fifo_oe => data_fifo_oe,

      fifo_out => fifo_out,

      fifo_mrst_b => fifo_mrst_b,       -- ok -> fifo_mrst* - to FIFOs 
      fifo_prst_b => fifo_prst_b,       -- ok -> fifo_prst* - to FIFOs 

      fifo_full_b  => fifo_full,          -- full*(7 DOWNTO 1) - from FIFOs 
      fifo_half_b  => fifo_half,          -- half*(7 DOWNTO 1) - from FIFOs 
      fifo_pae_b   => fifo_pae,           -- paef*(7 DOWNTO 1) - from FIFOs 
      fifo_empty_b => data_fifo_empty_b,  -- emptyf*(7 DOWNTO 1) - from FIFOs 

-- From CAFIFO to Data FIFOs
      dcfeb_fifo_wr_en => dcfeb_fifo_wr_en,
      alct_fifo_wr_en  => alct_fifo_wr_en,
      tmb_fifo_wr_en   => tmb_fifo_wr_en,

      cafifo_l1a_match => cafifo_l1a_match,

-- From ALCT,TMB,DCFEBs to CAFIFO
      alct_dv     => gen_alct_data_valid,
      tmb_dv      => gen_tmb_data_valid,
      dcfeb0_dv   => dcfeb_data_valid(1),
      dcfeb0_data => dcfeb_data(1),
      dcfeb1_dv   => dcfeb_data_valid(2),
      dcfeb1_data => dcfeb_data(2),
      dcfeb2_dv   => dcfeb_data_valid(3),
      dcfeb2_data => dcfeb_data(3),
      dcfeb3_dv   => dcfeb_data_valid(4),
      dcfeb3_data => dcfeb_data(4),
      dcfeb4_dv   => dcfeb_data_valid(5),
      dcfeb4_data => dcfeb_data(5),
      dcfeb5_dv   => dcfeb_data_valid(6),
      dcfeb5_data => dcfeb_data(6),
      dcfeb6_dv   => dcfeb_data_valid(7),
      dcfeb6_data => dcfeb_data(7),


-- From/To DCFEBs (FF-EMU-MOD)

      ul_dav   => ul_dav,               -- davf(5 DOWNTO 1) - from DCFEBs 
      ul_movlp => ul_movlp,             -- movlp(5 DOWNTO 1) - from DCFEBs

      dcfeb_l1a_match => dcfeb_l1a_match,  -- lctf(5 DOWNTO 1) - to DCFEBs
      dcfeb_l1a       => dcfeb_l1a,        -- febrst - to DCFEBs
      dcfeb_injpulse  => dcfeb_injpulse,   -- inject - to DCFEBs
      dcfeb_extpulse  => dcfeb_extpulse,   -- extpulse - to DCFEBs

-- From/To LVMB

      r_lvmb_pon => r_lvmb_pon,
      lvmb_csb   => int_lvmb_csb,
      lvmb_sclk  => int_lvmb_sclk,
      lvmb_sdin  => int_lvmb_sdin,
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
    port map (
      otx1_tx_en  => otx1_tx_en,
      otx1_tx_dis => otx1_tx_dis,
      otx1_reset  => otx1_reset,
      otx1_fault  => otx1_fault,
      otx2_tx_en  => otx2_tx_en,
      otx2_tx_dis => otx2_tx_dis,
      otx2_reset  => otx2_reset,
      otx2_fault  => otx2_fault,
      orx1_rx_en  => orx1_rx_en,
      orx1_en_sd  => orx1_en_sd,
      orx1_sd     => orx1_sd,
      orx1_sq_en  => orx1_sq_en,
      orx2_rx_en  => orx2_rx_en,
      orx2_en_sd  => orx2_en_sd,
      orx2_sd     => orx2_sd,
      orx2_sq_en  => orx2_sq_en);

  orx2_01_sd <= orx2_sd;
  orx2_02_sd <= orx2_sd;
  orx2_03_sd <= orx2_sd;
  orx2_04_sd <= orx2_sd;
  orx2_05_sd <= orx2_sd;
  orx2_06_sd <= orx2_sd;
  orx2_07_sd <= orx2_sd;
  orx2_08_sd <= orx2_sd;

-- FIFO MUX
  fifo_out <= dcfeb_fifo_out(1) when data_fifo_oe = "111111110" else
              dcfeb_fifo_out(2) when data_fifo_oe = "111111101" else
              dcfeb_fifo_out(3) when data_fifo_oe = "111111011" else
              dcfeb_fifo_out(4) when data_fifo_oe = "111110111" else
              dcfeb_fifo_out(5) when data_fifo_oe = "111101111" else
              dcfeb_fifo_out(6) when data_fifo_oe = "111011111" else
              dcfeb_fifo_out(7) when data_fifo_oe = "110111111" else
              gen_tmb_fifo_out  when data_fifo_oe = "101111111" else
              gen_alct_fifo_out when data_fifo_oe = "011111111" else
              (others => 'Z');

-- DCFEB FIFO WR_EN GENERATION

-- fifo_wr_en_proc : process(dcfeb0_data_valid,dcfeb1_data_valid,dcfeb2_data_valid,dcfeb3_data_valid,
--                                                                              dcfeb4_data_valid,dcfeb5_data_valid,dcfeb6_data_valid,tmb_data_valid,
--                                                                              alct_data_valid,fifo_rm_en,fifo_tm_en,fifo_tm_wr_en,fifo_rw_en)
--begin
--      fifo_wr_en(1) <= (dcfeb0_data_valid and fifo_rm_en(1)) or (fifo_tm_wr_en(1) and fifo_tm_en(1));
--      fifo_wr_en(2) <= (dcfeb1_data_valid and fifo_rm_en(2)) or (fifo_tm_wr_en(2) and fifo_tm_en(2));
--      fifo_wr_en(3) <= (dcfeb2_data_valid and fifo_rm_en(3)) or (fifo_tm_wr_en(3) and fifo_tm_en(3));
--      fifo_wr_en(4) <= (dcfeb3_data_valid and fifo_rm_en(4)) or (fifo_tm_wr_en(4) and fifo_tm_en(4));
--      fifo_wr_en(5) <= (dcfeb4_data_valid and fifo_rm_en(5)) or (fifo_tm_wr_en(5) and fifo_tm_en(5));
--      fifo_wr_en(6) <= (dcfeb5_data_valid and fifo_rm_en(6)) or (fifo_tm_wr_en(6) and fifo_tm_en(6));
--      fifo_wr_en(7) <= (dcfeb6_data_valid and fifo_rm_en(7)) or (fifo_tm_wr_en(7) and fifo_tm_en(7));
--      fifo_wr_en(8) <= (tmb_data_valid and fifo_rm_en(8)) or (fifo_tm_wr_en(8) and fifo_tm_en(8));
--      fifo_wr_en(9) <= (alct_data_valid and fifo_rm_en(9)) or (fifo_tm_wr_en(9) and fifo_tm_en(9));
--end process;

  fifo_wr_en <= "000000000";            -- to remove error 528!!!

-- Test FIFO Management

  FIFO_OUT_SEL_PM : fifo_outdata_sel
    port map (
      fifo_sel      => tfifo_sel,
      fifo0_outdata => dcfeb_tfifo_out(1),
      fifo1_outdata => dcfeb_tfifo_out(2),
      fifo2_outdata => dcfeb_tfifo_out(3),
      fifo3_outdata => dcfeb_tfifo_out(4),
      fifo4_outdata => dcfeb_tfifo_out(5),
      fifo5_outdata => dcfeb_tfifo_out(6),
      fifo6_outdata => dcfeb_tfifo_out(7),
      fifo7_outdata => dcfeb_tfifo_out(8),
      fifo_outdata  => tfifo_data);

  FIFO_WC_SEL_PM : fifo_wc_sel
    port map (
      fifo_sel => tfifo_sel,
      fifo0_wc => dcfeb_tfifo_wr_cnt(1),
      fifo1_wc => dcfeb_tfifo_wr_cnt(2),
      fifo2_wc => dcfeb_tfifo_wr_cnt(3),
      fifo3_wc => dcfeb_tfifo_wr_cnt(4),
      fifo4_wc => dcfeb_tfifo_wr_cnt(5),
      fifo5_wc => dcfeb_tfifo_wr_cnt(6),
      fifo6_wc => dcfeb_tfifo_wr_cnt(7),
      fifo7_wc => dcfeb_tfifo_wr_cnt(8),
      fifo_wc  => tfifo_wc);

  FIFO_RC_SEL_PM : fifo_rc_sel
    port map (
      fifo_sel => tfifo_sel,
      fifo0_rc => dcfeb_tfifo_rd_cnt(1),
      fifo1_rc => dcfeb_tfifo_rd_cnt(2),
      fifo2_rc => dcfeb_tfifo_rd_cnt(3),
      fifo3_rc => dcfeb_tfifo_rd_cnt(4),
      fifo4_rc => dcfeb_tfifo_rd_cnt(5),
      fifo5_rc => dcfeb_tfifo_rd_cnt(6),
      fifo6_rc => dcfeb_tfifo_rd_cnt(7),
      fifo7_rc => dcfeb_tfifo_rd_cnt(8),
      fifo_rc  => tfifo_rc);

  tfifo_str(0)  <= dcfeb_tfifo_empty(1);
  tfifo_str(1)  <= dcfeb_tfifo_full(1);
  tfifo_str(2)  <= dcfeb_tfifo_empty(2);
  tfifo_str(3)  <= dcfeb_tfifo_full(2);
  tfifo_str(4)  <= dcfeb_tfifo_empty(3);
  tfifo_str(5)  <= dcfeb_tfifo_full(3);
  tfifo_str(6)  <= dcfeb_tfifo_empty(4);
  tfifo_str(7)  <= dcfeb_tfifo_full(4);
  tfifo_str(8)  <= dcfeb_tfifo_empty(5);
  tfifo_str(9)  <= dcfeb_tfifo_full(5);
  tfifo_str(10) <= dcfeb_tfifo_empty(6);
  tfifo_str(11) <= dcfeb_tfifo_full(6);
  tfifo_str(12) <= dcfeb_tfifo_empty(7);
  tfifo_str(13) <= dcfeb_tfifo_full(7);
  tfifo_str(14) <= dcfeb_tfifo_empty(8);
  tfifo_str(15) <= dcfeb_tfifo_full(8);

  GEN_DCFEB_TFIFO : for I in NFEB+1 downto 1 generate  -- (dummy DCFEB7 for GBRX test only)

  begin

    dcfeb_gbrx_data(I)       <= (others => '0');
    dcfeb_gbrx_data_valid(I) <= '0';
    dcfeb_gbrx_data_clk(I)   <= '0';

    dcfeb_tfifo_in(I)    <= dcfeb_gbrx_data(I)       when (tfifo_mode = '1') else vme_data_in;
    dcfeb_tfifo_wr_en(I) <= dcfeb_gbrx_data_valid(I) when (tfifo_mode = '1') else tfifo_wr_en(I);
--  dcfeb_tfifo_wr_ck(I) <= dcfeb_gbrx_data_clk(I) when (tfifo_mode = '1') else clk2p5;;
    dcfeb_tfifo_wr_ck(I) <= clk2p5;
    dcfeb_tfifo_rd_en(I) <= tfifo_rd_en(I);
    dcfeb_tfifo_rd_ck(I) <= clk2p5;

    DCFEB_TFIFO : FIFO_DUALCLOCK_MACRO
      generic map (
        DEVICE                  => "VIRTEX6",  -- Target Device: "VIRTEX5", "VIRTEX6" 
        ALMOST_FULL_OFFSET      => X"0080",  -- Sets almost full threshold
        ALMOST_EMPTY_OFFSET     => X"0080",  -- Sets the almost empty threshold
        DATA_WIDTH              => 16,  -- Valid values are 1-72 (37-72 only valid when FIFO_SIZE="36Kb")
        FIFO_SIZE               => "18Kb",   -- Target BRAM, "18Kb" or "36Kb" 
        FIRST_WORD_FALL_THROUGH => false)  -- Sets the FIFO FWFT to TRUE or FALSE

      port map (
        ALMOSTEMPTY => dcfeb_tfifo_aempty(I),  -- Output almost empty 
        ALMOSTFULL  => dcfeb_tfifo_afull(I),   -- Output almost full
        DO          => dcfeb_tfifo_out(I),     -- Output data
        EMPTY       => dcfeb_tfifo_empty(I),   -- Output empty
        FULL        => dcfeb_tfifo_full(I),    -- Output full
        RDCOUNT     => dcfeb_tfifo_rd_cnt(I),  -- Output read count
        RDERR       => open,                   -- Output read error
        WRCOUNT     => dcfeb_tfifo_wr_cnt(I),  -- Output write count
        WRERR       => open,                   -- Output write error
        DI          => dcfeb_tfifo_in(I),      -- Input data
        RDCLK       => dcfeb_tfifo_rd_ck(I),   -- Input read clock
        RDEN        => dcfeb_tfifo_rd_en(I),   -- Input read enable
        RST         => reset,                  -- Input reset
        WRCLK       => dcfeb_tfifo_wr_ck(I),   -- Input write clock
        WREN        => dcfeb_tfifo_wr_en(I)    -- Input write enable
        );

  end generate GEN_DCFEB_TFIFO;

-- To CAFIFO

  alct_tmb_data_gen_PM : alct_tmb_data_gen

    port map(

      clk            => clk40,
      rst            => reset,
      l1a            => dcfeb_l1a,
      alct_l1a_match => cafifo_l1a_match(NFEB+2),
      tmb_l1a_match  => cafifo_l1a_match(NFEB+1),
      alct_dv        => gen_alct_data_valid,
      alct_data      => gen_alct_data,
      tmb_dv         => gen_tmb_data_valid,
      tmb_data       => gen_tmb_data);



  
  data_fifo_re      <= not data_fifo_re_b;
--  data_fifo_empty_b <= (not alct_fifo_empty) & (not tmb_fifo_empty) & (not dcfeb_fifo_empty);
  data_fifo_empty_b <= alct_fifo_empty & tmb_fifo_empty & dcfeb_fifo_empty;

  gen_alct_fifo_in <= gen_alct_data;

  ALCT_FIFO : FIFO_DUALCLOCK_MACRO
    generic map (
      DEVICE                  => "VIRTEX6",  -- Target Device: "VIRTEX5", "VIRTEX6" 
      ALMOST_FULL_OFFSET      => X"0080",    -- Sets almost full threshold
      ALMOST_EMPTY_OFFSET     => X"0080",    -- Sets the almost empty threshold
      DATA_WIDTH              => 16,  -- Valid values are 1-72 (37-72 only valid when FIFO_SIZE="36Kb")
      FIFO_SIZE               => "18Kb",     -- Target BRAM, "18Kb" or "36Kb" 
      FIRST_WORD_FALL_THROUGH => false)  -- Sets the FIFO FWFT to TRUE or FALSE

    port map (
      ALMOSTEMPTY => alct_fifo_aempty,      -- Output almost empty 
      ALMOSTFULL  => alct_fifo_afull,       -- Output almost full
      DO          => gen_alct_fifo_out,     -- Output data
      EMPTY       => alct_fifo_empty,       -- Output empty
      FULL        => alct_fifo_full,        -- Output full
      RDCOUNT     => alct_fifo_rd_cnt,      -- Output read count
      RDERR       => open,                  -- Output read error
      WRCOUNT     => alct_fifo_wr_cnt,      -- Output write count
      WRERR       => open,                  -- Output write error
      DI          => gen_alct_fifo_in,      -- Input data
      RDCLK       => clk40,                 -- Input read clock
      RDEN        => data_fifo_re(NFEB+2),  -- Input read enable
      RST         => reset,                 -- Input reset
      WRCLK       => clk40,                 -- Input write clock
      WREN        => alct_fifo_wr_en        -- Input write enable
      );


  gen_tmb_fifo_in <= gen_tmb_data;

  TMB_FIFO : FIFO_DUALCLOCK_MACRO
    generic map (
      DEVICE                  => "VIRTEX6",  -- Target Device: "VIRTEX5", "VIRTEX6" 
      ALMOST_FULL_OFFSET      => X"0080",    -- Sets almost full threshold
      ALMOST_EMPTY_OFFSET     => X"0080",    -- Sets the almost empty threshold
      DATA_WIDTH              => 16,  -- Valid values are 1-72 (37-72 only valid when FIFO_SIZE="36Kb")
      FIFO_SIZE               => "18Kb",     -- Target BRAM, "18Kb" or "36Kb" 
      FIRST_WORD_FALL_THROUGH => false)  -- Sets the FIFO FWFT to TRUE or FALSE

    port map (
      ALMOSTEMPTY => tmb_fifo_aempty,       -- Output almost empty 
      ALMOSTFULL  => tmb_fifo_afull,        -- Output almost full
      DO          => gen_tmb_fifo_out,      -- Output data
      EMPTY       => tmb_fifo_empty,        -- Output empty
      FULL        => tmb_fifo_full,         -- Output full
      RDCOUNT     => tmb_fifo_rd_cnt,       -- Output read count
      RDERR       => open,                  -- Output read error
      WRCOUNT     => tmb_fifo_wr_cnt,       -- Output write count
      WRERR       => open,                  -- Output write error
      DI          => gen_tmb_fifo_in,       -- Input data
      RDCLK       => clk40,                 -- Input read clock
      RDEN        => data_fifo_re(NFEB+1),  -- Input read enable
      RST         => reset,                 -- Input reset
      WRCLK       => clk40,                 -- Input write clock
      WREN        => tmb_fifo_wr_en         -- Input write enable
      );

-- DCFEB0


  dl_resync(1) <= dl_global_rst;


-- DCFEB1


  dl_resync(2) <= dl_global_rst;


-- DCFEB2


  dl_resync(3) <= dl_global_rst;


-- DCFEB3


  dl_resync(4) <= dl_global_rst;


-- DCFEB4

  dl_resync(5) <= dl_global_rst;



-- DCFEB5


  dl_resync(6) <= dl_global_rst;



-- DCFEB6


  dl_resync(7) <= dl_global_rst;


-- TMB0

  tmb_data <= tmb(15 downto 0);
--  tmb_data(16 downto 0) <= tmb(16 downto 0);
--  tmb_data(17)          <= '0';
--  tmb_data_valid        <= tmb(17);

  tmb_fifo_in_proc : process(fifo_rm_en, tmb_data_valid, fifo_tm_en, fifo_tm_wr_en, fifo_rw_en, tmb_data, fifo_out, fifo_in)

  begin
--      fifo_wr_en(8) <= (tmb_data_valid and fifo_rm_en(8)) or (fifo_tm_wr_en(8) and fifo_tm_en(8));
    if (fifo_rm_en(8) = '1') then
      tmb_fifo_in <= tmb_data;
    elsif (fifo_rw_en(8) = '1') then
      tmb_fifo_in <= fifo_out;
    else
      tmb_fifo_in <= fifo_in;
    end if;

  end process;

  b2v_tmb_fifo : FIFO_SYNC_MACRO
    generic map (
      DEVICE              => "VIRTEX6",  -- Target Device: "VIRTEX5, "VIRTEX6" 
      ALMOST_FULL_OFFSET  => X"0080",   -- Sets almost full threshold
      ALMOST_EMPTY_OFFSET => X"0080",   -- Sets the almost empty threshold
      DATA_WIDTH          => 16,  -- Valid values are 1-72 (37-72 only valid when FIFO_SIZE="36Kb")
      FIFO_SIZE           => "18Kb")    -- Target BRAM, "18Kb" or "36Kb" 
    port map (
      ALMOSTEMPTY => fifo_pae(8),       -- Output almost empty 
      ALMOSTFULL  => fifo_half(8),      -- Output almost full
      DO          => tmb_fifo_out,      -- Output data
      EMPTY       => fifo_empty(8),     -- Output empty
      FULL        => fifo_full(8),      -- Output full
      RDCOUNT     => tmb_rd_cnt,        -- Output read count
      RDERR       => tmb_rd_err,        -- Output read error
      WRCOUNT     => tmb_wr_cnt,        -- Output write count
      WRERR       => tmb_wr_err,        -- Output write error
      CLK         => fifo_wr_ck,        -- Input clock
      DI          => tmb_fifo_in,       -- Input data
      RDEN        => fifo_rd_en(8),     -- Input read enable
      RST         => reset,             -- Input reset
      WREN        => fifo_wr_en(8)      -- Input write enable
      );

-- TMB1

  alct_data <= alct(15 downto 0);
--  alct_data(16 downto 0) <= alct(16 downto 0);
--  alct_data(17)          <= '0';
--  alct_data_valid        <= alct(17);

  alct_fifo_in_proc : process(fifo_rm_en, alct_data_valid, fifo_tm_en, fifo_tm_wr_en, fifo_rw_en, alct_data, fifo_out, fifo_in)

  begin
--      fifo_wr_en(9) <= (alct_data_valid and fifo_rm_en(9)) or (fifo_tm_wr_en(9) and fifo_tm_en(9));
    if (fifo_rm_en(9) = '1') then
      alct_fifo_in <= alct_data;
    elsif (fifo_rw_en(9) = '1') then
      alct_fifo_in <= fifo_out;
    else
      alct_fifo_in <= fifo_in;
    end if;

  end process;

  b2v_alct_fifo : FIFO_SYNC_MACRO
    generic map (
      DEVICE              => "VIRTEX6",  -- Target Device: "VIRTEX5, "VIRTEX6" 
      ALMOST_FULL_OFFSET  => X"0080",   -- Sets almost full threshold
      ALMOST_EMPTY_OFFSET => X"0080",   -- Sets the almost empty threshold
      DATA_WIDTH          => 16,  -- Valid values are 1-72 (37-72 only valid when FIFO_SIZE="36Kb")
      FIFO_SIZE           => "18Kb")    -- Target BRAM, "18Kb" or "36Kb" 
    port map (
      ALMOSTEMPTY => fifo_pae(9),       -- Output almost empty 
      ALMOSTFULL  => fifo_half(9),      -- Output almost full
      DO          => alct_fifo_out,     -- Output data
      EMPTY       => fifo_empty(9),     -- Output empty
      FULL        => fifo_full(9),      -- Output full
      RDCOUNT     => alct_rd_cnt,       -- Output read count
      RDERR       => alct_rd_err,       -- Output read error
      WRCOUNT     => alct_wr_cnt,       -- Output write count
      WRERR       => alct_wr_err,       -- Output write error
      CLK         => fifo_wr_ck,        -- Input clock
      DI          => alct_fifo_in,      -- Input data
      RDEN        => fifo_rd_en(9),     -- Input read enable
      RST         => reset,             -- Input reset
      WREN        => fifo_wr_en(9)      -- Input write enable
      );


-- LVMB ADCs

  LVMB_ADC1_PM : LVMB_ADC
    port map (
      scl    => int_lvmb_sclk,
      sdi    => int_lvmb_sdin,
      sdo    => int_lvmb_adc_sdout(0),
      ce     => int_lvmb_csb(0),
      rst    => reset,
      device => "0001");

  LVMB_ADC2_PM : LVMB_ADC
    port map (
      scl    => int_lvmb_sclk,
      sdi    => int_lvmb_sdin,
      sdo    => int_lvmb_adc_sdout(1),
      ce     => int_lvmb_csb(1),
      rst    => reset,
      device => "0010");

  LVMB_ADC3_PM : LVMB_ADC
    port map (
      scl    => int_lvmb_sclk,
      sdi    => int_lvmb_sdin,
      sdo    => int_lvmb_adc_sdout(2),
      ce     => int_lvmb_csb(2),
      rst    => reset,
      device => "0011");

  LVMB_ADC4_PM : LVMB_ADC
    port map (
      scl    => int_lvmb_sclk,
      sdi    => int_lvmb_sdin,
      sdo    => int_lvmb_adc_sdout(3),
      ce     => int_lvmb_csb(3),
      rst    => reset,
      device => "0100");

  LVMB_ADC5_PM : LVMB_ADC
    port map (
      scl    => int_lvmb_sclk,
      sdi    => int_lvmb_sdin,
      sdo    => int_lvmb_adc_sdout(4),
      ce     => int_lvmb_csb(4),
      rst    => reset,
      device => "0101");

  LVMB_ADC6_PM : LVMB_ADC
    port map (
      scl    => int_lvmb_sclk,
      sdi    => int_lvmb_sdin,
      sdo    => int_lvmb_adc_sdout(5),
      ce     => int_lvmb_csb(5),
      rst    => reset,
      device => "0110");

  LVMB_ADC7_PM : LVMB_ADC
    port map (
      scl    => int_lvmb_sclk,
      sdi    => int_lvmb_sdin,
      sdo    => int_lvmb_adc_sdout(6),
      ce     => int_lvmb_csb(6),
      rst    => reset,
      device => "0111");

  LVMB_ADC_SDO_MUX_PM : LVMB_ADC_SDO_MUX
    port map (
      int_lvmb_adc_en  => flf_ctrl(7),
      int_lvmb_adc_sdo => int_lvmb_adc_sdout,
      lvmb_adc_sdo     => lvmb_sdout,
      adc_ce           => int_lvmb_csb,
      sdo              => int_lvmb_sdout);


  orx_dcfeb_data_n <= orx2_n;
  orx_dcfeb_data_p <= orx2_p;

  DMB_RX_PM : dmb_receiver
    generic map (
      USE_2p56GbE => 1,
      SIM_SPEEDUP => 1
      )
    port map (
      -- Chip Scope Pro Logic Analyzer control -- bgb
      CSP_GTX_MAC_LA_CTRL => LOGIC36L,
      CSP_PKT_FRM_LA_CTRL => LOGIC36L,
      CSP_FIFO_LA_CTRL    => LOGIC36L,


      --External signals
      RST              => reset,
      ORX2_01_N        => rx_dcfeb_data_n(1),
      ORX2_01_P        => rx_dcfeb_data_p(1),
      ORX2_02_N        => rx_dcfeb_data_n(2),
      ORX2_02_P        => rx_dcfeb_data_p(2),
      ORX2_03_N        => rx_dcfeb_data_n(3),
      ORX2_03_P        => rx_dcfeb_data_p(3),
      ORX2_04_N        => rx_dcfeb_data_n(4),
      ORX2_04_P        => rx_dcfeb_data_p(4),
      ORX2_05_N        => rx_dcfeb_data_n(5),
      ORX2_05_P        => rx_dcfeb_data_p(5),
      ORX2_06_N        => rx_dcfeb_data_n(6),
      ORX2_06_P        => rx_dcfeb_data_p(6),
      ORX2_07_N        => rx_dcfeb_data_n(7),
      ORX2_07_P        => rx_dcfeb_data_p(7),
      ORX2_08_N        => orx2_n(8),
      ORX2_08_P        => orx2_p(8),
      ORX2_09_N        => orx2_n(9),
      ORX2_09_P        => orx2_p(9),
      ORX2_10_N        => orx2_n(10),
      ORX2_10_P        => orx2_p(10),
      ORX2_11_N        => orx2_n(11),
      ORX2_11_P        => orx2_p(11),
      ORX2_12_N        => orx2_n(12),
      ORX2_12_P        => orx2_p(12),
      DCFEB1_DATA      => rx_dcfeb_data(1),
      DCFEB2_DATA      => rx_dcfeb_data(2),
      DCFEB3_DATA      => rx_dcfeb_data(3),
      DCFEB4_DATA      => rx_dcfeb_data(4),
      DCFEB5_DATA      => rx_dcfeb_data(5),
      DCFEB6_DATA      => rx_dcfeb_data(6),
      DCFEB7_DATA      => rx_dcfeb_data(7),
      DCFEB_DATA_VALID => rx_dcfeb_data_valid,

      --Internal signals
      FIFO_VME_MODE          => fifo_vme_mode,
      FIFO_SEL               => fifo_sel,
      RD_EN_FF               => rd_en_ff,
      WR_EN_FF               => wr_en_ff,
      FF_DATA_IN             => ff_data_in,
      FF_DATA_OUT            => ff_data_out,
      FF_WRD_CNT             => ff_wrd_cnt,
      FF_STATUS              => ff_status,
      DMBVME_CLK_S2          => dmbvme_clk_s2,
      DAQ_RX_125REFCLK       => daq_rx_125refclk,
      DAQ_RX_160REFCLK_115_0 => clk80
      );

  rx_dcfeb_sel  <= '1';
  opt_dcfeb_sel <= '0';

  GEN_DCFEB : for I in NFEB downto 1 generate
  begin

    dcfeb_data_valid(I) <= rx_dcfeb_data_valid(I) when (rx_dcfeb_sel = '1') else gen_dcfeb_data_valid(I);

    rx_dcfeb_data_p(I) <= orx_dcfeb_data_p(I) when (opt_dcfeb_sel = '1') else gen_dcfeb_data_p(I);
    rx_dcfeb_data_n(I) <= orx_dcfeb_data_n(I) when (opt_dcfeb_sel = '1') else gen_dcfeb_data_n(I);

    dcfeb_fifo_in(I) <= fifo_in when ((fifo_rm_en(I) = '0') and (fifo_rw_en(I) = '0')) else 
                        fifo_out when ((fifo_rm_en(I) = '0') and (fifo_rw_en(I) = '1')) else
                        rx_dcfeb_data(I) when (rx_dcfeb_sel = '1') else 
                        gen_dcfeb_data(I);

    DCFEB_V6_PM : DCFEB_V6
      generic map(
        dcfeb_addr => dcfeb_addr(I))
      port map(
        clk           => clk40,
        clk80         => clk80,
        rst           => reset,
        l1a           => dcfeb_l1a,
        l1a_match     => dcfeb_l1a_match(I),
        tx_ack        => dcfeb_tx_ack(I), -- 1 if rx_dcfeb_sel = 0!!!
        dcfeb_dv      => gen_dcfeb_data_valid(I),
        dcfeb_data    => gen_dcfeb_data(I),
        adc_mask      => dcfeb_adc_mask(I),
        dcfeb_fsel    => dcfeb_fsel(I),
        dcfeb_jtag_ir => dcfeb_jtag_ir(I),
        trst          => reset,
        tck           => dl_jtag_tck(I),
        tms           => dl_jtag_tms,
        tdi           => dl_jtag_tdi,
        rtn_shft_en   => dl_rtn_shft_en(I),
        tdo           => dl_jtag_tdo(I));

-- dcfeb_tx_ack(I) to be connected to data generator in DCFEB_V6!!!

    DCFEB_TX_PM : daq_optical_out
      generic map(
        USE_CHIPSCOPE => 0,
        SIM_SPEEDUP   => 1
        )
      port map(
        DAQ_TX_VIO_CNTRL     => LOGIC36L,
        DAQ_TX_LA_CNTRL      => LOGIC36L,
        RST                  => reset,
        DAQ_RX_N             => LOGICL,
        DAQ_RX_P             => LOGICH,
        DAQ_TDIS             => dcfeb_daq_tdis(I),
        DAQ_TX_N             => gen_dcfeb_data_n(I),
        DAQ_TX_P             => gen_dcfeb_data_p(I),
        DAQ_TX_125REFCLK     => LOGICL,  -- daq_tx_125refclk,
        DAQ_TX_125REFCLK_DV2 => LOGICL,  -- daq_tx_125refclk_dv2,
        DAQ_TX_160REFCLK     => clk80,
        L1A_MATCH            => LOGICL,
        TXD                  => gen_dcfeb_data(I),
        TXD_VLD              => gen_dcfeb_data_valid(I),
        JDAQ_RATE            => LOGICH,  -- '0' selects clock: 125 MHz (1.25 Gb), '1' selects 160 MHz (3.2 Gb)
        RATE_1_25            => open,
        RATE_3_2             => open,
        TX_ACK               => dcfeb_tx_ack(I),
        DAQ_DATA_CLK         => dcfeb_daq_data_clk(I));

    DCFEB_FIFO_PM : FIFO_DUALCLOCK_MACRO
      generic map (
        DEVICE                  => "VIRTEX6",  -- Target Device: "VIRTEX5", "VIRTEX6" 
        ALMOST_FULL_OFFSET      => X"0080",  -- Sets almost full threshold
        ALMOST_EMPTY_OFFSET     => X"0080",  -- Sets the almost empty threshold
        DATA_WIDTH              => 16,  -- Valid values are 1-72 (37-72 only valid when FIFO_SIZE="36Kb")
        FIFO_SIZE               => "18Kb",   -- Target BRAM, "18Kb" or "36Kb" 
        FIRST_WORD_FALL_THROUGH => false)  -- Sets the FIFO FWFT to TRUE or FALSE

      port map (
        ALMOSTEMPTY => dcfeb_fifo_aempty(I),  -- Output almost empty 
        ALMOSTFULL  => dcfeb_fifo_afull(I),   -- Output almost full
        DO          => dcfeb_fifo_out(I),     -- Output data
        EMPTY       => dcfeb_fifo_empty(I),   -- Output empty
        FULL        => dcfeb_fifo_full(I),    -- Output full
        RDCOUNT     => dcfeb_fifo_rd_cnt(I),  -- Output read count
        RDERR       => open,                  -- Output read error
        WRCOUNT     => dcfeb_fifo_wr_cnt(I),  -- Output write count
        WRERR       => open,                  -- Output write error
        DI          => dcfeb_fifo_in(I),      -- Input data
        RDCLK       => clk40,                 -- Input read clock
        RDEN        => data_fifo_re(I),       -- Input read enable
        RST         => reset,                 -- Input reset
        WRCLK       => clk40,                 -- Input write clock
        WREN        => dcfeb_fifo_wr_en(I)    -- Input write enable
        );

  end generate GEN_DCFEB;

end bdf_type;
