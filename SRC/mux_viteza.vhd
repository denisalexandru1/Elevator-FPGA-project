LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.ALL;	   

entity mux is
	port(
	A_MUX: in std_logic;
	B_MUX: in std_logic;
	SEL_MUX: in std_logic;
	Y_MUX: out std_logic
	);
end entity;

architecture arch_mux of mux is
begin
    Y_MUX <= A_MUX when SEL_MUX = '0' else B_MUX;
end architecture;
 