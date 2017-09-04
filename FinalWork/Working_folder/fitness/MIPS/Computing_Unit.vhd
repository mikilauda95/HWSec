----------------------------------------------------------------------------------
-- Company: Politecnico di Torino
-- Engineer: Alessandro Salvato
-- 
-- Create Date:    12:59:30 12/11/2016 
-- Design Name: 	
-- Module Name:    Computing_Unit - Behavioral 
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

entity Computing_Unit is
    Port ( instruction_code : in  STD_LOGIC_VECTOR (5 downto 0);
           signature : in  STD_LOGIC_VECTOR  (31 downto 0);
           clk : in  STD_LOGIC;
			  Reset_cpu: in STD_LOGIC;
           configuration_word : in  STD_LOGIC_VECTOR (31 downto 0);
			  valid_instruction_code: std_logic;
           out_mux : out  STD_LOGIC_VECTOR (31 downto 0));
end Computing_Unit;

architecture Behavioral of Computing_Unit is

	component Control_Logic is
    Port ( configuration_word : in  STD_LOGIC_VECTOR (31 downto 0);		--from environment
           dump_end : in  STD_LOGIC;												--from profiler
           clk : in  STD_LOGIC;														--from environment
			  Reset_cpu: in STD_LOGIC;													--from environment
           count_max : out  STD_LOGIC_VECTOR (9 downto 0);					--to profiler
           target_instr : out  STD_LOGIC_VECTOR (5 downto 0);				--to profiler
           EnableRF : out  STD_LOGIC;												--to profiler
           WriteRF : out  STD_LOGIC;												--to profiler
           ReadRF : out  STD_LOGIC;												--to profiler
           EnableDump : out  STD_LOGIC;											--to profiler
           Reset : out  STD_LOGIC;													--to profiler
           Sel_mux : out  STD_LOGIC_VECTOR (1 downto 0);						--to multiplexer
           dump_detection : in  STD_LOGIC;										--from profiler
           carry_detection : in  STD_LOGIC);										--from profiler
	end component;
	
	component multiplexer is
    Port ( a : in  STD_LOGIC_VECTOR (31 downto 0);								--from profile
           b : in  STD_LOGIC_VECTOR (31 downto 0);								--from MISR (environmnet)
           sel : in  STD_LOGIC_VECTOR (1 downto 0);							--from contro logic
           y : out  STD_LOGIC_VECTOR (31 downto 0));							--to environment
	end component;
	
	component DelayReg is
    Port ( data_in : in  STD_LOGIC_VECTOR (1 downto 0);
           clk : in  STD_LOGIC;
           data_out : out  STD_LOGIC_VECTOR (1 downto 0));
	end component;
	
	component profiler is
    Port ( instruction_code : in  STD_LOGIC_VECTOR (5 downto 0); 			--from execution_logic
           count_max : in  STD_LOGIC_VECTOR (9 downto 0);					--from control logic (environment)
			  valid_instruction_code : in std_logic;								--from execution logic
           target_instr : in  STD_LOGIC_VECTOR (5 downto 0);				--from control logic
           Reset : in  STD_LOGIC;													--from control logic, it works in asyncronous way
           EnableRF : in  STD_LOGIC;												--from control logic
           WriteRF : in  STD_LOGIC;												--from control logic
           ReadRF : in  STD_LOGIC;												--from control logic
           EnableDump : in  STD_LOGIC;												--from control logic
           clk : in  STD_LOGIC;														--from the environment
           carry_detection : out  STD_LOGIC;										--to control logic
			  dump_detection: out std_logic;											--to control logic
			  dump_end: out std_logic;                                     --to control logic
           data_out : out  STD_LOGIC_VECTOR (31 downto 0));					--to multiplexer
	end component;
	
	signal dump_end_profiler_to_contrlogic: std_logic;
	signal count_max_contrlogic_to_profiler: std_logic_vector(9 downto 0);
	signal target_instr_contrlogic_to_profiler: std_logic_vector(5 downto 0);
	signal EnableRF_contrlogic_to_profiler: std_logic;
	signal WriteRF_contrlogic_to_profiler: std_logic;
	signal ReadRF_contrlogic_to_profiler: std_logic;
	signal EnableDump_contrlogic_to_profiler: std_logic;
	signal Reset_contrlogic_to_profiler: std_logic;
	signal Sel_mux_contrlogic_to_mux: std_logic_vector(1 downto 0);
	signal dump_detection_profiler_to_contrlogic: std_logic;
	signal carry_detection_profiler_to_contrlogic: std_logic;
	
	signal data_out_profiler_to_mux: std_logic_vector(31 downto 0);
	
	signal sel_mux_delayed: std_logic_vector(1 downto 0);
	
begin
	
	CL : Control_Logic PORT MAP( configuration_word => configuration_word,
										  dump_end => dump_end_profiler_to_contrlogic,
										  clk => clk, 
										  Reset_cpu => Reset_cpu,
										  count_max => count_max_contrlogic_to_profiler, 
										  target_instr => target_instr_contrlogic_to_profiler,
										  EnableRF => EnableRF_contrlogic_to_profiler,
										  WriteRF => WriteRF_contrlogic_to_profiler,
										  ReadRF => ReadRF_contrlogic_to_profiler,
										  EnableDump => EnableDump_contrlogic_to_profiler,
										  Reset => Reset_contrlogic_to_profiler,
										  Sel_mux => Sel_mux_contrlogic_to_mux,
										  dump_detection => dump_detection_profiler_to_contrlogic,
										  carry_detection => carry_detection_profiler_to_contrlogic);
	
	MUX: multiplexer PORT MAP ( a => data_out_profiler_to_mux,
										 b => signature,
										 sel => sel_mux_delayed,
										 y => out_mux);
	
	PRO: profiler PORT MAP ( instruction_code => instruction_code,
									 count_max => count_max_contrlogic_to_profiler,
									 target_instr => target_instr_contrlogic_to_profiler,
									 Reset => Reset_contrlogic_to_profiler,
									 EnableRF => EnableRF_contrlogic_to_profiler,
									 WriteRF => WriteRF_contrlogic_to_profiler,
									 ReadRF => ReadRF_contrlogic_to_profiler,
							       EnableDump => EnableDump_contrlogic_to_profiler,
									 clk => clk, 
									 dump_detection => dump_detection_profiler_to_contrlogic,
									 carry_detection => carry_detection_profiler_to_contrlogic,
									 dump_end => dump_end_profiler_to_contrlogic,
									 data_out => data_out_profiler_to_mux,
									 valid_instruction_code => valid_instruction_code);
		
	REG: DelayReg PORT MAP (data_in => Sel_mux_contrlogic_to_mux , clk => clk , data_out => sel_mux_delayed);
									 

end Behavioral;

