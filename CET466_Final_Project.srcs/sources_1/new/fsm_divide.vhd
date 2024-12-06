----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/04/2024 04:09:48 PM
-- Design Name: 
-- Module Name: state_controller - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity fsm_divide is
    generic(
        WORD_SIZE: natural := 8
    );
    port(
        quotient, remainder:        out std_logic_vector(WORD_SIZE-1 downto 0);
        is_done:                    out std_logic; -- Indicates that we are done with the operation
        divisor, dividend:          in  unsigned(WORD_SIZE-1 downto 0);
        start, clk, rst:            in  std_logic --start is high asserted, rst is low asserted
    );
end fsm_divide;

architecture Behavioral of fsm_divide is
-- Declare states for FSM
type states is(INIT, LS, LOAD, DONE);
signal current_state, next_state: states;

-- Internal signals for the outputs. This allows us to use them in the state machine.
signal quotient_val:    unsigned(WORD_SIZE-1 downto 0) := to_unsigned(0, WORD_SIZE);
signal remainder_val:   unsigned(WORD_SIZE-1 downto 0) := to_unsigned(0, WORD_SIZE);

-- Internal signals for the division operation.
-- Internal divisor register, no dealing with pesky changes.
signal D:               unsigned(WORD_SIZE-1 downto 0) := to_unsigned(0, WORD_SIZE);
signal T:               unsigned(WORD_SIZE-1 downto 0); -- Negated divisor
-- Subtraction signals
signal difference:      unsigned(WORD_SIZE-1 downto 0);
signal difference_slv:  std_logic_vector(WORD_SIZE downto 0);
signal N_gte_D:         std_logic;
-- Counter signals
signal counter:         integer range 0 to WORD_SIZE;
-- Control signals
signal init_reg:        std_logic;
signal shift_quotient:  std_logic;
signal en_shift_left:   std_logic;
signal en_load:         std_logic;
signal sel_difference:  std_logic;
signal counter_done:    std_logic;
begin
    -- Assign the output values.
    quotient <= std_logic_vector(quotient_val);
    remainder <= std_logic_vector(remainder_val);
    
    -- Load the divisor register
    div_load: process(clk, rst) is begin
        if rst = '0' then
            D <= to_unsigned(0, WORD_SIZE);
        elsif rising_edge(clk) then
            if init_reg = '1' then
                D <= divisor;
            end if;
        end if;
    end process div_load;
    
    -- Subtractor circuit for divider
    T <= not(D) + 1; -- Negate the divisor register
    -- Do some black voodoo magic and perform the subtraction operation
    (N_gte_D,difference) <= ('0' & remainder_val(WORD_SIZE-2 downto 0) & quotient_val(WORD_SIZE-1)) + ('0' & T);
    
    -- Run device counter
    counter_done <= '1' when (counter = 0) else '0';
    
    div_counter: process(clk, rst) is begin
        if rst = '0' then
            counter <= 0;
        elsif rising_edge(clk) then
            if init_reg = '1' then
                counter <= WORD_SIZE;
            elsif counter > 0 then
                counter <= counter - 1;
            end if;
        end if;
    end process div_counter;
    
    -- Handle dividend and quotient
    quo_logic: process(clk, rst) is begin
        if rst = '0' then
            quotient_val <= to_unsigned(0, WORD_SIZE);
        elsif rising_edge(clk) then
            if init_reg = '1' then
                quotient_val <= dividend;
            elsif shift_quotient = '1' then
                quotient_val <= quotient_val(WORD_SIZE-2 downto 0) & N_gte_D;
            else
                quotient_val <= quotient_val;
            end if;
        end if;
    end process quo_logic;
    
    -- Handle remainder and dividend
    rem_logic: process(clk, rst) is begin
        if rst = '0' then
            remainder_val <= to_unsigned(0, WORD_SIZE);
        elsif rising_edge(clk) then
            if en_load = '1' then
                if sel_difference = '1' then
                    remainder_val <= difference;
                else -- sel_difference = '0'
                    remainder_val <= to_unsigned(0, WORD_SIZE);
                end if;
            elsif en_shift_left = '1' then
                remainder_val <= remainder_val(WORD_SIZE-2 downto 0) & quotient(WORD_SIZE-1);
            else
                remainder_val <= remainder_val;
            end if;
        end if;
    end process rem_logic;
    
    -- Signal circuitry for controlling the divider
    cntl_logic: process(next_state) is begin
        case next_state is
            when INIT =>
                init_reg        <= '1';
                en_shift_left   <= '0';
                en_load         <= '1';
                sel_difference  <= '0';
                shift_quotient  <= '0';
            when LS =>
                init_reg        <= '0';
                en_shift_left   <= '1';
                en_load         <= '0';
                sel_difference  <= '0';
                shift_quotient  <= '1';
            when LOAD =>
                init_reg        <= '0';
                en_shift_left   <= '0';
                en_load         <= '1';
                sel_difference  <= '1';
                shift_quotient  <= '1';
            when DONE =>
                init_reg        <= '0';
                en_shift_left   <= '0';
                en_load         <= '0';
                sel_difference  <= '0';
                shift_quotient  <= '0';
        end case;
    end process cntl_logic;
    
    -- State machine flip flops
    state_ff: process(clk, rst) is begin
        if rst = '0' then
            current_state <= DONE;
        elsif rising_edge(clk) then
            current_state <= next_state;
        end if;
    end process state_ff;
    
    -- State machine next state logic
    state_next_logic: process(current_state, start, N_gte_D, counter_done) is begin
        case current_state is
            when INIT =>
                if      (start = '0') and (N_gte_D = '0') then  next_state <= LS;
                elsif   (start = '0') and (N_gte_D = '1') then  next_state <= LOAD;
                else                                            next_state <= INIT;
                end if;
                is_done <= '0';
            when LS =>
                if      (N_gte_D = '0') and (counter_done = '0') then   next_state <= LS;
                elsif   (N_gte_D = '0') and (counter_done = '1') then   next_state <= DONE;
                elsif   (N_gte_D = '1') and (counter_done = '0') then   next_state <= LOAD;
                elsif   (N_gte_D = '1') and (counter_done = '1') then   next_state <= DONE;
                else                                                    next_state <= DONE;
                end if;
                is_done <= '0';
            when LOAD =>
                if      (N_gte_D = '0') and (counter_done = '0') then   next_state <= LS;
                elsif   (N_gte_D = '0') and (counter_done = '1') then   next_state <= DONE;
                elsif   (N_gte_D = '1') and (counter_done = '0') then   next_state <= LOAD;
                elsif   (N_gte_D = '1') and (counter_done = '1') then   next_state <= DONE;
                else                                                    next_state <= DONE;
                end if;
                is_done <= '0';
            when DONE =>
                if start = '1' then                                     next_state <= INIT;
                else                                                    next_state <= DONE;
                end if;
                is_done <= '1';
        end case;
    end process state_next_logic;
end Behavioral;
