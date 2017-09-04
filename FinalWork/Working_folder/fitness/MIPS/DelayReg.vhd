----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    11:54:59 12/17/2016 
-- Design Name: 
-- Module Name:    DelayReg - Behavioral 
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity DelayReg is
    Port ( data_in : in  STD_LOGIC_VECTOR (1 downto 0);
           clk : in  STD_LOGIC;
           data_out : out  STD_LOGIC_VECTOR (1 downto 0));
end DelayReg;

architecture Behavioral of DelayReg is
	signal tmp : std_logic_vector (1 downto 0) := (others => 'Z');
begin
	process(clk)
	begin
		tmp <= data_in;
		data_out <= tmp;
	end process;

end Behavioral;

