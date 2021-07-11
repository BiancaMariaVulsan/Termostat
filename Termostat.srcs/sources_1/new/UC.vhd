library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity UC is
port(
    temp: in std_logic_vector(11 downto 0);
    start, confirm, inc, dec, interval, clk: in std_logic;
    Tcrt: out std_logic_vector(11 downto 0);
    StartTime: out std_logic; 
    Leds: out std_logic_vector(4 downto 0)
);
end UC;

architecture UC_Arch of UC is
component TempRegister is
Port(
    TempIn: std_logic_vector(11 downto 0);
    Inc, Dec, Confirm, CLK: in std_logic;
    TempOut: out std_logic_vector(11 downto 0)
);
end component;

component Debouncer is
Port ( clk : in STD_LOGIC;
       btn : in STD_LOGIC;
       debBtn: out STD_LOGIC
);
end component;

component StateModule is
port(
    Start, Confirm, CLK: in std_logic;
    CrtState: out std_logic_vector(2 downto 0)
);
end component;

component BcdToBinary is
port(
    bcd: in std_logic_vector(11 downto 0);
    binary: out std_logic_vector(11 downto 0)
);
end component;

component Comparator is
port(
    Tmin, Tmax, Tcrt: in std_logic_vector(11 downto 0);
    clk: in std_logic;
    IncreaseTemp, DecreaseTemp: out std_logic
);
end component;

signal binaryTemp: std_logic_vector(11 downto 0):= (others => '0');
signal debStart, debConfirm, debInc, debDec: std_logic:= '0';
signal crtState: std_logic_vector(2 downto 0):= "000";
signal TminIn, TmaxIn, TcrtIn, TminOut, TmaxOut, TcrtOut: std_logic_vector(11 downto 0):= (others => '0');
signal incTempComp, decTempComp: std_logic:= '0';
signal incTempReg, decTempReg: std_logic:= '0';

begin

MinTempReg: TempRegister
port map(
    TempIn => TminIn, 
    Inc => '0', 
    Dec => '0', 
    CLK => clk,
    Confirm => confirm, 
    TempOut => TminOut
);

MaxTempReg: TempRegister
port map(
    TempIn => TmaxIn, 
    Inc => '0', 
    Dec => '0',
    CLK => clk, 
    Confirm => confirm, 
    TempOut => TmaxOut
);

CrtTempReg: TempRegister
port map(
    TempIn => TcrtIn, 
    Inc => incTempReg, 
    Dec => decTempReg, 
    CLK => clk,
    Confirm => confirm, 
    TempOut => TcrtOut
);

StateModuleComp: StateModule
port map(
    Start => debStart, 
    Confirm => debConfirm, 
    CLK => clk,
    CrtState => crtState
);

ComparatorComp: Comparator
port map(
    Tmin => TminOut, 
    Tmax => TmaxOut, 
    Tcrt => TcrtOut, 
    clk => clk, 
    IncreaseTemp => incTempComp, 
    DecreaseTemp => decTempComp
);

BcdToBinaryConvertor: BcdToBinary
port map(
    bcd => temp, 
    binary => binaryTemp
);

StartDeb: Debouncer
port map(
    clk => clk, 
    btn => start, 
    debBtn => debStart
);

ConfirmDeb: Debouncer
port map(
    clk => clk, 
    btn => confirm, 
    debBtn => debConfirm
);

IncDeb: Debouncer
port map(
    clk => clk, 
    btn => inc, 
    debBtn => debInc
);

DecDeb: Debouncer
port map(
    clk => clk, 
    btn => Dec, 
    debBtn => debDec
);

StartTime <= debStart;

selectTempReg: process(crtState, debInc, debDec)
begin 
    if crtState = "000" then 
        Leds <= "00001"; 
    elsif crtState = "001" then 
        tMinIn <= binaryTemp;
        Leds <= "00010"; 
    elsif crtState = "010" then 
        tMaxIn <= binaryTemp;
        Leds <= "00100"; 
    elsif crtState = "011" then 
        tCrtIn <= binaryTemp;
        Leds <= "01000"; 
    elsif crtState = "100" then
        Tcrt <= TcrtOut; 
        incTempReg <= incTempComp or debInc;
        decTempReg <= decTempComp or debDec;
        Leds <= "10000"; 
    end if;
end process;



end UC_Arch;
