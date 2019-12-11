
LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

ENTITY decoder2X4 IS
PORT(  d_input  : IN std_logic_vector(1 DOWNTO 0);
	d_enable: IN std_logic;
       d_output : OUT std_logic_vector(3 downto 0));
END decoder2X4;

ARCHITECTURE a_decoder of decoder2X4 is
BEGIN
    d_output(0) <= d_enable and ((not d_input(0)) and (not d_input(1)));
    d_output(1) <= d_enable and ( d_input(0) and (not d_input(1)));
    d_output(2) <= d_enable and ((not d_input(0)) and  d_input(1));
    d_output(3) <= d_enable and ( d_input(0) and  d_input(1));
END a_decoder; 