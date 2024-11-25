----------------------------------------------------------------------------------
-- Company: Central Connecticut State University
-- Engineer: Joseph Hawker
-- 
-- Create Date: 11/25/2024 09:32:32 AM
-- Design Name: PMOD KYPD Decoder
-- Module Name: pmod_kypd - Behavioral
-- Project Name: CET 466 Final Project - Calculator
-- Target Devices: Nexys 4 DDR
-- Tool Versions: Vivado 2024.2
-- Description: Decoder for handling the keypad to be used with the project
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

entity pmod_kypd is
    generic(
        MAX_CNT: integer := 1000000
    );
    port(
        clk100MHz:  in      std_logic;
        pmod:       inout   std_logic_vector(7 downto 0);
        digit:      out     std_logic_vector(3 downto 0)
    );
end pmod_kypd;

architecture Behavioral of pmod_kypd is
signal redclk:      std_logic;
signal col:         std_logic_vector (3 downto 0);
signal row:         std_logic_vector (3 downto 0);
signal decode_out:  std_logic_vector (3 downto 0);
signal clkcnt:      integer range 0 to MAX_CNT;
begin
-- Reduce the clock internally to 100 Hz
    clkdiv: process (clk100MHz) is
    begin
        if rising_edge(clk100MHz) then
            if clkcnt = MAX_CNT-1 then
                redclk <= not redclk;
                clkcnt <= 0;
             else
                clkcnt <= clkcnt + 1;
            end if;
        end if;
    end process clkdiv;
    
    -- Decode the input from the button press
    -- The column index is a state machine for determine the column to read.
    pmod(3 downto 0) <= col;
    row <= pmod(7 downto 4);
    digit <= decode_out;
    
    state: process(redclk) is
    begin
        if rising_edge(redclk) then
            if col = "0111" then
                col <= "1011";
            elsif col = "1011" then
                col <= "1101";
            elsif col = "1101" then
                col <= "1110";
            elsif col = "1110" then
                col <= "0111";
            else
                col <= "0111";
            end if;
        end if;
    end process state;
    
    -- Decoding time
    decode: process(redclk) is
    begin
        if rising_edge(redclk) then
            if col = "0111" then
                if row = "0111" then
                    decode_out <= x"1";
                elsif row = "1011" then
                    decode_out <= x"4";
                elsif row = "1101" then
                    decode_out <= x"7";
                elsif row = "1110" then
                    decode_out <= x"0";
                end if;
            elsif col = "1011" then
                if row = "0111" then
                    decode_out <= x"2";
                elsif row = "1011" then
                    decode_out <= x"5";
                elsif row = "1101" then
                    decode_out <= x"8";
                elsif row = "1110" then
                    decode_out <= x"F";
                end if;
            elsif col = "1101" then
                if row = "0111" then
                    decode_out <= x"3";
                elsif row = "1011" then
                    decode_out <= x"6";
                elsif row = "1101" then
                    decode_out <= x"9";
                elsif row = "1110" then
                    decode_out <= x"E";
                end if;
            elsif col = "1110" then
                if row = "0111" then
                    decode_out <= x"A";
                elsif row = "1011" then
                    decode_out <= x"B";
                elsif row = "1101" then
                    decode_out <= x"C";
                elsif row = "1110" then
                    decode_out <= x"D";
                end if;
            end if;
        end if;
    end process decode;
end Behavioral;
