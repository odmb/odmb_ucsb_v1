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
--use IEEE.STD_LOGIC_INTEGER.all;
use IEEE.STD_LOGIC_1164.all;
LIBRARY UNISIM;
USE UNISIM.vcomponents.all;
LIBRARY UNIMACRO;
USE UNIMACRO.vcomponents.all;

entity cafifo is
   generic (
    NFEB : integer range 1 to 7 := 5;  -- Number of DCFEBS, 7 in the final design
    FIFO_SIZE : integer range 1 to 64 := 16  -- Number of CAFIFO words
    );  
   port(
  
   clk : in std_logic;
   rst : in std_logic;

   l1a : in std_logic;
   l1a_match_in : in std_logic_vector(NFEB+2 downto 1);
   
   alct_dv : in std_logic;
   tmb_dv : in std_logic;
   dcfeb0_dv : in std_logic;
   dcfeb0_data : in std_logic_vector(15 downto 0);
   dcfeb1_dv : in std_logic;
   dcfeb1_data : in std_logic_vector(15 downto 0);
   dcfeb2_dv : in std_logic;
   dcfeb2_data : in std_logic_vector(15 downto 0);
   dcfeb3_dv : in std_logic;
   dcfeb3_data : in std_logic_vector(15 downto 0);
   dcfeb4_dv : in std_logic;
   dcfeb4_data : in std_logic_vector(15 downto 0);
   dcfeb5_dv : in std_logic;
   dcfeb5_data : in std_logic_vector(15 downto 0);
   dcfeb6_dv : in std_logic;
   dcfeb6_data : in std_logic_vector(15 downto 0);

   dcfeb_fifo_wren : out std_logic_vector(NFEB downto 1);
   alct_fifo_wren : out std_logic;
   tmb_fifo_wren : out std_logic
   
       
	);

end cafifo;

--}} End of automatically maintained section

architecture cafifo_architecture of cafifo is

signal alct_l1a_dav, tmb_l1a_dav : std_logic;
signal dcfeb_dv : std_logic_vector(NFEB downto 1);

type rx_state_type is (RX_IDLE, RX_DW);
type rx_state_array_type is array (NFEB+2 downto 1) of rx_state_type;
signal rx_next_state, rx_current_state: rx_state_array_type;
signal alct_rx_next_state, alct_rx_current_state: rx_state_type;
signal tmb_rx_next_state, tmb_rx_current_state: rx_state_type;

signal dcfeb_l1a_dav : std_logic_vector(NFEB downto 1);

signal l1a_cnt_out : std_logic_vector(11 downto 0);
	
type state_type is (FIFO_EMPTY, FIFO_NOT_EMPTY, FIFO_FULL);
signal next_state, current_state: state_type;

type dcfeb_l1a_cnt_array_type is array (NFEB downto 1) of std_logic_vector(11 downto 0);
signal dcfeb_l1a_cnt : dcfeb_l1a_cnt_array_type;

type l1a_cnt_array_type is array (FIFO_SIZE-1 downto 0) of std_logic_vector(11 downto 0);
signal l1a_cnt : l1a_cnt_array_type;

type l1a_array_type is array (FIFO_SIZE-1 downto 0) of std_logic_vector(NFEB+2 downto 1);
signal l1a_match : l1a_array_type;
signal l1a_dav : l1a_array_type;

type l1a_b_array_type is array (FIFO_SIZE-1 downto 0) of std_logic;
signal l1a_dav_b8, l1a_dav_b8_gm : l1a_b_array_type;
signal l1a_dav_b9, l1a_dav_b9_gm : l1a_b_array_type;

signal l1a_cnt_wren, l1a_match_wren : std_logic;
signal wr_addr_en, rd_addr_en : std_logic;
-- signal wr_addr_out, rd_addr_out : std_logic_vector(3 downto 0);
signal wr_addr_out, rd_addr_out : integer;

signal wren, rden : std_logic;
signal empty, full : std_logic;

signal reg_alct_l1a_dav : std_logic;
signal alct_fifo_empty, alct_fifo_full : std_logic;
signal alct_fifo_wr_en, alct_fifo_rd_en : std_logic;
signal alct_fifo_wr_cnt, alct_fifo_rd_cnt : std_logic_vector(9 downto 0);
signal alct_fifo_in, alct_fifo_out : std_logic_vector(15 downto 0);

signal reg_tmb_l1a_dav : std_logic;
signal tmb_fifo_empty, tmb_fifo_full : std_logic;
signal tmb_fifo_wr_en, tmb_fifo_rd_en : std_logic;
signal tmb_fifo_wr_cnt, tmb_fifo_rd_cnt : std_logic_vector(9 downto 0);
signal tmb_fifo_in, tmb_fifo_out : std_logic_vector(15 downto 0);

    
begin

-- Initial assignments

dcfeb_dv(1) <= dcfeb0_dv;
dcfeb_dv(2) <= dcfeb1_dv;
dcfeb_dv(3) <= dcfeb2_dv;
dcfeb_dv(4) <= dcfeb3_dv;
dcfeb_dv(5) <= dcfeb4_dv;
dcfeb_dv(6) <= dcfeb5_dv;
dcfeb_dv(7) <= dcfeb6_dv;

dcfeb_l1a_cnt(1) <= dcfeb0_data(11 downto 0) when (dcfeb0_dv = '1') else (OTHERS => '0');
dcfeb_l1a_cnt(2) <= dcfeb1_data(11 downto 0) when (dcfeb1_dv = '1') else (OTHERS => '0');
dcfeb_l1a_cnt(3) <= dcfeb2_data(11 downto 0) when (dcfeb2_dv = '1') else (OTHERS => '0');
dcfeb_l1a_cnt(4) <= dcfeb3_data(11 downto 0) when (dcfeb3_dv = '1') else (OTHERS => '0');
dcfeb_l1a_cnt(5) <= dcfeb4_data(11 downto 0) when (dcfeb4_dv = '1') else (OTHERS => '0');
dcfeb_l1a_cnt(6) <= dcfeb5_data(11 downto 0) when (dcfeb5_dv = '1') else (OTHERS => '0');
dcfeb_l1a_cnt(7) <= dcfeb6_data(11 downto 0) when (dcfeb6_dv = '1') else (OTHERS => '0');

wren <= l1a;
rden <= '0';

-- RX FSMs 

rx_fsm_regs: process (rx_next_state, rst, clk)

begin
	for dcfeb_index in 1 to NFEB loop
	   if (rst = '1') then
		    rx_current_state(dcfeb_index) <= RX_IDLE;
	   elsif rising_edge(clk) then
		    rx_current_state(dcfeb_index) <= rx_next_state(dcfeb_index);	      	
	   end if;
	end loop;

end process;

rx_fsm_logic : process (rx_current_state, dcfeb_dv)
	
begin
				
	for dcfeb_index in 1 to NFEB loop

	   case rx_current_state(dcfeb_index) is
		
		    when RX_IDLE =>
			
			     dcfeb_fifo_wren(dcfeb_index) <= '0';
			     if (dcfeb_dv(dcfeb_index) = '1') then
			       dcfeb_l1a_dav(dcfeb_index) <= '1';
			       rx_next_state(dcfeb_index) <= RX_DW;
			     else
			       dcfeb_l1a_dav(dcfeb_index) <= '0';
			       rx_next_state(dcfeb_index) <= RX_IDLE;
			     end if;
			
		    when RX_DW =>
			
			     dcfeb_l1a_dav(dcfeb_index) <= '0';
			     if (dcfeb_dv(dcfeb_index) = '1') then
			       dcfeb_fifo_wren(dcfeb_index) <= '1';
				     rx_next_state(dcfeb_index) <= RX_DW;
			     else
			       dcfeb_fifo_wren(dcfeb_index) <= '0';
				     rx_next_state(dcfeb_index) <= RX_IDLE;
			     end if;

		    when others =>

			     dcfeb_l1a_dav(dcfeb_index) <= '0';
			     dcfeb_fifo_wren(dcfeb_index) <= '0';
           rx_next_state(dcfeb_index) <= RX_IDLE;
				
		 end case;
			
	end loop;

end process;

alct_rx_fsm_logic : process (alct_rx_current_state, alct_dv)
	
begin
				
	   case alct_rx_current_state is
		
		    when RX_IDLE =>
			
			     if (alct_dv = '1') then
			       alct_l1a_dav <= '1';
			       alct_fifo_wren <= '1';
			       alct_rx_next_state <= RX_DW;
			     else
			       alct_l1a_dav <= '0';
			       alct_fifo_wren <= '0';
			       alct_rx_next_state <= RX_IDLE;
			     end if;
			
		    when RX_DW =>
			
			     alct_l1a_dav <= '0';
			     if (alct_dv = '1') then
			       alct_fifo_wren <= '1';
				     alct_rx_next_state <= RX_DW;
			     else
			       alct_fifo_wren <= '0';
			       alct_rx_next_state <= RX_IDLE;
			     end if;

		    when others =>

				   alct_l1a_dav <= '0';
			     alct_fifo_wren <= '0';
			     alct_rx_next_state <= RX_IDLE;
				
		 end case;

end process;

tmb_rx_fsm_logic : process (tmb_rx_current_state, tmb_dv)
	
begin
				
	   case tmb_rx_current_state is
		
		    when RX_IDLE =>
			
			     if (tmb_dv = '1') then
			       tmb_l1a_dav <= '1';
			       tmb_fifo_wren <= '1';
			       tmb_rx_next_state <= RX_DW;
			     else
			       tmb_l1a_dav <= '0';
			       tmb_fifo_wren <= '0';
			       tmb_rx_next_state <= RX_IDLE;
			     end if;
			
		    when RX_DW =>
			
			     tmb_l1a_dav <= '0';
			     if (tmb_dv = '1') then
			       tmb_fifo_wren <= '1';
				     tmb_rx_next_state <= RX_DW;
			     else
			       tmb_fifo_wren <= '0';
			       tmb_rx_next_state <= RX_IDLE;
			     end if;

		    when others =>

				   tmb_l1a_dav <= '0';
			     tmb_fifo_wren <= '0';
			     tmb_rx_next_state <= RX_IDLE;
				
		 end case;

end process;

-- l1a Counter
	
l1a_counter: process (clk, l1a, rst)

variable l1a_cnt_data : std_logic_vector(11 downto 0);

begin

	if (rst = '1') then
		l1a_cnt_data := (OTHERS => '0');		
	elsif (rising_edge(clk)) then
		if (l1a = '1') then
			l1a_cnt_data := l1a_cnt_data + 1;
		end if;
	end if; 

	l1a_cnt_out <= l1a_cnt_data + 1;
	
end process;

-- Memory

l1a_cnt_fifo : process (l1a_cnt_wren, wr_addr_out, wr_addr_en, rd_addr_en, rst, clk)

begin
	if (rst = '1') then
	  for index in 0 to FIFO_SIZE-1 loop
      l1a_cnt(index) <= (OTHERS => '0');
	  end loop;
	elsif rising_edge(clk) then
	  if (l1a_cnt_wren = '1') then
      l1a_cnt(wr_addr_out) <= l1a_cnt_out;
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
      l1a_match(wr_addr_out) <= l1a_match_in;
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
--	       if (dcfeb_l1a_cnt(dcfeb_index) = l1a_cnt(index)) then
--            l1a_dav(index)(dcfeb_index) <= dcfeb_l1a_dav(dcfeb_index);
	       if (dcfeb_l1a_cnt(dcfeb_index) = l1a_cnt(index)) and (dcfeb_l1a_dav(dcfeb_index) = '1') then
            l1a_dav(index)(dcfeb_index) <= '1';
         end if;
	    end loop;
	  end loop;
	end if;

end process;

alct_reg : process (alct_l1a_dav, rst, clk)

begin
	if (rst = '1') then
	   reg_alct_l1a_dav <= '0';
	elsif rising_edge(clk) then
	   reg_alct_l1a_dav <= alct_l1a_dav;
	end if;
	
end process;

alct_fifo_wr_en <= l1a_match_in(9);
alct_fifo_rd_en <= alct_l1a_dav;
alct_fifo_in <= "0000" & l1a_cnt_out;
  
alct_fifo : FIFO_SYNC_MACRO
   generic map (
      DEVICE => "VIRTEX6",            -- Target Device: "VIRTEX5, "VIRTEX6" 
      ALMOST_FULL_OFFSET => X"0080",  -- Sets almost full threshold
      ALMOST_EMPTY_OFFSET => X"0080", -- Sets the almost empty threshold
      DATA_WIDTH => 16,   -- Valid values are 1-72 (37-72 only valid when FIFO_SIZE="36Kb")
      FIFO_SIZE => "18Kb")            -- Target BRAM, "18Kb" or "36Kb" 
   port map (
      ALMOSTEMPTY => open,   -- Output almost empty 
      ALMOSTFULL => open,     -- Output almost full
      DO => alct_fifo_out,                     -- Output data
      EMPTY => alct_fifo_empty,               -- Output empty
      FULL => alct_fifo_full,                 -- Output full
      RDCOUNT => alct_fifo_rd_cnt,           -- Output read count
      RDERR => open,               -- Output read error
      WRCOUNT => alct_fifo_wr_cnt,           -- Output write count
      WRERR => open,               -- Output write error
      CLK => clk,                   -- Input clock
      DI => alct_fifo_in,                     -- Input data
      RDEN => alct_fifo_rd_en,                 -- Input read enable
      RST => rst,                   -- Input reset
      WREN => alct_fifo_wr_en                  -- Input write enable
   );

alct_dv_fifo_gm : process (l1a_cnt, alct_fifo_out, reg_alct_l1a_dav, rst, clk)

begin
	if (rst = '1') then
	  for index in 0 to FIFO_SIZE-1 loop
      l1a_dav_b9_gm(index) <= '0';
	  end loop;
	elsif rising_edge(clk) then
	  for index in 0 to FIFO_SIZE-1 loop      
	    if (alct_fifo_out(11 downto 0) = l1a_cnt(index)) and (reg_alct_l1a_dav = '1') then
         l1a_dav_b9_gm(index) <= '1';
      end if;
	  end loop;
	end if;

end process;
	
alct_dv_fifo : process (l1a_cnt, dcfeb_l1a_cnt, alct_l1a_dav, rst, clk)
variable filled : std_logic;
begin
  filled := '0';
	if (rst = '1') then
	  for index in 0 to FIFO_SIZE-1 loop
      l1a_dav_b9(index) <= '0';
	  end loop;
	elsif rising_edge(clk) and alct_l1a_dav='1' then
	  for index in wr_addr_out+1 to FIFO_SIZE-1 loop      
	       if (l1a_match(index)(9) = '1') and (filled = '0') then
            l1a_dav_b9(index) <= '1';
            filled := '1';
         end if;
	  end loop;
	  for index in 1 to wr_addr_out-1 loop      
	       if (l1a_match(index)(9) = '1') and (filled = '0') then
            l1a_dav_b9(index) <= '1';
            filled := '1';
         end if;
	  end loop;
	end if;

end process;
	
tmb_reg : process (tmb_l1a_dav, rst, clk)

begin
	if (rst = '1') then
	   reg_tmb_l1a_dav <= '0';
	elsif rising_edge(clk) then
	   reg_tmb_l1a_dav <= tmb_l1a_dav;
	end if;
	
end process;

tmb_fifo_wr_en <= l1a_match_in(8);
tmb_fifo_rd_en <= tmb_l1a_dav;
tmb_fifo_in <= "0000" & l1a_cnt_out;
  
tmb_fifo : FIFO_SYNC_MACRO
   generic map (
      DEVICE => "VIRTEX6",            -- Target Device: "VIRTEX5, "VIRTEX6" 
      ALMOST_FULL_OFFSET => X"0080",  -- Sets almost full threshold
      ALMOST_EMPTY_OFFSET => X"0080", -- Sets the almost empty threshold
      DATA_WIDTH => 16,   -- Valid values are 1-72 (37-72 only valid when FIFO_SIZE="36Kb")
      FIFO_SIZE => "18Kb")            -- Target BRAM, "18Kb" or "36Kb" 
   port map (
      ALMOSTEMPTY => open,   -- Output almost empty 
      ALMOSTFULL => open,     -- Output almost full
      DO => tmb_fifo_out,                     -- Output data
      EMPTY => tmb_fifo_empty,               -- Output empty
      FULL => tmb_fifo_full,                 -- Output full
      RDCOUNT => tmb_fifo_rd_cnt,           -- Output read count
      RDERR => open,               -- Output read error
      WRCOUNT => tmb_fifo_wr_cnt,           -- Output write count
      WRERR => open,               -- Output write error
      CLK => clk,                   -- Input clock
      DI => tmb_fifo_in,                     -- Input data
      RDEN => tmb_fifo_rd_en,                 -- Input read enable
      RST => rst,                   -- Input reset
      WREN => tmb_fifo_wr_en                  -- Input write enable
   );

tmb_dv_fifo_gm : process (l1a_cnt, tmb_fifo_out, reg_tmb_l1a_dav, rst, clk)

begin
	if (rst = '1') then
	  for index in 0 to FIFO_SIZE-1 loop
      l1a_dav_b8_gm(index) <= '0';
	  end loop;
	elsif rising_edge(clk) then
	  for index in 0 to FIFO_SIZE-1 loop      
	    if (tmb_fifo_out(11 downto 0) = l1a_cnt(index)) and (reg_tmb_l1a_dav = '1') then
         l1a_dav_b8_gm(index) <= '1';
      end if;
	  end loop;
	end if;

end process;
	
tmb_dv_fifo : process (l1a_cnt, dcfeb_l1a_cnt, tmb_l1a_dav, rst, clk)
variable filled : std_logic;
begin
  filled := '0';
	if (rst = '1') then
	  for index in 0 to FIFO_SIZE-1 loop
      l1a_dav_b8(index) <= '0';
	  end loop;
	elsif rising_edge(clk) and tmb_l1a_dav='1' then
	  for index in wr_addr_out+1 to FIFO_SIZE-1 loop      
	       if (l1a_match(index)(8) = '1') and (filled = '0') then
            l1a_dav_b8(index) <= '1';
            filled := '1';
         end if;
	  end loop;
	  for index in 1 to wr_addr_out-1 loop      
	       if (l1a_match(index)(8) = '1') and (filled = '0') then
            l1a_dav_b8(index) <= '1';
            filled := '1';
         end if;
	  end loop;
	end if;

end process;
	
-- Address Counters
	
addr_counter: process (clk, wr_addr_en, rd_addr_en, rst)

--variable addr_rd_data, addr_wr_data : std_logic_vector(3 downto 0);
variable addr_rd_data, addr_wr_data : integer;

begin

	if (rst = '1') then
		addr_rd_data := 0;
		addr_wr_data := 0;		
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
			elsif (rden = '1' and wren='0') then
			  
			  if (rd_addr_out = wr_addr_out-1)  then
				  next_state <= FIFO_EMPTY;
				else
				  next_state <= FIFO_NOT_EMPTY;
				end if;
				l1a_cnt_wren <= '0';
				l1a_match_wren <= '0';
				rd_addr_en <= '1';
				wr_addr_en <= '0';
			elsif (rden='1' and wren='1') then
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
