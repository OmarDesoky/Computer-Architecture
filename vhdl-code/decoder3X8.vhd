
LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

ENTITY decoder3X8 IS
PORT(  d_input  : IN std_logic_vector(2 DOWNTO 0);
	d_enable: IN std_logic;
       d_output : OUT std_logic_vector(7 downto 0));
END decoder3X8;

ARCHITECTURE a_decoder of decoder3X8 is
BEGIN
    d_output(0) <= d_enable and ((not d_input(0)) and (not d_input(1)) and  (not d_input(2))); --000
    d_output(1) <= d_enable and ( d_input(0) and (not d_input(1)) and  (not d_input(2)));      --001
    d_output(2) <= d_enable and ((not d_input(0)) and  d_input(1) and (not d_input(2)));       --010
    d_output(3) <= d_enable and ( d_input(0) and  d_input(1) and  (not d_input(2)));           --011
    d_output(4) <= d_enable and ((not d_input(0)) and (not d_input(1)) and   d_input(2)); --100
    d_output(5) <= d_enable and ( d_input(0) and (not d_input(1)) and  d_input(2));      --101
    d_output(6) <= d_enable and ((not d_input(0)) and  d_input(1) and d_input(2));       --110
    d_output(7) <= d_enable and ( d_input(0) and  d_input(1) and  d_input(2));           --111

END a_decoder; 
