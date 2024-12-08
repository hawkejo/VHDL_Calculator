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

entity state_controller is
    generic(
        INPUT_WORD_SIZE:    natural :=  8;
        DISP_WORD_SIZE:     natural := 24
    );
    port(
        -- Outputs
        result:         out     std_logic_vector(DISP_WORD_SIZE-1 downto 0);
        remainder:  out     std_logic_vector(INPUT_WORD_SIZE-1 downto 0);
        -- Input values
        lhs:            in      unsigned(INPUT_WORD_SIZE-1 downto 0);
        rhs:            in      unsigned(INPUT_WORD_SIZE-1 downto 0);
        -- Execution buttons
        add:            in      std_logic;
        sub:            in      std_logic;
        mult:           in      std_logic;
        div:            in      std_logic;
        -- Control and synchronization signals
        rst:            in      std_logic;  -- Low asserted
        clk:            in      std_logic
    );
end state_controller;

architecture Behavioral of state_controller is
-- Divider signals
signal quotient:        std_logic_vector(INPUT_WORD_SIZE-1 downto 0);
signal quotient_rsze:   std_logic_vector(DISP_WORD_SIZE-1 downto 0);
signal remainder_div:       std_logic_vector(INPUT_WORD_SIZE-1 downto 0);
signal div_start:       std_logic;
signal div_done:        std_logic;
-- Multiplier signals
signal product:         std_logic_vector(DISP_WORD_SIZE-1 downto 0);
signal mult_out:        std_logic_vector((INPUT_WORD_SIZE*2)-1 downto 0);
signal mult_start:      std_logic;  -- Signals for future state machine implementation
signal mult_done:       std_logic;
-- Adder signals
signal sum:             std_logic_vector(DISP_WORD_SIZE-1 downto 0);
-- Subtractor signals
signal difference:      std_logic_vector(DISP_WORD_SIZE-1 downto 0);
-- Define state machine signals
type states is(
        ADDER_START, ADDITION,
        SUBTRACTOR_START, SUBTRACTION,
        MULTIPLIER_START, MULTIPLICATION,
        DIVIDER_START, DIVISION,
        DONE
    );
signal current_state, next_state: states;
signal result_out:      std_logic_vector(DISP_WORD_SIZE-1 downto 0);
signal new_result:      std_logic_vector(DISP_WORD_SIZE-1 downto 0);
signal remainder_out:   std_logic_vector(INPUT_WORD_SIZE-1 downto 0);
signal remainder_next:  std_logic_vector(INPUT_WORD_SIZE-1 downto 0);
begin
    -- Specify output value
    result <= result_out;
    remainder <= remainder_out;
    
    -- Instantiate divider
    div0: entity work.fsm_divide port map(
        quotient => quotient,
        remainder => remainder_div,
        is_done => div_done,
        divisor => rhs,
        dividend => lhs,
        start => div_start,
        clk => clk,
        rst => rst
    );
    
    -- Instantiate multiplier
    mult0: entity work.fsm_multiplier port map(
        product => mult_out,
        is_done => mult_done,
        multiplier => lhs,
        multiplicand => rhs,
        start => mult_start,
        rst => rst,
        clk => clk
    );
    product <= x"00" & mult_out;
    -- Instantiate multiplier
--    product <= x"00" & std_logic_vector(lhs * rhs);
--    mult_done <= '1';
    
    -- Instantiate adder
    sum <= x"000" & "000" & std_logic_vector(('0' & lhs) + ('0' & rhs));
    
    -- Instantiate subtractor
    difference <= x"0000" & std_logic_vector(lhs - rhs);
    
    -- State machine flip flops
    fsm_ff: process(clk,rst) is begin
        if rst = '0' then
            current_state <= DONE;
            result_out <= x"000000";
            remainder_out <= x"00";
        elsif rising_edge(clk) then
            current_state <= next_state;
            result_out <= new_result;
            remainder_out <= remainder_next;
        end if;
    end process fsm_ff;
    
    -- State machine next state logic
    fsm_logic: process(current_state, mult_done, div_done, add, sub, mult, div) is begin
        case current_state is
            when DONE =>
                if add = '1' then
                    next_state <= ADDER_START;
                elsif sub = '1' then
                    next_state <= SUBTRACTOR_START;
                elsif mult = '1' then
                    next_state <= MULTIPLIER_START;
                elsif div = '1' then
                    next_state <= DIVIDER_START;
                else
                    next_state <= DONE;
                end if;
            when ADDER_START =>
                next_state <= ADDITION;
            when ADDITION =>
                next_state <= DONE;
            when SUBTRACTOR_START =>
                next_state <= SUBTRACTION;
            when SUBTRACTION =>
                next_state <= DONE;
            when MULTIPLIER_START =>
                next_state <= MULTIPLICATION;
            when MULTIPLICATION =>
                if mult_done = '0' then
                    next_state <= MULTIPLICATION;
                elsif mult_done = '1' then
                    next_state <= DONE;
                end if;
            when DIVIDER_START =>
                next_state <= DIVISION;
            when DIVISION =>
                if div_done = '0' then
                    next_state <= DIVISION;
                elsif div_done = '1' then
                    next_state <= DONE;
                end if;
            when others =>
                next_state <= DONE;
            end case;
    end process fsm_logic;
    
    -- Handle other control signals
    fsm_signals: process(next_state, sum, difference, product, quotient,
                        remainder_div, result_out, remainder_out) is begin
        case next_state is
        when ADDITION =>
            new_result <= sum;
            mult_start <= '0';
            div_start <= '0';
            remainder_next <= x"00";
        when SUBTRACTION =>
            new_result <= difference;
            mult_start <= '0';
            div_start <= '0';
            remainder_next <= x"00";
        when MULTIPLIER_START =>
            new_result <= result_out;
            mult_start <= '1';
            div_start <= '0';
            remainder_next <= x"00";
        when MULTIPLICATION =>
            new_result <= product;
            mult_start <= '0';
            div_start <= '0';
            remainder_next <= x"00";
        when DIVIDER_START =>
            new_result <= result_out;
            mult_start <= '0';
            div_start <= '1';
            remainder_next <= x"00";
        when DIVISION =>
            new_result <= x"0000" & quotient;
            mult_start <= '0';
            div_start <= '0';
            remainder_next <= remainder_div;
        when others =>
            new_result <= result_out;
            mult_start <= '0';
            div_start <= '0';
            remainder_next <= remainder_out;
        end case;
    end process fsm_signals;
end Behavioral;
