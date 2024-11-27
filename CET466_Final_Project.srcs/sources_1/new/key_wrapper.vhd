----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/25/2024 11:42:40 AM
-- Design Name: 
-- Module Name: key_wrapper - Behavioral
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

entity key_wrapper is
    port ( 
        pmod : inout STD_LOGIC_VECTOR (7 downto 0);
        digit : out STD_LOGIC_VECTOR (3 downto 0);
        key_a : out STD_LOGIC;
        key_b : out STD_LOGIC;
        key_c : out STD_LOGIC;
        key_d : out STD_LOGIC;
        key_e : out STD_LOGIC;
        key_f : out STD_LOGIC;
        press:  out std_logic;
        clk100MHz : in STD_LOGIC
    );
end key_wrapper;

architecture Behavioral of key_wrapper is
signal key: std_logic_vector(3 downto 0);

begin
    
    process (key) is
    begin
        if press = '1' then
            if key = x"A" then
                key_a <= '1';
                key_b <= '0';
                key_c <= '0';
                key_d <= '0';
                key_e <= '0';
                key_f <= '0';
                digit <= x"0";
            elsif key = x"B" then
                key_a <= '0';
                key_b <= '1';
                key_c <= '0';
                key_d <= '0';
                key_e <= '0';
                key_f <= '0';
                digit <= x"0";
            elsif key = x"C" then
                key_a <= '0';
                key_b <= '0';
                key_c <= '1';
                key_d <= '0';
                key_e <= '0';
                key_f <= '0';
                digit <= x"0";
            elsif key = x"D" then
                key_a <= '0';
                key_b <= '0';
                key_c <= '0';
                key_d <= '1';
                key_e <= '0';
                key_f <= '0';
                digit <= x"0";
            elsif key = x"E" then
                key_a <= '0';
                key_b <= '0';
                key_c <= '0';
                key_d <= '0';
                key_e <= '1';
                key_f <= '0';
                digit <= x"0";
            elsif key = x"F" then
                key_a <= '0';
                key_b <= '0';
                key_c <= '0';
                key_d <= '0';
                key_e <= '0';
                key_f <= '1';
                digit <= x"0";
            else
                key_a <= '0';
                key_b <= '0';
                key_c <= '0';
                key_d <= '0';
                key_e <= '0';
                key_f <= '0';
                digit <= key;
            end if;
        end if;
    end process;

    key0: entity work.pmod_kypd port map(
        clk100MHz => clk100MHz,
        pmod => pmod,
        digit => key,
        press => press
    );
end Behavioral;
