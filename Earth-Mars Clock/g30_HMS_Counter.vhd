-- this circuit tests the g30_HMS_Counter circuit on the Altera board 
--
-- entity name: g30_HMS_Counter
--
-- Copyright (C) 2014 Bo Zheng and Habib Ahmed
-- Version 1.0
-- Bo Zheng; bo.zheng@mail.mcgill.ca, Habib Ahmed; habib.ahmed@mail.mcgill.ca
-- Date: Mar. 14th, 2014

library ieee;
use ieee.std_logic_1164.all; -- allows use of the std_logic_vector type
use ieee.numeric_std.all; -- allows use of the unsigned type

LIBRARY lpm; 
USE lpm.lpm_components.all;

entity g30_HMS_Counter is
port( reset: in std_logic; 
		clock, sec_clock, load_enable: in std_logic;
		H_Set: in std_logic_vector(4 downto 0);
		M_Set, S_Set: in std_logic_vector(5 downto 0);
		Hours: out std_logic_vector(4 downto 0);
		Minutes, Seconds: out std_logic_vector(5 downto 0);
		end_of_day: out std_logic );

end g30_HMS_Counter;

architecture behavior of g30_HMS_Counter is 

Signal Sset, Mset, Hset: integer range 0 to 60;
signal S1set,S2set,M1set,M2set,H1set,H2set: std_logic_vector (3 downto 0);
signal S0to9,S0to5,M0to9,M0to5,H0to9,H0to2: std_logic_vector (3 downto 0);
Signal load1,load2,load3,load4,c5ar,load5,load6,l1,l2,l3,l4,l5,l6: std_logic;
Signal Senable,Henable: std_logic;
Signal countDone1,countDone2,countDone3,countDone4,countDone5a,countDone5b,countDone6,count6Is2: std_logic;
Signal count1,count2,count3,count4,count5,count6: std_logic_vector (3 downto 0);
signal change1, change2,change3,change4,change5,change6: std_logic_vector (4 downto 0);
begin 

Sset<= To_integer(unsigned(S_Set));
Mset<= To_integer(unsigned(M_set));
Hset<= To_integer(unsigned(H_set));

S1set<= std_logic_vector(To_unsigned(Sset mod 10,4));
S2set<= std_logic_vector(To_unsigned(Sset/10 mod 10,4));
M1set<= std_logic_vector(To_unsigned(Mset mod 10,4));
M2set<= std_logic_vector(To_unsigned(Mset/10 mod 10,4));
H1set<= std_logic_vector(To_unsigned(Hset mod 10,4));
H2set<= std_logic_vector(To_unsigned(Hset/10 mod 10,4));


with load_enable select
S0to9 <= S1set when '1',
		"0000" when '0';
		
with load_enable select
S0to5 <= S2set when '1',
		"0000" when '0';
		
with load_enable select
M0to9 <= M1set when '1',
		"0000" when '0';

with load_enable select
M0to5 <= M2set when '1',
		"0000" when '0';

with load_enable select
H0to9 <= H1set when '1',
		"0000" when '0';
		
with load_enable select
H0to2 <= H2set when '1',
		"0000" when '0';



	
Senable<=sec_clock AND (not load_enable);
l1<=countDone1 OR reset ;
load1<=l1 or load_enable;

Scounter0to9: lpm_counter
Generic Map( lpm_width=>4)
port map (updown=>'1',clock=>clock, sload=> load1, data=>S0to9, cnt_en=>Senable, q=>count1);

change1<= Senable & count1;
with change1 select 
countDone1 <= 
	'1' when "11001",
	'0' when others;


l2<=countDone2 OR reset;	
load2<=l2 or load_enable;
counter0to5: lpm_counter 
Generic Map( lpm_width=>4)
port map (updown=>'1',clock=>clock, sload=> load2, data=>S0to5, cnt_en=>countDone1, q=>count2);

change2<= countDone1 & count2;
with change2 select 
countDone2 <= 
	'1' when "10101",
	'0' when others;

--Minutes Counter
l3<=countDone3 OR reset;
load3<=l3 or load_enable;

Mcounter0to9: lpm_counter
Generic Map( lpm_width=>4)
port map (updown=>'1',clock=>clock, sload=> load3, data=>M0to9, cnt_en=>countDone2, q=>count3);

change3<= countDone2 & count3;
with change3 select 
countDone3 <= 
	'1' when "11001",
	'0' when others;


l4<=countDone4 OR reset;	
load4<=l4 or load_enable;

Mcounter0to5: lpm_counter 
Generic Map( lpm_width=>4)
port map (updown=>'1',clock=>clock, sload=> load4, data=>M0to5, cnt_en=>countDone3, q=>count4);

change4<=countDone3 & count4;
with change4 select 
countDone4 <= 
	'1' when "10101",
	'0' when others;
	
--Hours counter

c5ar<=countDone5a OR reset  ;
l5<=c5ar OR (countDone5b AND count6Is2);
load5<=l5 or load_enable;

Hcounter0to4: lpm_counter
Generic Map( lpm_width=>4)
port map (updown=>'1',clock=>clock, sload=> load5, data=>H0to9, cnt_en=>countDone4, q=>count5);

change5<=countDone4 & count5;
with change5 select 
countDone5a <= 
	'1' when "11001",
	'0' when others;


with change5 select
countDone5b <=
	'1' when "10011",
	'0' when others;


l6<=countDone6 OR reset;	
load6<=l6 or load_enable;
HEnable<= countDone5a OR (countDone5b AND count6Is2);

Hcounter0to2: lpm_counter 
Generic Map( lpm_width=>4)
port map (updown=>'1',clock=>clock, sload=> load6, data=>H0to2, cnt_en=>HEnable, q=>count6);

change6<=HEnable & count6;
with change6 select 
countDone6 <= 
	'1' when "10010",
	'0' when others;

with count6 select
count6Is2 <=
	'1' when "0010",
	'0' when others;

--end_of_day

end_of_day<= countDone6 And clock;

Seconds<= std_logic_vector(To_unsigned((To_integer(unsigned(count1))+(To_integer(unsigned(count2))*10)),6));

Minutes<= std_logic_vector(To_unsigned((To_integer(unsigned(count3))+(To_integer(unsigned(count4))*10)),6));

Hours<= std_logic_vector(To_unsigned((To_integer(unsigned(count5))+(To_integer(unsigned(count6))*10)),5));

end behavior;
	


	

