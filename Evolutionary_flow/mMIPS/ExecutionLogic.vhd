library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ExecutionLogic is
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
end ExecutionLogic;

architecture Behavioral of ExecutionLogic is
	type state_type is (START, FORWARD, WAIT_1, WAIT_EX, CLEAR);
	signal current_state, next_state: state_type;

	signal changed : std_logic;
	signal prev_bra_bad : std_logic;
	signal indexTmp : std_logic_vector (5 downto 0);
	signal instrTmp : std_logic_vector (31 downto 0);
	
	signal futureStall : std_logic_vector(1 downto 0) := (others => '0');

begin
	process (clk, reset)
	begin
		if (clk = '1' and clk'event) then
			if (reset = '1') then
				current_state <= START;
			else
				current_state <= next_state;
			end if;
		end if;
	end process;

	process (clk, current_state, changed) --index_in, instr_in, stall, changed, ex_uncleared, 
	variable c : integer := 3;
	begin
		if (clk = '1' or changed = '1') then
			if (clk = '1' and clk'event) then 
				c := c - 1;
				futureStall(0) <= futureStall(1);
				if (indexTmp = "101110" or indexTmp = "101111" or indexTmp = "010101" or indexTmp = "010110") then
					futureStall(1) <= '1';
				else 
					futureStall(1) <= '0';
				end if;
			end if;
		case current_state is 
				when START => 
					valid <= '0';
					c := 2;
					next_state <= FORWARD;
		
				when FORWARD =>	
					instr_out <= instrTmp; 
					index_out <= indexTmp;
					instrTmp <= instr_in;
					indexTmp <= index_in;
					valid <= '0';
					if (c <= 0) then
						valid <= '1';
					end if;
					if (pr_bra_bad = '1') then
						valid <= '0';
						next_state <= CLEAR;
					elsif (stall = '1') then
						next_state <= WAIT_1;
					elsif (futureStall(0) = '1') then
						next_state <= WAIT_1;
					else
						next_state <= FORWARD;	
					end if;
					
				when WAIT_1 =>
					valid <= '0';
					if (pr_bra_bad = '1') then
						valid <= '0';
						next_state <= CLEAR;
					elsif (stall = '1' or EX_uncleared = '0') then
						next_state <= WAIT_1;
					else
						next_state <= FORWARD;
					end if;
					
				when WAIT_EX =>
					valid <= '0';
					if (pr_bra_bad = '1') then
						next_state <= CLEAR;
					elsif (EX_uncleared = '1' and stall = '0') then
						instrTmp <= instr_in;
						indexTmp <= index_in; 
						next_state <= FORWARD;
					elsif (EX_uncleared = '1' and stall = '1') then
						next_state <= WAIT_1;
						instrTmp <= instr_in;
						indexTmp <= index_in; 
					elsif (EX_uncleared = '0') then
						next_state <= WAIT_EX;
					end if;	
					
				when CLEAR =>
					instrTmp <= (others => '0');
					indexTmp <= (others => '0');
					valid <= '0';
					if (pr_bra_bad = '1') then
						next_state <= CLEAR;
					else
						next_state <= WAIT_EX;				
					end if;
					
				when others =>
					next_state <= FORWARD;
				end case;
				end if;
	end process;
	
	process(clk)
	begin
		if(clk = '1' and clk'event) then
			prev_bra_bad <= pr_bra_bad;
		end if;
	end process;
	
	changed <= prev_bra_bad xor pr_bra_bad;
	
end Behavioral;