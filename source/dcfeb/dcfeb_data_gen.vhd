---------------------------------------------------------------------------------------------------
--
-- Title       : dcfeb data generator
-- Design      : 
-- Author      : Guido Magazzù
--
---------------------------------------------------------------------------------------------------
--
-- Description : tx_ctrl RAM FLF
--
---------------------------------------------------------------------------------------------------

library IEEE;
library unisim;
use IEEE.STD_LOGIC_UNSIGNED.all;
use IEEE.STD_LOGIC_1164.all;
use unisim.vcomponents.all;

entity dcfeb_data_gen is
   port(
  
   clk : in std_logic;
   rst : in std_logic;
   l1a : in std_logic;
   l1a_match : in std_logic;

   dcfeb_addr : in std_logic_vector(3 downto 0);

   dcfeb_dv : out std_logic;
   dcfeb_data : out std_logic_vector(15 downto 0)
	
	);

end dcfeb_data_gen;

--}} End of automatically maintained section

architecture dcfeb_data_gen_architecture of dcfeb_data_gen is

type state_type is (IDLE, TX_HEADER1, TX_HEADER2, TX_DATA);
    
signal next_state, current_state: state_type;

signal dw_cnt_en, dw_cnt_rst : std_logic;
signal l1a_cnt_out : std_logic_vector(23 downto 0);
signal dw_cnt_out : std_logic_vector(11 downto 0);
constant dw_n : std_logic_vector(11 downto 0) := "000000001000";
signal tx_start : std_logic;

begin
  
-- l1a_counter
	
l1a_cnt: process (clk, l1a)

variable l1a_cnt_data : std_logic_vector(23 downto 0);

begin

	if (rst = '1') then
		l1a_cnt_data := (OTHERS => '0');
	elsif (rising_edge(clk)) then
    if (l1a = '1') then    
			l1a_cnt_data := l1a_cnt_data + 1;
		end if;              
	end if; 

	l1a_cnt_out <= l1a_cnt_data;
	
end process;

-- dw_counter
	
dw_cnt: process (clk, dw_cnt_en, dw_cnt_rst)

variable dw_cnt_data : std_logic_vector(11 downto 0);

begin

	if (rst = '1') then
		dw_cnt_data := (OTHERS => '0');
	elsif (rising_edge(clk)) then
    if (dw_cnt_rst = '1') then    
			dw_cnt_data := (OTHERS => '0');
    elsif (dw_cnt_en = '1') then    
			dw_cnt_data := dw_cnt_data + 1;
		end if;              
	end if; 

	dw_cnt_out <= dw_cnt_data + 1;
	
end process;

-- FSM 
	
fsm_regs: process (next_state, rst, clk)

begin
	if (rst = '1') then
		current_state <= IDLE;
	elsif rising_edge(clk) then
		current_state <= next_state;	      	
	end if;

end process;

SRL16_TX_START : SRL16 port map(tx_start, '1', '1', '1', '1', CLK, l1a_match);

fsm_logic : process (tx_start, l1a_cnt_out, dw_cnt_out, current_state)
	
begin
				
	case current_state is
		
		when IDLE =>
			
      dcfeb_data <= (OTHERS => 'Z');			
      dcfeb_dv <= '0';	
      dw_cnt_en <= '0';
			dw_cnt_rst <= '1';
			if (tx_start = '1') then
				next_state <= TX_HEADER1;
			else
				next_state <= IDLE;
			end if;
			
		when TX_HEADER1 =>
			
      dcfeb_data <= dcfeb_addr & l1a_cnt_out(23 downto 12);			
      dcfeb_dv <= '1';	
      dw_cnt_en <= '0';
			dw_cnt_rst <= '0';
			next_state <= TX_HEADER2;
			
		when TX_HEADER2 =>
			
      dcfeb_data <= dcfeb_addr & l1a_cnt_out(11 downto 0);			
      dcfeb_dv <= '1';	
      dw_cnt_en <= '0';
			dw_cnt_rst <= '0';
			next_state <= TX_DATA;
			
		when TX_DATA =>

      dcfeb_data <= dcfeb_addr & dw_cnt_out;			
      dcfeb_dv <= '1';	
			if (dw_cnt_out = dw_n) then
        dw_cnt_en <= '0';
			  dw_cnt_rst <= '1';
				next_state <= IDLE;
			else
        dw_cnt_en <= '1';
			  dw_cnt_rst <= '0';
				next_state <= TX_DATA;
			end if;

		when others =>

      dcfeb_data <= (OTHERS => 'Z');			
      dcfeb_dv <= '0';	
      dw_cnt_en <= '0';
			dw_cnt_rst <= '1';
			next_state <= IDLE;
				
		end case;
			
	end process;
		
end dcfeb_data_gen_architecture;
