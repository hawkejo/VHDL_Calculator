---------------------------------------------------------------------------------
-- Engineer:            Joseph Hawker
-- 
-- Design Name:         Part A
-- Project Name:        Lab 02
-- Module Name:         bcd_controller
-- Target Device(s):    Nexys 4 DDR, Alterra Cyclone 4 Development Board
-- Tool Versions:       Vivado 2024.1.2, Quartus Prime 21.1
-- Date Created:        23 September 2024
--
-- Description: Wrapper module for interfacing with specific FPGA logic boards.
--      This module is written to target multiple boards with a minimum of 4
--      seven segment displays and convert binary numbers to BCD numbers
--
--      This module assumes low asserted outputs and a maximum of 8 displays.
---------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity bcd_controller is
    generic(
        WORD_SIZE:      positive    := 24; -- 8 displays total
        BCD_WIDTH:      positive    := 32  -- 8 displays with 4-bits per display
    );
    port(
        clk:            in std_logic;
        number:         in std_logic_vector (WORD_SIZE-1 downto 0);
        seg:            out std_logic_vector (6 downto 0);
        an:             out std_logic_vector (7 downto 0);
        dp:             out std_logic
    );
end bcd_controller;

architecture main of bcd_controller is
signal active:         std_logic_vector(7 downto 0);
signal data:           std_logic_vector(39 downto 0);
signal bcd:            std_logic_vector(BCD_WIDTH-1 downto 0);
signal digit0, digit1, digit2, digit3: std_logic_vector(3 downto 0);
signal digit4, digit5, digit6, digit7: std_logic_vector(3 downto 0);

begin
    digit0 <= bcd(BCD_WIDTH-1 downto BCD_WIDTH-4);
    digit1 <= bcd(BCD_WIDTH-5 downto BCD_WIDTH-8);
    digit2 <= bcd(BCD_WIDTH-9 downto BCD_WIDTH-12);
    digit3 <= bcd(BCD_WIDTH-13 downto BCD_WIDTH-16);
    digit4 <= bcd(BCD_WIDTH-17 downto BCD_WIDTH-20);
    digit5 <= bcd(BCD_WIDTH-21 downto BCD_WIDTH-24);
    digit6 <= bcd(BCD_WIDTH-25 downto BCD_WIDTH-28);
    digit7 <= bcd(BCD_WIDTH-29 downto BCD_WIDTH-32);
    
    --active <= x"FF";
    
    test_active: process(number) is
    begin
        if (unsigned(number) > 9999999) then
            active <= x"FF";
        elsif (unsigned(number) > 999999) then
            active <= x"7F";
        elsif (unsigned(number) > 99999) then
            active <= x"3F";
        elsif (unsigned(number) > 9999) then
            active <= x"1F";
        elsif (unsigned(number) > 999) then
            active <= x"0F";
        elsif (unsigned(number) > 99) then
            active <= x"07";
        elsif (unsigned(number) > 9) then
            active <= x"03";
        else -- Default to have low display on
            active <= x"01";
        end if;
    end process test_active;
    

    
    data <= ('0' & digit0 &
             '0' & digit1 &
             '0' & digit2 &
             '0' & digit3 &
             '0' & digit4 &
             '0' & digit5 &
             '0' & digit6 &
             '0' & digit7
        );
    dec0: entity work.bcd_decoder(main) port map (
        clk => clk,
        number => number,
        bcd_out => bcd
    );
    disp0: entity work.seven_seg_controller(main) port map (
        seg => seg,
        an => an,
        active => active,
        dp => dp,
        d => data,
        clk100MHz => clk
    );
end main;