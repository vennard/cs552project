library verilog;
use verilog.vl_types.all;
entity b16mux2_1 is
    port(
        ina             : in     vl_logic_vector(15 downto 0);
        inb             : in     vl_logic_vector(15 downto 0);
        s               : in     vl_logic;
        \Out\           : out    vl_logic_vector(15 downto 0)
    );
end b16mux2_1;
