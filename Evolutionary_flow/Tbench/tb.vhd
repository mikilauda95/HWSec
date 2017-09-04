use std.textio.all;
use ieee.std_logic_textio.all; -- if you're saving this type of signal

architecture test of macroentity_tb is
    FILE timing_file: TEXT open WRITE_MODE is "timingData.txt";
    FILE ram_data_file: TEXT open WRITE_MODE is "ramData.txt";
    constant wordsToCheck : integer := 10;
    signal endOfCode : std_logic := '0';

begin
    process(endOfCode)
    variable L : LINE;
    begin

      write(L, time'image(now));
      writeline(timing_file, L);

      rf: for i in 0 to wordsToCheck loop:
        write(L, RAM(i*4));
        -- write(L, dut.ram.data(i*4))
        writeline(ram_data_file, L);
      end loop rf;

      wait;
    end process;

    process(ram_data)
    begin
      if (ram_data = 'jumpcode' and valid = 1) then
        endOfCode <= '1';
      end if;
    end process;

end test;
