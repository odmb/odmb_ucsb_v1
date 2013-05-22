-- PULSE_EDGE: Creates a pulse one clock cycle long if rising edge

library ieee;
use ieee.std_logic_1164.all;
library unisim;
use unisim.vcomponents.all;

entity PULSE_EDGE is
  port (
    CLK  : in  std_logic;
    DIN  : in  std_logic;
    DOUT : out std_logic
    );
end PULSE_EDGE;

architecture PULSE_EDGE_Arch of PULSE_EDGE is
  signal DOUT_INNER, DOUT_D : std_logic := '0';
  signal DOUT_B             : std_logic := '1';

begin  --Architecture

  FDDIN  : FDC port map(DOUT_D, DIN, DOUT_INNER, DOUT_B);
  FDDOUT : FD port map(DOUT_INNER, CLK, DOUT_D);
  DOUT_B <= not DOUT_INNER;
  DOUT   <= DOUT_INNER;

end PULSE_EDGE_Arch;
