library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;  		  

entity comparator_dir is
	port( ETAJ1, ETAJ2 : in std_logic_vector(3 downto 0);
	COMP, EGAL: out std_logic);
end entity;

architecture arch_COMP of comparator_dir is
begin
	process(ETAJ1, ETAJ2)		-- directia 1 reprezinta mersul in sus iar 0 cel in jos	
	begin
		if ETAJ1 < ETAJ2 then
			COMP <= '1';
			EGAL <= '0';
		elsif ETAJ1 > ETAJ2 then
			COMP <= '0';
			EGAL <= '0';
		else
			EGAL <= '1';	
			COMP <= '0';
		end if;	  
	end process;
end architecture;
