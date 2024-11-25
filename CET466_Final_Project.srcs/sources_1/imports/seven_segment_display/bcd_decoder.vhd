---------------------------------------------------------------------------------
-- Engineer:            Joseph Hawker
-- 
-- Design Name:         Part A
-- Project Name:        Lab 02
-- Module Name:         bcd_decoder
-- Target Device(s):    Nexys 4 DDR, Alterra Cyclone 4 Development Board
-- Tool Versions:       Vivado 2024.1.2, Quartus Prime 21.1
-- Date Created:        23 September 2024
--
-- Description: Used to convert binary numbers to BCD in multiple digits. The
--      referenced code has been modified to meet requirements and personal
--      design goals. I've written one of these before in Verilog, but have no
--      idea where the code is, and would likely rewrite it anyways as a state
--      machine instead of using a for loop.
--
-- Reference: https://allaboutfpga.com/vhdl-code-for-binary-to-bcd-converter/
---------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity bcd_decoder is
    generic(
        WORD_SIZE:      positive    := 24; -- 8 displays total
        BCD_WIDTH:      positive    := 32  -- 8 displays with 4-bits per display
    );
    port(
        clk:            in std_logic;
        number:         in std_logic_vector(WORD_SIZE-1 downto 0);
        bcd_out:        out std_logic_vector(BCD_WIDTH-1 downto 0)
    );
end bcd_decoder;

architecture main of bcd_decoder is
    type states is (
        start,
        shift,
        done
    );
    signal state, state_next: states;
    signal binary, binary_next:                 std_logic_vector(WORD_SIZE-1 downto 0);
    signal bcd, bcd_reg, bcd_next:              std_logic_vector(BCD_WIDTH-1 downto 0);
    signal bcd_out_reg, bcd_out_reg_next:       std_logic_vector(BCD_WIDTH-1 downto 0);
    signal shift_counter, shift_counter_next:   natural range 0 to WORD_SIZE;
    
begin
    process(clk) begin -- Handle flip-flops for state machine
        if rising_edge(clk) then
            binary <= binary_next;
            bcd <= bcd_next;
            state <= state_next;
            bcd_out_reg <= bcd_out_reg_next;
            shift_counter <= shift_counter_next;
        end if;
    end process;
    
    convert:
    process(state, binary, number, bcd, bcd_reg, shift_counter) begin
        state_next <= state;
        bcd_next <= bcd;
        binary_next <= binary;
        shift_counter_next <= shift_counter;
        
        case state is
            when start =>
                state_next <= shift;
                binary_next <= number;
                bcd_next <= (others =>'0');
                shift_counter_next <= 0;
            when shift =>
                if shift_counter = WORD_SIZE then
                    state_next <= done;
                else
                    binary_next <= binary(WORD_SIZE-2 downto 0) & 'L';
                    bcd_next <= bcd_reg(BCD_WIDTH-2 downto 0) & binary(WORD_SIZE-1);
                    shift_counter_next <= shift_counter + 1;
                end if;
            when done =>
                state_next <= start;
        end case;
    end process; -- convert
    
    bcd_reg(BCD_WIDTH-1 downto BCD_WIDTH-4) <=
        bcd(BCD_WIDTH-1 downto BCD_WIDTH-4) + 3 when bcd(BCD_WIDTH-1 downto BCD_WIDTH-4) > 4 else
        bcd(BCD_WIDTH-1 downto BCD_WIDTH-4);
    bcd_reg(BCD_WIDTH-5 downto BCD_WIDTH-8) <=
        bcd(BCD_WIDTH-5 downto BCD_WIDTH-8) + 3 when bcd(BCD_WIDTH-5 downto BCD_WIDTH-8) > 4 else
        bcd(BCD_WIDTH-5 downto BCD_WIDTH-8);
    bcd_reg(BCD_WIDTH-9 downto BCD_WIDTH-12) <=
        bcd(BCD_WIDTH-9 downto BCD_WIDTH-12) + 3 when bcd(BCD_WIDTH-9 downto BCD_WIDTH-12) > 4 else
        bcd(BCD_WIDTH-9 downto BCD_WIDTH-12);
    bcd_reg(BCD_WIDTH-13 downto BCD_WIDTH-16) <=
        bcd(BCD_WIDTH-13 downto BCD_WIDTH-16) + 3 when bcd(BCD_WIDTH-13 downto BCD_WIDTH-16) > 4 else
        bcd(BCD_WIDTH-13 downto BCD_WIDTH-16);
    bcd_reg(BCD_WIDTH-17 downto BCD_WIDTH-20) <=
        bcd(BCD_WIDTH-17 downto BCD_WIDTH-20) + 3 when bcd(BCD_WIDTH-17 downto BCD_WIDTH-20) > 4 else
        bcd(BCD_WIDTH-17 downto BCD_WIDTH-20);
    bcd_reg(BCD_WIDTH-21 downto BCD_WIDTH-24) <=
        bcd(BCD_WIDTH-21 downto BCD_WIDTH-24) + 3 when bcd(BCD_WIDTH-21 downto BCD_WIDTH-24) > 4 else
        bcd(BCD_WIDTH-21 downto BCD_WIDTH-24);
    bcd_reg(BCD_WIDTH-25 downto BCD_WIDTH-28) <=
        bcd(BCD_WIDTH-25 downto BCD_WIDTH-28) + 3 when bcd(BCD_WIDTH-25 downto BCD_WIDTH-28) > 4 else
        bcd(BCD_WIDTH-25 downto BCD_WIDTH-28);
    bcd_reg(BCD_WIDTH-29 downto BCD_WIDTH-32) <=
        bcd(BCD_WIDTH-29 downto BCD_WIDTH-32) + 3 when bcd(BCD_WIDTH-29 downto BCD_WIDTH-32) > 4 else
        bcd(BCD_WIDTH-29 downto BCD_WIDTH-32);
    
    bcd_out_reg_next <= bcd when state = done else bcd_out_reg;
    
    bcd_out <= bcd_out_reg;
end main;