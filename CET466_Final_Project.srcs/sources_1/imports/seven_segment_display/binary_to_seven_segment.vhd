---------------------------------------------------------------------------------
-- Engineer:            Joseph Hawker
-- 
-- Design Name:         Part A
-- Project Name:        Lab 02
-- Module Name:         binary_to_seven_segment
-- Target Device(s):    Nexys 4 DDR, Alterra Cyclone 4 Development Board
-- Tool Versions:       Vivado 2024.1.2, Quartus Prime 21.1
-- Date Created:        23 September 2024
--
-- Description: Generic binary decoder for a seven segment display. The decoder
--      takes a hexadecimal number as input and translates it to the display.
--
--      It is assumed that the seven segment displays being used are all low
--      asserted.
---------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity binary_to_seven_segment is
    port (
        number_nibble:  in std_logic_vector(3 downto 0); -- 4-bit binary number to decode
        seg:            out std_logic_vector(6 downto 0) -- g f e d c b a
    );
end binary_to_seven_segment;

architecture main of binary_to_seven_segment is
begin
    seg <=  "1000000" when (number_nibble = x"0") else
            "1111001" when (number_nibble = x"1") else
            "0100100" when (number_nibble = x"2") else
            "0110000" when (number_nibble = x"3") else
            "0011001" when (number_nibble = x"4") else
            "0010010" when (number_nibble = x"5") else
            "0000010" when (number_nibble = x"6") else
            "1111000" when (number_nibble = x"7") else
            "0000000" when (number_nibble = x"8") else
            "0011000" when (number_nibble = x"9") else
            "0001000" when (number_nibble = x"a") else
            "0000011" when (number_nibble = x"b") else
            "0100111" when (number_nibble = x"c") else
            "0100001" when (number_nibble = x"d") else
            "0000110" when (number_nibble = x"e") else
            "0001110" when (number_nibble = x"f") else
            "1111111";
end main;
