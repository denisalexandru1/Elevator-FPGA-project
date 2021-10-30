library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;  	 

entity BISTABIL_STARE is
	port(
	SET_VALUE, RST_VALUE: in std_logic;
	CLK: in std_logic;
	REG_VALUE: inout std_logic
	);
end entity;

architecture arch_bistabil_stare of bistabil_stare is
begin
	process(CLK)
	begin
		if rising_edge(CLK) then
			if set_value = '1' and rst_value = '0' then	  
				reg_value <= '1';
			elsif set_value = '0' and rst_value = '1' then
				reg_value <= '0';
			else
				reg_value <= reg_value;
			end if;
		end if;
	end process;
end architecture;
