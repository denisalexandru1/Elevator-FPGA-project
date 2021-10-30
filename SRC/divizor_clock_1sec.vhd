LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.ALL;
 
ENTITY Clock_Divider_1Sec IS
	PORT (
		clk_div, reset : IN std_logic;
		clock_out : OUT std_logic
	);
END Clock_Divider_1Sec;
 
ARCHITECTURE bhv OF Clock_Divider_1Sec IS
 
	SIGNAL count : INTEGER := 1;
	SIGNAL tmp : std_logic := '0';
 
BEGIN
	PROCESS (clk_div, reset)
	BEGIN
		IF (reset = '1') THEN
			count <= 1;
			tmp <= '0';
		ELSIF (rising_edge(clk_div)) THEN
			count <= count + 1;
			IF (count = 49999999) THEN
				tmp <= not tmp;
				count <= 1;	 
			END IF;
		END IF;
		clock_out <= tmp;
	END PROCESS;
 
END bhv;