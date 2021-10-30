library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;  	   
use ieee.std_logic_unsigned.all;  

entity Control_7Seg is
	port
	(ETAJ_7SEG: in std_logic_vector(3 downto 0);  
	DIR_7SEG: in std_logic;
	CLK: in std_logic;
	RESET_7SEG: in std_logic;
	MISCARE_7SEG: in std_logic;
	LED_OUT: out std_logic_vector(6 downto 0);
	Anode_Activate: out std_logic_vector(3 downto 0);
	SZ_USA, SZ_GREUTATE: in std_logic; 
	LED_SZ_USA, LED_SZ_GREUTATE, LED_USA: out std_logic
	);
end entity;

architecture arch_control_7seg of control_7seg is	
signal refresh_counter: std_logic_vector (19 downto 0);
signal LED_activating_counter: std_logic_vector (1 downto 0); 
signal LED_BCD: std_logic_vector (3 downto 0);

begin

	process(clk,reset_7seg)
	begin 
	    if(reset_7seg='1') then
	        refresh_counter <= (others => '0');
	    elsif(rising_edge(clk)) then
	        refresh_counter <= refresh_counter + 1;
	    end if;
	end process;
	LED_activating_counter <= refresh_counter(19 downto 18);   
	
	process(LED_activating_counter)
	begin
	    case LED_activating_counter is
	    when "00" =>
	        Anode_Activate <= "0111"; 

            if MISCARE_7SEG = '0' then
                LED_out <= "1110000" ; -- "t"
            else
                if DIR_7SEG = '1' then
                    LED_out <= "0011000"; -- "P"
                else 
                    LED_out <= "1100010";  -- "o"
                end if;
            end if;
                
	    when "01" =>
	        Anode_Activate <= "1011"; 
	           
	        if MISCARE_7SEG = '0' then
                LED_out <= "0100100" ; -- "S"
            else
                if DIR_7SEG = '1' then
                    LED_out <= "1000001"; -- "U"
                else 
                    LED_out <= "1000010";  -- "d"
                end if;
            end if;
	    when "10" =>
	        Anode_Activate <= "1101"; 
	        
            case ETAJ_7SEG is
                when "0000" => LED_out <= "0000001"; -- "0"     
                when "0001" => LED_out <= "1001111"; -- "1" 
                when "0010" => LED_out <= "0010010"; -- "2" 
                when "0011" => LED_out <= "0000110"; -- "3" 
                when "0100" => LED_out <= "1001100"; -- "4" 
                when "0101" => LED_out <= "0100100"; -- "5" 
                when "0110" => LED_out <= "0100000"; -- "6" 
                when "0111" => LED_out <= "0001111"; -- "7" 
                when "1000" => LED_out <= "0000000"; -- "8"     
                when "1001" => LED_out <= "0000100"; -- "9" 
                when "1010" => LED_out <= "0000001"; -- "0"
                when "1011" => LED_out <= "1001111"; -- "1"
                when "1100" => LED_out <= "0010010"; -- "2"
                when others => LED_OUT <= "0111000"; -- "F"
            end case;
	    when "11" =>
	        Anode_Activate <= "1110"; 
             case ETAJ_7SEG is
                when "1010" => LED_out <= "1001111"; -- 1
                when "1011" => LED_out <= "1001111"; -- 1
                when "1100" => LED_out <= "1001111"; -- 1
                when others => LED_out <= "0000001"; -- 0
            end case;
		when others =>
	    end case;
	end process; 
	
	process(SZ_USA, SZ_GREUTATE, MISCARE_7SEG)
    begin
        LED_SZ_USA <= SZ_USA;
        LED_SZ_GREUTATE <= SZ_GREUTATE;
		if MISCARE_7SEG = '1' THEN
			LED_USA <= '0';
		else 
			LED_USA <= '1';	 
		end if;
    end process;
     
 
end architecture;