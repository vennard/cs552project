library verilog;
use verilog.vl_types.all;
entity shift_left is
    port(
        \In\            : in     vl_logic_vector(15 downto 0);
        cnt             : in     vl_logic_vector(3 downto 0);
        \Out\           : out    vl_logic_vector(15 downto 0)
    );
end shift_left;