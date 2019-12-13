LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

ENTITY BitOr6 IS
	PORT(Address : IN std_logic_vector(5 DOWNTO 0);
		IR : IN std_logic_vector(5 DOWNTO 3);
		 R : OUT std_logic_vector(2 DOWNTO 0));

END ENTITY BitOr6;

ARCHITECTURE a_BitOr6 OF BitOr6 IS
SIGNAL TEMP : std_logic;
BEGIN

TEMP <= ( (NOT Address(0)) AND (NOT Address(1)) AND Address(2) AND (NOT Address(3)) AND Address(4) AND Address(5)) OR
	( Address(0) AND Address(1) AND Address(2) AND Address(3) AND Address(4) AND Address(5));

	R(0) <= TEMP AND IR(3);

	R(1) <= TEMP AND IR(4);

	R(2) <= 
	TEMP AND 
	(
	(IR(5) AND (NOT IR(4)) AND (NOT IR(3)))
	);
END a_BitOr6;
