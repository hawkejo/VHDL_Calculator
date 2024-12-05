library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity debouncer is
    generic (
        ARR_SIZE: positive := 20
    );
    port (
        clk100MHz: in std_logic;
        bouncy: in std_logic;
        debounced: out std_logic
    );
end debouncer;

architecture main of debouncer is
signal shift: std_logic_vector(ARR_SIZE-1 downto 0);
begin
    debounced <= '1' when not unsigned(shift) = 0 else '0'; -- Unary AND
    
    process(clk100MHz, bouncy) begin
        if rising_edge(clk100MHz) then
            shift <= shift(ARR_SIZE-2 downto 0) & bouncy;
        end if;
    end process;
        
end main;