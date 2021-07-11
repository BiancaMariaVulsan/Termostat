library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity StateModule is
port(
    Start, Confirm, CLK: in std_logic;
    CrtState: out std_logic_vector(2 downto 0)
);
end StateModule;

architecture StateModule_Arch of StateModule is
signal state: std_logic_vector(2 downto 0):=(others => '0');
begin
    startTermostat: process(CLK, Start, state)
    begin 
        if CLK = '1' and clk'event then 
            if Start = '1'then 
                state <= "001";
            elsif Confirm = '1' and state > "000" then 
                if state < "100" then 
                    state <= state + 1;
                end if;
            end if;
        end if;
    end process;
    
    CrtState <= state;

end StateModule_Arch;
