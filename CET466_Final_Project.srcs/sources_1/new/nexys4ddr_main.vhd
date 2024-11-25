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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity nexys4ddr_main is
    port(
        an:         out     std_logic_vector(7 downto 0);
        seg:        out     std_logic_vector(6 downto 0);
        dp:         out     std_logic;
        
        JA:         inout   std_logic_vector(7 downto 0);
        clk100MHz:  in      std_logic
    );
end nexys4ddr_main;

architecture Behavioral of nexys4ddr_main is
signal key: std_logic_vector(3 downto 0);
begin
    dp <= '1';
    an <= "11111110";
    
    disp0: entity work.binary_to_seven_segment port map(
        number_nibble => key,
        seg => seg
    );
    
    key0: entity work.pmod_kypd port map(
        clk100MHz => clk100MHz,
        pmod => JA,
        digit => key
    );
end Behavioral;
