LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

ENTITY pc_register IS
GENERIC ( n : integer := 16;
	  codeSegmentStart: integer :=500);
PORT( Clk,Rst : IN std_logic;
	    d,d2 : IN std_logic_vector(n-1 DOWNTO 0);
	    q : OUT std_logic_vector(n-1 DOWNTO 0);
	enable,enable2: in std_logic
);
	
END pc_register;
ARCHITECTURE a_pc_register_nbits OF pc_register IS
BEGIN
PROCESS (d,Clk,Rst)
BEGIN
IF Rst = '1' THEN
q <= std_logic_vector(to_unsigned(codeSegmentStart, q'length));
ELSIF (Clk = '1' and enable='1') THEN
q <= d;
ELSIF (Clk = '1' and enable2='1') THEN
q <= d2;
END IF;
END PROCESS;
END a_pc_register_nbits;