-- VMECONFREGS: Assign values to registers used in ODMB_CTRL

library ieee;
library work;
library unisim;
use unisim.vcomponents.all;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity VMECONFREGS is
  
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
end VMECONFREGS;



architecture VMECONFREGS_Arch of VMECONFREGS is

  signal DTACK_INNER : std_logic;
  signal CMDDEV      : std_logic_vector(12 downto 0);

  signal OUT_LCT_L1A                         : std_logic_vector(15 downto 0) := (others => '0');
  signal LCT_L1A_DLY_INNER                   : std_logic_vector(5 downto 0);
  signal W_LCT_L1A, D_W_LCT_L1A, Q_W_LCT_L1A : std_logic                     := '0';
  signal R_LCT_L1A, D_R_LCT_L1A, Q_R_LCT_L1A : std_logic                     := '0';

  signal OUT_TMB_PUSH                           : std_logic_vector(15 downto 0) := (others => '0');
  signal TMB_PUSH_DLY_INNER                     : std_logic_vector(4 downto 0);
  signal W_TMB_PUSH, D_W_TMB_PUSH, Q_W_TMB_PUSH : std_logic                     := '0';
  signal R_TMB_PUSH, D_R_TMB_PUSH, Q_R_TMB_PUSH : std_logic                     := '0';

  signal OUT_PUSH                   : std_logic_vector(15 downto 0) := (others => '0');
  signal PUSH_DLY_INNER             : std_logic_vector(4 downto 0);
  signal W_PUSH, D_W_PUSH, Q_W_PUSH : std_logic                     := '0';
  signal R_PUSH, D_R_PUSH, Q_R_PUSH : std_logic                     := '0';

  signal OUT_ALCT_PUSH                             : std_logic_vector(15 downto 0) := (others => '0');
  signal ALCT_PUSH_DLY_INNER                       : std_logic_vector(4 downto 0);
  signal W_ALCT_PUSH, D_W_ALCT_PUSH, Q_W_ALCT_PUSH : std_logic                     := '0';
  signal R_ALCT_PUSH, D_R_ALCT_PUSH, Q_R_ALCT_PUSH : std_logic                     := '0';

begin  --Architecture

-- Decode instruction
  --CMDHIGH <= '1' when (COMMAND(9) = '0' and COMMAND(8) = '0' and COMMAND(7) = '0' and COMMAND(6) = '0'
  --                     and COMMAND(5) = '0' and COMMAND(4) = '0' and DEVICE = '1') else '0';
  --CMDDEV <= CMDHIGH & COMMAND(3) & COMMAND(2) & COMMAND(1) & COMMAND(0);
  CMDDEV <= DEVICE  & COMMAND & "00";  -- Variable that looks like the VME commands we input  

  W_LCT_L1A   <= '1' when (unsigned(CMDDEV) = x"1000") else '0';
  W_TMB_PUSH  <= '1' when (unsigned(CMDDEV) = x"1004") else '0';
  W_PUSH      <= '1' when (unsigned(CMDDEV) = x"1008") else '0';
  W_ALCT_PUSH <= '1' when (unsigned(CMDDEV) = x"100C") else '0';
  R_LCT_L1A   <= '1' when (unsigned(CMDDEV) = x"1400") else '0';
  R_TMB_PUSH  <= '1' when (unsigned(CMDDEV) = x"1404") else '0';
  R_PUSH      <= '1' when (unsigned(CMDDEV) = x"1408") else '0';
  R_ALCT_PUSH <= '1' when (unsigned(CMDDEV) = x"140C") else '0';

-- Write LCT_L1A_DLY
  GEN_LCT_L1A_DLY : for I in 5 downto 0 generate
  begin
    FD_W_LCT_L1A : FDCE port map(LCT_L1A_DLY_INNER(I), STROBE, W_LCT_L1A, RST, INDATA(I));
  end generate GEN_LCT_L1A_DLY;
  LCT_L1A_DLY <= LCT_L1A_DLY_INNER;
  D_W_LCT_L1A <= '1' when (STROBE = '1' and W_LCT_L1A = '1') else '0';
  FD_DTACK_LCT_L1A : FD port map(Q_W_LCT_L1A, SLOWCLK, D_W_LCT_L1A);
  DTACK_INNER <= '0' when (Q_W_LCT_L1A = '1')                else 'Z';

-- Read LCT_L1A_DLY
  OUT_LCT_L1A(5 downto 0) <= LCT_L1A_DLY_INNER when (STROBE = '1' and R_LCT_L1A = '1') else (others => 'Z');

  D_R_LCT_L1A <= '1' when (STROBE = '1' and R_LCT_L1A = '1') else '0';
  FD_R_LCT_L1A : FD port map(Q_R_LCT_L1A, SLOWCLK, D_R_LCT_L1A);
  DTACK_INNER <= '0' when (Q_R_LCT_L1A = '1')                else 'Z';

-- Write TMB_PUSH_DLY
  GEN_TMB_PUSH_DLY : for I in 4 downto 0 generate
  begin
    FD_W_TMB_PUSH : FDCE port map(TMB_PUSH_DLY_INNER(I), STROBE, W_TMB_PUSH, RST, INDATA(I));
  end generate GEN_TMB_PUSH_DLY;
  TMB_PUSH_DLY <= TMB_PUSH_DLY_INNER;
  D_W_TMB_PUSH <= '1' when (STROBE = '1' and W_TMB_PUSH = '1') else '0';
  FD_DTACK_TMB_PUSH : FD port map(Q_W_TMB_PUSH, SLOWCLK, D_W_TMB_PUSH);
  DTACK_INNER  <= '0' when (Q_W_TMB_PUSH = '1')                else 'Z';

-- Read TMB_PUSH_DLY
  OUT_TMB_PUSH(4 downto 0) <= TMB_PUSH_DLY_INNER when (STROBE = '1' and R_TMB_PUSH = '1') else (others => 'Z');

  D_R_TMB_PUSH <= '1' when (STROBE = '1' and R_TMB_PUSH = '1') else '0';
  FD_R_TMB_PUSH : FD port map(Q_R_TMB_PUSH, SLOWCLK, D_R_TMB_PUSH);
  DTACK_INNER  <= '0' when (Q_R_TMB_PUSH = '1')                else 'Z';

-- Write PUSH_DLY
  GEN_PUSH_DLY : for I in 4 downto 0 generate
  begin
    FD_W_PUSH : FDCE port map(PUSH_DLY_INNER(I), STROBE, W_PUSH, RST, INDATA(I));
  end generate GEN_PUSH_DLY;
  PUSH_DLY    <= PUSH_DLY_INNER;
  D_W_PUSH    <= '1' when (STROBE = '1' and W_PUSH = '1') else '0';
  FD_DTACK_PUSH : FD port map(Q_W_PUSH, SLOWCLK, D_W_PUSH);
  DTACK_INNER <= '0' when (Q_W_PUSH = '1')                else 'Z';

-- Read PUSH_DLY
  OUT_PUSH(4 downto 0) <= PUSH_DLY_INNER when (STROBE = '1' and R_PUSH = '1') else (others => 'Z');

  D_R_PUSH    <= '1' when (STROBE = '1' and R_PUSH = '1') else '0';
  FD_R_PUSH : FD port map(Q_R_PUSH, SLOWCLK, D_R_PUSH);
  DTACK_INNER <= '0' when (Q_R_PUSH = '1')                else 'Z';

-- Write ALCT_PUSH_DLY
  GEN_ALCT_PUSH_DLY : for I in 4 downto 0 generate
  begin
    FD_W_ALCT_PUSH : FDCE port map(ALCT_PUSH_DLY_INNER(I), STROBE, W_ALCT_PUSH, RST, INDATA(I));
  end generate GEN_ALCT_PUSH_DLY;
  ALCT_PUSH_DLY <= ALCT_PUSH_DLY_INNER;
  D_W_ALCT_PUSH <= '1' when (STROBE = '1' and W_ALCT_PUSH = '1') else '0';
  FD_DTACK_ALCT_PUSH : FD port map(Q_W_ALCT_PUSH, SLOWCLK, D_W_ALCT_PUSH);
  DTACK_INNER   <= '0' when (Q_W_ALCT_PUSH = '1')                else 'Z';

-- Read ALCT_PUSH_DLY
  OUT_ALCT_PUSH(4 downto 0) <= ALCT_PUSH_DLY_INNER when (STROBE = '1' and R_ALCT_PUSH = '1') else (others => 'Z');

  D_R_ALCT_PUSH <= '1' when (STROBE = '1' and R_ALCT_PUSH = '1') else '0';
  FD_R_ALCT_PUSH : FD port map(Q_R_ALCT_PUSH, SLOWCLK, D_R_ALCT_PUSH);
  DTACK_INNER   <= '0' when (Q_R_ALCT_PUSH = '1')                else 'Z';

-- General assignments
  OUTDATA <= OUT_LCT_L1A when R_LCT_L1A = '1' else
             OUT_TMB_PUSH  when R_TMB_PUSH = '1' else
             OUT_PUSH      when R_PUSH = '1' else
             OUT_ALCT_PUSH when R_ALCT_PUSH = '1' else
             (others => 'Z');
  DTACK <= DTACK_INNER;
  
end VMECONFREGS_Arch;
