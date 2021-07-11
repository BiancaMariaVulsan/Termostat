library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity BinaryToBCD is
port(binary: in std_logic_vector(15 downto 0);
	 bcd: out std_logic_vector(15 downto 0));
end BinaryToBCD;

architecture BinaryToBCD_Arch of BinaryToBCD is

begin
    process(binary)
	variable nr : integer;
	variable c : integer;
	begin
		nr := conv_integer(binary);
		c := nr mod 10;
		bcd(3 downto 0) <= conv_std_logic_vector(c, 4);
		c := nr / 10 mod 10;
		bcd(7 downto 4) <= conv_std_logic_vector(c, 4);
		c := nr / 100 mod 10;
		bcd(11 downto 8) <= conv_std_logic_vector(c, 4);
		c := nr / 1000;
		bcd(15 downto 12) <= conv_std_logic_vector(c, 4);
	end process;

end BinaryToBCD_Arch;
