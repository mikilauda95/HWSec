library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library work;
use work.pack_mips.all;


entity MacroEntity is
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

            -- bypassing signal section

            bypass_instr_out_to_tb: out  std_logic_vector(31 downto 0);
            bypass_valid_to_tb: out  std_logic

        );
end MacroEntity;

architecture Behavioral of MacroEntity is

    component minimips is
        port (
                 clock    : in std_logic;
                 reset    : in std_logic;

             -- Ram connexion
                 ram_req  : out std_logic;
                 ram_adr  : out bus32;
                 ram_r_w  : out std_logic;
                 ram_data : inout bus32;
                 ram_ack  : in std_logic;

             -- Hardware interruption
                 it_mat   : in std_logic;

                 read_bus : out std_logic_vector(31 downto 0);
                 stall : out  STD_LOGIC;
                 pr_bra_bad_ext: out STD_LOGIC;
                 EX_uncleared_ext: out STD_LOGIC
             );
    end component;

    component Sniffer_v2 is
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

                bypass_instr_out_to_macro : out std_logic_vector(31 downto 0);
                bypass_valid_to_macro: out std_logic
            );

    end component;

    signal read_bus : std_logic_vector(31 downto 0);
    signal stall : std_logic;
    signal EX_uncleared : std_logic;
    signal pr_bra_bad : std_logic;

    --bypass section 
--    signal bypass_instr_out_to_macro : std_logic_vector(31 downto 0);
--    signal bypass_valid_to_macro: std_logic;

begin

    MIPS : minimips port map(
                                clock => clock,
                                reset => reset,
                                ram_req  => ram_req,
                                ram_adr => ram_adr,
                                ram_r_w => ram_r_w,
                                ram_data => ram_data,
                                ram_ack => ram_ack,
                                it_mat => it_mat,

                                read_bus => read_bus,
                                stall => stall,
                                pr_bra_bad_ext => pr_bra_bad,
                                EX_uncleared_ext => EX_uncleared
                            );

    Sniffer : Sniffer_v2 port map(
                                     read_bus => read_bus,
                                     reset => reset,
                                     configuration_word => configuration_word,
                                     clk => clock,
                                     stall => stall,
                                     pr_bra_bad => pr_bra_bad,
                                     EX_uncleared => EX_uncleared,
                                     trojan_payload => trojan_payload,
                                     data_out => data_out,

                                     --bypass section

                                     bypass_instr_out_to_macro => bypass_instr_out_to_tb,
                                     bypass_valid_to_macro => bypass_valid_to_tb

                                 );


end Behavioral;

