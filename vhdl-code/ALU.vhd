LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
--use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

ENTITY ALU is
	generic(n: integer :=4);
	port(	a,b: in std_logic_vector(n-1 downto 0);
		sel: in std_logic_vector(4 downto 0);
		cin: in std_logic;
		cout: out std_logic;
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
	cout <= result(n);

-- add  => a +b
elsif(sel="00001" ) then
	result <= std_logic_vector(resize(signed(a), n+1) + resize(signed(b), n+1));
	f<=result(n-1 downto 0);
	cout <= result(n);
	
-- adc =>a +b +cin
elsif(sel="00010" ) then
	result <=std_logic_vector(resize(signed(a), n+1) + resize(signed(b), n+1) + signed(carry));
	f<=result(n-1 downto 0);
	cout <= result(n);

-- mov => f <= b
elsif(sel="00011" ) then
	result(n-1 downto 0) <= b;
	f <= result(n-1 downto 0);
	cout<='U';
--sbc => a-b-cin
elsif(sel="00100" ) then
	result<=std_logic_vector(resize(signed(a), n+1) - resize(signed(b), n+1)- signed(carry));
	f<=result(n-1 downto 0);
	cout <= result(n);
--sbc => a and b
elsif(sel="00101" ) then
	result(n-1 downto 0)<=a and b;
	f<=result(n-1 downto 0);
	cout<='U';
	result(n) <='0';
-- or=> a or b
elsif(sel="00110" ) then
	result(n-1 downto 0)<= a or b;
	f<=result(n-1 downto 0);
	cout<='U';
	result(n) <='0';
-- xor => a xor b
elsif(sel="00111" ) then
	result(n-1 downto 0)<= a xor b;
	f<=result(n-1 downto 0);
	cout<='U';
	result(n) <='0';
-- inc b => b+1
elsif(sel="01000" ) then
	result <= std_logic_vector(resize(signed(b), n+1)+ signed(temp) );
	f<=result(n-1 downto 0);
	cout<=result(n);
-- dec b => b-1
elsif(sel="01001" ) then
	result<= std_logic_vector(resize(signed(b), n+1)-signed(temp));
	f<=result(n-1 downto 0);
	cout<=result(n);
-- clr => f=>0
elsif(sel="01010" ) then
	result<= (others=>'0');
	f<=result(n-1 downto 0);
	cout<='U';
--invert => not b
elsif(sel="01011" ) then
	result(n-1 downto 0)<= not(b);
	f<=result(n-1 downto 0);
	cout<='U';
	result(n) <='0';
--logic shift right => lsr b
elsif(sel="01100" ) then
	result(n-1 downto 0) <= std_logic_vector(shift_right(signed(b), 1) );
	f<= result(n-1 downto 0);
	cout<=('U');
	result(n) <= '0';
--ror => ror b
elsif(sel="01101" ) then
	result(n-1 downto 0)<= ( b(0) & b(n-1 downto 1) );
	f<= result(n-1 downto 0);
	cout<= ( b(0) ) ;
	result(n) <= b(0);

--rrc => rrc b
elsif(sel="01110" ) then
	result(n-1 downto 0)<=( cin & b(n-1 downto 1) );
	f<= result(n-1 downto 0);
	cout<= ( b(0) ) ;
	result(n) <= b(0);
--arthi shift right => asr b
elsif(sel="01111" ) then
	result(n-1 downto 0)<= std_logic_vector(shift_right(unsigned(b), 1) ) ; 
	f<= result(n-1 downto 0);
	cout<=('U');
	result(n) <= '0';

--logic shift left => lsl b
elsif(sel="10000" ) then
	result(n-1 downto 0) <=(b(n-2 downto 0) & "0");
	f<= result(n-1 downto 0) ;
	cout <= b(n-1);
	cout <= b(n-1);

--rol => rol b
elsif(sel="10001" ) then
	result(n-1 downto 0) <=( b(n-2 downto 0) & b(n-1) );
	f<= result(n-1 downto 0) ;
	cout <= b(n-1);
	cout <= b(n-1);

--rlc  => rlc b
elsif(sel="10010" ) then
	result(n-1 downto 0) <= ( b(n-2 downto 0) & cin);
	f<= result(n-1 downto 0) ;
	cout<= b(n-1);
	result(n) <= b(n-1);

end if;

--parity flag
parity := '1' ;--initally it's set,as there is no 1's
for i in 0 to n-1 loop   --check for all the bits.
	if(result(i) = '1') then --check if the bit is '1'
            parity := parity xor '1'; --toggle parity flag
        end if;
end loop;
flags(1) <= parity;

--overflow flag
if((sel="00001")or(sel ="00010")) then
	flags(0) <= ( not(a(n-1)) and not(b(n-1)) and result(n-1)) or( (a(n-1))and(b(n-1))and not(result(n-1)) );
elsif((sel="00000")or(sel ="00100")) then
	flags(0) <= ( not(a(n-1))and(b(n-1))and(result(n-1)) ) or ( (a(n-1))and not(b(n-1))and not(result(n-1)) );

else
	flags(0) <='0';

end if;

END PROCESS;
		-- assigning flags after performing the operation
-- carry flag
flags(4) <= result(n);
--zero flag
flags(3) <= '1' when result = (result'range => '0') else
	 '0';
--negative flag
flags(2) <= result(n-1);

END ALU_Arch;