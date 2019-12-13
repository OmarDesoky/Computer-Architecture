LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

ENTITY BitOr1 IS
	PORT(Address : IN std_logic_vector(5 DOWNTO 0);
		IR : IN std_logic_vector(5 DOWNTO 3);
		OP: IN std_logic_vector(15 DOWNTO 12);
		 R : OUT std_logic_vector(1 DOWNTO 0));

END ENTITY BitOr1;

ARCHITECTURE a_BitOr1 OF BitOr1 IS
SIGNAL TEMP : std_logic;
BEGIN

TEMP <= ( (NOT Address(0)) AND (NOT Address(1)) AND (NOT Address(2)) AND (NOT Address(3)) AND (NOT Address(4)) AND (NOT Address(5)));

	R(0) <= 
	TEMP AND
	(
	(NOT OP(15)) AND (NOT OP(14)) AND (NOT OP(13)) AND (NOT OP(12))
	)
	AND
	(
	(NOT IR(3)) AND (NOT IR(4)) AND (NOT IR(5))
	);

	R(1) <= 
	TEMP AND
	(
	OP(15) AND (NOT OP(14)) AND (NOT OP(13)) AND (NOT OP(12))
	);

END a_BitOr1;
