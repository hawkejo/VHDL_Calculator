----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/25/2024 02:22:00 PM
-- Design Name: 
-- Module Name: read_bcd - Behavioral
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

entity read_bcd is
    Port ( num : out STD_LOGIC_VECTOR (26 downto 0);
           digit : in STD_LOGIC_VECTOR (3 downto 0);
           write : in STD_LOGIC;
           clk100MHz : in STD_LOGIC);
end read_bcd;

architecture Behavioral of read_bcd is

begin


end Behavioral;
