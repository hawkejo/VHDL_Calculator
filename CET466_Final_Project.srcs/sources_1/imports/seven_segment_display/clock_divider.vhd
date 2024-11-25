---------------------------------------------------------------------------------
-- Engineer:            Joseph Hawker
-- 
-- Design Name:         Part B
-- Project Name:        Lab 02
-- Module Name:         seven_seg_controller
-- Target Device(s):    Nexys 4 DDR, Alterra Cyclone 4 Development Board
-- Tool Versions:       Vivado 2024.1.2, Quartus Prime 21.1
-- Date Created:        23 September 2024
--
-- Description: This module allows for driving up to 8 seven segment displays.
--      It takes a clock input and in turn shifts the displays to allow for
--      displaying on one display at a time.
---------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity clock_divider is
    generic(
        MSB : natural    := 16  
    );
    port (
        clk_out:    out std_logic;
        clk100MHz:  in std_logic
    );   
    end clock_divider;  
architecture main of clock_divider is
    signal shift:   std_logic_vector(MSB downto 0);
    begin
    
        clk_out <= shift(MSB); -- Should be around 191 Hz
        process (clk100MHz) is -- Reduce the clock down to something more usable
        begin
            if rising_edge(clk100MHz) then
                shift <= std_logic_vector(unsigned(shift) + 1);
            end if;
        end process;
    end main;