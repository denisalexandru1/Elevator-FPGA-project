library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;  		
use ieee.std_logic_unsigned.all;	

entity numarator_etaj_curent is
	port(
	dir_num_cur, en_num_cur, clk_num_cur, clr_num_cur: in std_logic;  
	q_num_cur: out std_logic_vector(3 downto 0)
	);
end entity;

architecture arch_numarator_etaj_curent of numarator_etaj_curent is 
begin
	process (CLR_NUM_CUR, CLK_NUM_CUR) 	  
	variable MEM: std_logic_vector(3 downto 0) := "0000";
	begin
		if CLR_NUM_CUR = '1' then
			MEM := "0000";
		elsif falling_edge(clk_num_cur) then 
			if EN_NUM_CUR = '1' then
				if dir_num_cur = '1' and MEM /= "1100" then
					MEM := MEM + 1;
				elsif dir_num_cur = '0' and MEM /= "0000" then
					MEM := MEM - 1;	 
				end if;
			end if;
		end if;
		Q_NUM_CUR <= MEM;
	end process;
end architecture;
	
	