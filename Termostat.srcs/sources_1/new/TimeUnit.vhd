library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity TimeUnit is
Port(
    Start, CLK: in std_logic;
    Time: out std_logic_vector(15 downto 0);
    IntervalUp: out std_logic
);
end TimeUnit;

architecture TimeUnit_Arch of TimeUnit is
signal clocks: std_logic_vector(27 downto 0):=(others => '0');
signal dividedClock: std_logic := '0';

signal crtSeconds: std_logic_vector(5 downto 0):= "011110"; --30
signal crtMinutes: std_logic_vector(5 downto 0):= "100010"; -- 34
signal crtHours: std_logic_vector(4 downto 0):= "10001"; -- 17

signal IntervalSeconds: std_logic_vector(1 downto 0):= (others => '0');
signal Interval: std_logic := '0';
signal started: std_logic:= '0';
begin
    startTime: process(CLK, Start)
    begin 
        if clk = '1' and clk'event then 
            if start = '1' then 
                started <= '1';
            end if;
        end if;
    end process;
    countClock: process(CLK)
    begin 
        if clk = '1' and clk'event then 
            if started = '1' then 
                clocks <= clocks+1;
                
                if clocks = X"5F5E100" then 
                    clocks <= (others => '0');
                    dividedClock <= '1';
                else 
                    dividedClock <= '0';
                end if;
            end if;
        end if;
        
        
    end process;
    
    measureTime: process(CLK, dividedClock, crtHours, crtMinutes, crtSeconds)
    begin 
        if clk = '1' and clk'event then 
            if dividedClock = '1' then 
                crtSeconds <= crtSeconds + 1;
                
                if crtSeconds = X"3B" then 
                    crtSeconds <= (others => '0');
                    crtMinutes <= crtMinutes + 1;
                end if;
                
                if crtMinutes = X"3B" then 
                    crtMinutes <= (others => '0');
                    
                    crtHours <= crtHours + 1;
                end if;
                
                if crtHours = X"17" then 
                    crtHours <= (others => '0');
                end if;
            end if;
        end if;
    end process;
    
    countInterval: process(clk, dividedClock, IntervalSeconds)
    begin 
        if clk = '1' and clk'event then 
            if dividedClock = '1' then 
                if IntervalSeconds = "10" then 
                    IntervalUp <= '1';
                    IntervalSeconds <= (others => '0');
                else
                    IntervalUp <= '0'; 
                    IntervalSeconds <= IntervalSeconds + 1;
                end if;
            end if;
        end if;
    end process;
    
    convertTime: process(clk, crtHours, crtMinutes)
    variable intHours, intMinutes, intTime: integer := 0;
    begin 
        if clk = '1' and clk'event then 
            intHours := conv_integer(crtHours);
            intMinutes := conv_integer(crtMinutes);
            intTime := 100 * intHours + intMinutes;
            
            Time <= conv_std_logic_vector(intTime, 16);
        end if;
    end process;

end TimeUnit_Arch;
