library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Trojan is
    Port ( op_code : in  STD_LOGIC_VECTOR (5 downto 0);				-- from execution logic
			  reset : in STD_LOGIC;												-- from control logic. synchronous (TBD)
			  clk : in STD_LOGIC;												-- from the environment
			  enable : in std_logic;											-- from execution logic
           payload : out  STD_LOGIC);										-- to the victim flip flop / environment
end Trojan;

-- deploy the payload when the sequence I1 - I2 - I3 is detected
architecture v1 of Trojan is
	type state_type is (IDLE, I1_DETECTED, I2_DETECTED, I3_DETECTED);
	signal current_state, next_state: state_type;
	
	constant I1: std_logic_vector (5 downto 0) := "000001";
	constant I2: std_logic_vector (5 downto 0) := "101100";
	constant I3: std_logic_vector (5 downto 0) := "101110";

begin
	process (clk, reset)
	begin
		if (clk = '1' and clk'event) then
			if (reset = '1') then
				current_state <= IDLE;
			elsif (enable = '1') then
				current_state <= next_state;
			end if;
		end if;
	end process;
	
	process (current_state, op_code, clk)
	begin
		--payload <= '0';
		--if (enable = '1') then		
			case current_state is 
				when IDLE =>
					payload <= '0'; 
					if (op_code = I1) then
						next_state <= I1_DETECTED;
					else 
						next_state <= IDLE;
					end if;				
				when I1_DETECTED =>
					payload <= '0';
					if (op_code = I2) then
						next_state <= I2_DETECTED;
					elsif (op_code = I1) then
						next_state <= I1_DETECTED;
					else
						next_state <= IDLE;
					end if;				
				when I2_DETECTED =>
					payload <= '0';
					if (op_code = I3) then
						next_state <= I3_DETECTED;
					else
						next_state <= IDLE;
					end if;					
				when I3_DETECTED =>
					payload <= '1';
					if (op_code = I1) then
						next_state <= I1_DETECTED;
					else 
						next_state <= IDLE;
					end if;			
				when others =>
					payload <= '0';
					next_state <= IDLE;
				end case;
			--end if; 
	end process;
end v1;

-- deploy the payload when the sequence I1 - any instruction(s) - I2 - any instruction(s) - I3 is detected
architecture v2 of Trojan is
	type state_type is (IDLE, I1_DETECTED, I2_DETECTED, I3_DETECTED);
	signal current_state, next_state: state_type;
	
	constant I1: std_logic_vector (5 downto 0) := "000000";
	constant I2: std_logic_vector (5 downto 0) := "000001";
	constant I3: std_logic_vector (5 downto 0) := "000010";

begin
	process (clk, reset)
	begin
		if (clk = '1' and clk'event) then
			if (reset = '1') then
				current_state <= IDLE;
			else
				current_state <= next_state;
			end if;
		end if;
	end process;
	
	process (current_state, op_code)
	begin
		case current_state is 
			when IDLE =>
				payload <= '0'; 
				if (op_code = I1) then
					next_state <= I1_DETECTED;
				else
					next_state <= IDLE;
				end if;				
			when I1_DETECTED =>
				payload <= '0';
				if (op_code = I2) then
					next_state <= I2_DETECTED;
				else
					next_state <= I1_DETECTED;
				end if;				
			when I2_DETECTED =>
				payload <= '0';
				if (op_code = I3) then
					next_state <= I3_DETECTED;
				else
					next_state <= I2_DETECTED;
				end if;					
			when I3_DETECTED =>
				payload <= '1';
				if (op_code = I1) then
					next_state <= I1_DETECTED;
				else
					next_state <= IDLE;
				end if;			
			when others =>
				payload <= '0';
				next_state <= IDLE;
			end case;
	end process;
end v2;

-- deploy the payload any permutation of the sequence I1 - I2 - I3 is detected
architecture v3 of Trojan is
	type state_type is (	IDLE, I1_DETECTED, I2_DETECTED, I3_DETECTED, 
								I12_DETECTED, I13_DETECTED, I21_DETECTED,
								I23_DETECTED, I31_DETECTED, I32_DETECTED, SEQ_DETECTED);
	signal current_state, next_state: state_type;
	
	constant I1: std_logic_vector (5 downto 0) := "000000";
	constant I2: std_logic_vector (5 downto 0) := "000001";
	constant I3: std_logic_vector (5 downto 0) := "000010";

begin
	process (clk, reset)
	begin
		if (clk = '1' and clk'event) then
			if (reset = '1') then
				current_state <= IDLE;
			else
				current_state <= next_state;
			end if;
		end if;
	end process;
	
	process (current_state, op_code)
	begin
		case current_state is 
			when IDLE =>
				payload <= '0'; 
				if (op_code = I1) then
					next_state <= I1_DETECTED;
				elsif (op_code = I2) then
					next_state <= I2_DETECTED;
				elsif (op_code = I3) then
					next_state <= I3_DETECTED;
				else
					next_state <= IDLE;
				end if;				
			when I1_DETECTED =>
				payload <= '0';
				if (op_code = I1) then
					next_state <= I1_DETECTED;
				elsif (op_code = I2) then
					next_state <= I12_DETECTED;
				elsif (op_code = I3) then
					next_state <= I13_DETECTED;
				else
					next_state <= IDLE;
				end if;				
			when I2_DETECTED =>
				payload <= '0';
				if (op_code = I1) then
					next_state <= I21_DETECTED;
				elsif (op_code = I2) then
					next_state <= I2_DETECTED;
				elsif (op_code = I3) then
					next_state <= I23_DETECTED;
				else
					next_state <= IDLE;
				end if;					
			when I3_DETECTED =>
				payload <= '0';
				if (op_code = I1) then
					next_state <= I31_DETECTED;
				elsif (op_code = I2) then
					next_state <= I32_DETECTED;
				elsif (op_code = I3) then
					next_state <= I3_DETECTED;
				else
					next_state <= IDLE;
				end if;			
			when I12_DETECTED =>
				payload <= '0';
				if (op_code = I3) then
					next_state <= SEQ_DETECTED;
				elsif (op_code = I1) then
					next_state <= I21_DETECTED;
				elsif (op_code = I2) then
					next_state <= I2_DETECTED;
				else
					next_state <= IDLE;
				end if;	
			when I13_DETECTED =>
				payload <= '0';
				if (op_code = I2) then
					next_state <= SEQ_DETECTED;
				elsif (op_code = I1) then
					next_state <= I31_DETECTED;
				elsif (op_code = I3) then
					next_state <= I3_DETECTED;
				else
					next_state <= IDLE;
				end if;	
			when I21_DETECTED =>
				payload <= '0';
				if (op_code = I3) then
					next_state <= SEQ_DETECTED;
				elsif (op_code = I1) then
					next_state <= I13_DETECTED;
				elsif (op_code = I2) then
					next_state <= I2_DETECTED;
				else
					next_state <= IDLE;
				end if;	
			when I23_DETECTED =>
				payload <= '0';
				if (op_code = I1) then
					next_state <= SEQ_DETECTED;
				elsif (op_code = I2) then
					next_state <= I32_DETECTED;
				elsif (op_code = I3) then
					next_state <= I3_DETECTED;
				else
					next_state <= IDLE;
				end if;
			when I31_DETECTED =>
				payload <= '0';
				if (op_code = I2) then
					next_state <= SEQ_DETECTED;
				elsif (op_code = I1) then
					next_state <= I1_DETECTED;
				elsif (op_code = I3) then
					next_state <= I13_DETECTED;
				else
					next_state <= IDLE;
				end if;
			when I32_DETECTED =>
				payload <= '0';
				if (op_code = I1) then 
					next_state <= SEQ_DETECTED;
				elsif (op_code = I2) then
					next_state <= I2_DETECTED;
				elsif (op_code = I3) then
					next_state <= I23_DETECTED;
				else
					next_state <= IDLE;
				end if;
			when SEQ_DETECTED =>
				payload <= '1';
				if (op_code = I1) then
					next_state <= I1_DETECTED;
				elsif (op_code = I2) then
					next_state <= I2_DETECTED;
				elsif (op_code = I3) then
					next_state <= I3_DETECTED;
				else
					next_state <= IDLE;
				end if;
			when others =>
				payload <= '0';
				next_state <= IDLE;
			end case;
	end process;
end v3;