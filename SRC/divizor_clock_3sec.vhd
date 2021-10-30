											 								  LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.ALL;
 
ENTITY Clock_Divider_3Sec IS
	PORT (
		clk_div_3sec, reset_3sec : IN std_logic;
		clock_out_3sec : OUT std_logic
	);
END Clock_Divider_3Sec;
 
ARCHITECTURE bhv_3sec OF Clock_Divider_3Sec IS
 
	SIGNAL count : INTEGER := 1;
	SIGNAL tmp : std_logic := '0';
 
BEGIN
	PROCESS (clk_div_3sec, reset_3sec)
	BEGIN
		IF (reset_3sec = '1') THEN
			count <= 1;
			tmp <= '0';
		ELSIF (rising_edge(clk_div_3sec)) THEN
			count <= count + 1;
			IF (count = 149999999) THEN
				tmp <= not tmp;
				count <= 1;	 
			END IF;
		END IF;
		clock_out_3sec <= tmp;
	END PROCESS;
 
END bhv_3sec;