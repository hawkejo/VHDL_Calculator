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

entity seven_seg_controller is
    generic(
        MSB : natural    := 15  
    );
    port (
        seg:        out std_logic_vector(6 downto 0);
        an:         out std_logic_vector(7 downto 0);
        dp:         out std_logic;
        d:          in std_logic_vector(39 downto 0); -- 8 distinct chunks of data with a dp
        active:     in std_logic_vector(7 downto 0);  -- Specify which displays are active.
        clk100MHz:  in std_logic                      -- Each bit is high asserted.
    );   
    end seven_seg_controller;  
    
architecture main of seven_seg_controller is
    -- Breakouts for individual display signals
    signal seg0:            std_logic_vector(6 downto 0);
    signal seg1:            std_logic_vector(6 downto 0);
    signal seg2:            std_logic_vector(6 downto 0);
    signal seg3:            std_logic_vector(6 downto 0);
    signal seg4:            std_logic_vector(6 downto 0);
    signal seg5:            std_logic_vector(6 downto 0);
    signal seg6:            std_logic_vector(6 downto 0);
    signal seg7:            std_logic_vector(6 downto 0);
    signal dp0:             std_logic;
    signal dp1:             std_logic;
    signal dp2:             std_logic;
    signal dp3:             std_logic;
    signal dp4:             std_logic;
    signal dp5:             std_logic;
    signal dp6:             std_logic;
    signal dp7:             std_logic;
    -- State machine signals
    type disp_states is (disp0, disp1, disp2, disp3, disp4, disp5, disp6, disp7);
    signal pstate, nstate: disp_states := disp0;
    
    -- Used for clock reducer
    signal clk_reduced:     std_logic;
    signal shift:           std_logic_vector(MSB downto 0);
begin
    -- Reduce the clock signal
    clk_reduced <= shift(MSB);
    div0: process (clk100MHz) is -- Reduce the clock down to something more usable
    begin
        if rising_edge(clk100MHz) then
            shift <= std_logic_vector(unsigned(shift) + 1);
        end if;
    end process div0;
    
    dec0: entity work.binary_to_seven_segment(main) port map(
        number_nibble => d(3 downto 0),
        seg => seg0
    );
    dec1: entity work.binary_to_seven_segment(main) port map(
        number_nibble => d(8 downto 5),
        seg => seg1
    );
    dec2: entity work.binary_to_seven_segment(main) port map(
        number_nibble => d(13 downto 10),
        seg => seg2
    );
    dec3: entity work.binary_to_seven_segment(main) port map(
        number_nibble => d(18 downto 15),
        seg => seg3
    );
    dec4: entity work.binary_to_seven_segment(main) port map(
        number_nibble => d(23 downto 20),
        seg => seg4
    );
    dec5: entity work.binary_to_seven_segment(main) port map(
        number_nibble => d(28 downto 25),
        seg => seg5
    );
    dec6: entity work.binary_to_seven_segment(main) port map(
        number_nibble => d(33 downto 30),
        seg => seg6
    );
    dec7: entity work.binary_to_seven_segment(main) port map(
        number_nibble => d(38 downto 35),
        seg => seg7
    );
    dp0 <= not d(4);
    dp1 <= not d(9);
    dp2 <= not d(14);
    dp3 <= not d(19);
    dp4 <= not d(24);
    dp5 <= not d(29);
    dp6 <= not d(34);
    dp7 <= not d(39);
    
    -- State machine to control which display is used
    state_regs: process(clk_reduced) is
    begin
        if rising_edge(clk_reduced) then
            pstate <= nstate;
        end if;
    end process state_regs;
    
    next_state_logic: process(pstate) is
    begin
        case pstate is
            when disp0 => nstate <= disp1;
            when disp1 => nstate <= disp2;
            when disp2 => nstate <= disp3;
            when disp3 => nstate <= disp4;
            when disp4 => nstate <= disp5;
            when disp5 => nstate <= disp6;
            when disp6 => nstate <= disp7;
            when disp7 => nstate <= disp0;
            
            when others => nstate <= disp0;
        end case;
    end process next_state_logic;
    
    output_logic: process(pstate, seg0, seg1, seg2, seg3, seg4, seg5, seg6, seg7,
                            dp0, dp1, dp2, dp3, dp4, dp5, dp6, dp7, active) is
    begin
        case pstate is
            when disp0 =>
                if active(0) = '1' then
                    an <= "11111110";
                else
                    an <= "11111111";
                end if;
                seg <= seg0;
                dp <= dp0;
            when disp1 =>
                if active(1) = '1' then
                    an <= "11111101";
                else
                    an <= "11111111";
                end if;
                seg <= seg1;
                dp <= dp1;
            when disp2 =>
                if active(2) = '1' then
                    an <= "11111011";
                else
                    an <= "11111111";
                end if;
                seg <= seg2;
                dp <= dp2;
            when disp3 =>
                if active(3) = '1' then
                    an <= "11110111";
                else
                    an <= "11111111";
                end if;
                seg <= seg3;
                dp <= dp3;
            when disp4 =>
                if active(4) = '1' then
                    an <= "11101111";
                else
                    an <= "11111111";
                end if;
                seg <= seg4;
                dp <= dp4;
            when disp5 =>
                if active(5) = '1' then
                    an <= "11011111";
                else
                    an <= "11111111";
                end if;
                seg <= seg5;
                dp <= dp5;
            when disp6 =>
                if active(6) = '1' then
                    an <= "10111111";
                else
                    an <= "11111111";
                end if;
                seg <= seg6;
                dp <= dp6;
            when disp7 =>
                if active(7) = '1' then
                    an <= "01111111";
                else
                    an <= "11111111";
                end if;
                seg <= seg7;
                dp <= dp7;
                
            when others =>
                if active(0) = '1' then
                    an <= "11111110";
                else
                    an <= "11111111";
                end if;
                seg <= seg0;
                dp <= dp0;
        end case;
    end process output_logic;
end main;
