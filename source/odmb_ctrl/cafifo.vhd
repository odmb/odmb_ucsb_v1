---------------------------------------------------------------------------------------------------
--
-- Title       : tx_ctrl_v2_0
-- Design      : 
-- Author      : Guido Magazzù
-- Company     : elvis
--
---------------------------------------------------------------------------------------------------
--
-- Description : tx_ctrl RAM FLF
--
---------------------------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_UNSIGNED.all;
use IEEE.STD_LOGIC_1164.all;

entity cafifo is
   port(
  
   clk : in std_logic;
   rstn : in std_logic;
   sw_reset : in std_logic;
   tc_enable : in std_logic;

	-- From/To SLV_MGT Module

   start : in std_logic;
   start_res : out std_logic;
   stop : in std_logic;
   stop_res : out std_logic;
   mode : in std_logic;
   cmd_n : in std_logic_vector(9 downto 0);
	 busy : out std_logic;
	
   vme_cmd_reg : in std_logic_vector(31 downto 0);
   vme_dat_reg_in : in std_logic_vector(31 downto 0);
   vme_dat_reg_out : out std_logic_vector(31 downto 0);

-- To/From VME Master

   vme_cmd : out std_logic;
   vme_cmd_rd : in std_logic;
	
	 vme_addr : out std_logic_vector(23 downto 1); 
   vme_wr : out std_logic;
	 vme_wr_data : out std_logic_vector(15 downto 0); 
   vme_rd : out std_logic;
	 vme_rd_data : in std_logic_vector(15 downto 0); 
 	 
-- From/To VME_CMD Memory and VME_DAT Memory

   vme_mem_addr : out std_logic_vector(9 downto 0);
   vme_mem_rden : out std_logic;
   vme_cmd_mem_out : in std_logic_vector(31 downto 0);
   vme_dat_mem_out : in std_logic_vector(31 downto 0);
   vme_dat_mem_wren : out std_logic;
   vme_dat_mem_in : out std_logic_vector(31 downto 0)

	);

end cafifo;

--}} End of automatically maintained section

architecture cafifo_architecture of cafifo is

type state_type is (FIFO_EMPTY, FIFO_NOT_EMPTY, FIFO_FULL);
signal next_state, current_state: state_type;

type l1a_cnt_array_type is array (FIFO_SIZE-1 downto 0) of std_logic_vector(11 downto 0);
signal l1a_cnt : l1a_cnt_array_type;

type l1a_array_type is array (FIFO_SIZE-1 downto 0) of std_logic_vector(NFEB+2 downto 1);
signal l1a_match : l1a_array_type;
signal l1a_dv : l1a_array_type;

signal l1a_cnt_wren, l1a_match_wren : std_logic;
signal wr_addr_en, rd_addr_en : std_logic;
signal wr_addr_out, rd_addr_out : std_logic_vector(3 downto 0);
    
begin

-- Assignments
	
-- Write Memory
l1a_cnt_fifo : process (l1a_cnt_wren, wr_addr_out, wr_addr_en, rd_addr_en, rst, clk)

begin
	if (rst = '1') then
	  for index in 0 to FIFO_SIZE-1 loop
      l1a_cnt(index) <= (OTHERS => '0');
	  end loop;
	elsif rising_edge(clk) then
	  if (l1a_cnt_wren = '1') then
      l1a_cnt(wr_addr_out) = l1a_cnt_in;
    end if;
	end if;

end process;

l1a_dav_fifo : process (l1a_cnt, dcfeb_l1a_cnt, dcfeb_l1a_dav, rst, clk)

begin
	if (rst = '1') then
	  for index in 0 to FIFO_SIZE-1 loop
      l1a_dav(index) <= (OTHERS => '0');
	  end loop;
	elsif rising_edge(clk) then
	  for index in 0 to FIFO_SIZE-1 loop      
      for dcfeb_index in 1 to NFEB loop
	     if (dcfeb_l1a_cnt(dcfeb_index) = l1a_cnt(index)) then
        l1a_dav(index)(dcfeb_index) = dcfeb_l1a_dav(dcfeb_index);
    end if;
	end if;

end process;

l1a_match_fifo : process (l1a_match_wren, wr_addr_out, wr_addr_en, rd_addr_en, rst, clk)

begin
	if (rst = '1') then
	  for index in 0 to FIFO_SIZE-1 loop
      l1a_match(index) <= (OTHERS => '0');
	  end loop;
	elsif rising_edge(clk) then
	  if (l1a_match_wren = '1') then
      l1a_match(wr_addr_out) = l1a_match_in;
    end if;
	end if;

end process;
	
-- Address Counters
	
addr_cnt: process (clk, wr_addr_en, rd_addr_en, rst)

variable addr_rd_data, addr_wr_data : std_logic_vector(3 downto 0);

begin

	if (rst = '1') then
		addr_rd_data := (OTHERS => '0');
		addr_wr_data := (OTHERS => '0');		
	elsif (rising_edge(clk)) then
		if (wr_addr_en = '1') then
			addr_wr_data := addr_wr_data + 1;
		end if;
		if (rd_addr_en = '1') then
		  addr_rd_data := addr_rd_data + 1;
		end if;              
	end if; 

	wr_addr_out <= addr_wr_data;
	rd_addr_out <= addr_rd_data;
	
end process;

-- FSM 
	
fsm_regs: process (next_state, rst, clk)

begin
	if (rst = '1') then
		current_state <= FIFO_EMPTY;
	elsif rising_edge(clk) then
		current_state <= next_state;	      	
	end if;

end process;

fsm_logic : process (wren, rden, current_state, wr_addr_out, rd_addr_out)
	
begin
				
	case current_state is
		
		when FIFO_EMPTY =>
			
			empty <= '1';
			full <= '0';
			if (wren = '1') then
				next_state <= FIFO_NOT_EMPTY;
				wr_addr_en <= '1';
				rd_addr_en <= '0';
				l1a_cnt_wren <= '1';
				l1a_match_wren <= '1';
			else
				next_state <= FIFO_EMPTY;
				wr_addr_en <= '0';
				rd_addr_en <= '0';
				l1a_cnt_wren <= '0';
				l1a_match_wren <= '0';
			end if;
			
		when FIFO_NOT_EMPTY =>
			
			empty <= '0';
			full <= '0';
			if (wren = '1' and rden='0') then
			  
			  if (wr_addr_out = rd_addr_out-1) then
				  next_state <= FIFO_FULL;
				else
				  next_state <= FIFO_NOT_EMPTY;
				end if;

				l1a_cnt_wren <= '1';
				l1a_match_wren <= '1';
        wr_addr_en <= '1';
        rd_addr_en <= '0';
			else if (rden = '1' and wren='0') then
			  
			  if (rd_addr_out = wr_addr_out-1)  then
				  next_state <= FIFO_EMPTY;
				else
				  next_state <= FIFO_NOT_EMPTY;
				end if;
				l1a_cnt_wren <= '0';
				l1a_match_wren <= '0';
				rd_addr_en <= '1';
				wr_addr_en <= '0';
			else if (rden='1' and wren='1') then
				next_state <= FIFO_NOT_EMPTY;
        wr_addr_en <= '1';
        rd_addr_en <= '1';			  
				l1a_cnt_wren <= '1';
				l1a_match_wren <= '1';
			else
				next_state <= FIFO_NOT_EMPTY;
				l1a_cnt_wren <= '0';
				l1a_match_wren <= '0';
        wr_addr_en <= '0';
        rd_addr_en <= '0';
			end if;
			
		when FIFO_FULL =>

			empty <= '0';
			full <= '1';
		  l1a_cnt_wren <= '0';
			l1a_match_wren <= '0';
			wr_addr_en <= '0';
			if (rden = '1') then
			  next_state <= FIFO_NOT_EMPTY;
			  rd_addr_en <= '1';
			else
				next_state <= FIFO_FULL;
			  rd_addr_en <= '0';
			end if;

		when others =>

      next_state <= FIFO_EMPTY;
			empty <= '0';
			full <= '0';
		  l1a_cnt_wren <= '0';
			l1a_match_wren <= '0';
      wr_addr_en <= '0';
      rd_addr_en <= '0';
				
		end case;
			
	end process;
		
end cafifo_architecture;
