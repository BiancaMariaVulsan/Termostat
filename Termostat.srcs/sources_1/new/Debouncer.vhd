library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Debouncer is
Port ( clk : in STD_LOGIC;
       btn : in STD_LOGIC;
       debBtn: out STD_LOGIC);
end Debouncer;

architecture Debouncer_Arch of Debouncer is
signal count: std_logic_vector(15 downto 0):= (others => '0');
signal q1: std_logic:= '0';
signal q2: std_logic:= '0';

begin
    countP: process(CLK)
    begin
        if clk = '1' and clk'event then 
            count <= count + '1';
        end if;
    end process;
    
    countUpT: process(count, clk)
    begin 
        if clk = '1' and clk'event then
            if count = X"FFFF" then 
                q1 <= btn;
            end if;
            q2 <= q1;
        end if;
    end process;
    
    debBtn <= q1 and (not q2);

end Debouncer_Arch;
