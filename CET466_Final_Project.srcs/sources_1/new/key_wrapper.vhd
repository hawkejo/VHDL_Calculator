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

entity key_wrapper is
    port ( 
        pmod : inout STD_LOGIC_VECTOR (7 downto 0);
        digOut : out STD_LOGIC_VECTOR (3 downto 0);
        a : out STD_LOGIC;
        b : out STD_LOGIC;
        c : out STD_LOGIC;
        d : out STD_LOGIC;
        e : out STD_LOGIC;
        f : out STD_LOGIC;
        btnSig: out std_logic;
        clk100MHz : in STD_LOGIC
    );
end key_wrapper;

architecture Behavioral of key_wrapper is
signal key: std_logic_vector(3 downto 0);
signal press: std_logic;
signal digit: std_logic_vector(3 downto 0);
signal key_a,key_b,key_c,key_d,key_e,key_f: std_logic;
begin
    btnSig <= press;
    digOut <= digit;
    a <= key_a;
    b <= key_b;
    c <= key_c;
    d <= key_d;
    e <= key_e;
    f <= key_f;
    
    process (press) is
    begin
        if rising_edge(press) then
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
        else
            key_a <= key_a;
            key_b <= key_b;
            key_c <= key_c;
            key_d <= key_d;
            key_e <= key_e;
            key_f <= key_f;
            digit <= digit;
        end if;
    end process;

    key0: entity work.pmod_kypd port map(
        clk100MHz => clk100MHz,
        pmod => pmod,
        digit => key,
        pressOut => press
    );
end Behavioral;
