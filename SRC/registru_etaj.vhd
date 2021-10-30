library ieee;
use ieee.std_logic_1164.all;	  
use ieee.numeric_std.ALL;	  	

entity REG_ETAJ is
	port(
	D_REG: in std_logic_vector(3 downto 0);
	CLK: in std_logic;
	EN_REG: in std_logic;
	Q_REG: out std_logic_vector(3 downto 0)
	);
end REG_ETAJ;

architecture ARCH_REG_ETAJ of REG_ETAJ is
begin
	process(CLK)
	begin 
		if EN_REG = '1' then
			if rising_edge(clk) then
				Q_REG <= D_REG;
			end if;		 
		end if;
	end process;
end architecture;
	

