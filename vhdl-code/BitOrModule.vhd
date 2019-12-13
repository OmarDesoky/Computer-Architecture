LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

ENTITY BitOrModule IS
	PORT(Address : IN std_logic_vector(5 DOWNTO 0);		--currnet address from temp register
		IR : IN std_logic_vector(15 DOWNTO 0);		--IR register
		NextAddress : std_logic_vector(5 DOWNTO 0);	--next address from rom
		 R : OUT std_logic_vector(5 DOWNTO 0));		--new address 

END ENTITY BitOrModule;

ARCHITECTURE a_BitOrModule OF BitOrModule IS

COMPONENT BitOr1 IS
	PORT(Address : IN std_logic_vector(5 DOWNTO 0);
		IR : IN std_logic_vector(5 DOWNTO 3);
		OP: IN std_logic_vector(15 DOWNTO 12);
		 R : OUT std_logic_vector(1 DOWNTO 0));

END COMPONENT;

COMPONENT BitOr2 IS
	PORT(Address : IN std_logic_vector(5 DOWNTO 0);
		IR : IN std_logic_vector(15 DOWNTO 0);
		 R : OUT std_logic_vector(4 DOWNTO 0));

END COMPONENT;

COMPONENT BitOr3 IS
	PORT(Address : IN std_logic_vector(5 DOWNTO 0);
		IR : IN std_logic_vector(5 DOWNTO 3);
		 R0 : OUT std_logic);

END COMPONENT;

COMPONENT BitOr4 IS
	PORT(Address : IN std_logic_vector(5 DOWNTO 0);
		IR5 : IN std_logic;
		 R0 : OUT std_logic);

END COMPONENT;

COMPONENT BitOr5 IS
	PORT(Address : IN std_logic_vector(5 DOWNTO 0);
		IR11 : IN std_logic;
		 R0 : OUT std_logic);

END COMPONENT;

COMPONENT BitOr6 IS
	PORT(Address : IN std_logic_vector(5 DOWNTO 0);
		IR : IN std_logic_vector(5 DOWNTO 3);
		 R : OUT std_logic_vector(2 DOWNTO 0));

END COMPONENT;

SIGNAL OUTPUT1 : std_logic_vector(1 DOWNTO 0);
SIGNAL OUTPUT2 : std_logic_vector(4 DOWNTO 0);
SIGNAL OUTPUT3 : std_logic;
SIGNAL OUTPUT4 : std_logic;
SIGNAL OUTPUT5 : std_logic;
SIGNAL OUTPUT6 : std_logic_vector(2 DOWNTO 0);

BEGIN

	B1: BitOR1 PORT MAP(Address,IR(5 DOWNTO 3),IR(15 DOWNTO 12),OUTPUT1);
	B2: BitOR2 PORT MAP(Address,IR(15 DOWNTO 0),OUTPUT2);
	B3: BitOR3 PORT MAP(Address,IR(5 DOWNTO 3),OUTPUT3);
	B4: BitOR4 PORT MAP(Address,IR(5),OUTPUT4);
	B5: BitOR5 PORT MAP(Address,IR(11),OUTPUT5);
	B6: BitOR6 PORT MAP(Address,IR(5 DOWNTO 3),OUTPUT6);

	R(0) <= NextAddress(0) OR OUTPUT1(0) OR OUTPUT2(0) OR OUTPUT3 OR OUTPUT4 OR OUTPUT5 OR OUTPUT6(0);
	R(1) <= NextAddress(1) OR OUTPUT1(1) OR OUTPUT2(1) OR OUTPUT6(1);
	R(2) <= NextAddress(2) OR OUTPUT2(2) OR OUTPUT6(2);
	R(3) <= NextAddress(3) OR OUTPUT2(3);
	R(4) <= NextAddress(4) OR OUTPUT2(4);
	R(5) <= NextAddress(5);
	
END a_BitOrModule;
