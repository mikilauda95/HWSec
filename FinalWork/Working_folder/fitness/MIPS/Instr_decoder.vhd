library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Instr_decoder is
    Port ( instruction : in  STD_LOGIC_VECTOR (31 downto 0);				-- from fetch stage
           --op_code : out  STD_LOGIC_VECTOR (5 downto 0);					-- to exectution logic
		   index : out  STD_LOGIC_VECTOR (5 downto 0)
		   );
end Instr_decoder;

architecture Behavioral of Instr_decoder is
	
	--OP_SPECIAL, "100000", ADD
	--OP_NORMAL , "001000", ADDI
	--OP_NORMAL , "001001", ADDIU
	--OP_SPECIAL, "100001", ADDU
	--OP_SPECIAL, "100100", AND
	--OP_NORMAL , "001100", ANDI
	--OP_NORMAL , "000100", BEQ
	--OP_REGIMM , "000001", BGEZ
	--OP_REGIMM , "010001", BGEZAL
	--OP_NORMAL , "000111", BGTZ
	--OP_NORMAL , "000110", BLEZ
	--OP_REGIMM , "000000", BLTZ
	--OP_REGIMM , "010000", BLTZAL
	--OP_NORMAL , "000101", BNE
	--OP_SPECIAL, "001101", BREAK
	--OP_COP0   , "000001", COP0
	--OP_NORMAL , "000010", J
	--OP_NORMAL , "000011", JAL
	--OP_SPECIAL, "001001", JALR
	--OP_SPECIAL, "001000", JR
	--OP_NORMAL , "001111", LUI
	--OP_NORMAL , "100011", LW
	--OP_NORMAL , "110000", LWC0
	--OP_COP0   , "000000", MFC0
	--OP_SPECIAL, "010000", MFHI
	--OP_SPECIAL, "010010", MFLO
	--OP_COP0   , "000100", MTC0
	--OP_SPECIAL, "010001", MTHI
	--OP_SPECIAL, "010011", MTLO
	--OP_SPECIAL, "011000", MULT
	--OP_SPECIAL, "011001", MULT
	--OP_SPECIAL, "100111", NOR
	--OP_SPECIAL, "100101", OR
	--OP_NORMAL , "001101", ORI
	--OP_SPECIAL, "000000", SLL
	--OP_SPECIAL, "000100", SLLV
	--OP_SPECIAL, "101010", SLT
	--OP_NORMAL , "001010", SLTI
	--OP_NORMAL , "001011", SLTIU
	--OP_SPECIAL, "101011", SLTU
	--OP_SPECIAL, "000011", SRA
	--OP_SPECIAL, "000111", SRAV
	--OP_SPECIAL, "000010", SRL
	--OP_SPECIAL, "000110", SRLV
	--OP_SPECIAL, "100010", SUB
	--OP_SPECIAL, "100011", SUBU
	--OP_NORMAL , "101011", SW
	--OP_NORMAL , "111000", SWC0
	--OP_SPECIAL, "001100", SYSC
	--OP_SPECIAL, "100110", XOR
	--OP_NORMAL , "001110", XORI

begin
	process(instruction)
	begin
		case instruction(31 downto 26) is
			when "000000" => 	--SPECIAL MODE
			case instruction(5 downto 0) is
				when		"000000"	=>	index		<=		"100010";
				when		"000010" 	=>	index		<=		"101010";
				when		"000011"    =>	index		<=		"101000";
				when		"000100"    =>	index		<=		"100011";
				when		"000110"    =>	index		<=		"101011";
				when		"000111"    =>	index		<=		"101001";
				when		"001000"    =>	index		<=		"010011";
				when		"001001"    =>	index		<=		"010010";
				when		"001100"    =>	index		<=		"110000";
				when		"001101"    =>	index		<=		"001110";
				when		"010000"    =>	index		<=		"011000";
				when		"010001"    =>	index		<=		"011011";
				when		"010010"    =>	index		<=		"011001";
				when		"010011"    =>	index		<=		"011100";
				when		"011000"    =>	index		<=		"011101";
				when		"011001"    =>	index		<=		"011110";
				when		"100000"    =>	index		<=		"000000";
				when		"100001"    =>	index		<=		"000011";
				when		"100010"    =>	index		<=		"101100";
				when		"100011"    =>	index		<=		"101101";
				when		"100100"    =>	index		<=		"000100";
				when		"100101"    =>	index		<=		"100000";
				when		"100110"    =>	index		<=		"110001";
				when		"100111"    =>	index		<=		"011111";
				when		"101010"    =>	index		<=		"100100";
				when		"101011"    =>	index		<=		"100111";
				when others 			=> index    <=			"000000";
			end case;	       
           -- op_code <= instruction(5 downto 0);
			 when "000001" => 	--REGIMM MODE
			 case '0' & instruction(20 downto 16)	is
				when		"000000"	=>	index		<=		"001011";
				when		"000001" 	=>	index		<=		"000111";
				when		"010000"    =>	index		<=		"001100";
				when		"010001"    =>	index		<=		"001000";
				when others 			=> index    <=			"000000";
			end case;		
			   -- op_code <= '0' & instruction(20 downto 16);
			 when "010000" => 	--COP0 MODE
			 case '0' & instruction(25 downto 21)	is
				when		"000000"	=>	index		<=		"010111";
				when		"000001" 	=>	index		<=		"001111";
				when		"000100"    =>	index		<=		"011010";
				when others 			=> index    <=		"000000";
			end case;
          --  op_code <= '0' & instruction(25 downto 21);
			 when others   => 	--NORMAL MODE
			 case instruction(31 downto 26)is
				when		"000010"	=>	index		<=		"010000";
				when		"000011" 	=>	index		<=		"010001";
				when		"000100"    =>	index		<=		"000110";
				when		"000101"    =>	index		<=		"001101";
				when		"000110"    =>	index		<=		"001010";
				when		"000111"    =>	index		<=		"001001";
				when		"001000"    =>	index		<=		"000001";
				when		"001001"    =>	index		<=		"000010";
				when		"001010"    =>	index		<=		"100101";
				when		"001011"    =>	index		<=		"100110";
				when		"001100"    =>	index		<=		"000101";
				when		"001101"    =>	index		<=		"100001";
				when		"001110"    =>	index		<=		"110010";
				when		"001111"    =>	index		<=		"010100";
				when		"100011"    =>	index		<=		"010101";
				when		"101011"    =>	index		<=		"101110";
				when		"110000"    =>	index		<=		"010110";
				when		"111000"    =>	index		<=		"101111";
				when others 			=> index    <=		"000000";
			end case;		 
          --  op_code <= instruction(31 downto 26);
		end case;	
	end process;
end Behavioral;








