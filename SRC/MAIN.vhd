library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;  	   
use ieee.std_logic_unsigned.all; 

entity LIFT is
	port(
	OK, MAIN_SZ_GREUTATE, MAIN_SZ_USA, MAIN_VITEZA, CLK, MAIN_RESET: in std_logic;
	ETAJ_CERERE, IEUD: in std_logic_vector(3 downto 0);
	MAIN_LED_SZ_GREUTATE, MAIN_LED_SZ_USA, MAIN_LED_USA, MAIN_LED_GASIT: out std_logic;
	ANOZI: out std_logic_vector(3 downto 0);
	CATOZI: out std_logic_vector(6 downto 0)
	);
end LIFT;

architecture arch_lift of LIFT is  

 --- UNITATE CONTROL --- 

component UNITATE_CONTROL is
	port(	
	-- INTRARI
	CLK, RESET, SZ_GREUTATE, SZ_USA: in std_logic; -- Intrari switch-uri
	GASIT, VALID, OK_DB, SENS, TCD, TCU: in std_logic; -- Intrari Unit cautare
	MISCARE, AJUNS, TC_USA: in std_logic; -- Intrari UE
	-- IESIRI
	SET_GASIT, RST_GASIT,SET_SENS,RST_SENS, EN_NUM_ADD, EN_REG, RST_OK_DB, DELETE, LOAD_NUM, WE, CLR_NUM_ADD, CLR_MEM: out std_logic;	-- Iesiri in Unit cautare
	SET_MISCARE,RST_MISCARE, RST_NUM_USA, RST_DIV_FREQ, CLR_NUM_ETAJ, RST_7SEG: out std_logic -- Iesiri in UE	 
	);
end component;		

 --- COMPONENTE UNITATE CAUTARE ---- 	

component Debouncer is
	port(
	OK: in std_logic;
	RST_OK_DB: in std_logic;
	CLK_DEB: in std_logic;
	OK_DB: out std_logic
	);
end component;
component BISTABIL_STARE is
	port(
	SET_VALUE, RST_VALUE: in std_logic;
	CLK: in std_logic;
	REG_VALUE: inout std_logic
	);
end component;	
component Memorie is 
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
end component;
component numarator_cautare is
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
end component; 
component CHECK_VALID is
	port(
	CHK_VALID_IEUD: in std_logic_vector(3 downto 0);
	CHK_VALID_SENS: in std_logic; 				 
	CHK_VALID_OUT: out std_logic
	);
end component;
component REG_ETAJ is
	port(
	D_REG: in std_logic_vector(3 downto 0);
	CLK: in std_logic;
	EN_REG: in std_logic;
	Q_REG: out std_logic_vector(3 downto 0)
	);
end component;	

--- COMPONENTE UNITATE EXECUTIE	

component Clock_Divider_1Sec is
	PORT (
		clk_div, reset : IN std_logic;
		clock_out : OUT std_logic
	);
end component;
component Clock_Divider_3Sec is
	PORT (
		clk_div_3sec, reset_3sec : IN std_logic;
		clock_out_3sec : OUT std_logic
	);
end component;
component numarator_usa is
	port(
	clk_num_usa, rst_num_usa, en_num_usa : in std_logic;
	tc_num_usa : out std_logic	 
	);
end component;
component comparator_dir is
	port( ETAJ1, ETAJ2 : in std_logic_vector(3 downto 0);
	COMP, EGAL: out std_logic);
end component;	 
component mux is
	port(
	A_MUX: in std_logic;
	B_MUX: in std_logic;
	SEL_MUX: in std_logic;
	Y_MUX: out std_logic
	);
end component; 
component numarator_etaj_curent is
	port(
	dir_num_cur, en_num_cur, clk_num_cur, clr_num_cur: in std_logic;  
	q_num_cur: out std_logic_vector(3 downto 0)
	);
end component; 
component Control_7Seg is
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
end component;  


--- Semnale UC->Unit Cautare---
signal S_SET_GASIT,S_RST_GASIT, S_SET_SENS, S_RST_SENS, S_EN_NUM_ADD, S_EN_REG, S_RST_OK_DB, S_DELETE, S_LOAD_NUM, S_WE, S_CLR_NUM_ADD, S_CLR_MEM: std_logic;	  
--- Semnale Unit Cautare
signal S_OK_DB, S_GASIT, S_SENS, S_VALID, S_TCU, S_TCD: std_logic;
signal S_ETAJ_CAUTARE, S_IEUD_MEM, S_ETAJ_GASIT: std_logic_vector(3 downto 0); 

--- Semnale UC->UE ---
signal S_RST_7SEG, S_SET_MISCARE, S_RST_MISCARE, S_RST_NUM_USA, S_RST_DIV_FREQ, S_CLR_NUM_ETAJ: std_logic;
--- Semnale UE ---
signal CLK_1SEC, CLK_3SEC, S_TC_USA, S_MISCARE,S_DIR, S_AJUNS, CLK_NUM_ETAJ: std_logic;
signal S_ETAJ_CURENT: std_logic_vector(3 downto 0);	  

begin 	
	UC: UNITATE_CONTROL port map(CLK => CLK, RESET => MAIN_RESET, SZ_GREUTATE => MAIN_SZ_GREUTATE, SZ_USA => MAIN_SZ_USA,
						GASIT => S_GASIT, VALID => S_VALID, OK_DB => S_OK_DB,SENS => S_SENS, TCD => S_TCD,
						TCU => S_TCU, MISCARE => S_MISCARE, AJUNS => S_AJUNS, TC_USA => S_TC_USA, -- INTRARI
						SET_GASIT => S_SET_GASIT,RST_GASIT => S_RST_GASIT, SET_SENS => S_SET_SENS,RST_SENS => S_RST_SENS, EN_NUM_ADD => S_EN_NUM_ADD, EN_REG => S_EN_REG,
						RST_OK_DB => S_RST_OK_DB, DELETE => S_DELETE, LOAD_NUM => S_LOAD_NUM, WE => S_WE, CLR_NUM_ADD => S_CLR_NUM_ADD,
						CLR_MEM => S_CLR_MEM, SET_MISCARE => S_SET_MISCARE,RST_MISCARE => S_RST_MISCARE, RST_NUM_USA => S_RST_NUM_USA,
						RST_DIV_FREQ => S_RST_DIV_FREQ, CLR_NUM_ETAJ => S_CLR_NUM_ETAJ, RST_7SEG => S_RST_7SEG);  -- IESIRI 
						
	--- Componente Unitate Cautare ---
	DEBOUNCER1: DEBOUNCER port map(OK => OK, RST_OK_DB => S_RST_OK_DB, CLK_DEB => CLK, OK_DB => S_OK_DB);
 	STARE_GASIT1: BISTABIL_STARE port map(SET_VALUE => S_SET_GASIT,RST_VALUE => S_RST_GASIT, CLK => CLK, REG_VALUE => S_GASIT);	
	STARE_SENS1: BISTABIL_STARE port map(SET_VALUE => S_SET_SENS,RST_VALUE => S_RST_SENS, CLK => CLK, REG_VALUE => S_SENS); 
	MEMORIE1: MEMORIE port map(ETAJ_CURENT => S_ETAJ_CURENT, ETAJ_CERERE => ETAJ_CERERE, ETAJ_CAUTARE => S_ETAJ_CAUTARE, 
					  RST_MEM => S_CLR_MEM, IEUD => IEUD, WE => S_WE, DELETE => S_DELETE, CLK => CLK, Q_RAM => S_IEUD_MEM); 
	NUMARATOR_ADRESA1: NUMARATOR_CAUTARE port map(ETAJ_CURENT => S_ETAJ_CURENT, SENS => S_SENS, LOAD_NUM => S_LOAD_NUM, 
					  CLK => CLK, CLEAR_NUM_ADD => S_CLR_NUM_ADD, EN_NUM_ADD => S_EN_NUM_ADD, ETAJ_CAUTARE => S_ETAJ_CAUTARE,
	  				  TCU => S_TCU, TCD => S_TCD);
	VERIF_VALID1: CHECK_VALID port map(CHK_VALID_IEUD => S_IEUD_MEM, CHK_VALID_SENS => S_SENS, CHK_VALID_OUT => S_VALID); 
	REG_ETAJ1: REG_ETAJ port map(D_REG => S_ETAJ_CAUTARE, CLK => CLK, EN_REG => S_EN_REG, Q_REG => S_ETAJ_GASIT);
	
	--- Componente Unitate Executie
	DIV_FREQ_1S: Clock_Divider_1Sec port map(CLK_DIV => CLK, RESET => S_RST_DIV_FREQ, CLOCK_OUT => CLK_1SEC);  
	DIV_FREQ_3S: Clock_Divider_3Sec port map(CLK_DIV_3SEC => CLK, RESET_3SEC => S_RST_DIV_FREQ, CLOCK_OUT_3SEC => CLK_3SEC);	 
	NUM_USA1: Numarator_Usa port map(CLK_NUM_USA => CLK_1SEC, RST_NUM_USA => S_RST_NUM_USA, EN_NUM_USA => S_MISCARE, TC_NUM_USA => S_TC_USA);
	STARE_MISCARE1: BISTABIL_STARE port map(SET_VALUE => S_SET_MISCARE,RST_VALUE => S_RST_MISCARE, CLK => CLK, REG_VALUE => S_MISCARE);	
	COMP_DIR1: Comparator_Dir port map( ETAJ1 => S_ETAJ_CURENT, ETAJ2 => S_ETAJ_GASIT, COMP => S_DIR, EGAL => S_AJUNS);	
	MUX_VIT1: MUX port map(A_MUX => CLK_1SEC, B_MUX => CLK_3SEC, SEL_MUX => MAIN_VITEZA, Y_MUX => CLK_NUM_ETAJ);
	NUM_ETAJ_CURENT1: Numarator_Etaj_curent port map(DIR_NUM_CUR => S_DIR, EN_NUM_CUR => S_MISCARE, CLK_NUM_CUR => CLK_NUM_ETAJ, CLR_NUM_CUR => S_CLR_NUM_ETAJ, Q_NUM_CUR => S_ETAJ_CURENT);
	AFISARE1: Control_7Seg port map(ETAJ_7SEG => S_ETAJ_CURENT, DIR_7SEG => S_DIR, CLK => CLK, RESET_7SEG => S_RST_7SEG,
						MISCARE_7SEG => S_MISCARE, LED_OUT => CATOZI, ANODE_ACTIVATE => ANOZI, SZ_USA => MAIN_SZ_USA, SZ_GREUTATE => MAIN_SZ_GREUTATE, 
						LED_SZ_USA => MAIN_LED_SZ_USA, LED_SZ_GREUTATE => MAIN_LED_SZ_GREUTATE, LED_USA => MAIN_LED_USA);
	
	MAIN_LED_GASIT <= S_GASIT;

end architecture;







	


