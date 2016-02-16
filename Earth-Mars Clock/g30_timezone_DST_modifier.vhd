
library ieee;
use ieee.std_logic_1164.all; -- allows use of the std_logic_vector type
use ieee.numeric_std.all; -- allows use of the unsigned type

entity g30_timezone_DST_modifier is

port (EHours:in std_logic_vector (4 downto 0);
	zoneNum: in unsigned (4 downto 0);
	DSTsw9: in std_logic;
	Days: in std_logic_vector (4 downto 0);
	Months: in std_logic_vector (3 downto 0);
	Years: in std_logic_vector (11 downto 0);
	ESeconds,EMinutes: in std_logic_vector(5 downto 0);
	earthSeconds,earthMinutes: out unsigned (5 downto 0);
	earthHours:out unsigned (4 downto 0);
	EDays: out unsigned (4 downto 0);
	EMonths: out unsigned (3 downto 0);
	EYears: out unsigned (11 downto 0));

end g30_timezone_DST_modifier;

architecture behavior of g30_timezone_DST_modifier is

signal DST: unsigned(4 downto 0);
signal DST1: std_logic_vector (4 downto 0);
signal Daylim_present, Daylim_past:std_logic_vector (4 downto 0);
signal Month_past: unsigned (3 downto 0);
signal year: unsigned (11 downto 0);
begin

Daylimcalc:process(Months,Days)
begin 
if Months= "0001" then
			Month_past<= "1100";
			year<= unsigned(Years) - "000000000001";
else			
			Month_past<=unsigned(Months)- "0001";
			year<= unsigned(Years);
end if;
			
if (Month_past = "0010") and ((To_integer(year)) mod 4)= 0 then Daylim_past<="11101";
elsif Month_past=("0100") then  Daylim_past<="11110";
elsif Month_past=("0110") then  Daylim_past<="11110";
elsif Month_past=("1001") then  Daylim_past<="11110";
elsif Month_past=("1011") then  Daylim_past<="11110";
elsif Month_past=("0100" or "0110" or "1001" or "1011") then  Daylim_past<="11110";
elsif Month_past= "0010" and ((To_integer(unsigned(year))) mod 4)/=0 then Daylim_past<="11100";
else  
	Daylim_past<="11111";
end if;


if (Months = "0010") and ((To_integer(unsigned(Years))) mod 4)= 0 then Daylim_present<="11101";
elsif Months=("0100") then  Daylim_present<="11110";
elsif Months=("0110") then  Daylim_present<="11110";
elsif Months=("1001") then  Daylim_present<="11110";
elsif Months=("1011") then  Daylim_present<="11110";
elsif Months=("0100" or "0110" or "1001" or "1011") then  Daylim_present<="11110";
elsif Months= "0010" and ((To_integer(unsigned(Years))) mod 4)/=0 then Daylim_present<="11100";
else  
	Daylim_present<="11111";
end if;

end process;


func:process (EHours, zoneNum, DSTsw9,Days,Months,Years,ESeconds, EMinutes, Daylim_present, Daylim_past)
begin

earthSeconds<=unsigned(ESeconds);
earthMinutes<=unsigned(EMinutes);
DST1<=("0000" & DSTsw9);
DST<=unsigned(DST1);
if zoneNum < "01100" then 
	if (Unsigned(EHours) + zoneNum +DST )< "11000" then
		earthHours<= (Unsigned(EHours) + zoneNum +DST );
		EDays<=unsigned(Days);
		EMonths<=unsigned(Months);
		EYears<=unsigned(Years);

--	elsif (Unsigned(EHours) +zoneNum < DST then
--		earthHours<=(Unsigned(EHours) + zoneNum +"11000"-DST );
--		if Days="00001" then
--			EDays<= Daylim_past;
--			if Months= "0001" then
--				EMonths<= "1100";
--				EYears<= unsigned(Years) - "000000000001";
--			else
--				EMonths<= unsigned(Months)- "0001";
---				EYears<= unsigned(Years);
--			end if;	
--		else
--			EDays<= unsigned(Days)- "00001";
--			EMonths<=unsigned(Months);
--			EYears<=unsigned(Years);
--		end if;
--

	else
		earthHours<=(Unsigned(EHours) + zoneNum +DST- "11000");
		if Days =(Daylim_present) then 
			EDays<="00001";
			if Months="1100" then 
				EMonths<="0001";
				EYears<=Unsigned(Years) + "000000000001";
			else
				EMonths<=unsigned(Months) + "0001";
				EYears<=unsigned(Years);
			end if;
		else 
			EDays<=unsigned(Days) + "00001";
			EMonths<=unsigned(Months);
			EYears<=unsigned(Years);
		end if;
	end if;

else

	if (Unsigned(EHours) + zoneNum +DST )> "11000" then
		earthHours<= (Unsigned(EHours) + zoneNum +DST- "11000" );	
		EDays<=unsigned(Days);
		EMonths<=unsigned(Months);
		EYears<=unsigned(Years);
	else
		earthHours<= (Unsigned(EHours) + zoneNum +DST );
		if Days="00001" then
			EDays<= unsigned(Daylim_past);
			if Months= "0001" then
				EMonths<= "1100";
				EYears<= unsigned(Years) - "000000000001";
			else
				EMonths<= unsigned(Months)- "0001";
				EYears<= unsigned(Years);
			end if;	
		else
			EDays<= unsigned(Days)- "00001";
			EMonths<=unsigned(Months);
			EYears<=unsigned(Years);
		end if;
	end if;
end if;

end process;
end behavior;

