----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/25/2024 09:32:32 AM
-- Design Name: 
-- Module Name: nexys4ddr_main - Behavioral
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
use ieee.numeric_std.all;

entity nexys4ddr_main is
    generic(
        WORD_SIZE:  natural := 27;          -- MSB numeric values
        MAX_NUM:    natural := 99999999     -- Maximum possible value
    );
    port(
        an:         out     std_logic_vector(7 downto 0);
        seg:        out     std_logic_vector(6 downto 0);
        LED:        out     std_logic_vector(6 downto 0);
        dp:         out     std_logic;
        
        lhs:        in      unsigned(7 downto 0);
        rhs:        in      unsigned(7 downto 0);
        add:        in      std_logic;
        sub:        in      std_logic;
        mult:       in      std_logic;
        div:        in      std_logic;
        clk100MHz:  in      std_logic
    );
end nexys4ddr_main;

architecture Behavioral of nexys4ddr_main is
signal binary_number: std_logic_vector(24 downto 0);
begin    
    disp0: entity work.bcd_controller port map(
        clk => clk100MHz,
        number => number,
        seg => seg,
        an => an,
        dp => dp
    );
end Behavioral;
