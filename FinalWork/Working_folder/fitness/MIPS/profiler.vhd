----------------------------------------------------------------------------------
-- Company: Politecnico di Torino
-- Engineer: Alessandro Salvato
-- 
-- Create Date:    14:32:23 12/06/2016 
-- Design Name: 	 
-- Module Name:    profiler - Behavioral 
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
use IEEE.NUMERIC_STD.ALL;
use ieee.std_logic_unsigned.all;

entity profiler is
    Port ( instruction_code : in  STD_LOGIC_VECTOR (5 downto 0); 			--from execution_logic
           count_max : in  STD_LOGIC_VECTOR (9 downto 0);					--from control logic
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
end profiler;

--each control signal is considered active when is high

architecture Behavioral of profiler is

TYPE regfile_type IS ARRAY (0 TO 51) OF std_logic_vector(15 DOWNTO 0);
SIGNAL regfile : regfile_type;

signal count_state: std_logic_vector(9 downto 0);					--in place of register
signal target_instr_state: std_logic_vector(5 downto 0);			--in place of register

shared variable indice: integer := 0;
shared variable dump_end_flag: integer := 0;

--signal RAM_out: std_logic_vector(15 downto 0);
--signal count_out_RAM: std_logic_vector(9 downto 0);
--signal target_instr_out_RAM: std_logic_vector(5 downto 0);


begin
	
	WriteProcess: process(Clk)
	variable tmp: std_logic_vector(15 downto 0);
	begin
		
		if (clk = '1' and clk'EVENT) then
			if(Reset = '1') then
				for index in 0 to 51 loop
					regfile(index) <= std_logic_vector(to_unsigned(index, 16));
				end loop;
				dump_detection <= '0';
				carry_detection <= '0';
			elsif (WriteRF = '1' and EnableRF = '1' and valid_instruction_code = '1') then
					tmp := regfile(to_integer(unsigned(instruction_code)));
					tmp := tmp + std_logic_vector(to_unsigned(64, 16)); -- 10000000
					if((tmp(15 downto 6) > count_state) and (tmp(5 downto 0) = target_instr_state)) then 
						
						if(EnableDump = '1') then
							dump_detection <= '1';
							tmp := regfile(to_integer(unsigned(instruction_code)));
						else
							dump_detection <= '0';
						end if;
						
					else
					
						if(tmp(15 downto 6) = "0000000000") then -- se dopo la somma il contatore è uguale a zero, allora c'è stato carry
							carry_detection <= '1';               -- è indipendente da target_instr, qualsiasi istruzione può esssere soggetta al carry detection
							--buffer_out <= "1111111111111111" & tmp;
						else
							carry_detection <= '0';
						end if;
						
						dump_detection <= '0';
						--carry_detection <= '0';
					end if;
					regfile(to_integer(unsigned(instruction_code))) <= tmp; 
					if(dump_end_flag = 1) then
						dump_detection <= '0';
					end if;
			end if;
		end if;
	end process;
	
	init: process(reset, clk)
	begin
			if(clk = '1' and clk'event and reset = '1') then
				count_state <= (others => 'Z'); 
				target_instr_state <= (others => 'Z'); 
				--indice := 0;
--				dump_detection <= '0';
--				carry_detection <= '0';
--				dump_end <= '0';
			end if;
	end process;
	
	
	write_register: process(count_max, target_instr, reset)
	begin
		if(reset = '0' and count_max /= "ZZZZZZZZZZ" and target_instr /="ZZZZZZ") then --when reset is deactivated control logic writes the correct values 
			count_state <= count_max;
			target_instr_state <= target_instr;
--			dump_detection <= '0';
--			carry_detection <= '0';
--			dump_end <= '0';
		end if;
	end process;
--	
	dump_mode: process(clk, ReadRF, reset)
	variable tmp: std_logic_vector(31 downto 0);
	begin	
		if(ReadRF = '1' and EnableRF = '1' and EnableDump = '1' and Reset = '0') then
			if(clk = '1' and clk'event) then
				if(indice <51) then
					tmp(15 downto 0) := regfile(indice);
					tmp(31 downto 16) := regfile(indice+1);
					data_out <= tmp;
					dump_end <= '0';
					dump_end_flag := 0;
					indice := indice + 2;
				else
					indice := 0;
					tmp(15 downto 0) := regfile(51);
					tmp(31 downto 16) := (others => '1');
					dump_end <= '1';
					dump_end_flag := 1;
				end if;
			end if;
		elsif(reset = '1') then
			indice := 0;
			dump_end <= '0';
			dump_end_flag := 0;
			data_out <= (others => '1');
		end if;				
		
	end process;
	
--	writing_out: process(buffer_out)
--	begin
--			data_out <= buffer_out;
--	end process;
	
end Behavioral;

