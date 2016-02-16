-- entity name:g30_Controller 
--
-- Copyright (c) 2014 Bo Zheng and Habib Ahmed
-- Version 1.0
-- Author: Bo Zheng; Habib Ahmed;bo.zheng@mail.mcgill.ca;habib.ahmed@mail.mcgill.ca
-- Date: Jan 23rd, 2014


entity g30_LCD_decoder is

port(

);

end g30_LCD_decoder;


architecture behavior of g30_LCD_decoder is

component g30_Controller 

port(

);

end component;



begin

Controller: g30_Controller;

port map(

);

process (lcd)

begin

case lcd is
	WHEN "00" =>
		if 