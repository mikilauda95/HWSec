----------------------------------------------------------------------------------
-- Company: Politecnico di Torino
-- Engineer: Alessandro Salvato
-- 
-- Create Date:    12:34:19 12/11/2016 
-- Design Name: 
-- Module Name:    multiplexer - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity multiplexer is
    Port ( a : in  STD_LOGIC_VECTOR (31 downto 0);		--from profiler
           b : in  STD_LOGIC_VECTOR (31 downto 0);		--from MISR
           sel : in  STD_LOGIC_VECTOR (1 downto 0);	--from control logic
           y : out  STD_LOGIC_VECTOR (31 downto 0));	--to environment
end multiplexer;

architecture Behavioral of multiplexer is

begin

	process(a, b, sel)
	begin
		case sel is
			when "00" => y <= a;
			when "01" => y <= b;
			when others => y <= (others => 'Z');
		end case;
	end process;

end Behavioral;

