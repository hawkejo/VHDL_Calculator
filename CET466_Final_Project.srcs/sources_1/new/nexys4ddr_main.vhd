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

entity nexys4ddr_main is
    generic(
        WORD_SIZE:  natural := 27;          -- MSB numeric values
        MAX_NUM:    natural := 99999999     -- Maximum possible value
    );
    port(
        an:         out     std_logic_vector(7 downto 0);
        seg:        out     std_logic_vector(6 downto 0);
        LED:        out     std_logic_vector(5 downto 0);
        dp:         out     std_logic;
        
        JA:         inout   std_logic_vector(7 downto 0);
        clk100MHz:  in      std_logic
    );
end nexys4ddr_main;

architecture Behavioral of nexys4ddr_main is
signal key:     std_logic_vector(3 downto 0);
signal data:    std_logic_vector(39 downto 0);
begin    
    data <= x"00000000" & "000" & '0' & key;
    
    disp0: entity work.seven_seg_controller port map(
        seg => seg,
        an => an,
        dp => dp,
        d => data,
        active => "00000001",
        clk100MHz => clk100MHz
    );
    
    key0: entity work.key_wrapper port map(
        pmod => JA,
        digit => key,
        key_a => LED(0),
        key_b => LED(1),
        key_c => LED(2),
        key_d => LED(3),
        key_e => LED(4),
        key_f => LED(5),
        clk100MHz => clk100MHz
    );
end Behavioral;
