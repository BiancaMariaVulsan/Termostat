library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Termostat is
port(
    Temp: in std_logic_vector(11 downto 0);
    Start, Confirm, Inc, Dec, CLK: in std_logic;
    An: out std_logic_vector(3 downto 0);
    Cat: out std_logic_vector(6 downto 0);
    Leds: out std_logic_vector(4 downto 0)
);
end Termostat;

architecture Termostat_Arch of Termostat is
component UC is
port(
    temp: in std_logic_vector(11 downto 0);
    start, confirm, inc, dec, interval, clk: in std_logic;
    tCrt: out std_logic_vector(11 downto 0);
    startTime: out std_logic;
    Leds: out std_logic_vector(4 downto 0)
);
end component;

component UE is
Port(
    startBtn, clk: in std_logic; 
    tCrt: in std_logic_vector(11 downto 0);
    intervalUp: out std_logic;
    cat: out std_logic_vector(6 downto 0);
    an: out std_logic_vector(3 downto 0)
);
end component;

signal startTime, interval: std_logic:= '0';
signal crtTemp: std_logic_vector(11 downto 0);

begin

UcComponent: UC
port map(
    temp => Temp, 
    start => Start, 
    confirm => Confirm, 
    inc => inc, 
    dec => dec, 
    interval => interval, 
    clk => clk, 
    tCrt => crtTemp, 
    startTime => startTime,
    Leds => Leds
);

UeComponent: UE
port map(
    startBtn => startTime,
    clk => clk, 
    tCrt => crtTemp, 
    intervalUp => interval, 
    cat => Cat, 
    an => An
);

end Termostat_Arch;
