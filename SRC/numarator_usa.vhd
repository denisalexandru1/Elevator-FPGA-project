library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;  		
use ieee.std_logic_unsigned.all;	 

entity numarator_usa is
	port(
	clk_num_usa, rst_num_usa, en_num_usa : in std_logic;
	tc_num_usa : out std_logic	 
	);
end entity;

architecture arch_numarator_usa of numarator_usa is
begin
	process(clk_num_usa, rst_num_usa)
	variable num : std_logic_vector(3 downto 0) := "0000"; 
	variable tc: std_logic := '0';
	begin	
		tc := '0';
		if rst_num_usa = '1' then
			num := "0000"; 
		elsif rising_edge(clk_num_usa) then 
			if en_num_usa = '0' then  --!!!! ACTIV PE 0
				if num = "0101" then
					num := "0000";
				else
					num := num + 1;
				end if;	 
			end if;
		end if;
		if num = "0101" then
			tc := '1';
		end if;
		tc_num_usa <= tc;
	end process;
end architecture;

