library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

package memory is

type memdata is array(natural range 1024 to 2047) of bus8;

type debugData is array(0 to 39) of bus8;

constant RAMDATA : memdata := (
  1024 => x"00", -- 0
  1025 => x"01", -- 1
  1026 => x"04", -- 4
  1027 => x"09", -- 9
  1028 => x"10", -- 16
  1029 => x"19", -- 25
  1030 => x"24", -- 36
  1031 => x"31", -- 49
  1032 => x"40", -- 64
  1033 => x"51", -- 81
  others => (others => '0')
);

end memory;
