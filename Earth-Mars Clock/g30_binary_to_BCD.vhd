--entity name:g30_binary_to_BCD

-- Copyright (C) 2014 Habib Ahmed; Bo Zheng
-- Version 1.0
-- Bo Zheng; bo.zheng@mail.mcgill.ca, Habib Ahmed; habib.ahmed@mail.mcgill.ca
-- Date: Feb. 3rd, 2014

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library lpm;
use lpm.lpm_components.all;

entity g30_binary_to_BCD is
port( clock: in std_logic; 
		bin: in unsigned (5 downto 0);
		BCD: out std_logic_vector(7 downto 0));
end g30_binary_to_BCD;

architecture behavior of g30_binary_to_BCD is 
signal a: std_logic_vector(5 downto 0);
begin
a<= std_logic_vector(bin);
rom: lpm_rom

Generic map(

	lpm_widthad => 6,
	lpm_numwords => 64,
	lpm_outdata => "UNREGISTERED",
	lpm_address_control => "REGISTERED",
	lpm_file => "crc_rom.mif",
	lpm_width => 8) 
	PORT MAP(inclock => clock, address => a, q => BCD);
	
END behavior;
	
	