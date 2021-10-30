library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;  	   
use ieee.std_logic_unsigned.all;

entity numarator_cautare is
	port(
	etaj_curent: in std_logic_vector(3 downto 0);
	sens: in std_logic;
	load_num: in std_logic;
	clk: in std_logic;
	clear_num_add: in std_logic;
	en_num_add: in std_logic;
	etaj_cautare: out std_logic_vector( 3 downto 0);
	tcu: out std_logic;
	tcd: out std_logic
	);
end entity;

architecture arch_numarator_cautare of numarator_cautare is
begin		
	process(CLK, clear_num_add)	
	variable NUM : std_logic_vector(3 downto 0) := "0000"; 
	variable temptcd, temptcu: std_logic;
	begin		
		temptcd := '0';
		temptcu := '0';
		if clear_num_add = '1' then
			NUM := "0000";	
		else if en_num_add = '1' then
			if rising_edge(clk) then
				if load_num = '1' then
					if sens = '1' then
						if etaj_curent > NUM then
							NUM := "0000";
						else
							NUM := etaj_curent;
						end if;
					else
						if etaj_curent < NUM then
							NUM := "1100";
						else			  
							NUM := etaj_curent;
						end if;
					end if;
				else --incrementare numarator
					if sens = '1' then
						if num /= "1100" then	  
							num := num + 1;	 
						end if;
					else 
						if num /= "0000" then
							num := num - 1;
						end if;		  
					end if;	 
				end if;
			end if;
		end if;	
	end if;
	if NUM = "0000" and sens = '0' then
		temptcd := '1';		 
	end if;
	if NUM = "1100" and sens = '1' then	 
		temptcu := '1';
	end if;
	
	tcd <= temptcd;
	tcu <= temptcu;
	etaj_cautare <= NUM;	
	
	end process;				
end architecture;		
			
				
	
	
	
	

	