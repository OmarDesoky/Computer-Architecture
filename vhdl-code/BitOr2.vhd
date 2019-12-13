LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

ENTITY BitOr2 IS
	PORT(Address : IN std_logic_vector(5 DOWNTO 0);
		IR : IN std_logic_vector(15 DOWNTO 0);
		 R : OUT std_logic_vector(4 DOWNTO 0));

END ENTITY BitOr2;

ARCHITECTURE a_BitOr2 OF BitOr2 IS
SIGNAL TEMP,OP2,OP1 : std_logic;
BEGIN

	TEMP <= 
	(
	((NOT Address(0)) AND (NOT Address(1)) AND (NOT Address(2)) AND (NOT Address(3)) AND (NOT Address(4)) AND Address(5)) OR
	( Address(0) AND Address(1) AND (NOT Address(2)) AND Address(3) AND (NOT Address(4)) AND Address(5))
	);

	OP2 <= 
	(
	(NOT IR(15)) OR ((IR(15) AND (NOT IR(14)) AND (NOT IR(13)) AND (NOT IR(12))))
	);

	OP1 <= 
	(
	IR(15) AND IR(14) AND (NOT IR(13))
	);


	R(0) <= (TEMP AND OP2 AND IR(12)) OR (TEMP AND OP1 AND IR(6));

	R(1) <= (TEMP AND OP2 AND IR(13)) OR (TEMP AND OP1 AND IR(7));

	R(2) <= (TEMP AND OP2 AND IR(14)) OR (TEMP AND OP1 AND IR(8));

	R(3) <= (TEMP AND OP1 AND (NOT IR(9)));

	R(4) <= (TEMP AND OP1 AND IR(9));

END a_BitOr2;
