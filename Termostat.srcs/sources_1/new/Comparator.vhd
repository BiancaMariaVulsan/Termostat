library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Comparator is
port(
    Tmin, Tmax, Tcrt: in std_logic_vector(11 downto 0);
    clk: in std_logic;
    IncreaseTemp, DecreaseTemp: out std_logic
);
end Comparator;

architecture Comparator_Arch of Comparator is
signal enable: std_logic:='0';
signal clocks: std_logic_vector(31 downto 0):=(others => '0');
begin
    changeTemp: process(enable)
    begin  
        if enable = '1' then    
            if Tcrt < Tmin then 
                IncreaseTemp <= '1';
                DecreaseTemp <= '0';
            elsif Tcrt > Tmax then 
                IncreaseTemp <= '0';
                DecreaseTemp <= '1';
            else 
                IncreaseTemp <= '0';
                DecreaseTemp <= '0';
            end if;
        else 
            IncreaseTemp <= '0';
            DecreaseTemp <= '0';
        end if;
    end process;
    
    countClocks: process(clk)
    begin 
        if clk = '1' and clk'event then 
            if clocks = X"11E1A300" then 
                enable <= '1';
                clocks <= (others => '0');
            else 
                enable <= '0';
                clocks <= clocks + 1;
            end if;
        end if;
    end process;
end Comparator_Arch;
