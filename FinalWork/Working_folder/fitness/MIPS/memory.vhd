library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.pack_mips.all;

package memory is

type memdata is array(natural range 1024 to 2047) of bus8;

type debugData is array(0 to 39) of bus8;

constant RAMDATA : memdata := (
  1027 => x"00", -- 0
  1031 => x"01", -- 1
  1035 => x"04", -- 4
  1039 => x"09", -- 9
  1043 => x"10", -- 16
  1047 => x"19", -- 25
  1051 => x"24", -- 36
  1055 => x"31", -- 49
  1059 => x"40", -- 64
  1063 => x"51", -- 81
  others => (others => '0')
);

end memory;
