library ieee;
use ieee.std_logic_1164.all;	  
use ieee.numeric_std.ALL;

entity Memorie is 
	port(
	ETAJ_CURENT: in std_logic_vector(3 downto 0);
	ETAJ_CERERE: in std_logic_vector(3 downto 0);
	ETAJ_CAUTARE: in std_logic_vector(3 downto 0);	
	RST_MEM: in std_logic;
	IEUD: in std_logic_vector(3 downto 0);
	WE: in std_logic;
	DELETE: in std_logic;
	CLK: in std_logic;
	Q_RAM: out std_logic_vector(3 downto 0)
	);			 
end Memorie;
architecture ARCH_MEMORIE of Memorie is 		
	type MEMORIE is array(0 to 12) of std_logic_vector(3 downto 0);
	signal MEM : MEMORIE :=  (x"0", x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0");   
	
	begin	 
	process( CLK, RST_MEM )
	begin	
		if RST_MEM = '1' then
			MEM <= (x"0", x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0"); 
		elsif rising_edge(clk) then 
			if DELETE = '1' then   
				MEM(to_integer(unsigned(ETAJ_CURENT))) <= "0000";
			elsif WE = '1' then
				MEM(to_integer(unsigned(ETAJ_CERERE))) <= IEUD;
			else
				Q_RAM <= MEM(to_integer(unsigned(ETAJ_CAUTARE)));		 
			end if;
		end if;
	end process;
end architecture;
					
					
					
	