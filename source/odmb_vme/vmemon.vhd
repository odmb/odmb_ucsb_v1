-- VMEMON: Sends out FLFCTRL with monitoring values

library ieee;
library work;
library unisim;
use unisim.vcomponents.all;
use ieee.std_logic_1164.all;

entity VMEMON is
  port (

    SLOWCLK : in std_logic;
    RST     : in std_logic;

    DEVICE  : in std_logic;
    STROBE  : in std_logic;
    COMMAND : in std_logic_vector(9 downto 0);

    INDATA  : in  std_logic_vector(15 downto 0);
    OUTDATA : out std_logic_vector(15 downto 0);

    DTACK : out std_logic;

    FLFCTRL : out std_logic_vector(15 downto 0);
    FLFDATA : in  std_logic_vector(15 downto 0)

    );
end VMEMON;


architecture VMEMON_Arch of VMEMON is

  --Declaring internal signals
  signal CMDHIGH                       : std_logic;
  signal BUSY                          : std_logic;
  signal WRITECTRL, READCTRL, READDATA : std_logic;

  signal DTACK_INNER                                        : std_logic;
  signal FLFCTRL_INNER                                      : std_logic_vector(15 downto 0);
  signal D_OUTDATA_1, Q_OUTDATA_1, D_OUTDATA_2, Q_OUTDATA_2 : std_logic;
  
begin

-- generate CMDHIGH / generate WRITECTRL / generate READCTRL / generate READDATA
  CMDHIGH   <= '1' when (COMMAND(9 downto 4) = "000000" and DEVICE = '1') else '0';
  WRITECTRL <= '1' when (COMMAND(3 downto 0) = "0000" and CMDHIGH = '1')  else '0';
  READCTRL  <= '1' when (COMMAND(3 downto 0) = "0001" and CMDHIGH = '1')  else '0';
  READDATA  <= '1' when (COMMAND(3 downto 0) = "0010" and CMDHIGH = '1')  else '0';

  GEN_FLFCTRL : for K in 0 to 15 generate
  begin
    FLFCTRL_K : FDCE port map (FLFCTRL_INNER(K) , STROBE , WRITECTRL , RST , INDATA(K));
  end generate GEN_FLFCTRL;

  FLFCTRL <= FLFCTRL_INNER;

  OUTDATA(15 downto 0) <= FLFCTRL_INNER(15 downto 0) when (STROBE = '1' and READCTRL = '1') else FLFDATA(15 downto 0) when (STROBE = '1' and READDATA = '1') else "ZZZZZZZZZZZZZZZZ";

-- bug in uncleaned version?
  D_OUTDATA_1 <= '1' when ((STROBE = '1') and ((WRITECTRL = '1') or (READCTRL = '1'))) else '0';

  FD_OUTDATA_1 : FD port map(Q_OUTDATA_1, SLOWCLK, D_OUTDATA_1);

  DTACK_INNER <= '0' when (Q_OUTDATA_1 = '1') else 'Z';

--  OUTDATA(15 downto 0) <= FLFDATA(15 downto 0) when (STROBE = '1' and READDATA = '1') else (others => '1');
  D_OUTDATA_2 <= '1' when (STROBE = '1' and READDATA = '1') else '0';

  FD_OUTDATA_2 : FD port map(Q_OUTDATA_2, SLOWCLK, D_OUTDATA_2);

  DTACK_INNER <= '0' when (Q_OUTDATA_2 = '1') else 'Z';

  DTACK <= DTACK_INNER;

end VMEMON_Arch;
