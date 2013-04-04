library ieee;
use ieee.std_logic_1164.all;
USE IEEE.std_logic_arith.all;
USE IEEE.std_logic_unsigned.all;

ENTITY ot_mgr IS
PORT (
		 otx1_tx_en : OUT STD_LOGIC;
		 otx1_tx_dis : OUT STD_LOGIC;
		 otx1_reset : OUT STD_LOGIC;
		 otx1_fault : IN STD_LOGIC;
		 otx2_tx_en : OUT STD_LOGIC;
		 otx2_tx_dis : OUT STD_LOGIC;
		 otx2_reset : OUT STD_LOGIC;
		 otx2_fault : IN STD_LOGIC;
		 orx1_rx_en : OUT STD_LOGIC;
		 orx1_en_sd : OUT STD_LOGIC;
		 orx1_sd : IN STD_LOGIC;
		 orx1_sq_en : OUT STD_LOGIC;
		 orx2_rx_en : OUT STD_LOGIC;
		 orx2_en_sd : OUT STD_LOGIC;
		 orx2_sd : IN STD_LOGIC;
		 orx2_sq_en : OUT STD_LOGIC		
);
	
end ot_mgr;


ARCHITECTURE om_architecture OF ot_mgr IS

begin

	otx1_tx_en <= '1';
	otx1_tx_dis <= '0';
	otx1_reset <= '0';
	otx2_tx_en <= '1';
	otx2_tx_dis <= '0';
	otx2_reset <= '0';
	orx1_rx_en <= '1';
	orx1_en_sd <= '0';
	orx1_sq_en <= '0';
	orx2_rx_en <= '1';
	orx2_en_sd <= '0';
	orx2_sq_en <= '0';
	
end om_architecture;
