LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

ENTITY ALU is
	generic(n: integer :=16);
	port(	a,b: in std_logic_vector(n-1 downto 0);
		sel: in std_logic_vector(4 downto 0);
		cin: in std_logic;			-- enable flag register
		f : out std_logic_vector(n-1 downto 0);
		flags: out std_logic_vector(4 downto 0)		-- C | Z | N | P | O
	    );

END ENTITY ALU;

ARCHITECTURE ALU_Arch OF ALU IS

signal result: std_logic_vector(n downto 0); 
signal carry: std_logic_vector(1 downto 0);
signal temp : std_logic_vector(1 downto 0);


BEGIN
carry(0)<= cin;
carry(1)<= '0';

--- used to inc and dec
temp(0)<='1';
temp(1)<='0';
---

PROCESS (a,b,sel,result,carry) IS
variable parity: std_logic;
BEGIN

-- sub/ cmp =>	a - b
if(sel ="00000") then
	result<=std_logic_vector(resize(signed(a), n+1) - resize(signed(b), n+1));
	f<=result(n-1 downto 0);

-- add  => a +b
elsif(sel="00001" ) then
	result <= std_logic_vector(resize(signed(a), n+1) + resize(signed(b), n+1));
	f<=result(n-1 downto 0);
	
-- adc =>a +b +cin
elsif(sel="00010" ) then
	result <=std_logic_vector(resize(signed(a), n+1) + resize(signed(b), n+1) + signed(carry));
	f<=result(n-1 downto 0);

-- mov => f <= b
elsif(sel="00011" ) then
	result(n-1 downto 0) <= b;
	f <= result(n-1 downto 0);
	result(n) <='0';
--sbc => a-b-cin
elsif(sel="00100" ) then
	result<=std_logic_vector(resize(signed(a), n+1) - resize(signed(b), n+1)- signed(carry));
	f<=result(n-1 downto 0);
--sbc => a and b
elsif(sel="00101" ) then
	result(n-1 downto 0)<=a and b;
	f<=result(n-1 downto 0);
	result(n) <='0';
-- or=> a or b
elsif(sel="00110" ) then
	result(n-1 downto 0)<= a or b;
	f<=result(n-1 downto 0);
	result(n) <='0';
-- xor => a xnor b
elsif(sel="00111" ) then
	result(n-1 downto 0)<= a xnor b;
	f<=result(n-1 downto 0);
	result(n) <='0';
-- inc a => a+1
elsif(sel="01000" ) then
	result <= std_logic_vector(resize(signed(a), n+1)+ signed(temp) );
	f<=result(n-1 downto 0);
-- dec a => a-1
elsif(sel="01001" ) then
	result<= std_logic_vector(resize(signed(a), n+1)-signed(temp));
	f<=result(n-1 downto 0);
-- clr => f=>0
elsif(sel="01010" ) then
	result<= (others=>'0');
	f<=result(n-1 downto 0);
--invert => not a
elsif(sel="01011" ) then
	result(n-1 downto 0)<= not(a);
	f<=result(n-1 downto 0);
	result(n) <='0';
--logic shift right => lsr a
elsif(sel="01100" ) then
	result(n-1 downto 0) <= std_logic_vector(shift_right(signed(a), 1) );
	f<= result(n-1 downto 0);
	result(n) <= '0';
--ror => ror a
elsif(sel="01101" ) then
	result(n-1 downto 0)<= ( a(0) & a(n-1 downto 1) );
	f<= result(n-1 downto 0);
	result(n) <= a(0);

--rrc => rrc a
elsif(sel="01110" ) then
	result(n-1 downto 0)<=( cin & a(n-1 downto 1) );
	f<= result(n-1 downto 0);
	result(n) <= a(0);
--arthi shift right => asr a
elsif(sel="01111" ) then
	result(n-1 downto 0)<= std_logic_vector(shift_right(unsigned(a), 1) ) ; 
	f<= result(n-1 downto 0);
	result(n) <= '0';

--logic shift left => lsl a
elsif(sel="10000" ) then
	result(n-1 downto 0) <=(a(n-2 downto 0) & "0");
	f<= result(n-1 downto 0) ;

--rol => rol a
elsif(sel="10001" ) then
	result(n-1 downto 0) <=( a(n-2 downto 0) & a(n-1) );
	f<= result(n-1 downto 0) ;

--rlc  => rlc a
elsif(sel="10010" ) then
	result(n-1 downto 0) <= ( a(n-2 downto 0) & cin);
	f<= result(n-1 downto 0) ;
	result(n) <= a(n-1);
-- inc b => b+1
elsif(sel="10011" ) then
	result <= std_logic_vector(resize(signed(b), n+1)+ signed(temp) );
	f<=result(n-1 downto 0);
-- dec b => b-1
elsif(sel="10100" ) then
	result<= std_logic_vector(resize(signed(b), n+1)-signed(temp));
	f<=result(n-1 downto 0);

end if;
			-- assigning flags after performing the operation

-- carry flag
flags(4) <= result(n);

--zero flag
if(result = (result'range => '0')) then
	flags(3) <='1';
else
	flags(3) <='0';
end if;

--negative flag
flags(2) <= result(n-1);

--parity flag

parity := '1' ;--initally it's set,as there is no 1's
for i in 0 to n-1 loop   --check for all the bits.
	if(result(i) = '1') then --check if the bit is '1'
            parity := parity xor '1'; --toggle parity flag
        end if;
end loop;
flags(1) <= parity;


--overflow flag
if( ((sel="00001")or(sel ="00010") )   ) then
	flags(0) <= ( not(a(n-1)) and not(b(n-1)) and result(n-1)) or( (a(n-1))and(b(n-1))and not(result(n-1)) );
elsif(((sel="00000")or(sel ="00100")) ) then
	flags(0) <= ( not(a(n-1))and(b(n-1))and(result(n-1)) ) or ( (a(n-1))and not(b(n-1))and not(result(n-1)) );
else
	flags(0) <='0';
end if;

END PROCESS;




END ALU_Arch;