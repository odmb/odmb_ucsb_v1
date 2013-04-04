LIBRARY ieee;
use IEEE.STD_LOGIC_UNSIGNED.all;
USE IEEE.std_logic_arith.all;
USE ieee.std_logic_1164.all;

--  Entity Declaration

ENTITY vme_outdata_sel IS
	PORT (

		device : IN STD_LOGIC_VECTOR(9 downto 0);
		device1_outdata : IN STD_LOGIC_VECTOR(15 downto 0);
		device2_outdata : IN STD_LOGIC_VECTOR(15 downto 0);
		device3_outdata : IN STD_LOGIC_VECTOR(15 downto 0);
		device8_outdata : IN STD_LOGIC_VECTOR(15 downto 0);
		device9_outdata : IN STD_LOGIC_VECTOR(15 downto 0);
		outdata : OUT STD_LOGIC_VECTOR(15 downto 0)
	);
END vme_outdata_sel;

--  Architecture Body
ARCHITECTURE vme_outdata_sel_architecture OF vme_outdata_sel IS

begin

	outdata <= device1_outdata when device="0000000010" else
				  device2_outdata when device="0000000100" else
				  device3_outdata when device="0000001000" else
				  device8_outdata when device="0100000000" else
				  device9_outdata when device="1000000000" else
				  "0000000000000000";

END vme_outdata_sel_architecture;
