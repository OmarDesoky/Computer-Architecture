LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

ENTITY PLA IS
	PORT(Address : IN std_logic_vector(5 DOWNTO 0);		--current address from temp register
		IR : IN std_logic_vector(15 DOWNTO 0);		--IR resgister
		FR: IN std_logic_vector(15 DOWNTO 0);		--FLAG REGISTER
		 R : OUT std_logic_vector(5 DOWNTO 0));		--Output address

END ENTITY PLA;

ARCHITECTURE a_PLA OF PLA IS
SIGNAL TEMP,OP2,OP1,BR,HLT,NOP,CONDITION : std_logic;
BEGIN

	TEMP <= (Address(0) AND Address(1) AND (NOT Address(2)) AND Address(3) AND Address(4) AND (NOT Address(5)));

	OP2 <= ((NOT IR(15)) OR ((IR(15) AND (NOT IR(14)) AND (NOT IR(13)) AND (NOT IR(12)))));

	OP1 <= (IR(15) AND IR(14) AND (NOT IR(13)));

	NOP <= (IR(15) AND IR(14) AND IR(13) AND (NOT IR(12)) AND IR(11));

	HLT <= (IR(15) AND IR(14) AND IR(13) AND (NOT IR(12)) AND (NOT IR(11)));

	BR <= ( IR(15) AND (NOT IR(14)) AND IR(13) AND (NOT IR(12)) AND (NOT IR(11)) );

	CONDITION <= ( ((NOT IR(10)) AND (NOT IR(9)) AND (NOT IR(8))) OR 
			((NOT IR(10)) AND (NOT IR(9)) AND IR(8) AND FR(3)) OR
			((NOT IR(10)) AND IR(9) AND (NOT IR(8)) AND (NOT FR(3))) OR
			((NOT IR(10)) AND IR(9) AND IR(8) AND FR(4)) OR
			(IR(10) AND (NOT IR(9)) AND (NOT IR(8)) AND (FR(3) OR FR(4))) OR
			(IR(10) AND (NOT IR(9)) AND IR(8) AND (NOT(FR(3) OR FR(4)))) OR
			(IR(10) AND IR(9) AND (NOT IR(8)) AND (NOT FR(4))) );

	R(0) <= TEMP AND ( NOP OR (BR AND CONDITION) );
	R(1) <= TEMP AND ( NOP OR HLT OR BR );
	R(2) <= TEMP AND (NOP OR HLT OR OP2);
	R(3) <= TEMP AND ( BR AND (NOT CONDITION) );
	R(4) <= TEMP AND ( NOP OR HLT OR OP2 OR BR );
	R(5) <= TEMP AND (OP2 OR OP1);
 
END a_PLA;
