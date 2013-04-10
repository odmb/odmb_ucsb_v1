library ieee;
library work;
use work.Latches_Flipflops.all;
use ieee.std_logic_1164.all;
--Library unisim;
--use UNISIM.vcomponents.all;
--use UNISIM.vpck.all;
--use UNISIM.all;


ENTITY ODMB_CTRL IS
  generic (
    NFEB : integer range 1 to 7 := 7  -- Number of DCFEBS, 7 in the final design
    );  
PORT 	(

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
		tmb_dav : IN STD_LOGIC;											-- previously lctdav1, from J4
		alct_dav : IN STD_LOGIC;											-- previously lctdav2, from J4
		lctrqst : OUT STD_LOGIC_VECTOR (2 downto 1);				-- lctrqst(2 downto 1) - to J4
		rsvtd_in : IN STD_LOGIC_VECTOR(4 DOWNTO 0);				-- OK 	spare(2 DOWNTO 0) - to J4
		rsvtd_out : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);			-- OK		spare(7 DOWNTO 3) - from J4
		cafifo_push : OUT STD_LOGIC;  -- PUSH from TRGCNTRL to CAFIFO
		cafifo_l1a_match : OUT STD_LOGIC_VECTOR(NFEB+2 downto 0); -- L1A_MATCH from TRGCNTRL to CAFIFO

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

-- From/To DCFEBs (FF-EMU-MOD)

		ul_dav: IN STD_LOGIC_VECTOR(6 DOWNTO 0);						-- davf(5 DOWNTO 1) - from DCFEBs 
		ul_movlp: IN STD_LOGIC_VECTOR(6 DOWNTO 0);					-- movlp(5 DOWNTO 1) - from DCFEBs

		dcfeb_injpulse : OUT STD_LOGIC;										-- inject - to DCFEBs
		dcfeb_extpulse : OUT STD_LOGIC;										-- extpulse - to DCFEBs
		dcfeb_l1a : OUT STD_LOGIC;
		dcfeb_l1a_match : OUT STD_LOGIC_VECTOR(NFEB downto 1);

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
 
    lct_err : out std_logic;  -- To an LED in the original design
		leds : OUT STD_LOGIC_VECTOR(5 DOWNTO 0));

end ODMB_CTRL;


ARCHITECTURE ODMB_CTRL_arch of ODMB_CTRL  is

COMPONENT BGB_BSCAN_emulator is

  port(
		
		IR 		: out std_logic_vector(9 downto 0);

		CAPTURE1 : out std_ulogic;
		DRCK1    : out std_ulogic;
		RESET1   : out std_ulogic;
		SEL1     : out std_ulogic;
		SHIFT1   : out std_ulogic;
		UPDATE1  : out std_ulogic;
		RUNTEST1  : out std_ulogic;
		TDO1		: in  std_ulogic;
		
		CAPTURE2 : out std_ulogic;
		DRCK2    : out std_ulogic;
		RESET2   : out std_ulogic;
		SEL2     : out std_ulogic;
		SHIFT2   : out std_ulogic;
		UPDATE2  : out std_ulogic;
		RUNTEST2  : out std_ulogic;
		TDO2		: in  std_ulogic;

		TDO3		: in  std_ulogic;
		TDO4		: in  std_ulogic;

      TDO	: out std_ulogic;

      TCK	: in  std_ulogic;
      TDI	: in  std_ulogic;
      TMS	: in  std_ulogic;
      TRST	: in  std_ulogic
    );

end COMPONENT;


COMPONENT INSTRGDC is

  port (
    BTDI   : in  std_logic;             -- TDI from BSCAN_VIRTEX
    DRCK   : in  std_logic;             -- Signals are from BSCAN_VIRTEX
    SEL1   : in  std_logic;
    UPDATE : in  std_logic;
    SHIFT  : in  std_logic;
    D0     : out std_logic;
    F      : out std_logic_vector(47 downto 1));

end COMPONENT;

COMPONENT CONFREGS is  -- Used to be LOADTIME+SETFEBDLY+SETCALDLY in the old design
  generic (
    NFEB : integer range 1 to 7 := 5  -- Number of DCFEBS, 7 in the final design
    );  
  port (
    RST : in std_logic;

    BTDI   : in std_logic;
    SEL2   : in std_logic;
    DRCK   : in std_logic;
    UPDATE : in std_logic;
    SHIFT  : in std_logic;

    FLOADDLY  : in std_logic;           -- Generates PUSH_DLY & LCT_L1A_DLY
    FLOADCDLY : in std_logic;           -- Generates INJDLY & EXTDLY & CALGDLY & CALLCTDLY
    FLOADID   : in std_logic;           -- Generates CRATEID
    FLOADKILL : in std_logic;           -- Generates KILLCFEB

    TDO         : out std_logic;
    ALCT_PUSH_DLY    : out std_logic_vector(4 downto 0);
    TMB_PUSH_DLY    : out std_logic_vector(4 downto 0);
    PUSH_DLY    : out std_logic_vector(4 downto 0);
    LCT_L1A_DLY : out std_logic_vector(5 downto 0);
    INJDLY      : out std_logic_vector(4 downto 0);
    EXTDLY      : out std_logic_vector(4 downto 0);
    CALGDLY     : out std_logic_vector(4 downto 0);
    CALLCTDLY   : out std_logic_vector(3 downto 0);
    KILLCFEB    : out std_logic_vector(NFEB downto 1);
    CRATEID     : out std_logic_vector(6 downto 0)
    );

end COMPONENT;

COMPONENT CONFLOGIC is  -- Used to be discrete logic in JTAGCOM
  generic (
    NFEB : integer range 1 to 7 := 5  -- Number of DCFEBS, 7 in the final design
    );  
  port (
    CLKCMS   : in std_logic;          
    RST      : in std_logic;          

    INSTR    : in std_logic_vector(47 downto 1);
    CCBINJ   : in std_logic;          
    CCBPLS   : in std_logic;          
    CCBPED   : in std_logic;              
    SELRAN   : in std_logic;          

    CAL_TRGSEL   : out std_logic;          
    ENACFEB      : out std_logic;          
    CAL_MODE     : out std_logic         
   );

end COMPONENT;


COMPONENT CALTRIGCON is
  generic (
    NFEB : integer range 1 to 7 := 5  -- Number of DCFEBS, 7 in the final design
    );  
  port (
    CLKIN         : in std_logic;
    CLKSYN     : in std_logic;
     RST         : in std_logic;
   
    DIN     : in std_logic;
    DRCK     : in std_logic;
    SEL2     : in std_logic;
    SHIFT : in std_logic;
    FLOAD    : in std_logic;
    FCYC    : in std_logic;
    FCYCM    : in std_logic;

    CCBPED    : in std_logic;

    LCTOUT       : out std_logic;
    GTRGOUT : out std_logic
    );

end COMPONENT;

COMPONENT RANDOMTRG is
  generic (
    NFEB : integer range 1 to 7 := 5  -- Number of DCFEBS, 7 in the final design
    );  
  port (
    CLK         : in std_logic;
    RST         : in std_logic;

    DIN         : in std_logic;
    DRCK        : in std_logic;
    SEL2        : in std_logic;
    SHIFT       : in std_logic;
    UPDATE      : in std_logic;

    FLOAD       : in std_logic;      -- INSTR19
    FTSTART     : in std_logic;      -- INSTR20
    FBURST      : in std_logic;      -- INSTR32

    ENL1RLS     : in std_logic;
    
    PREL1RLS    : out std_logic;    
    SELRAN      : out std_logic;
    GTRGOUT     : out std_logic;
    LCTOUT      : out std_logic_vector(NFEB downto 0);
    PULSE       : out std_logic
    );

end COMPONENT;

COMPONENT LOADCFEB is
  generic (
    NFEB : integer range 1 to 7 := 5  -- Number of DCFEBS, 7 in the final design
    );  
  port (
    CLK : in std_logic;
    RST : in std_logic;
               
    BTDI     : in std_logic;
    DRCK     : in std_logic;
    SEL2     : in std_logic;
    SHIFT    : in std_logic;
    UPDATE   : in std_logic;
    TDO    : out std_logic;

    FLOAD    : in std_logic;
    CALLCT_1 : in std_logic;
    RNDMLCT  : in std_logic_vector(NFEB downto 0);

    LCTFEB : out std_logic_vector(NFEB downto 0);
    CFEB   : out std_logic_vector(NFEB downto 1)
    );

end COMPONENT;

COMPONENT TRGSEL is
  port (
    RST : in std_logic;

    BTDI     : in std_logic;
    SEL2     : in std_logic;
    DRCK     : in std_logic;
    UPDATE   : in std_logic;
    SHIFT    : in std_logic;

    FLOAD    : in std_logic;

    TDO    : out std_logic;
    JTRGEN : out std_logic_vector(3 downto 0)
    );

end COMPONENT;

COMPONENT TRGCNTRL is
  generic (
    NFEB : integer range 1 to 7 := 5  -- Number of DCFEBS, 7 in the final design
    );  
  port (
    CLK         : in std_logic;
    RAW_L1A     : in std_logic;
    RAW_LCT     : in std_logic_vector(NFEB downto 0);
    CAL_LCT     : in std_logic_vector(NFEB downto 0);
    CAL_L1A     : in std_logic;
    LCT_L1A_DLY : in std_logic_vector(5 downto 0);
    PUSH_DLY    : in std_logic_vector(4 downto 0);
    ALCT_DAV    : in std_logic;
    TMB_DAV     : in std_logic;
    ALCT_PUSH_DLY : in std_logic_vector(4 downto 0);
    TMB_PUSH_DLY : in std_logic_vector(4 downto 0);

    JTRGEN    : in std_logic_vector(3 downto 0);
    EAFEB     : in std_logic;
    CMODE     : in std_logic;
    CALTRGSEL : in std_logic;
    KILLCFEB  : in std_logic_vector(NFEB downto 1);

    DCFEB_L1A       : out std_logic;
    DCFEB_L1A_MATCH : out std_logic_vector(NFEB downto 1);
    FIFO_PUSH       : out std_logic;
    FIFO_L1A_MATCH  : out std_logic_vector(NFEB+2 downto 0);
    LCT_ERR         : out std_logic
    );

end COMPONENT;

COMPONENT TRGFIFO is
  generic (
    NFEB : integer range 1 to 7 := 5  -- Number of DCFEBS, 7 in the final design
    );  
  port (
    CLK         : in  std_logic;
    RST         : in  std_logic;
    PUSH        : in  std_logic;
    POP         : in  std_logic;
    BC0         : in  std_logic;
    BXRST       : in  std_logic;
    FIFO_L1A_MATCH_IN   : in  std_logic_vector(NFEB downto 0);
    
    FIFO_L1A_MATCH_OUT : out std_logic_vector(NFEB downto 0);
    FIFO_BX_CNT_OUT : out std_logic_vector(15 downto 0);
    FIFO_FULL_B  : out std_logic;
    FIFO_EMPTY_B : out std_logic;
    FIFO_ERR     : out std_logic
    );
    
end COMPONENT;


COMPONENT LOADFIFO is
  
  port (
    SHIFT  : in  std_logic;
    FENF   : in  std_logic;
    BTDI   : in  std_logic;
    SEL2   : in  std_logic;
    DRCK   : in  std_logic;
    UPDATE : in  std_logic;
    RST    : in  std_logic;
    RENF   : out std_logic_vector(7 downto 0);
    TDO    : out std_logic);
 
end COMPONENT;

COMPONENT CCBCODE is
  port (
    CCB_CMD : in std_logic_vector(5 downto 0);
    CCB_CMD_S : in std_logic;
    CCB_DATA : in std_logic_vector(7 downto 0);
    CCB_DATA_S : in std_logic;
    CMSCLK : in std_logic;
    CCB_BXRST : in std_logic;
    CCB_BX0 : in std_logic;
    CCB_L1ARST : in std_logic;
    CCB_CLKEN : in std_logic;
    BX0 : out std_logic;
    BXRST : out std_logic;
    L1ARST : out std_logic;
    CLKEN : out std_logic;
    BC0 : out std_logic;  
    L1ASRST : out std_logic;
    TTCCAL : out std_logic_vector(2 downto 0)
    );
 
end COMPONENT;

COMPONENT CALIBTRG is
  port (
    CMSCLK : in std_logic;
	 CLK80 : in std_logic;
    RST : in std_logic;
    PLSINJEN : in std_logic;
    CCBPLS : in std_logic;
    CCBINJ : in std_logic;
    FPLS : in std_logic;
    FINJ : in std_logic;
    FPED : in std_logic;
    PRELCT : in std_logic;
    PREGTRG : in std_logic;
    INJDLY : in std_logic_vector(4 downto 0);
    EXTDLY : in std_logic_vector(4 downto 0);
    CALLCTDLY : in std_logic_vector(3 downto 0);
    CALGDLY : in std_logic_vector(4 downto 0);
    RNDMPLS : in std_logic;
    RNDMGTRG : in std_logic;
    PEDESTAL : out std_logic;
    CAL_GTRG : out std_logic;
--    CALLCT_1 : out std_logic;
    CALLCT : out std_logic;
    INJBACK : out std_logic;
    PLSBACK : out std_logic;
-- SCPSYN AND SCOPE have not been implemented
-- and we do not intend to implement them (we think)
--    SCPSYN : out std_logic; 
--    SYNCIF : out std_logic;
    LCTRQST : out std_logic;  
    INJPLS : out std_logic;
    XL1ADLY : in std_logic_vector(1 downto 0)
    );
end COMPONENT;
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------


-- clock and reset signals

signal rst : std_logic := '0';
signal rstn : std_logic := '1';

-- jtag signals

signal initjtags : std_logic := '0';
signal drck1, sel1, reset1, shift1, capture1, update1 : std_ulogic;
signal drck2, sel2, reset2, shift2, capture2, update2 : std_ulogic;
signal b_tms1, b_tdi1, b_tck1 : std_ulogic;
signal b_tms2, b_tdi2, b_tck2 : std_ulogic;
signal tdo1 : std_ulogic;
signal tdo2 : std_ulogic;

-------------------------------------------------------------------------------

signal ccbped : std_logic;
signal ccbinjin, ccbinjin_1, ccbinjin_2, ccbinjin_3, ccbinj : std_logic;
signal ccbplsin, ccbplsin_1, ccbplsin_2, ccbplsin_3, ccbpls : std_logic;
signal plsinjen_inner, plsinjen, plsinjen_1, plsinjen_rst, plsinjen_inv : std_logic;
       
-- INSTRGDC outputs

signal instr : std_logic_vector(47 downto 1);

-- CONFREGS outputs
signal KILLCFEB : std_logic_vector(NFEB downto 1);											
signal  crateid : std_logic_vector(6 downto 0);     -- Instruction 15    
signal  callctdly : std_logic_vector(3 downto 0);    
signal  calgdly : std_logic_vector(4 downto 0);
signal  extdly : std_logic_vector(4 downto 0);    
signal  injdly : std_logic_vector(4 downto 0);   
signal  alct_push_dly : std_logic_vector (4 downto 0);
signal  tmb_push_dly : std_logic_vector (4 downto 0); 
signal  push_dly : std_logic_vector (4 downto 0);
signal  lct_l1a_dly : std_logic_vector (5 downto 0);

-- CONFLOGIC outputs
signal CAL_TRGSEL, ENACFEB, CAL_MODE : std_logic;											

-- CALTRIGCON outputs
signal prelct, pregtrg : std_logic;											

-- Switches: SW4->RANDOMTRG inputS
signal sw4_enl1rls : std_logic := '1';						

-- TRGCNTRL outputs
signal FIFO_PUSH : std_logic;
signal trg_fifo_l1a_match_in : std_logic_vector(NFEB+2 downto 0);

-- TRGFIFO
signal TRG_FIFO_FULL_B, TRG_FIFO_EMPTY_B, TRG_FIFO_PUSH, TRG_FIFO_POP, TRG_FIFO_ERR : std_logic;			
signal TRG_FIFO_L1A_MATCH_OUT : std_logic_vector(NFEB downto 0);											
signal TRG_FIFO_BX_CNT_OUT : std_logic_vector(15 downto 0);											

-- RANDOMTRG outputs
signal rndmgtrg, rndmpls, selran : std_logic;											
signal rndmlct : std_logic_vector(NFEB downto 0);						

-- LOADCFEF outputs
signal CAL_LCT : std_logic_vector(NFEB downto 0);						
signal loadcfeb_cfeb : std_logic_vector(NFEB downto 1);						

-- TRGSEL outputs
signal JTRGEN : std_logic_vector(3 downto 0);						

-- CCBCODE outputs

signal bx0 : std_logic;											
signal bxrst : std_logic;										
signal l1arst : std_logic;								
signal clken : std_logic;								
signal bc0 : std_logic;									
signal l1asrst : std_logic;										
signal ttccal : std_logic_vector(2 downto 0);
								

-- LOADFIFO outputs

signal  joef : std_logic_vector(7 downto 0);    
signal  tdo_fifo : std_logic;    

signal LOGICH : std_logic := '1';

-- CALIBTRG outputs

signal pedestal : std_logic;
signal cal_gtrg : std_logic;
signal callct_1 : std_logic;
signal inject : std_logic;
signal pulse : std_logic;
signal prelctrqst : std_logic;
signal injplsmon : std_logic;
signal xl1adly : std_logic_vector(1 downto 0);

-------------------------------------------------------------------------------

begin

mbc_fsel <= instr;

leds(5 downto 0) <= crateid(5 downto 0);

JTAG_PM : BGB_BSCAN_emulator
  port map (

		IR => mbc_jtag_ir,

		CAPTURE1 => capture1,
		DRCK1 => drck1,
		RESET1 => reset1,
		SEL1 => sel1,
		SHIFT1 => shift1,
		UPDATE1 => update1,
		RUNTEST1 => open,
		TDO1 => tdo1,
		
		CAPTURE2 => capture2,
		DRCK2 => drck2,
		RESET2 => reset2,
		SEL2 => sel2,
		SHIFT2 => shift2,
		UPDATE2 => update2,
		RUNTEST2 => open,
		TDO2 => tdo2,

		TDO3 => '0',
		TDO4 => '0',

		TCK => tck,
		TDI => tdi,
		TMS => tms,
		TDO => tdo,
		TRST => reset
    );

INSTR_DECODER_PM : INSTRGDC
	port map (
    BTDI => tdi,                -- TDI from BSCAN_VIRTEX
    DRCK => drck1,              -- Signals are from BSCAN_VIRTEX
    SEL1 => sel1,
    SHIFT => shift1,
    UPDATE => update1,
    D0 => tdo1,
    F => instr);
 
CONFREGS_PM : CONFREGS   -- Used to be LOADTIME+SETFEBDLY+SETCALDLY in the old design
  generic map (NFEB => NFEB)  
  port map (
    RST         => reset,
                
    BTDI       => tdi,
    DRCK       => drck2,
    SEL2       => sel2,
    SHIFT      => shift2,
    UPDATE     => update2,
                
    FLOADDLY    => instr(13),
    FLOADCDLY   => instr(17),
    FLOADID     => instr(15),
    FLOADKILL   => instr(16),
                
    TDO         => open,
    ALCT_PUSH_DLY    => alct_push_dly,
    TMB_PUSH_DLY    => tmb_push_dly,
    PUSH_DLY    => push_dly,
    LCT_L1A_DLY => lct_l1a_dly, 
    INJDLY      => injdly,
    EXTDLY      => extdly,
    CALGDLY     => calgdly,
    CALLCTDLY   => callctdly,
    KILLCFEB    => killcfeb,
    CRATEID     => crateid
    );

CONFLOGIC_PM : CONFLOGIC  -- Used to be discrete logic in JTAGCOM
  generic map (NFEB => NFEB)  
  port map(
    CLKCMS       => clk40,
    RST          => reset,
                 
    INSTR        => instr,
    CCBINJ       => ccbinj,
    CCBPLS       => ccbpls,
    CCBPED       => ccbped,
    SELRAN       => selran,
                 
    CAL_TRGSEL   => cal_trgsel,
    ENACFEB      => enacfeb,
    CAL_MODE     => cal_mode
   );

   
CALTRIGCON_PM : CALTRIGCON 
  generic map (NFEB => NFEB)  
  port map (
    CLKIN   => clk40,
    CLKSYN  => plsinjen,
    RST     => reset,
            
    DIN     => tdi,
    DRCK    => drck2,
    SEL2    => sel2,
    SHIFT   => shift2,
    FLOAD   => instr(6),
    FCYC    => instr(7),
    FCYCM   => instr(8),
            
    CCBPED  => ccbped,
            
    LCTOUT  => prelct,
    GTRGOUT => pregtrg
    );

RANDOMTRG_PM : RANDOMTRG 
  generic map (NFEB => NFEB)  
  port map(
    CLK        => clk40,
    RST        => reset,
               
    DIN        => tdi,
    DRCK       => drck2,
    SEL2       => sel2,
    SHIFT      => shift2,
    UPDATE     => update2,
               
    FLOAD      => instr(19),
    FTSTART    => instr(20),
    FBURST     => instr(22),               
               
    ENL1RLS    => sw4_enl1rls,
    
    PREL1RLS   => ccb_l1rls,
    SELRAN     => selran,             
    GTRGOUT    => rndmgtrg,
    LCTOUT     => rndmlct,
    PULSE      => rndmpls
    );

LOADCFEB_PM : LOADCFEB
  generic map (NFEB => NFEB)  
  port map (
    CLK        => clk40,
    RST        => reset,
               
    BTDI       => tdi,
    DRCK       => drck2,
    SEL2       => sel2,
    SHIFT      => shift2,
    UPDATE     => update2,
               
    TDO        => open, 

    FLOAD      => instr(9),
                
    CALLCT_1   => callct_1,
    RNDMLCT    => rndmlct,

    LCTFEB     => cal_lct,
    CFEB       => loadcfeb_cfeb  -- It does not go anywhere, AFAWK
    );


TRGSEL_PM : TRGSEL 
  port map(
    RST     => reset,
            
    BTDI       => tdi,
    DRCK       => drck2,
    SEL2       => sel2,
    SHIFT      => shift2,
    UPDATE     => update2,
            
    FLOAD   => instr(37),
            
    TDO     => open,
    JTRGEN  => jtrgen
    );


TRGCNTRL_PM : TRGCNTRL 
  generic map (NFEB => NFEB)  
  port map (
    CLK             => clk40,
    RAW_L1A         => ccb_l1acc,
    RAW_LCT         => rawlct,
    CAL_LCT         => cal_lct,
    CAL_L1A         => cal_gtrg,
    LCT_L1A_DLY     => lct_l1a_dly, 
    PUSH_DLY        => push_dly,    -- Not used for now
    ALCT_DAV    => alct_dav,
    TMB_DAV     => tmb_dav,
    ALCT_PUSH_DLY => alct_push_dly,
    TMB_PUSH_DLY => tmb_push_dly,
                
    JTRGEN          => jtrgen,
    EAFEB           => enacfeb,
    CMODE           => cal_mode,   
    CALTRGSEL       => cal_trgsel,
    KILLCFEB        => killcfeb,
                    
    DCFEB_L1A       => dcfeb_l1a,
    DCFEB_L1A_MATCH => dcfeb_l1a_match,
    FIFO_PUSH       => trg_fifo_push,
    FIFO_L1A_MATCH  => trg_fifo_l1a_match_in,
    LCT_ERR         => lct_err
    );

TRGFIFO_PM : TRGFIFO
  generic map (NFEB => NFEB)  
  port map (
    CLK            => clk40,
    RST            => reset,
    
    PUSH           => trg_fifo_push,
    FIFO_L1A_MATCH_IN   => trg_fifo_l1a_match_in(NFEB downto 0),
    POP            => trg_fifo_pop,
    BC0            => bc0, 
    BXRST          => bxrst,
                   
    FIFO_L1A_MATCH_OUT => trg_fifo_l1a_match_out,
    FIFO_BX_CNT_OUT    => trg_fifo_bx_cnt_out,
    FIFO_FULL_B    => trg_fifo_full_b,
    FIFO_EMPTY_B    => trg_fifo_empty_b,
    FIFO_ERR       => trg_fifo_err
    );

cafifo_push <= trg_fifo_push;
cafifo_l1a_match <= trg_fifo_l1a_match_in;

CCBCODE_PM : CCBCODE
	port map(
    CCB_CMD => ccb_cmd,
    CCB_CMD_S => ccb_cmd_s,
    CCB_DATA => ccb_data,
    CCB_DATA_S => ccb_data_s,
    CMSCLK => clk40,
    CCB_BXRST => ccb_bxrst,
    CCB_BX0 => ccb_bx0,
    CCB_L1ARST => ccb_l1arst,
    CCB_CLKEN => ccb_clken,
    BX0 => bx0,
    BXRST => bxrst,
    L1ARST => l1arst,
    CLKEN => clken,
    BC0 => bc0,  
    L1ASRST => l1asrst,
    TTCCAL => ttccal);

-- generate CCBPED
ccbped <= '1' when (ccb_cal(2) = '0' or ttccal(2) = '1') else '0';

-- generate CCBINJIN
ccbinjin <= '1' when (ccb_cal(1) = '0' or ttccal(1) = '1') else '0';

-- generate CCBPLSIN
ccbplsin <= '1' when (ccb_cal(0) = '0' or ttccal(0) = '1') else '0';

-- generate CCBINJ
FD(ccbinjin, clk40, ccbinjin_1);
FD(ccbinjin_1, clk40, ccbinjin_2);
ccbinjin_3 <= '1' when (plsinjen = '1' and (ccbinjin_1 = '1' or ccbinjin_2 = '1')) else '0';
FD(ccbinjin_3, clk40, ccbinj);  

-- generate CCBPLS
FD(ccbplsin, clk40, ccbplsin_1);
FD(ccbplsin_1, clk40, ccbplsin_2);
ccbplsin_3 <= '1' when (plsinjen = '1' and (ccbplsin_1 = '1' or ccbplsin_2 = '1')) else '0';
FD(ccbplsin_3, clk40, ccbpls);  

-- generate PLSINJEN (CLKSYN inside CALTRIGCON inside of JTAGCOM)
FDC(LOGICH, reset, plsinjen_rst, plsinjen_1);
FD(plsinjen_1, clk40, plsinjen_rst);
FDC(plsinjen_inv, clk40, plsinjen_rst, plsinjen_inner);
plsinjen <= plsinjen_inner;
plsinjen_inv <= not plsinjen_inner;

CALIBTRG_PM : CALIBTRG
	port MAP (
    CMSCLK => clk40,
	 CLK80 => clk80,
    RST => reset,
    PLSINJEN => plsinjen,
 --   CCBINJ => ccbinj,
 --   CCBPLS => ccbpls,
    CCBINJ => test_ccbinj,
    CCBPLS => test_ccbpls,
	 FINJ => instr(3),
    FPLS => instr(4),
    FPED => instr(5),
    PRELCT => prelct, -- generated by CALTRIGCON
    PREGTRG =>  pregtrg, -- generated by CALTRIGCON
    INJDLY => injdly,
    EXTDLY => extdly,
    CALLCTDLY => callctdly,
    CALGDLY => calgdly,
    RNDMPLS => rndmpls, -- generated by RANDOMTRG
    RNDMGTRG => rndmgtrg, -- generated by RANDOMTRG
    PEDESTAL => pedestal,
    CAL_GTRG => cal_gtrg,
--    CALLCT_1 : out std_logic;
    CALLCT => callct_1,
    INJBACK => inject,
    PLSBACK => pulse,
-- SCPSYN AND SCOPE have not been implemented
-- and we do not intend to implement them (we think)
--    SCPSYN : out std_logic; 
--    SYNCIF : out std_logic;
    LCTRQST => prelctrqst,
    INJPLS => injplsmon,
    XL1ADLY => xl1adly);

--dl_gtrig <= cal_gtrg;	
--dl_injpulse <= inject;
--dl_extpulse <= pulse;

LOADFIFO_PM : LOADFIFO
  port map(
    FENF => instr(12),                -- INSTR(12)
    BTDI => tdi,
    DRCK => drck2,
    SEL2 => sel2,
    SHIFT => shift2,
    UPDATE => update2,
    RST => instr(1),                  -- JRST (or RESET or FPGARST or L1ASRST)
    RENF => joef,
    TDO => tdo_fifo);


TDO2 <= 'L';

-- from ODMB_CTRL_EMPTY

		ccb_rsvi <= "000";

		lctrqst <= "00";
		rsvtd_out <= "000";

-- From GigaLinks

--		gtx0_data <= "0000000000000000";										  
--		gtx0_data_valid <= '0';	 
--		gtx1_data <= "0000000000000000";											  
--		gtx1_data_valid <= '0';	 		 
		gtx0_data <= grx0_data;										  
		gtx0_data_valid <= grx0_data_valid;	 
		gtx1_data <= grx1_data;											  
		gtx1_data_valid <= grx1_data_valid;	 		 
	
-- From/To FIFOs

		fifo_rd_ck <= '0';											  
		fifo_rd_en <= "000000000";											  
		fifo_sel <= "0000";				 

		fifo_mrst_b <= '0';	
		fifo_prst_b <= '0';	

-- From/To DCFEBs (FF-EMU-MOD)

--		dl_lct <= "0000000";
 
end ODMB_CTRL_arch;
