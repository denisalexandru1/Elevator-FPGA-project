library ieee;
use ieee.std_logic_1164.all;	  
use ieee.numeric_std.ALL;

entity CHECK_VALID is
	port(
	CHK_VALID_IEUD: in std_logic_vector(3 downto 0);
	CHK_VALID_SENS: in std_logic; 				 
	CHK_VALID_OUT: out std_logic
	);
end CHECK_VALID;

architecture ARCH_CHECK_VALID of CHECK_VALID is	   
begin
process (CHK_VALID_IEUD, CHK_VALID_SENS)   
variable VAR_OUT : std_logic;
begin		 
	
	if CHK_VALID_IEUD(3) = '1' then
		VAR_OUT := '1';
	elsif CHK_VALID_IEUD(2) = '1' then
		if CHK_VALID_SENS = '1' and CHK_VALID_IEUD(1) = '1' then
			VAR_OUT := '1';
		elsif CHK_VALID_SENS = '0' and CHK_VALID_IEUD(0) = '1' then
			VAR_OUT := '1';
		else
			VAR_OUT := '0';
		end if;
	else
		VAR_OUT := '0';
	end if;	   
	CHK_VALID_OUT <= VAR_OUT;
end process;
end architecture;