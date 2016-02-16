
library ieee;
use ieee.std_logic_1164.all; -- allows use of the std_logic_vector type
use ieee.numeric_std.all; -- allows use of the unsigned type


entity g30_Marstime_modifier is

port (MHours:in std_logic_vector (4 downto 0);
	zoneNum: in unsigned (4 downto 0);
	MSeconds,MMinutes: in std_logic_vector(5 downto 0);
	marsSeconds,marsMinutes: out unsigned (5 downto 0);
	marsHours:out unsigned (4 downto 0));

end g30_Marstime_modifier;


architecture behavior of g30_Marstime_modifier is

begin

process (MHours, zoneNum, MSeconds, MMinutes)
begin
marsSeconds<= unsigned(MSeconds);
marsMinutes<=unsigned(MMinutes);

if zoneNum < "01100" then 
	if (Unsigned(MHours) + zoneNum)< "11000" then
		marsHours<= (Unsigned(MHours) + zoneNum );
		

	else
		marsHours<=(Unsigned(MHours) + zoneNum - "11000");
		
	end if;

else

	if (Unsigned(MHours) + zoneNum )> "11000" then
		marsHours<= (Unsigned(MHours) + zoneNum - "11000" );	
		
	else
		marsHours<= (Unsigned(MHours) + zoneNum );
		
	end if;
end if;

end process;
end behavior;




