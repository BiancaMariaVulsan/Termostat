library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity UE is
Port(
    StartBtn, CLK: in std_logic; 
    Tcrt: in std_logic_vector(11 downto 0);
    IntervalUp: out std_logic;
    Cat: out std_logic_vector(6 downto 0);
    An: out std_logic_vector(3 downto 0)
);
end UE;

architecture UE_Arch of UE is
component TimeUnit is
Port(
    Start, CLK: in std_logic;
    Time: out std_logic_vector(15 downto 0);
    IntervalUp: out std_logic
);
end component;

component BinaryToBCD is
port(binary: in std_logic_vector(15 downto 0);
	 bcd: out std_logic_vector(15 downto 0));
end component;

component SSD is
port(
	digits:in std_logic_vector(15 downto 0);
	clk: in std_logic;
	cat: out std_logic_vector(6 downto 0);
	an: out std_logic_vector (3 downto 0));
end component;

signal TimeSignal: std_logic_vector(15 downto 0) := (others => '0');
signal Interval: std_logic := '0';
signal SsdSource: std_logic_vector(15 downto 0):= (others => '0');
signal SsdSourceBCD: std_logic_vector(15 downto 0):= (others => '0');

begin

TimeUnitComp: TimeUnit 
port map(
    Start => StartBtn, 
    CLK => CLK, 
    Time => TimeSignal, 
    IntervalUp => Interval
);

IntervalUp <= Interval;

BinaryToBCDComp: BinaryToBCD
port map(
    binary => SsdSource,
    bcd => SsdSourceBCD
);

selectSsdSource: process(TimeSignal, Interval, Tcrt)
begin 
    if Interval = '1' then 
        SsdSource <= X"0" & Tcrt;
    else 
        SsdSource <= TimeSignal;
    end if;
end process;

SsdComponent: SSD
port map(
    digits => SsdSourceBCD, 
    clk => clk, 
    cat => cat, 
    an => an
);

end UE_Arch;
