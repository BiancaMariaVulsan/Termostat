library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity BcdToBinary is
port(
    bcd: in std_logic_vector(11 downto 0);
    binary: out std_logic_vector(11 downto 0)
);
end BcdToBinary;

architecture BcdToBinary_Arch of BcdToBinary is
signal binaryIn: std_logic_vector(10 downto 0) := (others => '0');
begin
    binaryIn <= bcd(3 downto 0) * "01" +
              bcd(7 downto 4) * "1010" +
              bcd(11 downto 8) * "1100100";
              
    binary <= '0' & binaryIn;

end BcdToBinary_Arch;
