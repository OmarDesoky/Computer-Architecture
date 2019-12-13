LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
-- will be modified
ENTITY main IS
PORT( 	testinput	: IN std_logic_vector(15 downto 0);
	Clk : IN std_logic;
	reg_clear: in std_logic_vector(17 downto 0)
);
END main;

ARCHITECTURE a_main_mix OF main IS  
-- adding alu compoenet to the architecture
COMPONENT ALU is
	generic(n: integer :=16);
	port(	a,b: in std_logic_vector(n-1 downto 0);
		sel: in std_logic_vector(4 downto 0);
		cin: in std_logic;			-- enable flag register
		f : out std_logic_vector(n-1 downto 0);
		flags: out std_logic_vector(4 downto 0)		-- C | Z | N | P | O
	    );

END COMPONENT;
-- ==============Adding address generator ===============
COMPONENT NewAddress IS
	PORT(PLA_ADDRESS : IN std_logic_vector(5 DOWNTO 0);		--ADDRESS FROM PLA
		BITOR_ADDRESS : IN std_logic_vector(5 DOWNTO 0);	--ADDRESS FROM BIT ORING
		 NEW_ADDRESS : OUT std_logic_vector(5 DOWNTO 0));	--OUTPUT NEW ADDRESS TO uAR

END COMPONENT;
COMPONENT PLA IS
	PORT(Address : IN std_logic_vector(5 DOWNTO 0);		--current address from temp register
		IR : IN std_logic_vector(15 DOWNTO 0);		--IR resgister
		FR: IN std_logic_vector(15 DOWNTO 0);		--FLAG REGISTER
		 R : OUT std_logic_vector(5 DOWNTO 0));		--Output address

END COMPONENT;
COMPONENT BitOrModule IS
	PORT(Address : IN std_logic_vector(5 DOWNTO 0);		--currnet address from temp register
		IR : IN std_logic_vector(15 DOWNTO 0);		--IR register
		NextAddress : std_logic_vector(5 DOWNTO 0);	--next address from rom
		 R : OUT std_logic_vector(5 DOWNTO 0));		--new address 

END COMPONENT;
--========================================================
-- adding register components to the architecture 
COMPONENT register_nbits IS
GENERIC ( n : integer := 16);
PORT( Clk,Rst : IN std_logic;
	    d : IN std_logic_vector(n-1 DOWNTO 0);
	    q : OUT std_logic_vector(n-1 DOWNTO 0);
	enable: in std_logic
);
	
END COMPONENT;
-- micro mar with reset value = fetch (011010)
COMPONENT micro_mar_register IS
GENERIC ( n : integer := 6);
PORT( Clk,Rst : IN std_logic;
	    d : IN std_logic_vector(n-1 DOWNTO 0);
	    q : OUT std_logic_vector(n-1 DOWNTO 0);
	enable: in std_logic
);
	
END COMPONENT;
-- Temp register that store the old value of the micro mar
COMPONENT temp_register IS
GENERIC ( n : integer := 6);
PORT( Clk,Rst : IN std_logic;
	    d : IN std_logic_vector(n-1 DOWNTO 0);
	    q : OUT std_logic_vector(n-1 DOWNTO 0);
	enable: in std_logic
);
	
END COMPONENT;
COMPONENT mdr_register IS
GENERIC ( n : integer := 16);
PORT( Clk,Rst : IN std_logic;
	    d,d2 : IN std_logic_vector(n-1 DOWNTO 0);
	    q : OUT std_logic_vector(n-1 DOWNTO 0);
	enable,enable2: in std_logic
);
	
END COMPONENT;
--PC with 2 inputs with 2 enables 
COMPONENT pc_register IS
GENERIC ( n : integer := 16);
PORT( Clk,Rst : IN std_logic;
	    d,d2 : IN std_logic_vector(n-1 DOWNTO 0);
	    q : OUT std_logic_vector(n-1 DOWNTO 0);
	enable,enable2: in std_logic
);
END COMPONENT;
-- incrementor
COMPONENT incrementor IS
GENERIC ( n : integer := 16);
PORT( Clk,Rst : IN std_logic;
	    d : IN std_logic_vector(n-1 DOWNTO 0);
	    q : OUT std_logic_vector(n-1 DOWNTO 0);
		enable: in std_logic
);
	
END COMPONENT;
-- ====================================================================================
-- =========================tristate buffers ==========================================
COMPONENT tristate IS
GENERIC ( n : integer := 16);
PORT(  input  : IN std_logic_vector(n-1 DOWNTO 0);
       enable : IN std_logic;
       output : OUT std_logic_vector(n-1 DOWNTO 0));
END COMPONENT;
COMPONENT pc_tristate IS
GENERIC ( n : integer := 16);
PORT(  input  : IN std_logic_vector(n-1 DOWNTO 0);
       enable : IN std_logic;
       output,output2 : OUT std_logic_vector(n-1 DOWNTO 0));
END COMPONENT;
--======================================================================================
-- ===========Decoder 2X4 and 3X8 ======================================================
COMPONENT decoder2X4 IS
PORT(  d_input  : IN std_logic_vector(1 DOWNTO 0);
	d_enable: IN std_logic;
       d_output : OUT std_logic_vector(3 downto 0));
END COMPONENT;
COMPONENT decoder3X8 IS
PORT(  d_input  : IN std_logic_vector(2 DOWNTO 0);
	d_enable: IN std_logic;
       d_output : OUT std_logic_vector(7 downto 0));
END COMPONENT;
-- =====================================================================================
-- MEMORY =============================================================================
COMPONENT RAM IS
	Generic(addressBits: integer :=12;
		wordSize: integer :=16);
	PORT(
		clk : IN std_logic;
		we  : IN std_logic;
		address : IN  std_logic_vector(addressBits - 1 DOWNTO 0);
		datain  : IN  std_logic_vector(wordSize - 1 DOWNTO 0);
		dataout : OUT std_logic_vector(wordSize - 1 DOWNTO 0));
END COMPONENT;
COMPONENT ROM IS
	Generic(addressBits: integer :=6;
		wordSize: integer :=21);
	PORT(
		address : IN  std_logic_vector(addressBits - 1 DOWNTO 0);
		dataout : OUT std_logic_vector(wordSize - 1 DOWNTO 0));
END COMPONENT;
-- =====================================================================================
-- SIGNALS USED ========================================================================
-- =====================================================================================
SIGNAL mainbus,y_to_alu,incrementor_pc,alu_to_z,
ir_out,in_fr,ir_address,out_fr,from_ram,temp_address:  std_logic_vector(15 downto 0);
SIGNAL naf,address_of_cs,temp_to_boc_and_pla 
,PLA_ADDRESS, BITOR_ADDRESS,NEW_ADDRESS: std_logic_vector(5 downto 0);

type mySignal is array (0 to 12) of std_logic_vector(15 downto 0);
SIGNAL regiTri: mySignal;

SIGNAL alu_to_fr: std_logic_vector(4 downto 0);	-- C | Z | N | P | O
-- RAM Address
SIGNAL address: std_logic_vector(11 downto 0);
-- Control store signal 
SIGNAL control_store : std_logic_vector(20 downto 0);
-- Control signals decoded 
SIGNAL f1,f3,src,dst : std_logic_vector(7 downto 0);
SIGNAL f2,f4 : std_logic_vector(3 downto 0);
-- general purpose registers signals(in,out) 
SIGNAL R0_in,R1_in,R2_in,R3_in,R4_in,R5_in,SP_in: std_logic;
SIGNAL R0_out,R1_out,R2_out,R3_out,R4_out,R5_out,SP_out: std_logic;
-- TODO :flag register enable 
SIGNAL flags_enable,carry_in: std_logic;

--=====================================================================
--=======================BEGINING of the program ======================
--=====================================================================
BEGIN 
	mainbus <= testinput;
	naf <= control_store(20 downto 15);
	f1_decoder : decoder3X8 PORT MAP( control_store(14 downto 12), '1', f1);
	f3_decoder : decoder3X8 PORT MAP( control_store(9 downto 7), '1', f3);
	f2_decoder : decoder2X4 PORT MAP( control_store(11 downto 10), '1', f2);
	f4_decoder : decoder2X4 PORT MAP( control_store(6 downto 5), '1', f4);
	src_address_decoder: decoder3X8 PORT MAP( ir_out(8 downto 6), '1', src);
	dst_address_decoder: decoder3X8 PORT MAP( ir_out(2 downto 0), '1', dst);

-- =============================== ALU ==============================================
	alu_component : ALU PORT MAP(y_to_alu,mainbus,control_store(4 downto 0),carry_in,alu_to_z,alu_to_fr	-- C | Z | N | P | O 
						);
	Z : register_nbits PORT MAP(clk,reg_clear(11),alu_to_z,regiTri(11),f1(3));
	Z_tristate: tristate PORT MAP(regiTri(11),f3(5),mainbus);

	Y : register_nbits PORT MAP(clk,reg_clear(12),mainbus,y_to_alu,f2(2));
-- ==================================================================================
	-- Define all the needed registers connecting the clock, reset signal, main bus, output to tri-state buffer , and the enable in
	-- f1(5) => Rsrc-in , f1(6)=> Rdst-in , source address = IR8 IR7 IR6 , destination address = IR2 IR1 IR0
	-- src only out 1 to the corrsponding register address, dst same
	-- f3(2) => Rsrc-out , f3(1)=> Rdst-out
	R0_in <=(((f1(5))and(src(0)))or((f1(6))and(dst(0))));
	R0_out <=((f3(2))and(src(0)))or((f3(1))and(dst(0)));
	R0 : register_nbits PORT MAP(clk,reg_clear(0),mainbus,regiTri(0),R0_in);
	R0_tristate: tristate PORT MAP(regiTri(0),R0_out,mainbus);

	R1_in <= ((f1(5))and(src(1)))or((f1(6))and(dst(1)));
	R1_out <= ((f3(2))and(src(1)))or((f3(1))and(dst(1)));
	R1 : register_nbits PORT MAP(clk,reg_clear(1),mainbus,regiTri(1),R1_in);
	R1_tristate: tristate PORT MAP(regiTri(1),R1_out,mainbus);

	R2_in <= ((f1(5))and(src(2)))or((f1(6))and(dst(2)));
	R2_out <= ((f3(2))and(src(2)))or((f3(1))and(dst(2)));
	R2 : register_nbits PORT MAP(clk,reg_clear(2),mainbus,regiTri(2),R2_in);
	R2_tristate: tristate PORT MAP(regiTri(2),R2_out,mainbus);

	R3_in <=((f1(5))and(src(3)))or((f1(6))and(dst(3)));
	R3_out <=((f3(2))and(src(3)))or((f3(1))and(dst(3)));
	R3 : register_nbits PORT MAP(clk,reg_clear(3),mainbus,regiTri(3),R3_in);
	R3_tristate: tristate PORT MAP(regiTri(3),R3_out,mainbus);

	R4_in <=((f1(5))and(src(4)))or((f1(6))and(dst(4)));
	R4_out <= ((f3(2))and(src(4)))or((f3(1))and(dst(4)));
	R4 : register_nbits PORT MAP(clk,reg_clear(4),mainbus,regiTri(4),R4_in);
	R4_tristate: tristate PORT MAP(regiTri(4),R4_out,mainbus);

	R5_in <=((f1(5))and(src(5)))or((f1(6))and(dst(5)));
	R5_out <= ((f3(2))and(src(5)))or((f3(1))and(dst(5)));
	R5 : register_nbits PORT MAP(clk,reg_clear(5),mainbus,regiTri(5),R5_in);
	R5_tristate: tristate PORT MAP(regiTri(5),R5_out,mainbus);

	SP_in <= ((f1(5))and(src(6)))or((f1(6))and(dst(6)));
	SP_out <= ((f3(2))and(src(6)))or((f3(1))and(dst(6)));
	SP : register_nbits PORT MAP(clk,reg_clear(6),mainbus,regiTri(6),SP_in);
	SP_tristate: tristate PORT MAP(regiTri(6),SP_out,mainbus);

	PC : pc_register PORT MAP(clk,reg_clear(7),mainbus,incrementor_pc,regiTri(7),f1(1),f1(2));
	PC_tristate_buffer: pc_tristate PORT MAP(regiTri(7),f3(6),mainbus,incrementor_pc);

	SOURCE : register_nbits PORT MAP(clk,reg_clear(10),mainbus,regiTri(10),f1(4));
	SOURCE_tristate: tristate PORT MAP(regiTri(10),f3(7),mainbus);

-- ===================Define Ram and prepare its address ============
	temp_address <= regiTri(9); -- MAR
	address <= temp_address(11 downto 0);
	RAM_COMP: RAM PORT MAP (clk,f4(2),address,regiTri(8),from_ram); -- Data in is MDR
	MDR: mdr_register PORT MAP(clk,reg_clear(8),from_ram,mainbus,regiTri(8),f4(1),f1(7));
	tristatebuffers: tristate PORT MAP(regiTri(8),f3(3),mainbus);

	MAR : register_nbits PORT MAP(clk,reg_clear(9),mainbus,regiTri(9),f2(1));
	MAR_tristate: tristate PORT MAP(regiTri(9),f3(4),mainbus);
--===================================================================================
-- =============Flag register ==========================================================
	in_fr <= "00000000000"&alu_to_fr;
	FR : register_nbits PORT MAP(clk,reg_clear(13),in_fr,out_fr,flags_enable);
	carry_in <= out_fr(4); -- carry flag 
--==========================================================================
--============== address of the rom handled here=============================
	address_generator_comp: NewAddress PORT MAP(PLA_ADDRESS, BITOR_ADDRESS,NEW_ADDRESS );	--OUTPUT NEW ADDRESS TO uAR
	pla_comp : PLA PORT MAP(temp_to_boc_and_pla,ir_out,out_fr,PLA_ADDRESS);		
	boc_comp: BitOrModule PORT MAP(temp_to_boc_and_pla,ir_out,naf,BITOR_ADDRESS);		

	micro_MAR : micro_mar_register PORT MAP(clk,reg_clear(14),NEW_ADDRESS,address_of_cs,'1');
	temp : temp_register PORT MAP(clk,reg_clear(15),address_of_cs,temp_to_boc_and_pla,'1');

	rom_comp:ROM PORT MAP(address_of_cs,control_store);
--==========================================================================
	ir_address<="00000000"&ir_out(7 downto 0);
	IR : register_nbits PORT MAP(clk,reg_clear(16),mainbus,ir_out,f2(3));
	IR_tristate: tristate PORT MAP(ir_address,f4(3),mainbus);
-- =================== Incrementor ==============================================
	INC: incrementor PORT MAP(clk,reg_clear(17),incrementor_pc,regiTri(12),f3(6));
	INC_tristate:  tristate PORT MAP(regiTri(12),f1(2),incrementor_pc);
-- ==============================================================================
-- ==========================END=================================================
-- =============================================================================
end a_main_mix;