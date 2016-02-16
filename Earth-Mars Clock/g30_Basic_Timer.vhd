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

entity g30_Basic_Timer is
port( reset: in std_logic; 
		clk: in std_logic;
		enable:in std_logic;
		EPULSE: out std_logic;
		MPULSE: out std_logic);

end g30_Basic_Timer;

architecture behavior of g30_Basic_Timer is

signal A: std_logic;
signal B,E: std_logic_vector(25 downto 0);
signal C,F: std_logic_vector(25 downto 0);
signal D,G: std_logic;
signal H: std_logic;

begin

A<= (not D) OR reset;

const1: lpm_constant
Generic map(
	lpm_width=>26,
	lpm_cvalue=> 49999999
	)
port map(result(25 downto 0)=>B);

counter1: lpm_counter 
Generic Map( lpm_width=>26)
port map (updown=>'0',clock=>clk, sload=> A, data=> B, cnt_en=>enable, q(25 downto 0)=>C);



with C select
D <= 
	'0' when "00000000000000000000000000",
	'1' when others;


EPULSE<= (not D);


H<=(not G) OR reset;
const2: lpm_constant
Generic map(
	lpm_width=>26,
	lpm_cvalue=> 51374562
	)
port map(result(25 downto 0)=>E);

counter2: lpm_counter 
Generic Map( lpm_width=>26)
port map (clock=>clk, updown=>'0', sload=> H, data(25 downto 0)=> E, cnt_en=>enable, q(25 downto 0)=>F);

with F select
G <= 
	'0' when "00000000000000000000000000",
	'1' when others;
	
MPULSE<= (not G);
end behavior;


