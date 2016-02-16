-- entity name:g30_Seconds_to_Days 
--
-- Copyright (c) 2014 Bo Zheng and Habib Ahmed
-- Version 1.0
-- Author: Bo Zheng; Habib Ahmed;bo.zheng@mail.mcgill.ca;habib.ahmed@mail.mcgill.ca
-- Date: Jan 23rd, 2014

library ieee; 
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity g30_Seconds_to_Days is
--declare the input and output signals, as the input and the output are involved in computation
--therefore, both of them need to be unsigned.	
port ( seconds				:	in unsigned(16 downto 0);
			day_fraction		:	out unsigned(39 downto 0) );
end g30_Seconds_to_Days;


architecture addition of g30_Seconds_to_Days is
	--declare signals in the architecture, as the sizes of these signals need to 
	--consist with the input and output of each adder and shifter 
	signal adder1:unsigned(19 downto 0);
	signal adder2:unsigned(23 downto 0);
	signal adder3:unsigned(26 downto 0);
	signal adder4:unsigned(27 downto 0);
	signal adder5:unsigned(28 downto 0);
	signal adder6:unsigned(30 downto 0);
	signal adder7:unsigned(34 downto 0);
	signal adder8:unsigned(39 downto 0);
	signal adder9:unsigned(39 downto 0);
	
begin
	--the input is shifted by different bits in different stages according to the formula
	--for example, in the first stage, the input seconds is shifted by 2 
	--to avoid overflow, the output of the shifter is shifted left by one more bit.
	adder1<= seconds+("0" & seconds & "00");
	adder2<= adder1+ ("0" & seconds & "000000");
	adder3<= adder2+ ("0" & seconds & "000000000");
	adder4<= adder3+ ("0" & seconds & "0000000000");
	adder5<= adder4+ ("0" & seconds & "00000000000");
	adder6<= adder5+ ("0" & seconds & "0000000000000");
	adder7<= adder6+ ("0" & seconds & "00000000000000000");
	adder8<= adder7+ ("0" & seconds & "0000000000000000000000");
	adder9<= adder8+ (seconds & "00000000000000000000000");
	--the output of the adder9 is the day fraction multiplied by 12,725,829 as showed by the formula
	day_fraction<= adder9;
	
end addition;