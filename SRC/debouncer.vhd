library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;  	 

entity bistabil_d is
	port(
	D: in std_logic;
	CLK: in std_logic;
	CLR: in std_logic;
	Q: out std_logic
	);
end entity;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;  

entity and_gate_3in is
	port(
	INPUT:in std_logic_vector (2 downto 0);
	I: out std_logic
	);
	
end and_gate_3in;

architecture arch_bistabil_d of bistabil_d is
begin
	process(CLR, CLK)
	begin
		if CLR = '1' then  
			Q <= '0';
		else
			if rising_edge(clk) then
				Q <= D;
			end if;
		end if;
	end process;
end architecture;	  



architecture arch_and_gate_3in of and_gate_3in is
begin
	I <= '1' when INPUT = "111" else '0';
end architecture;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;  

entity Debouncer is
	port(
	OK: in std_logic;
	RST_OK_DB: in std_logic;
	CLK_DEB: in std_logic;
	OK_DB: out std_logic
	);
end entity;

architecture arch_debouncer of debouncer is		

component and_gate_3in is
	port(
	INPUT:in std_logic_vector (2 downto 0);
	I: out std_logic
	);
	
end component;

component bistabil_d is
	port(
	D: in std_logic;
	CLK: in std_logic;
	CLR: in std_logic;
	Q: out std_logic
	);
end component;

signal S0, S1, S2: std_logic;

begin
	Bis0: bistabil_d port map (D => OK, CLK => CLK_DEB, CLR => RST_OK_DB, Q => S0);	
	Bis1: bistabil_d port map (D => S0, CLK => CLK_DEB, CLR => RST_OK_DB, Q => S1);
	Bis2: bistabil_d port map (D => S1, CLK => CLK_DEB, CLR => RST_OK_DB, Q => S2);
	
	AND_GATE: and_gate_3in port map ( INPUT(0) => S0,  INPUT(1)=> S1, INPUT(2) => S2, I =>  OK_DB);

end architecture;
	
	


			
			