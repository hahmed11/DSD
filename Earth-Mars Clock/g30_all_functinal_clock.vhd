-- entity name:g30_Controller 
--
-- Copyright (c) 2014 Bo Zheng and Habib Ahmed
-- Version 1.0
-- Author: Bo Zheng; Habib Ahmed;bo.zheng@mail.mcgill.ca;habib.ahmed@mail.mcgill.ca
-- Date: Jan 23rd, 2014
library ieee;
use ieee.std_logic_1164.all; -- allows use of the std_logic_vector type
use ieee.numeric_std.all; -- allows use of the unsigned type


entity g30_all_functinal_clock is

port(  clock, cReset, aReset,pb0 , DSTsw9:in std_logic;
	sw0_3: in std_logic_vector (3 downto 0);
	sw4_8: in std_logic_vector (4 downto 0);
 
segment1, segment2, segment3,segment4 : out std_logic_vector(6 downto 0)
);

end g30_all_functinal_clock;

architecture behavior of g30_all_functinal_clock is



component g30_Controller 
port(
clock, reset, w:in std_logic;
enable,display_en,zone_en,Eload_en,Mload_en,EDload_en, sychr_en:out std_logic);

end component;



component g30_Mars_Earth_clock 
port ( reset: in std_logic; 
		clock, enable, Eload_enable, Mload_enable: in std_logic;
		MH_Set,EH_Set: in std_logic_vector(4 downto 0);
		MM_Set,EM_Set, MS_Set,ES_Set: in std_logic_vector(5 downto 0);
		EHours: out std_logic_vector(4 downto 0);
		EMinutes, ESeconds: out std_logic_vector(5 downto 0);
		Eend_of_day: out std_logic;
		MHours: out std_logic_vector(4 downto 0);
		MMinutes, MSeconds: out std_logic_vector(5 downto 0);
		Mend_of_day: out std_logic );

end component;

component g30_YMD_Counter 
port (reset: in std_logic; 
		clock: in std_logic;
		day_count_en:in std_logic;
		load_enable: in std_logic;
		Y_Set: in std_logic_vector (11 downto 0);
		M_Set: in std_logic_vector (3 downto 0);
		D_Set: in std_logic_vector (4 downto 0);
		Years:out std_logic_vector (11 downto 0);
		Months: out std_logic_vector (3 downto 0);
		Days: out std_logic_vector (4 downto 0));

end component;

component g30_UTC_to_MTC 
Port( enable,clock,reset: in std_logic;
		load_enable: in std_logic;
		Ehour_f: in std_logic_vector(4 downto 0);
		Eminute_f, Esecond_f: in std_logic_vector(5 downto 0); 
		Eyear_f: in std_logic_vector (11 downto 0);  
		Emonth_f: in std_logic_vector (3 downto 0); 
		Eday_f: in std_logic_vector (4 downto 0); 
		
		MTC:out unsigned(74 downto 0);
		MHours: out std_logic_vector(4 downto 0);
		MMinutes,MSeconds: out std_logic_vector(5 downto 0);
		JD2000: out unsigned(54 downto 0));
		
end component;

component g30_7_segment_decoder
port ( code : in std_logic_vector ( 3 downto 0);
		RippleBlank_In : in std_logic;
		RippleBlank_Out: out std_logic;
		segments : out std_logic_vector(6 downto 0));

end component;

component g30_timezone_DST_modifier

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

end component;

component g30_setTimeDate_modifier
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

end component;

component g30_Marstime_modifier
	port (MHours:in std_logic_vector (4 downto 0);
	zoneNum: in unsigned (4 downto 0);
	MSeconds,MMinutes: in std_logic_vector(5 downto 0);
	marsSeconds,marsMinutes: out unsigned (5 downto 0);
	marsHours:out unsigned (4 downto 0));

end component;

component g30_binary_to_BCD
port( clock: in std_logic; 
		bin: in unsigned (5 downto 0);
		BCD: out std_logic_vector(7 downto 0));
end component;

signal zoneNum: unsigned (4 downto 0);
---signals from the controller
signal enable,display_en,zone_en,Eload_en,Mload_en,EDload_en, sychr_en: std_logic;

--signals from mars & earth clock
signal MH_Set,EH_Set: std_logic_vector(4 downto 0);
signal MM_Set,EM_Set, MS_Set,ES_Set: std_logic_vector(5 downto 0);
signal EHours: std_logic_vector(4 downto 0);
signal EMinutes, ESeconds:  std_logic_vector(5 downto 0);
signal Eend_of_day:  std_logic;
signal MHours:  std_logic_vector(4 downto 0);
signal MMinutes, MSeconds:  std_logic_vector(5 downto 0);
signal Mend_of_day:  std_logic; 

--signal form YMD counter
signal Y_Set: std_logic_vector (11 downto 0);
signal M_Set: std_logic_vector (3 downto 0);
signal D_Set: std_logic_vector (4 downto 0);
signal Years: std_logic_vector (11 downto 0);
signal Months: std_logic_vector (3 downto 0);
signal Days: std_logic_vector (4 downto 0);

--signals from UTC_to_MTC converter, which are not actually useful in this lab
signal MTC: unsigned(74 downto 0);
signal JD2000: unsigned(54 downto 0);

--signals from lcd decoder
signal LCD1,LCD2,LCD3,LCD4 :std_logic_vector ( 3 downto 0);
signal Ripi1,Ripi2,Ripi3,Ripi4: std_logic;---------------------
signal Ripo1,Ripo2,Ripo3,Ripo4: std_logic;---------------------
 

--signal from EarthTime modifier
signal earthSeconds,earthMinutes:  unsigned (5 downto 0);
signal	earthHours:unsigned (4 downto 0);
signal	EDays: unsigned (4 downto 0);
signal	EMonths: unsigned (3 downto 0);
signal	EYears: unsigned (11 downto 0);

--signal from  setTimeDate modifier

signal fES_Set,fEM_Set: unsigned (5 downto 0);
signal	fEH_Set: unsigned (4 downto 0);
signal	fD_Set: unsigned (4 downto 0);
signal	fM_Set:  unsigned (3 downto 0);
signal	fY_Set: unsigned (11 downto 0);


--signal from marsTime modifier
 
signal	marsSeconds,marsMinutes:  unsigned (5 downto 0);
signal	marsHours:  unsigned (4 downto 0);

signal minBCD: std_logic_vector(7 downto 0);
begin

---set up the controller
controller: g30_Controller
port map(clock=>clock, reset=>not cReset, w=>not pb0, 
enable=>enable,display_en=>display_en,zone_en=>zone_en,Eload_en=>Eload_en,Mload_en=>Mload_en,EDload_en=>EDload_en, sychr_en=>sychr_en);

---set up the Mars Earth clock
MarEarClock: g30_Mars_Earth_clock
port map( reset=> not aReset, clock=>clock, enable=>enable,Eload_enable=>Eload_en, Mload_enable=>Mload_en,MH_Set=>MH_Set, EH_Set=>std_logic_vector(fEH_Set), MM_Set=>MM_Set, MS_Set=>MS_Set,
			EM_Set=>std_logic_vector(fEM_Set), ES_Set=>std_logic_vector(fES_Set), EHours=>EHours, EMinutes=>EMinutes, ESeconds=>ESeconds, Eend_of_day=>Eend_of_day, MHours=>MHours, MMinutes=>MMinutes, 
			MSeconds=>MSeconds, Mend_of_day=>Mend_of_day);
		
---set up the YMD counter
EarthYMD:g30_YMD_Counter
port map(reset=>not aReset, 
		clock=>clock,
		day_count_en=>Eend_of_day,
		load_enable=>EDload_en,
		Y_Set=>std_logic_vector(fY_Set),
		M_Set=>std_logic_vector(fM_Set),
		D_Set=> std_logic_vector(fD_Set),
		Years=>Years,
		Months=> Months,
		Days=> Days);
		
---set up the UTC to MTC converter

UTC2MTC:g30_UTC_to_MTC
port map(
        enable=>'1',clock=>clock,reset=>aReset,
		load_enable=>sychr_en,
		Ehour_f=>EH_Set,
		Eminute_f=>EM_Set, Esecond_f=>ES_Set, 
		Eyear_f=>Y_Set,  
		Emonth_f=>M_Set, 
		Eday_f=>D_Set, 
		MTC=>MTC,
		MHours=>MH_Set,
		MMinutes=>MM_Set,MSeconds=>MS_Set,
		JD2000=>JD2000);

---modify the HMS & YMD those will be displayed based on zone number and DST
ETDmodifier: g30_timezone_DST_modifier 
port map(EHours=>EHours,
	zoneNum=>zoneNum,
	DSTsw9=>DSTsw9,
	Days=>Days,
	Months=>Months,
	Years=>Years,
	ESeconds=>ESeconds,EMinutes=>EMinutes,
	earthSeconds=>earthSeconds,earthMinutes=>earthMinutes,
	earthHours=>earthHours,
	EDays=>EDays,
	EMonths=>EMonths,
	EYears=>EYears);


---modify the setting value of HMS & YMD based on zone number and DST

setTimeModifier: g30_setTimeDate_modifier	
port map(EHours=>EH_Set,
	zoneNum=>zoneNum,
	DSTsw9=>DSTsw9,
	Days=>D_Set,
	Months=>M_Set,
	Years=>Y_Set,
	ESeconds=>ES_Set,EMinutes=>EM_Set,
	earthSeconds=>fES_Set,earthMinutes=>fEM_Set,
	earthHours=>fEH_Set,
	EDays=>fD_Set,
	EMonths=>fM_Set,
	EYears=>fY_Set);

 

---modify the mars time based on the zone number and DST
marsTimeModifier: g30_Marstime_modifier
	port map (MHours=>MHours,
	zoneNum=>zoneNum,
	MSeconds=>MSeconds,MMinutes=>MMinutes,
	marsSeconds=>marsSeconds,marsMinutes=>marsMinutes,
	marsHours=>marsHours);

Bi2BCD:  g30_binary_to_BCD
	port map( clock=> clock, 
		bin=>earthMinutes,
		BCD=>minBCD);




--set up the four LEDs
Lcdseg1:g30_7_segment_decoder
port map(
code=>LCD1, RippleBlank_In=>'0', RippleBlank_Out=>Ripo1, segments=>segment1);

Lcdseg2:g30_7_segment_decoder
port map(
code=>LCD2, RippleBlank_In=>Ripo3, RippleBlank_Out=>Ripo2, segments=>segment2);

Lcdseg3:g30_7_segment_decoder
port map(
code=>LCD3, RippleBlank_In=>Ripo4, RippleBlank_Out=>Ripo3, segments=>segment3);

Lcdseg4:g30_7_segment_decoder
port map(
code=>LCD4, RippleBlank_In=>'1', RippleBlank_Out=>Ripo4, segments=>segment4);

--process(zoneNum)
--		
--begin
--
--if zoneNum > "01011" then
--		if unsigned(EHours)> ("11000"-ZoneNum) than
--			earthhours<= unsigned(EHours)+zoneNum-"11000";
--		else
--			earthhours<=unsigned(Ehours)+zoneNum;
--			if Days="00001" then 
--				Days<=Daylim_past;
--				if Months="1100" then year
--			else
--				Days<=Days-"00001";
	
--eS<="000000";
--eM<="000000";
--eH<="00000";
--LCD1<= "1000";
--LCD2<= "1000";
--LCD3<= "1000";
--LCD4<= "1000";	
--zoneNum<="00000";
--D_Set<="00000";
--M_Set<="0000";
--Y_Set<="000000000000";
--ES_Set<="000000";
--EM_Set<="000000";
--EH_Set<="00000";


	
process(all) 
--enable,display_en,zone_en,Eload_en,Mload_en,EDload_en, sychr_en,earthSeconds,earthMinutes,earthHours,EDays,EMonths,EYears,marsSeconds,
	--		marsMinutes, marsHours,sw4_8,sw0_3,DSTsw9)

begin	
if display_en='1' then


	if sw0_3= "0000" then
		LCD1<= std_logic_vector(to_unsigned((to_integer(earthSeconds) mod 10), 4));
		LCD2<= std_logic_vector(to_unsigned(((to_integer(earthSeconds)/10) mod 10), 4));
		LCD3<= "0000";
		LCD4<= "0000";
	
	elsif sw0_3= "0001" then

		LCD1<= minBCD(3 downto 0);
		LCD2<= minBCD(7 downto 4);
--		LCD1<= std_logic_vector(to_unsigned((to_integer(earthMinutes) mod 10), 4));
--		LCD2<= std_logic_vector(to_unsigned(((to_integer(earthMinutes)/10) mod 10), 4));
		LCD3<= "0000";
		LCD4<= "0000";

	elsif sw0_3= "0010" then
		LCD1<= std_logic_vector(to_unsigned((to_integer(earthHours) mod 10), 4));
		LCD2<= std_logic_vector(to_unsigned(((to_integer(earthHours)/10) mod 10), 4));
		LCD3<= "0000";
		LCD4<= "0000";

	elsif sw0_3= "0011" then
		LCD1<=std_logic_vector(to_unsigned((to_integer(EDays) mod 10), 4));
		LCD2<= std_logic_vector(to_unsigned(((to_integer(EDays)/10) mod 10), 4));
		LCD3<= "0000";
		LCD4<= "0000";

	elsif sw0_3= "0100" then

		LCD1<=std_logic_vector(to_unsigned((to_integer(EMonths) mod 10), 4));
		LCD2<= std_logic_vector(to_unsigned(((to_integer(EMonths)/10) mod 10), 4));
		LCD3<= "0000";
		LCD4<= "0000";
	
	elsif sw0_3= "0101" then
		LCD1<= std_logic_vector(to_unsigned((to_integer(EYears) mod 10), 4));
		LCD2<= std_logic_vector(to_unsigned(((to_integer(EYears)/10) mod 10), 4));
		LCD3<= std_logic_vector(to_unsigned(((to_integer(EYears)/100) mod 10), 4));
		LCD4<= std_logic_vector(to_unsigned(((to_integer(EYears)/1000) mod 10), 4));
		
	elsif sw0_3= "0110" then
		
		LCD1<= std_logic_vector(to_unsigned((to_integer(marsSeconds) mod 10), 4));
		LCD2<= std_logic_vector(to_unsigned(((to_integer(marsSeconds)/10) mod 10), 4));
		LCD3<= "0000";
		LCD4<= "0000";
	
	elsif sw0_3= "0111" then
		LCD1<= std_logic_vector(to_unsigned((to_integer(marsMinutes) mod 10), 4));
		LCD2<= std_logic_vector(to_unsigned(((to_integer(marsMinutes)/10) mod 10), 4));
		LCD3<= "0000";
		LCD4<= "0000";

	elsif sw0_3= "1000" then
		LCD1<= std_logic_vector(to_unsigned((to_integer(marsHours) mod 10), 4));
		LCD2<= std_logic_vector(to_unsigned(((to_integer(marsHours)/10) mod 10), 4));
		LCD3<= "0000";
		LCD4<= "0000";

		-- when the switch is selected a N/A mode, it displays 8888


	end if;

elsif zone_en='1' then
	zoneNum<= unsigned (sw4_8);
	LCD1<=std_logic_vector(to_unsigned((to_integer(unsigned (sw4_8)) mod 10), 4));
	LCD2<= std_logic_vector(to_unsigned(((to_integer(unsigned (sw4_8))/10) mod 10), 4));
	LCD3<= "0000";
	LCD4<= "0000";

elsif EDload_en='1' then 
	if sw4_8( 4 downto 3) = "00" then
		D_Set<= sw4_8(0) & sw0_3;
		LCD1<=std_logic_vector(to_unsigned((to_integer(unsigned(sw4_8(0) & sw0_3)) mod 10), 4));
		LCD2<= std_logic_vector(to_unsigned(((to_integer(unsigned(sw4_8(0) & sw0_3))/10) mod 10), 4));
		LCD3<= "0000";
		LCD4<= "0000";

	elsif sw4_8(4 downto 3) = "01" then
		M_Set<= sw0_3;
		LCD1<=std_logic_vector(to_unsigned((to_integer(unsigned(sw0_3)) mod 10), 4));
		LCD2<= std_logic_vector(to_unsigned(((to_integer(unsigned(sw0_3))/10) mod 10), 4));
		LCD3<= "0000";
		LCD4<= "0000";


	elsif sw4_8(4 downto 3) = "11" then
		Y_Set<=std_logic_vector( "011111010000" + unsigned("00000" & sw4_8(2 downto 0) & sw0_3));
		LCD1<= std_logic_vector(to_unsigned((to_integer("011111010000" + unsigned("00000" & sw4_8(2 downto 0) & sw0_3)) mod 10), 4));
		LCD2<= std_logic_vector(to_unsigned(((to_integer("011111010000" + unsigned("00000" & sw4_8(2 downto 0) & sw0_3))/10) mod 10), 4));
		LCD3<= std_logic_vector(to_unsigned(((to_integer("011111010000" + unsigned("00000" & sw4_8(2 downto 0) & sw0_3))/100) mod 10), 4));
		LCD4<= std_logic_vector(to_unsigned(((to_integer("011111010000" + unsigned("00000" & sw4_8(2 downto 0) & sw0_3))/1000) mod 10), 4));
	---------------------------------------------------------------------------	
	end if;


elsif Eload_en='1'  then
	if sw4_8( 4 downto 3) = "00" then
		ES_Set<= sw4_8(1 downto 0) & sw0_3;
		LCD1<=std_logic_vector(to_unsigned((to_integer(unsigned(sw4_8(1 downto 0) & sw0_3)) mod 10), 4));
		LCD2<= std_logic_vector(to_unsigned(((to_integer(unsigned(sw4_8(1 downto 0) & sw0_3))/10) mod 10), 4));
		LCD3<= "0000";
		LCD4<= "0000";


	elsif sw4_8(4 downto 3) = "01" then
		EM_Set<=sw4_8(1 downto 0) & sw0_3 ;
		LCD1<=std_logic_vector(to_unsigned((to_integer(unsigned(sw4_8(1 downto 0) & sw0_3)) mod 10), 4));
		LCD2<= std_logic_vector(to_unsigned(((to_integer(unsigned(sw4_8(1 downto 0) & sw0_3))/10) mod 10), 4));
		LCD3<= "0000";
		LCD4<= "0000";

	elsif sw4_8(4 downto 3) ="11" then
		EH_Set<= sw4_8(0) & sw0_3;
		LCD1<=std_logic_vector(to_unsigned((to_integer(unsigned(sw4_8(0) & sw0_3)) mod 10), 4));
		LCD2<= std_logic_vector(to_unsigned(((to_integer(unsigned(sw4_8(0) & sw0_3))/10) mod 10), 4));
		LCD3<= "0000";
		LCD4<= "0000";

	end if;


end if;

end process;


end behavior;