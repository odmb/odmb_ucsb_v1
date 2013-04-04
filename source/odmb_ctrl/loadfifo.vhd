library ieee;
library work;
use work.Latches_Flipflops.all;
use ieee.std_logic_1164.all;

entity LOADFIFO is
  
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
 
    
end LOADFIFO;

architecture LOADFIFO_Arch of LOADFIFO is

  --Declaring internal signals
  signal Q1_SHIFT,Q2_SHIFT,Q3_SHIFT,LOAD,C_UPDATE : std_logic;
  signal D : std_logic_vector(2 downto 0);

-----------

begin  --Architecture

  --All processes will be called CREATE_{name of signal they create}
  --If a process creates more than one signal, one name will be used and then
  --the other possible names will be in the comments
  --This is so the reader can use ctrl+f functions to find relevant processes
  
  -----------------------------------------------------------------------------
  JTAG_SHIFT: process (RST,SHIFT,SEL2,FENF,DRCK,LOAD,BTDI,Q1_SHIFT,Q2_SHIFT) 
  begin
    LOAD <= SHIFT and SEL2 and FENF;
    FDCE(BTDI,DRCK,LOAD,RST,Q1_SHIFT);
    FDCE(Q1_SHIFT,DRCK,LOAD,RST,Q2_SHIFT);
    FDCE(Q2_SHIFT,DRCK,LOAD,RST,Q3_SHIFT);
  end process;

  JTAG_UPDATE: process (RST,UPDATE,SEL2,FENF,Q1_SHIFT,Q2_SHIFT,Q3_SHIFT,C_UPDATE) 
  begin
    C_UPDATE <= UPDATE and SEL2 and FENF;
    FDC(Q1_SHIFT,C_UPDATE,RST,D(2));
    FDC(Q2_SHIFT,C_UPDATE,RST,D(1));
    FDC(Q3_SHIFT,C_UPDATE,RST,D(0));
  end process;

  DECODER: process (D) 
  begin
    if (D(2 downto 0) = "000") then
      RENF(0) <= '1';
    else
      RENF(0) <= '0';
    end if;
    if (D(2 downto 0) = "001") then
      RENF(1) <= '1';
    else
      RENF(1) <= '0';
    end if;
    if (D(2 downto 0) = "010") then
      RENF(2) <= '1';
    else
      RENF(2) <= '0';
    end if;
    if (D(2 downto 0) = "011") then
      RENF(3) <= '1';
    else
      RENF(3) <= '0';
    end if;
    if (D(2 downto 0) = "100") then
      RENF(4) <= '1';
    else
      RENF(4) <= '0';
    end if;
    if (D(2 downto 0) = "101") then
      RENF(5) <= '1';
    else
      RENF(5) <= '0';
    end if;
    if (D(2 downto 0) = "110") then
      RENF(6) <= '1';
    else
      RENF(6) <= '0';
    end if;
    if (D(2 downto 0) = "111") then
      RENF(7) <= '1';
    else
      RENF(7) <= '0';
    end if;
  end process;

  SET_TDO: process (Q3_SHIFT)
  begin
    TDO <= Q3_SHIFT;
  end process;

end LOADFIFO_Arch;
