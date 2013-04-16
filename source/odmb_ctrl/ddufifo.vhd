
library IEEE;
use IEEE.STD_LOGIC_UNSIGNED.all;
--use IEEE.STD_LOGIC_INTEGER.all;
use IEEE.STD_LOGIC_1164.all;
library UNISIM;
use UNISIM.vcomponents.all;
library UNIMACRO;
use UNIMACRO.vcomponents.all;
use work.hdlmacro.all;

entity ddufifo is
  port(

    clk_in : in std_logic;
    clk_out : in std_logic;
    rst : in std_logic;

    rx_ack : in std_logic;

    dv_in : in std_logic;
    ld_in : in std_logic;
    data_in : in std_logic_vector(15 downto 0);

    dv_out : out std_logic;
    data_out : out std_logic_vector(15 downto 0)
    );

end ddufifo;


architecture ddufifo_architecture of ddufifo is

  type fsm_state_type is (IDLE, FIFO_RX, FIFO_TX);
  signal f0_next_state, f0_current_state : fsm_state_type;
  signal f1_next_state, f1_current_state : fsm_state_type;

  signal f0_wren, f0_rden, f0_tx, f0_rx : std_logic;
  signal f0_empty, f0_aempty, f0_afull, f0_full : std_logic;
  signal f0_wr_cnt, f0_rd_cnt : std_logic_vector(9 downto 0);
  signal f0_out : std_logic_vector(15 downto 0);

  signal f1_wren, f1_rden, f1_tx, f1_rx : std_logic;
  signal f1_empty, f1_aempty, f1_afull, f1_full : std_logic;
  signal f1_wr_cnt, f1_rd_cnt : std_logic_vector(9 downto 0);
  signal f1_out : std_logic_vector(15 downto 0);
  
begin

-- FIFOs

    FIFO_0 : FIFO_DUALCLOCK_MACRO
      generic map (
        DEVICE                  => "VIRTEX6",  -- Target Device: "VIRTEX5", "VIRTEX6" 
        ALMOST_FULL_OFFSET      => X"0080",  -- Sets almost full threshold
        ALMOST_EMPTY_OFFSET     => X"0080",  -- Sets the almost empty threshold
        DATA_WIDTH              => 16,  -- Valid values are 1-72 (37-72 only valid when FIFO_SIZE="36Kb")
        FIFO_SIZE               => "18Kb",   -- Target BRAM, "18Kb" or "36Kb" 
        FIRST_WORD_FALL_THROUGH => false)  -- Sets the FIFO FWFT to TRUE or FALSE

      port map (
        ALMOSTEMPTY => f0_aempty,     -- Output almost empty 
        ALMOSTFULL  => f0_afull,      -- Output almost full
        DO          => f0_out,        -- Output data
        EMPTY       => f0_empty,      -- Output empty
        FULL        => f0_full,       -- Output full
        RDCOUNT     => f0_rd_cnt,     -- Output read count
        RDERR       => open,          -- Output read error
        WRCOUNT     => f0_wr_cnt,     -- Output write count
        WRERR       => open,          -- Output write error
        DI          => data_in,       -- Input data
        RDCLK       => clk_out,       -- Input read clock
        RDEN        => f0_rden,       -- Input read enable
        RST         => rst,           -- Input reset
        WRCLK       => clk_in,        -- Input write clock
        WREN        => f0_wren        -- Input write enable
        );

    FIFO_1 : FIFO_DUALCLOCK_MACRO
      generic map (
        DEVICE                  => "VIRTEX6",  -- Target Device: "VIRTEX5", "VIRTEX6" 
        ALMOST_FULL_OFFSET      => X"0080",  -- Sets almost full threshold
        ALMOST_EMPTY_OFFSET     => X"0080",  -- Sets the almost empty threshold
        DATA_WIDTH              => 16,  -- Valid values are 1-72 (37-72 only valid when FIFO_SIZE="36Kb")
        FIFO_SIZE               => "18Kb",   -- Target BRAM, "18Kb" or "36Kb" 
        FIRST_WORD_FALL_THROUGH => false)  -- Sets the FIFO FWFT to TRUE or FALSE

      port map (
        ALMOSTEMPTY => f1_aempty,     -- Output almost empty 
        ALMOSTFULL  => f1_afull,      -- Output almost full
        DO          => f1_out,        -- Output data
        EMPTY       => f1_empty,      -- Output empty
        FULL        => f1_full,       -- Output full
        RDCOUNT     => f1_rd_cnt,     -- Output read count
        RDERR       => open,          -- Output read error
        WRCOUNT     => f1_wr_cnt,     -- Output write count
        WRERR       => open,          -- Output write error
        DI          => data_in,       -- Input data
        RDCLK       => clk_out,       -- Input read clock
        RDEN        => f0_rden,       -- Input read enable
        RST         => rst,           -- Input reset
        WRCLK       => clk_in,        -- Input write clock
        WREN        => f1_wren        -- Input write enable
        );

-- FSMs 

  f0_fsm_regs : process (f0_next_state, rst, clk_in)

  begin
    if (rst = '1') then
      f0_current_state <= IDLE;
    elsif rising_edge(clk_in) then
      f0_current_state <= f0_next_state;
    end if;
 
  end process;

  f0_fsm_logic : process (f0_current_state, f0_empty, f1_empty, f1_rx, f1_tx, dv_in, ld_in)

  begin
    
    case f0_current_state is
        
        when IDLE =>

          f0_rx <= '0';
          f0_tx <= '0';
          f0_rden <= '0';
          if (f1_rx = '0') and (dv_in = '1') then
            f0_wren <= '1';
            f0_next_state <= FIFO_RX;
          else
            f0_wren <= '0';
            f0_next_state <= IDLE;
          end if;
          
        when FIFO_RX =>
          
          f0_rx <= '1';
          f0_tx <= '0';
          f0_wren <= dv_in;
          if (ld_in = '1') and (f1_tx = '0') then
            f0_rden <= '1';
            f0_next_state <= FIFO_TX;
          else
            f0_rden <= '0';
            f0_next_state <= FIFO_RX;
           end if;

        when FIFO_TX =>
          
          f0_rx <= '0';
          f0_tx <= '1';
          f0_wren <= '0';
          if (rx_ack = '1') then
            f0_rden <= '1';
          else
            f0_rden <= '0';
          end if; 
          if (f0_empty = '1') and (dv_in = '0') then
            f0_next_state <= IDLE;
          elsif (f0_empty = '1') and (dv_in = '1') then
            f0_next_state <= FIFO_RX;
          else
            f0_next_state <= FIFO_TX;
          end if;

        when others =>

          f0_tx <= '0';
          f0_wren <= '0';
          f0_rden <= '0';
          f0_next_state <= IDLE;
         
      end case;
      
  end process;

  f1_fsm_regs : process (f1_next_state, rst, clk_in)

  begin
    if (rst = '1') then
      f1_current_state <= IDLE;
    elsif rising_edge(clk_in) then
      f1_current_state <= f0_next_state;
    end if;
 
  end process;

  f1_fsm_logic : process (f1_current_state, f0_empty, f1_empty, f0_rx, f0_tx, dv_in, ld_in)

  begin
    
    case f1_current_state is
        
        when IDLE =>

          f1_rx <= '0';
          f1_tx <= '0';
          f1_rden <= '0';
          if (f0_rx = '0') and (f0_empty = '0') and (dv_in = '1') then
            f1_wren <= '1';
            f1_next_state <= FIFO_RX;
          else
            f1_wren <= '0';
            f1_next_state <= IDLE;
          end if;
          
        when FIFO_RX =>
          
          f1_rx <= '1';
          f1_tx <= '0';
          f1_wren <= dv_in;
          if (ld_in = '1') and (f0_tx = '0') then
            f1_rden <= '1';
            f1_next_state <= FIFO_TX;
          else
            f1_rden <= '0';
            f1_next_state <= FIFO_RX;
           end if;

        when FIFO_TX =>
          
          f1_rx <= '0';
          f1_tx <= '1';
          f1_wren <= '0';
          if (rx_ack = '1') then
            f1_rden <= '1';
          else
            f1_rden <= '0';
          end if; 
          if (f1_empty = '1') and (dv_in = '0') then
            f1_next_state <= IDLE;
          elsif (f0_empty = '1') and (f1_empty = '1') and (dv_in = '1') then
            f1_next_state <= IDLE;
          elsif (f0_empty = '0') and (f1_empty = '1') and (dv_in = '1') then
            f1_next_state <= FIFO_RX;
          else
            f1_next_state <= FIFO_TX;
          end if;

        when others =>

          f1_tx <= '0';
          f1_wren <= '0';
          f1_rden <= '0';
          f1_next_state <= IDLE;
         
      end case;
         
  end process;

  data_out <= f0_out when (f0_tx = '1') else 
              f1_out when (f1_tx = '1') else
              (OTHERS => '0'); 

  dv_out <= f0_rden or f1_rden;
   
end ddufifo_architecture;
