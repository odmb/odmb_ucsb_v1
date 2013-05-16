library ieee;
use ieee.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;
entity ODMB_VME is
  generic (
    NFEB : integer range 1 to 7 := 7  -- Number of DCFEBS, 7 in the final design
    );  
  port (

-- VME signals

    vme_addr        : in  std_logic_vector (23 downto 1);  -- adr(23 downto 1)
    vme_data_in     : in  std_logic_vector (15 downto 0);  -- data(15 downto 0)
    vme_data_out    : out std_logic_vector (15 downto 0);  -- data(15 downto 0)
    vme_am          : in  std_logic_vector (5 downto 0);   -- am(5 downto 0)
    vme_ga          : in  std_logic_vector (4 downto 0);   -- ga*(4 downto 0)
    vme_gap         : in  std_logic;                       -- ga*(5)
    vme_ds_b        : in  std_logic_vector(1 downto 0);    -- ids1*,ids0*
    vme_as_b        : in  std_logic;                       -- ias*
    vme_lword_b     : in  std_logic;                       -- ilword*
    vme_write_b     : in  std_logic;                       -- iwrite*
    vme_iack_b      : in  std_logic;                       -- inack*
    vme_sysreset_b  : in  std_logic;                       -- isysrst*
    vme_sysfail_b   : in  std_logic;                       -- isysfail*
    vme_sysfail_out : out std_logic;                       -- NEW
    vme_berr_b      : in  std_logic;                       -- iberr*
    vme_berr_out    : out std_logic;                       -- NEW
    vme_dtack_b     : out std_logic;                       -- odtack*
    vme_tovme       : out std_logic;                       -- tovme
    vme_tovme_b     : out std_logic;                       -- tovme*
    vme_doe         : out std_logic;                       -- doe
    vme_doe_b       : out std_logic;                       -- doe*

-- Clock

    clk80  : in std_logic;            -- For testctrl (80MHz)
    clk    : in std_logic;              -- NEW (fastclk -> 40MHz)
    clk_s1 : in std_logic;              -- NEW (midclk -> fastclk/4 -> 10MHz)
    clk_s2 : in std_logic;              -- NEW (slowclk -> midclk/4 -> 2.5MHz)
    clk_s3 : in std_logic;  -- NEW (slowclk2 -> midclk/8 -> 12.5MHz)

-- Reset

    rst : in std_logic;                 -- iglobalrst

-- JTAG Signals To/From DCFEBs

    dl_jtag_tck    : out std_logic_vector (6 downto 0);
    dl_jtag_tms    : out std_logic;
    dl_jtag_tdi    : out std_logic;
    dl_jtag_tdo    : in  std_logic_vector (6 downto 0);
    dl_rtn_shft_en : in  std_logic_vector (6 downto 0);
    ul_jtag_tck    : in  std_logic_vector (6 downto 0);
    ul_jtag_tms    : in  std_logic_vector (6 downto 0);
    ul_jtag_tdi    : in  std_logic_vector (6 downto 0);

-- JTAG Signals To/From DMB_CTRL

    mbc_jtag_tck : out std_logic;
    mbc_jtag_tms : out std_logic;
    mbc_jtag_tdi : out std_logic;
    mbc_jtag_tdo : in  std_logic;

--              mbc_rtn_shft_en  : IN STD_LOGIC; -- ????

-- Reprogram To DCFEB FPGA (CFEBPRG)

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
    tfifo_wr_en : out std_logic_vector(7 downto 0);
    tfifo_rd_en : out std_logic_vector(7 downto 0);
    tfifo_sel   : out std_logic_vector(7 downto 0);
    tfifo_mode  : out std_logic;

    odmb_ctrl : out std_logic_vector(15 downto 0);
    dcfeb_ctrl : out std_logic_vector(15 downto 0);
    odmb_data : in  std_logic_vector(15 downto 0);

    -- TESTCTRL
    tc_l1a         : out std_logic;
    tc_alct_dav    : out std_logic;
    tc_tmb_dav     : out std_logic;
    tc_lct         : out std_logic_vector(NFEB downto 0);
    ddu_data       : in  std_logic_vector(15 downto 0);
    ddu_data_valid : in  std_logic;
    tc_run         : out std_logic;
    ts_out         : out std_logic_vector(31 downto 0);
    dduclk         : in std_logic;

    -- VMECONFREGS outputs
    ALCT_PUSH_DLY : out std_logic_vector(4 downto 0);
    TMB_PUSH_DLY  : out std_logic_vector(4 downto 0);
    PUSH_DLY      : out std_logic_vector(4 downto 0);
    LCT_L1A_DLY   : out std_logic_vector(5 downto 0);

    -- TESTFIFOS
    TFF_DATA_OUT : in std_logic_vector(15 downto 0);
    TFF_WRD_CNT  : in std_logic_vector(11 downto 0);
    TFF_SEL   : out std_logic_vector(8 downto 1);
    RD_EN_TFF : out std_logic_vector(8 downto 1)


    );

end ODMB_VME;


architecture ODMB_VME_architecture of ODMB_VME is

  signal ext_vme_ga : std_logic_vector(5 downto 0);

  signal device         : std_logic_vector(9 downto 0);
  signal cmd            : std_logic_vector(9 downto 0);
  signal strobe         : std_logic;
  signal tovme_b, doe_b : std_logic;

  signal diagout_command : std_logic_vector(19 downto 0);
  signal led_command     : std_logic_vector(2 downto 0);

  signal outdata_cfebjtag : std_logic_vector(15 downto 0);
-- signal diagout_cfebjtag  : std_logic_vector(17 downto 0);
  signal led_cfebjtag     : std_logic;

  signal outdata_mbcjtag : std_logic_vector(15 downto 0);
  signal led_mbcjtag     : std_logic;

  signal outdata_lvdbmon : std_logic_vector(15 downto 0);

  signal cmd_adrs        : std_logic_vector(15 downto 0);
  signal outdata_fifomon : std_logic_vector(15 downto 0);

  signal outdata_vmemon      : std_logic_vector(15 downto 0);
  signal outdata_vmeconfregs : std_logic_vector(15 downto 0);
  signal outdata_testfifos : std_logic_vector(15 downto 0);

  signal jtag_tck : std_logic_vector(6 downto 0);

  signal outdata_testctrl : std_logic_vector(15 downto 0);

  component VMEMON is
    
    port (

      SLOWCLK : in std_logic;
      RST     : in std_logic;

      DEVICE  : in std_logic;
      STROBE  : in std_logic;
      COMMAND : in std_logic_vector(9 downto 0);

      INDATA  : in  std_logic_vector(15 downto 0);
      OUTDATA : out std_logic_vector(15 downto 0);

      DTACK : out std_logic;

      ODMB_CTRL : out std_logic_vector(15 downto 0);
      DCFEB_CTRL : out std_logic_vector(15 downto 0);
      ODMB_DATA : in  std_logic_vector(15 downto 0)

      );
  end component;


  component VMECONFREGS is
    port (

      SLOWCLK : in std_logic;
      RST     : in std_logic;

      DEVICE  : in std_logic;
      STROBE  : in std_logic;
      COMMAND : in std_logic_vector(9 downto 0);

      INDATA  : in  std_logic_vector(15 downto 0);
      OUTDATA : out std_logic_vector(15 downto 0);

      DTACK : out std_logic;

      ALCT_PUSH_DLY : out std_logic_vector(4 downto 0);
      TMB_PUSH_DLY  : out std_logic_vector(4 downto 0);
      PUSH_DLY      : out std_logic_vector(4 downto 0);
      LCT_L1A_DLY   : out std_logic_vector(5 downto 0)
      );
  end component;

  component TESTFIFOS is
  port (

    SLOWCLK : in std_logic;
    RST     : in std_logic;

    DEVICE  : in std_logic;
    STROBE  : in std_logic;
    COMMAND : in std_logic_vector(9 downto 0);

    INDATA  : in  std_logic_vector(15 downto 0);
    OUTDATA : out std_logic_vector(15 downto 0);

    DTACK : out std_logic;

    TFF_DATA_OUT : in std_logic_vector(15 downto 0);
    TFF_WRD_CNT  : in std_logic_vector(11 downto 0);

    TFF_SEL   : out std_logic_vector(8 downto 1);
    RD_EN_TFF : out std_logic_vector(8 downto 1)
    );
end component;

component TESTCTRL is
    generic (
      NFEB : integer range 1 to 7 := 7  -- Number of DCFEBS, 7 in the final design
      );    
    port (
      CLK     : in std_logic;
      DDUCLK     : in std_logic;
      SLOWCLK : in std_logic;
      RST     : in std_logic;

      DEVICE  : in std_logic;
      STROBE  : in std_logic;
      COMMAND : in std_logic_vector(9 downto 0);

      INDATA  : in  std_logic_vector(15 downto 0);
      OUTDATA : out std_logic_vector(15 downto 0);

      DTACK : out std_logic;

      L1A            : out std_logic;
      ALCT_DAV       : out std_logic;
      TMB_DAV        : out std_logic;
      LCT            : out std_logic_vector(NFEB downto 0);
      DDU_DATA       : in  std_logic_vector(15 downto 0);
      DDU_DATA_VALID : in  std_logic;
      TC_RUN         : out std_logic;
      TS_OUT         : out std_logic_vector(31 downto 0)
      );

  end component;

  component FIFOMON is
    
    port (

      SLOWCLK : in std_logic;
      RST     : in std_logic;

      DEVICE  : in std_logic;
      STROBE  : in std_logic;
      COMMAND : in std_logic_vector(9 downto 0);

      INDATA  : in  std_logic_vector(15 downto 0);
      OUTDATA : out std_logic_vector(15 downto 0);

      DTACK : out std_logic;

      FIFO_WR_EN : out std_logic_vector(7 downto 0);
      FIFO_RD_EN : out std_logic_vector(7 downto 0);
      FIFO_SEL   : out std_logic_vector(7 downto 0);
      FIFO_MODE  : out std_logic;
      FIFO_DATA  : in  std_logic_vector(15 downto 0);
      FIFO_STR   : in  std_logic_vector(15 downto 0);
      FIFO_WRC   : in  std_logic_vector(9 downto 0);
      FIFO_RDC   : in  std_logic_vector(9 downto 0));

  end component;

  component LVDBMON is
    
    port (

      SLOWCLK : in std_logic;
      RST     : in std_logic;

      DEVICE  : in std_logic;
      STROBE  : in std_logic;
      COMMAND : in std_logic_vector(9 downto 0);
      WRITER  : in std_logic;

      INDATA  : in  std_logic_vector(15 downto 0);
      OUTDATA : out std_logic_vector(15 downto 0);

      DTACK : out std_logic;

      LVADCEN : out std_logic_vector(6 downto 0);
      ADCCLK  : out std_logic;
      ADCDATA : out std_logic;
      ADCIN   : in  std_logic;

      LVTURNON   : out std_logic_vector(8 downto 1);
      R_LVTURNON : in  std_logic_vector(8 downto 1);
      LOADON     : out std_logic;

      DIAGLVDB : out std_logic_vector(17 downto 0)
      );

  end component;

  component CFEBJTAG is
    
    port (

      FASTCLK : in std_logic;
      SLOWCLK : in std_logic;
      RST     : in std_logic;

      DEVICE  : in std_logic;
      STROBE  : in std_logic;
      COMMAND : in std_logic_vector(9 downto 0);
      WRITER  : in std_logic;

      INDATA  : in    std_logic_vector(15 downto 0);
      OUTDATA : inout std_logic_vector(15 downto 0);

      DTACK : out std_logic;

      INITJTAGS      : in  std_logic;
      TCK            : out std_logic_vector(7 downto 1);
      TDI            : out std_logic;
      TMS            : out std_logic;
      FEBTDO         : in  std_logic_vector(7 downto 1);
      DL_RTN_SHFT_EN : in  std_logic_vector (7 downto 1);
      UL_JTAG_TCK    : in  std_logic_vector (7 downto 1);

      DIAGOUT : out std_logic_vector(17 downto 0);
      LED     : out std_logic
      );

  end component;

  component MBCJTAG is
    
    port (
      DEVICE    : in std_logic;
      COMMAND   : in std_logic_vector(9 downto 0);
      INDATA    : in std_logic_vector(15 downto 0);
      STROBE    : in std_logic;
      MBCTDO    : in std_logic;
      INITJTAGS : in std_logic;
      WRITER    : in std_logic;
      FASTCLK   : in std_logic;
      SLOWCLK   : in std_logic;
      RST       : in std_logic;

      OUTDATA : out std_logic_vector(15 downto 0);
      DTACK   : out std_logic;
      TDI     : out std_logic;
      TMS     : out std_logic;
      TCK     : out std_logic;
      LED     : out std_logic
      );

  end component;

  component COMMAND_MODULE is
    
    port (

      FASTCLK : in std_logic;
      SLOWCLK : in std_logic;

      GA  : in std_logic_vector(5 downto 0);
      ADR : in std_logic_vector(23 downto 1);
      AM  : in std_logic_vector(5 downto 0);

      AS      : in std_logic;
      DS0     : in std_logic;
      DS1     : in std_logic;
      LWORD   : in std_logic;
      WRITER  : in std_logic;
      IACK    : in std_logic;
      BERR    : in std_logic;
      SYSFAIL : in std_logic;

      DEVICE  : out std_logic_vector(9 downto 0);
      STROBE  : out std_logic;
      COMMAND : out std_logic_vector(9 downto 0);
      ADRS    : out std_logic_vector(17 downto 2);

      TOVME_B : out std_logic;
      DOE_B   : out std_logic;

      DIAGOUT : out std_logic_vector(19 downto 0);
      LED     : out std_logic_vector(2 downto 0)

      );

  end component;

  component vme_outdata_sel is
    
    port
      (

        device          : in  std_logic_vector(9 downto 0);
        device0_outdata : in  std_logic_vector(15 downto 0);
        device1_outdata : in  std_logic_vector(15 downto 0);
        device2_outdata : in  std_logic_vector(15 downto 0);
        device3_outdata : in  std_logic_vector(15 downto 0);
        device4_outdata : in  std_logic_vector(15 downto 0);
        device5_outdata : in  std_logic_vector(15 downto 0);
        device8_outdata : in  std_logic_vector(15 downto 0);
        device9_outdata : in  std_logic_vector(15 downto 0);
        outdata         : out std_logic_vector(15 downto 0)

        );

  end component;


-- Device 0 => VMESTAT

-- Device 1 => CFEBJTAG

-- Device 2 => MBCJTAG

-- Device 3 => CPROMJTAG (REMOVED)                      VMEMON

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
    
    port map (

      FASTCLK => clk,
      SLOWCLK => clk_s2,

      GA  => ext_vme_ga,                -- gap = ga(5)
      ADR => vme_addr,
      AM  => vme_am,

      AS      => vme_as_b,
      DS0     => vme_ds_b(0),
      DS1     => vme_ds_b(1),
      LWORD   => vme_lword_b,
      WRITER  => vme_write_b,
      IACK    => vme_iack_b,
      BERR    => vme_berr_b,
      SYSFAIL => vme_sysfail_b,

      TOVME_B => tovme_b,
      DOE_B   => doe_b,

      DEVICE  => device,
      STROBE  => strobe,
      COMMAND => cmd,
      ADRS    => cmd_adrs,

      DIAGOUT => diagout_command,
      LED     => led_command
      );

  VME_OUT_SEL_PM : vme_outdata_sel
    port map (

      device          => device,
      device0_outdata => outdata_testctrl,
      device1_outdata => outdata_cfebjtag,
      device2_outdata => outdata_mbcjtag,
      device3_outdata => outdata_vmemon,
      device4_outdata => outdata_vmeconfregs,
      device5_outdata => outdata_testfifos,
      device8_outdata => outdata_lvdbmon,
      device9_outdata => outdata_fifomon,
      outdata         => vme_data_out
      );

-- Device 0 => TESTCTRL

-- Device 1 => CFEBJTAG

  dl_jtag_tck <= jtag_tck;

  CFEBJTAG_PM : CFEBJTAG
    port map (

      FASTCLK => clk,
      SLOWCLK => clk_s2,
      RST     => rst,
      DEVICE  => device(1),
      STROBE  => strobe,
      COMMAND => cmd,
      WRITER  => vme_write_b,

      INDATA  => vme_data_in,
      OUTDATA => outdata_cfebjtag,

      DTACK => vme_dtack_b,

      INITJTAGS      => '0',            -- to be defined
      TCK            => jtag_tck,
      TDI            => dl_jtag_tdi,
      TMS            => dl_jtag_tms,
      FEBTDO         => dl_jtag_tdo,
      DL_RTN_SHFT_EN => dl_rtn_shft_en,
      UL_JTAG_TCK    => jtag_tck,

      DIAGOUT => diagout_cfebjtag,
      LED     => led_cfebjtag
      );

  MBCJTAG_PM : MBCJTAG
    port map (

      FASTCLK => clk,
      SLOWCLK => clk_s2,
      RST     => rst,
      DEVICE  => device(2),
      STROBE  => strobe,
      COMMAND => cmd,
      WRITER  => vme_write_b,

      INDATA  => vme_data_in,
      OUTDATA => outdata_mbcjtag,

      DTACK => vme_dtack_b,

      INITJTAGS => '0',                 -- to be defined
      TCK       => mbc_jtag_tck,
      TDI       => mbc_jtag_tdi,
      TMS       => mbc_jtag_tms,
      MBCTDO    => mbc_jtag_tdo,

      LED => led_mbcjtag
      );


  LVDBMON_PM : LVDBMON
    port map(

      SLOWCLK => clk_s2,
      RST     => rst,

      DEVICE  => device(8),
      STROBE  => strobe,
      COMMAND => cmd,
      WRITER  => vme_write_b,

      INDATA  => vme_data_in,
      OUTDATA => outdata_lvdbmon,

      DTACK => vme_dtack_b,

      LVADCEN => lvmb_csb,
      ADCCLK  => lvmb_sclk,
      ADCDATA => lvmb_sdin,
      ADCIN   => lvmb_sdout,

      LVTURNON   => lvmb_pon,
      R_LVTURNON => r_lvmb_pon,
      LOADON     => pon_load,

      DIAGLVDB => diagout_lvdbmon

      );

  FIFOMON_PM : FIFOMON
    port map (

      SLOWCLK => clk_s2,
      RST     => rst,

      DEVICE  => device(9),
      STROBE  => strobe,
      COMMAND => cmd,

      INDATA  => vme_data_in,
      OUTDATA => outdata_fifomon,

      DTACK => vme_dtack_b,

      FIFO_WR_EN => tfifo_wr_en,
      FIFO_RD_EN => tfifo_rd_en,
      FIFO_SEL   => tfifo_sel,
      FIFO_MODE  => tfifo_mode,
      FIFO_DATA  => tfifo_data,
      FIFO_STR   => tfifo_str,
      FIFO_WRC   => tfifo_wc,
      FIFO_RDC   => tfifo_rc


      );

  TESTCTRL_PM : TESTCTRL
    generic map (NFEB => NFEB)
    port map (

      CLK     => clk,
      DDUCLK  => clk80, -- Ideally, it'd be DDUCLK, but for some reason it does
                        -- not work
      SLOWCLK => clk_s2,
      RST     => rst,

      DEVICE  => device(0),
      STROBE  => strobe,
      COMMAND => cmd,

      INDATA  => vme_data_in,
      OUTDATA => outdata_testctrl,

      DTACK => vme_dtack_b,

      L1A            => TC_L1A,
      ALCT_DAV       => TC_ALCT_DAV,
      TMB_DAV        => TC_TMB_DAV,
      LCT            => TC_LCT,
      DDU_DATA       => DDU_DATA,
      DDU_DATA_VALID => DDU_DATA_VALID,
      TC_RUN         => TC_RUN,
      TS_OUT         => TS_OUT
      );

  VMEMON_PM : VMEMON
    port map (

      SLOWCLK => clk_s2,
      RST     => rst,

      DEVICE  => device(3),
      STROBE  => strobe,
      COMMAND => cmd,

      INDATA  => vme_data_in,
      OUTDATA => outdata_vmemon,

      DTACK => vme_dtack_b,

      ODMB_CTRL => odmb_ctrl,
      DCFEB_CTRL => dcfeb_ctrl,
      ODMB_DATA => odmb_data

      );


  VMECONFREGS_PM  : VMECONFREGS
    port map (

      SLOWCLK => CLK_S2 ,
      RST     => RST ,

      DEVICE  => DEVICE(4) ,
      STROBE  => STROBE ,
      COMMAND => CMD ,

      INDATA  => VME_DATA_IN ,
      OUTDATA => OUTDATA_VMECONFREGS ,

      DTACK         => VME_DTACK_B ,
      ALCT_PUSH_DLY => ALCT_PUSH_DLY,
      TMB_PUSH_DLY  => TMB_PUSH_DLY ,
      PUSH_DLY      => PUSH_DLY ,
      LCT_L1A_DLY   => LCT_L1A_DLY
      );

  TESTFIFOS_PM  : TESTFIFOS
    port map (

      SLOWCLK => CLK_S2 ,
      RST     => RST ,

      DEVICE  => DEVICE(5) ,
      STROBE  => STROBE ,
      COMMAND => CMD ,

      INDATA  => VME_DATA_IN ,
      OUTDATA => OUTDATA_TESTFIFOS ,

      DTACK         => VME_DTACK_B ,
      
      TFF_DATA_OUT => TFF_DATA_OUT,
      TFF_WRD_CNT  => TFF_WRD_CNT,
      TFF_SEL      => TFF_SEL,
      RD_EN_TFF    => RD_EN_TFF

      );

-- From/To LVMB

-- lvmb_pon <= "00000000";
-- pon_load <= '0';
    pon_oe_b <= '0';
-- lvmb_csb <= "0000000";               
-- lvmb_sclk <= '0';
-- lvmb_sdin <= '0';                    


-- To/From O-DMB ADC

    adc_cs    <= '0';
    adc_sclk  <= '0';
    adc_sdain <= '0';

-- To/From O-DMB DAC

    dac_cs    <= '0';
    dac_sclk  <= '0';
    dac_sdain <= '0';

-- To/From DCFEB FIFOs

    fifo_wr_ck <= '0';
    fifo_wr_en <= "000000000";
    fifo_rw_en <= "000000000";
    fifo_rm_en <= (others => '1');
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
    qpll_mode        <= '0';
    qpll_extcontrol  <= '0';
    qpll_reset       <= '0';
    qpll_f0sel       <= "0000";

  end ODMB_VME_architecture;

