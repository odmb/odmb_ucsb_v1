library ieee;
library work;
use work.Latches_Flipflops.all;
use ieee.std_logic_1164.all;

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
  signal CMDHIGH     : std_logic;
  signal CMDDEV      : std_logic_vector(4 downto 0);

  signal OUT_ALCT_PUSH                                      : std_logic_vector(15 downto 0) := (others => '0');
  signal ALCT_PUSH_DLY_INNER                                : std_logic_vector(4 downto 0);
  signal W_ALCT_PUSH, R_ALCT_PUSH, D_ALCT_PUSH, Q_ALCT_PUSH : std_logic                     := '0';

  signal OUT_TMB_PUSH                                   : std_logic_vector(15 downto 0) := (others => '0');
  signal TMB_PUSH_DLY_INNER                             : std_logic_vector(4 downto 0);
  signal W_TMB_PUSH, R_TMB_PUSH, D_TMB_PUSH, Q_TMB_PUSH : std_logic                     := '0';

  signal OUT_PUSH                       : std_logic_vector(15 downto 0) := (others => '0');
  signal PUSH_DLY_INNER                 : std_logic_vector(4 downto 0);
  signal W_PUSH, R_PUSH, D_PUSH, Q_PUSH : std_logic                     := '0';

  signal OUT_LCT_L1A                                : std_logic_vector(15 downto 0) := (others => '0');
  signal LCT_L1A_DLY_INNER                          : std_logic_vector(5 downto 0);
  signal W_LCT_L1A, R_LCT_L1A, D_LCT_L1A, Q_LCT_L1A : std_logic                     := '0';
  
begin  --Architecture

-- Decode instruction
  CMDHIGH <= '1' when (COMMAND(9) = '0' and COMMAND(8) = '0' and COMMAND(7) = '0' and COMMAND(6) = '0'
                       and COMMAND(5) = '0' and COMMAND(4) = '0' and DEVICE = '1') else '0';
  CMDDEV <= CMDHIGH & COMMAND(3) & COMMAND(2) & COMMAND(1) & COMMAND(0);

  W_ALCT_PUSH <= '1' when (CMDDEV = "10000") else '0';
  W_TMB_PUSH  <= '1' when (CMDDEV = "10001") else '0';
  W_PUSH      <= '1' when (CMDDEV = "10010") else '0';
  W_LCT_L1A   <= '1' when (CMDDEV = "10011") else '0';
  R_ALCT_PUSH <= '1' when (CMDDEV = "11000") else '0';
  R_TMB_PUSH  <= '1' when (CMDDEV = "11001") else '0';
  R_PUSH      <= '1' when (CMDDEV = "11010") else '0';
  R_LCT_L1A   <= '1' when (CMDDEV = "11011") else '0';

-- Write ALCT_PUSH_DLY
  GEN_ALCT_PUSH_DLY : for I in 4 downto 0 generate
  begin
    FDCE(INDATA(I), STROBE, W_ALCT_PUSH, RST, ALCT_PUSH_DLY_INNER(I));
  end generate GEN_ALCT_PUSH_DLY;
  ALCT_PUSH_DLY <= ALCT_PUSH_DLY_INNER;

-- Read ALCT_PUSH_DLY
  OUT_ALCT_PUSH(4 downto 0) <= ALCT_PUSH_DLY_INNER when (STROBE = '1' and R_ALCT_PUSH = '1') else (others => 'Z');

  D_ALCT_PUSH <= '1' when (STROBE = '1' and R_ALCT_PUSH = '1') else '0';
  FD(D_ALCT_PUSH, SLOWCLK, Q_ALCT_PUSH);
  DTACK_INNER <= '0' when (Q_ALCT_PUSH = '1')                  else 'Z';

-- Write TMB_PUSH_DLY
  GEN_TMB_PUSH_DLY : for I in 4 downto 0 generate
  begin
    FDCE(INDATA(I), STROBE, W_TMB_PUSH, RST, TMB_PUSH_DLY_INNER(I));
  end generate GEN_TMB_PUSH_DLY;
  TMB_PUSH_DLY <= TMB_PUSH_DLY_INNER;

-- Read TMB_PUSH_DLY
  OUT_TMB_PUSH(4 downto 0) <= TMB_PUSH_DLY_INNER when (STROBE = '1' and R_TMB_PUSH = '1') else (others => 'Z');

  D_TMB_PUSH  <= '1' when (STROBE = '1' and R_TMB_PUSH = '1') else '0';
  FD(D_TMB_PUSH, SLOWCLK, Q_TMB_PUSH);
  DTACK_INNER <= '0' when (Q_TMB_PUSH = '1')                  else 'Z';

-- Write PUSH_DLY
  GEN_PUSH_DLY : for I in 4 downto 0 generate
  begin
    FDCE(INDATA(I), STROBE, W_PUSH, RST, PUSH_DLY_INNER(I));
  end generate GEN_PUSH_DLY;
  PUSH_DLY <= PUSH_DLY_INNER;

-- Read PUSH_DLY
  OUT_PUSH(4 downto 0) <= PUSH_DLY_INNER when (STROBE = '1' and R_PUSH = '1') else (others => 'Z');

  D_PUSH      <= '1' when (STROBE = '1' and R_PUSH = '1') else '0';
  FD(D_PUSH, SLOWCLK, Q_PUSH);
  DTACK_INNER <= '0' when (Q_PUSH = '1')                  else 'Z';

-- Write LCT_L1A_DLY
  GEN_LCT_L1A_DLY : for I in 5 downto 0 generate
  begin
    FDCE(INDATA(I), STROBE, W_LCT_L1A, RST, LCT_L1A_DLY_INNER(I));
  end generate GEN_LCT_L1A_DLY;
  LCT_L1A_DLY <= LCT_L1A_DLY_INNER;

-- Read LCT_L1A_DLY
  OUT_LCT_L1A(5 downto 0) <= LCT_L1A_DLY_INNER when (STROBE = '1' and R_LCT_L1A = '1') else (others => 'Z');

  D_LCT_L1A   <= '1' when (STROBE = '1' and R_LCT_L1A = '1') else '0';
  FD(D_LCT_L1A, SLOWCLK, Q_LCT_L1A);
  DTACK_INNER <= '0' when (Q_LCT_L1A = '1')                  else 'Z';

-- General assignments
  OUTDATA <= OUT_ALCT_PUSH when R_ALCT_PUSH = '1' else
             OUT_TMB_PUSH when R_TMB_PUSH = '1' else
             OUT_PUSH     when R_PUSH = '1'     else
             OUT_LCT_L1A  when R_LCT_L1A = '1'  else
             (others => 'Z');
  DTACK <= DTACK_INNER;
  
end VMECONFREGS_Arch;
