library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity SSD is
port(
	digits:in std_logic_vector(15 downto 0);
	clk: in std_logic;
	cat: out std_logic_vector(6 downto 0);
	an: out std_logic_vector (3 downto 0));
end SSD;

architecture SSD_Arch of SSD is
signal sel: std_logic_vector(15 downto 0):= X"0000";
signal digitSel: std_logic_vector(3 downto 0) := "0000";
begin
    count:process(clk)
	begin 
		if clk = '1' and clk'event then
            sel <= sel + '1';
		end if;
	end process; 
	
    selectAnode:process(sel)
	begin
		case sel(15 downto 14) is 
			when "00" => an <= "0111";
			when "01" => an <= "1011";
			when "10" => an <= "1101";
			when others => an <= "1110";
		end case;
	end process;  
	
	digitSelection:process(sel, digits)		   
	begin
		case sel(15 downto 14) is 
			when "00" => digitSel <= digits(15 downto 12);
			when "01" => digitSel <= digits(11 downto 8);
			when "10" => digitSel <= digits(7 downto 4);
			when others => digitSel <= digits(3 downto 0); 
		end case;
	end process;  
	
	selectCatode: process(digitSel)
	begin
        case digitSel is
            when "0001" => cat<= "1111001";   --1
            when "0010" => cat<= "0100100";   --2
            when "0011" => cat<= "0110000";   --3
            when "0100" => cat<= "0011001";   --4
            when "0101" => cat<= "0010010";   --5
            when "0110" => cat<= "0000010";   --6
            when "0111" => cat<= "1111000";   --7
            when "1000" => cat<= "0000000";   --8
            when "1001" => cat<= "0010000";   --9
--            when "1010" => cat<= "0001000";   --A
--            when "1011" => cat<= "0000011";   --b
--            when "1100" => cat<= "1000110";   --C
--            when "1101" => cat<= "0100001";   --d
--            when "1110" => cat<= "0000110";   --E
--            when "1111" => cat<= "0001110";   --F
            when others => cat<= "1000000";   --0
          end case;
	end process;

end SSD_Arch;
