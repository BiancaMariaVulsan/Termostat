library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity TempRegister is
Port(
    TempIn: std_logic_vector(11 downto 0);
    Inc, Dec, Confirm, CLK: in std_logic;
    TempOut: out std_logic_vector(11 downto 0)
);
end TempRegister;

architecture TempRegister_Arch of TempRegister is

begin
    storeTemp: process(clk)
    variable InternalTemp: std_logic_vector(11 downto 0):=(others => '0');
    begin 
        if CLK = '1' and clk'event then 
            if Confirm  = '1' then 
                InternalTemp := TempIn;
            elsif Inc = '1' then 
                InternalTemp := InternalTemp + X"A";
            elsif Dec = '1' then 
                InternalTemp := InternalTemp - X"A";
            end if;
        end if;
        TempOut <= InternalTemp;
    end process;

end TempRegister_Arch;
