---------------------------------------------------------------------
-- Design unit: misr(rtl) (Entity and Architecture)
--            :
-- File name  : MISR.vhd
--            :
-- Description: Synthesizable RTL model of misr counter
--            :
-- Limitations: None
--            : 
-- System     : VHDL'93, STD_LOGIC_1164
--            :
-- Author     : Mark Zwolinski
--            : Department of Electronics and Computer Science
--            : University of Southampton
--            : Southampton SO17 1BJ, UK
--            : mz@ecs.soton.ac.uk
--
-- Revision   : Version 1.0 12/08/98
---------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity MISR is
  generic(n : integer  := 32);
  port(instruction : in std_logic_vector(n-1 downto 0);			-- from execution logic     
       clk : in std_logic;													-- from the environment
		 reset : in std_logic;												-- from control unit	 
		 enable : std_logic;													-- from execution logic
		 signature : out std_logic_vector(n-1 downto 0));			-- to multiplexer
end entity MISR;

architecture rtl of MISR is

	type tap_table is array (1 to 36, 1 to 4) of integer range -1 to 36;

	constant taps : tap_table := (
	 ( 0, -1, -1, -1), -- 1
	 ( 1,  0, -1, -1), -- 2
	 ( 1,  0, -1, -1), -- 3
	 ( 1,  0, -1, -1), -- 4
	 ( 2,  0, -1, -1), -- 5
	 ( 1,  0, -1, -1), -- 6
	 ( 1,  0, -1, -1), -- 7
	 ( 6,  5,  1,  0), -- 8
	 ( 4,  0, -1, -1), -- 9
	 ( 3,  0, -1, -1), --10
	 ( 2,  0, -1, -1), --11
	 ( 7,  4,  3,  0), --12
	 ( 4,  3,  1,  0), --13
	 (12, 11,  1,  0), --14
	 ( 1,  0, -1, -1), --15
	 ( 5,  3,  2,  0), --16
	 ( 3,  0, -1, -1), --17
	 ( 7,  0, -1, -1), --18
	 ( 6,  5,  1,  0), --19 
	 ( 3,  0, -1, -1), --20
	 ( 2,  0, -1, -1), --21
	 ( 1,  0, -1, -1), --22
	 ( 5,  0, -1, -1), --23
	 ( 4,  3,  1,  0), --24
	 ( 3,  0, -1, -1), --25
	 ( 8,  7,  1,  0), --26
	 ( 8,  7,  1,  0), --27
	 ( 3,  0, -1, -1), --28
	 ( 2,  0, -1, -1), --29
	 (16, 15,  1,  0), --30
	 ( 3,  0, -1, -1), --31
	 (28, 27,  1,  0), --32
	 (13,  0, -1, -1), --33
	 (15, 14,  1,  0), --34
	 ( 2,  0, -1, -1), --35
	 (11,  0, -1, -1)); --36

begin
	process(clk, reset) is
		variable reg : std_logic_vector(n-1 downto 0);
		variable feedback : std_logic;
	begin
		if reset = '1' then
			reg := (others => '1');
	   elsif (rising_edge(clk) and enable = '1') then 
			feedback := reg(taps(n, 1));
			for i in 2 to 4 loop
				if taps(n, i) >= 0 then
					feedback := feedback xor reg(taps(n, i));
				end if;
			end loop;
			for j in 0 to n-2 loop
				reg(j) := reg(j+1) xor instruction(j);
			end loop;
			reg(n-1) := feedback xor instruction(n-1);
	  end if;
	  signature <= reg;
	end process;
end architecture rtl;