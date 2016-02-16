-- this circuit tests the g30_YMD_Counter circuit on the Altera board 
--
-- entity name: g30_YMD_Counter
--
-- Copyright (C) 2014 Bo Zheng and Habib Ahmed
-- Version 1.0
-- Bo Zheng; bo.zheng@mail.mcgill.ca, Habib Ahmed; habib.ahmed@mail.mcgill.ca
-- Date: Mar. 1st, 2014

library ieee;
use ieee.std_logic_1164.all; -- allows use of the std_logic_vector type
use ieee.numeric_std.all; -- allows use of the unsigned type

LIBRARY lpm; 
USE lpm.lpm_components.all;

entity g30_YMD_Counter is
port( reset: in std_logic; 
		clock: in std_logic;
		day_count_en:in std_logic;
		load_enable: in std_logic;
		Y_Set: in std_logic_vector (11 downto 0);
		M_Set: in std_logic_vector (3 downto 0);
		D_Set: in std_logic_vector (4 downto 0);
		Years:out std_logic_vector (11 downto 0);
		Months: out std_logic_vector (3 downto 0);
		Days: out std_logic_vector (4 downto 0));
		
end g30_YMD_Counter;

architecture behavior of g30_YMD_Counter is
signal Daylim: std_logic_vector( 4 downto 0);
signal Monthlim: std_logic_vector(3 downto 0);
signal Yearlim: std_logic_vector( 11 downto 0);
signal change_enM, change_enY: std_logic;
signal day_inter: std_logic_vector ( 4 downto 0):="00001";
signal month_inter: std_logic_vector ( 3 downto 0):="0001";
signal year_inter: std_logic_vector (11 downto 0):="000000000000";
begin

Monthlim<="1100";
Yearlim<="111110100000";

day: process (clock, day_count_en, load_enable, Daylim, reset, day_inter, month_inter, year_inter,D_Set)

begin
	if reset='1' then 
		day_inter<="00001";
	
	
	elsif load_enable='1' then
		day_inter<=D_Set;
		
	elsif clock='1' and clock'event then
		 
		--set days limit for each month
		if (month_inter = "0010") and ((To_integer(unsigned(year_inter))) mod 4)= 0 then Daylim<="11101";
			elsif month_inter=("0100") then  Daylim<="11110";
			elsif month_inter=("0110") then  Daylim<="11110";
			elsif month_inter=("1001") then  Daylim<="11110";
			elsif month_inter=("1011") then  Daylim<="11110";
			elsif month_inter=("0100" or "0110" or "1001" or "1011") then  Daylim<="11110";
			elsif month_inter= "0010" and ((To_integer(unsigned(year_inter))) mod 4)/=0 then Daylim<="11100";
			else  
				Daylim<="11111";
		end if;
		
		--increment on days
		if day_count_en='1'  then 
			if day_inter=Daylim then
				day_inter<= "00001";
			
			else
				day_inter<= std_logic_vector(unsigned(day_inter)+"00001");
			
			end if;
		end if;
		
		if day_inter=Daylim then change_enM<='1';
		else
			change_enM<='0';
		end if;
	
--		if day_inter= std_logic_vector(unsigned(Daylim)+ "00001")  then day_inter<="00001";
--		end if;
		
		
	end if;	
		
	Days<= day_inter;

end process;


month: process ( clock, reset, day_inter, change_enM, day_count_en, Daylim,M_Set,load_enable,month_inter)

begin 
	if reset='1' then 
		month_inter<="0001";
	
	elsif load_enable='1' then
		month_inter<=M_Set;
		
	elsif clock='1' and clock'event then
		
		--increment on Month
		if day_inter= Daylim and change_enM='1' and day_count_en='1' then 
			if month_inter= Monthlim then
				month_inter<="0001";
			else
				month_inter<=std_logic_vector(unsigned(month_inter) +  "0001"); 
			end if;
		end if;
		
		
		
		if month_inter= std_logic_vector(unsigned(Monthlim)+"0001") then month_inter<="0001";
		end if;
		
		
		if month_inter=Monthlim then change_enY<='1';
		else
			change_enY<='0';
		end if;
		
		
	end if;
	
	Months<= month_inter;
	

end process;

year: process( clock, reset, month_inter, change_enY, Y_Set,load_enable,year_inter)

begin
	if reset='1' then 
		year_inter<="000000000000";
	
	elsif load_enable='1' then
		year_inter<=Y_Set;
		
	elsif clock='1' and clock'event then
		
		--increment on Year
		if month_inter = Monthlim and change_enY='1' and change_enM='1' and day_count_en='1' then 
			if year_inter=Yearlim then
				year_inter<="000000000000";
			else
				year_inter<=std_logic_vector(unsigned(year_inter) + "000000000001"); 
			end if;
		end if;
		
		if year_inter= std_logic_vector(unsigned(Yearlim)+"000000000001") then year_inter<="000000000000";
		end if;
	
	end if;
	
	Years<=year_inter;
	
end process;


end behavior;

		