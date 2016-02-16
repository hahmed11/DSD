-- this circuit computes the number of seconds since midnight given
-- the current time in HOurs (using a 24-hour notation), Minutes, and Seconds 
--
-- entity name: g30_7_segment_decoder
--
-- Copyright (C) 2014 Habid Ahmed and Bo Zheng
-- Version 1.0
-- Bo Zheng; bo.zheng@mail.mcgill.ca, Habib Ahmed; habib.ahmed@mail.mcgill.ca
-- Date: Feb. 7, 2014

library ieee;
use ieee.std_logic_1164.all; -- allows use of the std_logic_vector type
use ieee.numeric_std.all; -- allows use of the unsigned type


entity g30_7_segment_decoder is 

port ( code : in std_logic_vector ( 3 downto 0);
		RippleBlank_In : in std_logic;
		RippleBlank_Out: out std_logic;
		segments : out std_logic_vector(6 downto 0));

end g30_7_segment_decoder;
		
architecture behavior of g30_7_segment_decoder is

signal result: std_logic_vector(7 downto 0);
begin

with ( RippleBlank_In & code )  select
result <= 
	"01000000" when "00000",
	"01111001" when "00001",
	"00100100" when "00010",
	"00110000" when "00011",
	"00011001" when "00100",
	"00010010" when "00101",
	"00000010" when "00110",
	"01111000" when "00111",
	"00000000" when "01000",
	"00010000" when "01001",
	"00001000" when "01010",
	"00000011" when "01011",
	"01000110" when "01100",
	"00100001" when "01101",
	"00000110" when "01110",
	"00001110" when "01111",
	
	"11111111" when "10000",
	"01111001" when "10001",
	"00100100" when "10010",
	"00110000" when "10011",
	"00011001" when "10100",
	"00010010" when "10101",
	"00000010" when "10110",
	"01111000" when "10111",
	"00000000" when "11000",
	"00010000" when "11001",
	"00001000" when "11010",
	"00000011" when "11011",
	"01000110" when "11100",
	"00100001" when "11101",
	"00000110" when "11110",
	"00001110" when "11111";
	
RippleBlank_Out <= result(7);
segments <= result(6 downto 0);	
end behavior;

