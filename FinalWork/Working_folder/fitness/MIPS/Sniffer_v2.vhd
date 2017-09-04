library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Sniffer_v2 is
    PORT(
            read_bus: IN std_logic_vector(31 downto 0);
            reset: in std_logic;
            configuration_word: IN std_logic_vector(31 downto 0);
            clk: IN std_logic;
            stall : in  STD_LOGIC;
            pr_bra_bad: in STD_LOGIC;
            EX_uncleared : in STD_LOGIC;
            trojan_payload: out std_logic;
            data_out: out std_logic_vector(31 downto 0);

        --bypass section

            bypass_instr_out_to_macro: out  std_logic_vector(31 downto 0);
            bypass_valid_to_macro: out  std_logic

        );
           -- bypass_load: out  std_logic_vector(5 downto 0);   
           -- bypass_store: out  std_logic_vector(5 downto 0);

end Sniffer_v2;

architecture Behavioral of Sniffer_v2 is

component Computing_Unit is
    Port ( instruction_code : in  STD_LOGIC_VECTOR (5 downto 0);
           signature : in  STD_LOGIC_VECTOR  (31 downto 0);
           clk : in  STD_LOGIC;
			  Reset_cpu: in STD_LOGIC;
           configuration_word : in  STD_LOGIC_VECTOR (31 downto 0);
			  valid_instruction_code: std_logic;
           out_mux : out  STD_LOGIC_VECTOR (31 downto 0));
end component;

component Instr_decoder is
    Port ( instruction : in  STD_LOGIC_VECTOR (31 downto 0);				-- from fetch stage
		     index : out  STD_LOGIC_VECTOR (5 downto 0)
		   );
end component;

component ExecutionLogic is
    Port ( index_in : in  STD_LOGIC_VECTOR (5 downto 0);
           instr_in : in  STD_LOGIC_VECTOR (31 downto 0);
           clk : in  STD_LOGIC;
			  stall : in  STD_LOGIC;
			  pr_bra_bad: in STD_LOGIC;
			  EX_uncleared : in STD_LOGIC;
			  reset : in std_logic;
           index_out : out  STD_LOGIC_VECTOR (5 downto 0);
           instr_out : out  STD_LOGIC_VECTOR (31 downto 0);
           valid : out  STD_LOGIC);
end component;

component Trojan is
    Port ( op_code : in  STD_LOGIC_VECTOR (5 downto 0);				-- from execution logic
			  reset : in STD_LOGIC;												-- from control logic. synchronous (TBD)
			  clk : in STD_LOGIC;												-- from the environment
			  enable : in std_logic;											-- from execution logic
           payload : out  STD_LOGIC);										-- to the victim flip flop / environment
end component;

component MISR is
  generic(n : integer  := 32);
  port(instruction : in std_logic_vector(n-1 downto 0);			-- from execution logic     
       clk : in std_logic;													-- from the environment
		 reset : in std_logic;												-- from control unit	 
		 enable : std_logic;													-- from execution logic
		 signature : out std_logic_vector(n-1 downto 0));			-- to multiplexer
end component;

signal index_dec_to_el: std_logic_vector(5 downto 0);
signal index_el_to_comp_unit: std_logic_vector(5 downto 0);
signal instr_el_to_MISR: std_logic_vector(31 downto 0);

signal signature_MISR_to_profiler: std_logic_vector(31 downto 0);
signal el_enable : stD_logic;

for TRO : Trojan use entity work.Trojan(v1);

begin
	DEC: Instr_decoder PORT MAP(instruction => read_bus, index => index_dec_to_el);
	
	EXLOG : ExecutionLogic PORT MAP(
										  index_in => index_dec_to_el,
										  instr_in => read_bus,
										  clk => clk,
										  stall => stall,
										  pr_bra_bad => pr_bra_bad,
										  EX_uncleared => EX_uncleared,
										  reset => reset,
										  index_out => index_el_to_comp_unit,
										  instr_out => instr_el_to_MISR,
										  valid => el_enable);
	
	
	MSR: MISR Generic MAP(N => 32) PORT MAP(instruction => instr_el_to_MISR,
														 clk => clk,
														 reset => reset,
														 enable => el_enable,
														 signature => signature_MISR_to_profiler);
											
	TRO: Trojan PORT MAP(op_code => index_el_to_comp_unit,
						      reset => reset,
								clk => clk,
								enable => el_enable,
								payload => trojan_payload);
								
	CU: Computing_Unit PORT MAP(instruction_code => index_el_to_comp_unit,
										 signature => signature_MISR_to_profiler,
										 clk => clk,
										 configuration_word => configuration_word,
										 valid_instruction_code => el_enable,
										 out_mux => data_out,
										 Reset_cpu => reset);
	
--bypass section

    bypass_instr_out_to_macro <= instr_el_to_MISR;
    bypass_valid_to_macro <= el_enable; 

end Behavioral;



