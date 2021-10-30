Library IEEE;
Use IEEE.STD_LOGIC_1164.All;   

ENTITY UNITATE_CONTROL IS
	port(	
	-- INTRARI
	CLK, RESET, SZ_GREUTATE, SZ_USA: in std_logic; -- Intrari switch-uri
	GASIT, VALID, OK_DB, SENS, TCD, TCU: in std_logic; -- Intrari Unit cautare
	MISCARE, AJUNS, TC_USA: in std_logic; -- Intrari UE
	-- IESIRI
	SET_GASIT, RST_GASIT,SET_SENS,RST_SENS, EN_NUM_ADD, EN_REG, RST_OK_DB, DELETE,
	LOAD_NUM, WE, CLR_NUM_ADD, CLR_MEM: out std_logic;	-- Iesiri in Unit cautare
	SET_MISCARE,RST_MISCARE, RST_NUM_USA, RST_DIV_FREQ, CLR_NUM_ETAJ, RST_7SEG: out std_logic -- Iesiri in UE	 
	);
END ENTITY;		
ARCHITECTURE arch_unitate_control of unitate_control is
	TYPE STARE_T is (RESET_1, RESET_2, DEPLASARE, DELETE_1, DELETE_2, CHECK_PORNIRE,
					 RESET_USA, PORNIRE, RESET_DIV, OPERATIE, SCRIERE_1, SCRIERE_2, RESET_USA_2, CITIRE,
					 VALIDARE, LOAD_REG, LOAD_NUMARATOR, CLOCK_NUM, INCREMENTARE, CLOCK_NUM_ADD, 
					 SCHIMBARE_SENS_UP, SCHIMBARE_SENS_DOWN);
				 

	 SIGNAL STARE, NXSTARE: STARE_T;
	 BEGIN
	 	ACTUALIZEAZA_STARE : Process (RESET, CLK)
		Begin
			If (RESET = '1') Then
				STARE <= RESET_1;
			Elsif CLK'EVENT And CLK = '1' Then
				STARE <= NXSTARE;
			End If;
		End Process ACTUALIZEAZA_STARE;	  
		
		TRANSITIONS: Process(STARE, MISCARE, AJUNS, GASIT, SZ_USA, SZ_GREUTATE, TC_USA, OK_DB, VALID, SENS, TCD, TCU) 
		Begin
			Case STARE is 
				When RESET_1=> NXSTARE <= RESET_2;
				When RESET_2=> NXSTARE <= DEPLASARE;
				When DEPLASARE=>
					IF MISCARE = '1' THEN
						IF AJUNS = '1' THEN NXSTARE <= DELETE_1;
						ELSE NXSTARE <= OPERATIE; END IF;
					ELSE NXSTARE <= CHECK_PORNIRE; END IF;		
				When DELETE_1=> NXSTARE <= DELETE_2;
				When DELETE_2=> NXSTARE <= OPERATIE;
				When CHECK_PORNIRE=>
					IF GASIT = '0' OR SZ_USA = '1' OR SZ_GREUTATE = '1' THEN NXSTARE <= RESET_USA;
					ELSE
						IF TC_USA = '0' THEN NXSTARE <= OPERATIE;
						ELSE NXSTARE <= PORNIRE;	END IF;
					END IF;
				When RESET_USA=> NXSTARE <= OPERATIE;
				When PORNIRE=> NXSTARE <= RESET_DIV;
				When RESET_DIV=> NXSTARE <= OPERATIE;
				When OPERATIE=>
					IF OK_DB = '1' THEN NXSTARE <= SCRIERE_1;
					ELSE NXSTARE <= CITIRE; END IF;
				When SCRIERE_1=> NXSTARE <= SCRIERE_2;
				When SCRIERE_2=> 
					IF MISCARE = '0' THEN NXSTARE <= RESET_USA_2;
					ELSE NXSTARE <= CITIRE;	END IF;
				When RESET_USA_2=> NXSTARE <= CITIRE;
				When CITIRE=> NXSTARE <= VALIDARE;
				When VALIDARE=>
					IF VALID = '1' THEN
						NXSTARE <= LOAD_REG;
					ELSE 
						IF SENS = '0' THEN
							IF TCD = '0' THEN NXSTARE <= INCREMENTARE;
							ELSE NXSTARE <= SCHIMBARE_SENS_UP; END IF;
						ELSE
							IF TCU ='0' THEN NXSTARE <= INCREMENTARE;
							ELSE NXSTARE <= SCHIMBARE_SENS_DOWN; END IF;
						END IF;
					END IF;
				When LOAD_REG=> NXSTARE <= LOAD_NUMARATOR;
				When LOAD_NUMARATOR=> NXSTARE <= CLOCK_NUM;
				When CLOCK_NUM=> NXSTARE <= DEPLASARE;
				When INCREMENTARE=> NXSTARE <= CLOCK_NUM_ADD;
				When CLOCK_NUM_ADD=> NXSTARE <= DEPLASARE; 
				When SCHIMBARE_SENS_UP=> NXSTARE <= DEPLASARE; 
				When SCHIMBARE_SENS_DOWN=> NXSTARE <= DEPLASARE; 
			End Case;
		End Process TRANSITIONS;
		
		CALCUL_IESIRI: Process (STARE)
		Begin 
		 	-- Iesiri in Unit cautare 
			SET_GASIT <= '0';
			RST_GASIT <= '0';
			SET_SENS <= '0';
			RST_SENS <= '0'; 
			EN_NUM_ADD <= '0';
			EN_REG <= '0';
			RST_OK_DB <= '0';
			DELETE <= '0';
			LOAD_NUM <= '0';
			WE <= '0';
			CLR_NUM_ADD <= '0';
			CLR_MEM <= '0';
			-- Iesiri in UE	 
			SET_MISCARE <= '0';
			RST_MISCARE <= '0';
			RST_NUM_USA <= '0';
			RST_DIV_FREQ <= '0';
			CLR_NUM_ETAJ <= '0';
			RST_7SEG <= '0';
			
			
			Case STARE is 
				When RESET_1=>		 
					RST_DIV_FREQ <= '1';   
					RST_NUM_USA <= '1';	 
					RST_7SEG <= '1'; 
					RST_OK_DB <= '1';
					CLR_NUM_ETAJ <= '1';
					CLR_NUM_ADD <= '1';	
					CLR_MEM <= '1';
					SET_SENS <= '1';	
					RST_MISCARE <= '1';
					RST_GASIT <= '1';	  
				When RESET_2=>   
				When DEPLASARE=>
				When DELETE_1=>	 
					RST_DIV_FREQ <= '1';  
					RST_MISCARE <= '1';
					RST_GASIT <= '1';
					DELETE <= '1';
					RST_NUM_USA <= '1';
				When DELETE_2=>	 
				When CHECK_PORNIRE=> 
				When RESET_USA=> 
					RST_NUM_USA <= '1';
					RST_DIV_FREQ <= '1';
				When PORNIRE=> 
					SET_MISCARE <= '1';
					RST_DIV_FREQ <= '1';
				When RESET_DIV=> 
				When OPERATIE=>
				When SCRIERE_1=> 
					WE <= '1';
					RST_OK_DB <= '1';
				When SCRIERE_2=> 
				When RESET_USA_2=>	
					RST_NUM_USA <= '1';
					RST_DIV_FREQ <= '1';
				When CITIRE=>
				When VALIDARE=>
				When LOAD_REG=>	
					EN_REG <= '1';
					SET_GASIT <= '1';
				When LOAD_NUMARATOR=>  
					EN_NUM_ADD <= '1';
					LOAD_NUM <= '1';
				When CLOCK_NUM=>   
				When INCREMENTARE=>	  
					EN_NUM_ADD <= '1';
				When CLOCK_NUM_ADD=>  
				When SCHIMBARE_SENS_UP=>
					SET_SENS <= '1';
				When SCHIMBARE_SENS_DOWN=> 
					RST_SENS <= '1';
			End Case;
		end process;
end arch_unitate_control;
				
	
	
	