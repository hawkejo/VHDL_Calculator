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

entity seven_seg_controller is
    port (
        seg:        out std_logic_vector(6 downto 0);
        an:         out std_logic_vector(7 downto 0);
        dp:         out std_logic;
        d:          in std_logic_vector(39 downto 0); -- 8 distinct chunks of data with a dp
        active:     in std_logic_vector(7 downto 0); -- Specify which displays are active.
        clk100MHz:  in std_logic                     -- Each bit is high asserted.
    );   
    end seven_seg_controller;  
    
architecture main of seven_seg_controller is
    signal clk_reduced:     std_logic;
    signal decode_data:     std_logic_vector(3 downto 0);
    signal roll:            std_logic_vector(7 downto 0) := x"01";
    begin
        an <= not (roll and active);
        
        div0: entity work.clock_divider(main) port map(
            clk_out => clk_reduced,
            clk100MHz => clk100MHz
        );
        
        dec0: entity work.binary_to_seven_segment(main) port map(
            number_nibble => decode_data,
            seg => seg
        );
        
        decode_data <=  d(38 downto 35) when (roll = b"10000000") else
                        d(33 downto 30) when (roll = b"01000000") else
                        d(28 downto 25) when (roll = b"00100000") else
                        d(23 downto 20) when (roll = b"00010000") else
                        d(18 downto 15) when (roll = b"00001000") else
                        d(13 downto 10) when (roll = b"00000100") else
                        d( 8 downto  5) when (roll = b"00000010") else
                        d( 3 downto  0) when (roll = b"00000001") else
                        d( 3 downto  0);
        
        dp <=           d(39) when (roll = b"10000000") else
                        d(34) when (roll = b"01000000") else
                        d(29) when (roll = b"00100000") else
                        d(24) when (roll = b"00010000") else
                        d(19) when (roll = b"00001000") else
                        d(14) when (roll = b"00000100") else
                        d(9)  when (roll = b"00000010") else
                        d(4)  when (roll = b"00000001") else
                        d(4);
        
        process (clk_reduced) is
        begin
            if rising_edge(clk_reduced) then
                roll <= roll(6 downto 0) & roll(7);
            end if;
        end process;
    end main;
