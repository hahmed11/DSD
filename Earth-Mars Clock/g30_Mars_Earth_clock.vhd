-- this circuit tests the g30_Earth_Basic_Timer circuit on the Altera board 
--
-- entity name: g30_Earth_Basic_Timer
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

entity g30_Mars_Earth_clock is
port( 	reset: in std_logic; 
		clock, enable, Eload_enable, Mload_enable: in std_logic;
		MH_Set,EH_Set: in std_logic_vector(4 downto 0);
		MM_Set,EM_Set, MS_Set,ES_Set: in std_logic_vector(5 downto 0);
		EHours: out std_logic_vector(4 downto 0);
		EMinutes, ESeconds: out std_logic_vector(5 downto 0);
		Eend_of_day: out std_logic;
		MHours: out std_logic_vector(4 downto 0);
		MMinutes, MSeconds: out std_logic_vector(5 downto 0);
		Mend_of_day: out std_logic );

end g30_Mars_Earth_clock;

architecture behavior of g30_Mars_Earth_clock is

	COMPONENT g30_HMS_Counter
	PORT(
		reset: in std_logic; 
		clock, sec_clock, load_enable: in std_logic;
		H_Set: in std_logic_vector(4 downto 0);
		M_Set, S_Set: in std_logic_vector(5 downto 0);
		Hours: out std_logic_vector(4 downto 0);
		Minutes, Seconds: out std_logic_vector(5 downto 0);
		end_of_day: out std_logic 
	);
	end COMPONENT;
	
	COMPONENT g30_Basic_Timer
	PORT(
		reset: in std_logic; 
		clk: in std_logic;
		enable:in std_logic;
		EPULSE: out std_logic;
		MPULSE: out std_logic
	);
	end COMPONENT;
	
	signal e_sec_clock: std_logic;
	signal m_sec_clock: std_logic;
begin

 
	basicTimer: g30_Basic_Timer
	PORT MAP(
		reset => reset,
		clk => clock,
		enable => enable,
		EPULSE => e_sec_clock,
		MPULSE => m_sec_clock
	);
	
	earthCounter: g30_HMS_Counter
	PORT MAP(
		reset => reset,
		clock => clock,
		sec_clock => e_sec_clock,
		load_enable => Mload_enable,
		H_Set => EH_Set,
		M_Set => EM_Set,
		S_Set => ES_Set,
		Hours => EHours,
		Minutes => EMinutes,
		Seconds => ESeconds,
		end_of_day => Eend_of_day
	);
	
	marsCounter: g30_HMS_Counter
	PORT MAP(
		reset => reset,
		clock => clock,
		sec_clock => m_sec_clock,
		load_enable => Mload_enable,
		H_Set => MH_Set,
		M_Set => MM_Set,
		S_Set => MS_Set,
		Hours => MHours,
		Minutes => MMinutes,
		Seconds => MSeconds,
		end_of_day => Mend_of_day
	);
end behavior;
