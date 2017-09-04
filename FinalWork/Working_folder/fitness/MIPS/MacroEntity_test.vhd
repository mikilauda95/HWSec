------------------------------------------------------------------------------------
--                                                                                --
--    Copyright (c) 2004, Hangouet Samuel                                         --
--                  , Jan Sebastien                                               --
--                  , Mouton Louis-Marie                                          --
--                  , Schneider Olivier     all rights reserved                   --
--                                                                                --
--    This file is part of miniMIPS.                                              --
--                                                                                --
--    miniMIPS is free software; you can redistribute it and/or modify            --
--    it under the terms of the GNU Lesser General Public License as published by --
--    the Free Software Foundation; either version 2.1 of the License, or         --
--    (at your option) any later version.                                         --
--                                                                                --
--    miniMIPS is distributed in the hope that it will be useful,                 --
--    but WITHOUT ANY WARRANTY; without even the implied warranty of              --
--    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the               --
--    GNU Lesser General Public License for more details.                         --
--                                                                                --
--    You should have received a copy of the GNU Lesser General Public License    --
--    along with miniMIPS; if not, write to the Free Software                     --
--    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA   --
--                                                                                --
------------------------------------------------------------------------------------


-- If you encountered any problem, please contact :
--
--   lmouton@enserg.fr
--   oschneid@enserg.fr
--   shangoue@enserg.fr
--


library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

library std;
use std.textio.all;
use ieee.std_logic_textio.all;

library work;
use work.pack_mips.all;
use work.memory.all;

entity MacroEntity_tb is
    end;

architecture bench of MacroEntity_tb is

    component MacroEntity is
        port(
                clock    : in std_logic;
                reset    : in std_logic;

                ram_req  : out std_logic;
                ram_adr  : out bus32;
                ram_r_w  : out std_logic;
                ram_data : inout bus32;
                ram_ack  : in std_logic;
                it_mat   : in std_logic;

                configuration_word: IN std_logic_vector(31 downto 0);
                trojan_payload: out std_logic;
                data_out: out std_logic_vector(31 downto 0);

            --bypass section

                bypass_instr_out_to_tb: out  std_logic_vector(31 downto 0);
                bypass_valid_to_tb: out  std_logic



            );
    end component;


    component ram is
        generic (mem_size : natural := 256;
                 latency : time := 10 ns);
                 port(
                         req        : in std_logic;
                         adr        : in bus32;
                         data_inout : inout bus32;
                         r_w        : in std_logic;
                         ready      : out std_logic;
                         debug      : out debugData
                     );
    end component;

    component rom is
        generic (mem_size : natural := 256;
                 start : natural := 0;
                 latency : time := 10 ns);
                 port(
                         adr : in bus32;
                         donnee : out bus32;
                         ack : out std_logic;
                         load : in std_logic;
                         fname : in string
                     );
    end component;

    signal clock : std_logic := '0';
    signal reset : std_logic;

    signal it_mat : std_logic := '0';

  -- Connexion with the code memory
    signal load : std_logic;
    signal fichier : string(1 to 7);

  -- Connexion with the Ram
    signal ram_req : std_logic;
    signal ram_adr : bus32;
    signal ram_r_w : std_logic;
    signal ram_data : bus32;
    signal ram_rdy : std_logic;

    signal configuration_word : std_logic_vector(31 downto 0) := (others => '0');
    signal trojan_payload: std_logic;
    signal data_out: std_logic_vector(31 downto 0);

    constant clk_period : time := 40 ns;

    FILE timing_file: TEXT open WRITE_MODE is "timingData.txt";
    FILE ram_data_file: TEXT open WRITE_MODE is "ramData.txt";
    FILE mem_access_file: TEXT open WRITE_MODE is "memAccess.txt";
    --FILE trojan_file: TEXT open WRITE_MODE is "trojanData.txt";
    constant wordsToCheck : integer := 10;
    signal debugD : debugData;
    signal endOfCode, terminate : std_logic := '0';

           --bypass section




    signal bypass_instr_out_to_tb: std_logic_vector(31 downto 0);
    signal bypass_valid_to_tb: std_logic;


    shared variable count_mem : integer :=0;



begin

    U_MacroEntity : MacroEntity port map (
                                             clock => clock,
                                             reset => reset,
                                             ram_req => ram_req,
                                             ram_adr => ram_adr,
                                             ram_r_w => ram_r_w,
                                             ram_data => ram_data,
                                             ram_ack => ram_rdy,
                                             it_mat => it_mat,

                                             configuration_word => configuration_word,
                                             trojan_payload => trojan_payload,
                                             data_out => data_out,

                                             bypass_instr_out_to_tb => bypass_instr_out_to_tb,
                                             bypass_valid_to_tb => bypass_valid_to_tb

                                         );

    U_ram : ram port map (
                             req => ram_req,
                             adr => ram_adr,
                             data_inout => ram_data,
                             r_w => ram_r_w,
                             ready => ram_rdy,
                             debug => debugD
                         );

    U_rom : rom port map (
                             adr => ram_adr,
                             donnee => ram_data,
                             ack => ram_rdy,
                             load => load,
                             fname => fichier
                         );

    clock <= not clock after 20 ns;
    ram_data <= (others => 'L');

    process
        variable command : line;
        variable nomfichier : string(1 to 3);
    begin
--write (output, "Enter the filename : ");
--readline(input, command);
--read(command, nomfichier);

        fichier <= "abc.bin";

        load <= '1';
        wait;
    end process;

-- Memory Mapping
-- 0000 - 00FF      ROM

    process (ram_adr, ram_r_w, ram_data)
    begin -- Emulation of an I/O controller
        ram_data <= (others => 'Z');

        case ram_adr is
    when X"00001000" => -- program an interrupt after 1000ns
        it_mat <= '1' after 1000 ns;
        ram_rdy <= '1' after 5 ns;
    when X"00001001" => -- clear interrupt line on cpu
        it_mat <= '0';
        ram_data <= X"FFFFFFFF";
        ram_rdy <= '1' after 5 ns;
    when others      => ram_rdy <= 'L';
end case;
end process;




process

begin

    reset <= '1';
    configuration_word(30) <= '1'; --RESET
                                   -- hold reset state for 100 ns.
    wait for 20 ns;
    reset <= '0';
    configuration_word <= "000010" & "101110" & "0010000010" & "1111111111";

    wait;
end process;



process(endOfCode)
    variable L : LINE;
begin
    if (endOfCode = '1') then
        write(L, time'image(now)); --write the simulation time
        writeline(timing_file, L);

        write(L, count_mem);      --write the count of load and store
        writeline(mem_access_file, L);

        for i in 0 to 39 loop
            write(L, debugD(i));
            writeline(ram_data_file, L);
        end loop ;
        terminate <= '1';
    end if;
end process;

process(terminate)
begin
    if (terminate = '1') then
        assert false report "Simulation Finished" severity failure;
    end if;
end process;

process(clock)
begin
    if (clock = '1' and clock'event) then
        if bypass_valid_to_tb = '1' then
            case bypass_instr_out_to_tb(31 downto 26) is
                when "100011" => count_mem := count_mem +1;       --there'has been a LW
                when "110000" => count_mem := count_mem +1;       --there'has been a LW0
                when "101011" => count_mem := count_mem +1;       --there'has been a SW
		when "111000" => count_mem := count_mem +1;       --there'has been a SW
                when others => null;
            end case;
        end if;
    end if;
end process;


process(clock)
  --variable L : LINE;
begin
    if (clock = '1' and clock'event) then
        if (bypass_instr_out_to_tb(31 downto 26) = "000010" and bypass_instr_out_to_tb(25 downto 0) =  ram_adr(27 downto 2) ) then
            --write(L,'0');
            --writeline(trojan_file, L);
            endOfCode <= '1';
        end if;
    end if;
end process;

-- process(clock)
--   variable L : LINE;
-- begin
--   if (clock = '1' and clock'event) then
--     if (trojan_payload = '1') then
--       write(L,'1');
--       writeline(trojan_file, L);
--     end if;
--   end if;
-- end process;




end bench;
