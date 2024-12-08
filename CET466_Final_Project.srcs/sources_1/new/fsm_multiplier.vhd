----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/08/2024 12:53:16 PM
-- Design Name: 
-- Module Name: fsm_multiplier - Behavioral
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

entity fsm_multiplier is
    generic(
        WORD_SIZE:          natural := 8
    );
    port(
        product:            out std_logic_vector((WORD_SIZE*2)-1 downto 0);
        is_done:            out std_logic;
        multiplier:         in  unsigned(WORD_SIZE-1 downto 0);
        multiplicand:       in  unsigned(WORD_SIZE-1 downto 0);
        start, clk, rst:    in  std_logic -- rst is low asserted
    );
end fsm_multiplier;

architecture Behavioral of fsm_multiplier is
signal counter:             integer range 0 to WORD_SIZE := 0;
signal product_val:         unsigned((WORD_SIZE*2)-1 downto 0) := to_unsigned(0,WORD_SIZE*2);
signal internal_sum:        unsigned(WORD_SIZE downto 0);
signal M:                   unsigned(WORD_SIZE-1 downto 0);

-- Control signals
signal init_load:           std_logic;
signal shift_right_sig:     std_logic;
signal shift_add_sig:       std_logic;
signal counter_done:        std_logic;

type states is(
    DONE,
    INIT,
    RS,
    SHIFT_AND_ADD
    );
signal current_state, next_state:  states;
begin
    -- Assign the output
    product <= std_logic_vector(product_val);
    
    -- Handle the multiplicand
    mult0: process(clk,rst) is begin
        if rst = '0' then
            M <= to_unsigned(0, WORD_SIZE);
        elsif rising_edge(clk) then
            if init_load = '1' then
                M <= multiplicand;
            end if;
        end if;
    end process mult0;
    
    -- Build the adder
    internal_sum <= ('0' & product_val((WORD_SIZE*2)-1 downto WORD_SIZE)) + ('0' & M);
    
    -- Handle the product
    pro0: process(clk,rst) is begin
        if rst = '0' then
            product_val <= to_unsigned(0,WORD_SIZE*2);
        elsif rising_edge(clk) then
            if init_load = '1' then
                product_val <= to_unsigned(0, WORD_SIZE) & multiplier;
            elsif shift_right_sig = '1' then
                product_val <= '0' & product_val((WORD_SIZE*2)-1 downto 1);
            elsif shift_add_sig = '1' then
                product_val <= internal_sum & product_val(WORD_SIZE-1 downto 1);
            else
                product_val <= product_val;
            end if;
        end if;
    end process pro0;
    
    -- Handle the control logic
    ctl0: process(next_state) is begin
        case next_state is
            when DONE =>
                init_load <= '0';
                shift_right_sig <= '0';
                shift_add_sig <= '0';
            when INIT =>
                init_load <= '1';
                shift_right_sig <= '0';
                shift_add_sig <= '0';
            when RS =>
                init_load <= '0';
                shift_right_sig <= '1';
                shift_add_sig <= '0';
            when SHIFT_AND_ADD =>
                init_load <= '0';
                shift_right_sig <= '0';
                shift_add_sig <= '1';
            when others =>
                init_load <= '0';
                shift_right_sig <= '0';
                shift_add_sig <= '0';
        end case;
    end process ctl0;
    
    -- Counter logic
    counter_done <= '1' when (counter = 0) else '0';
    
    count0: process(clk, rst) is begin
        if rst = '0' then
            counter <= 0;
        elsif rising_edge(clk) then
            if init_load = '1' then
                counter <= WORD_SIZE;
            elsif counter > 0 then
                counter <= counter - 1;
            end if;
        end if;
    end process count0;
    
    -- Next state logic
    fsm0: process(current_state, counter_done, product_val, start) is begin
        case current_state is
            when DONE =>
                if start = '1' then
                    next_state <= INIT;
                else
                    next_state <= DONE;
                end if;
                is_done <= '1';
            when INIT =>
                if start = '0' and product_val(0) = '0' then
                    next_state <= RS;
                elsif start = '0' and product_val(0) = '1' then
                    next_state <= SHIFT_AND_ADD;
                else
                    next_state <= INIT;
                end if;
                is_done <= '0';
            when RS =>
                if counter_done = '1' then
                    next_state <= DONE;
                elsif product_val(0) = '0' then
                    next_state <= RS;
                elsif product_val(0) = '1' then
                    next_state <= SHIFT_AND_ADD;
                else
                    next_state <= DONE;
                end if;
                is_done <= '0';
            when SHIFT_AND_ADD =>
                if counter_done = '1' then
                    next_state <= DONE;
                elsif product_val(0) = '0' then
                    next_state <= RS;
                elsif product_val(0) = '1' then
                    next_state <= SHIFT_AND_ADD;
                else
                    next_state <= DONE;
                end if;
                is_done <= '0';
            when others =>
                next_state <= DONE;
            end case;
    end process fsm0;
    
    -- Handle FSM flip flops
    fsm1: process(clk,rst) is begin
        if rst = '0' then
            current_state <= DONE;
        elsif rising_edge(clk) then
            current_state <= next_state;
        end if;
    end process fsm1;
end Behavioral;
