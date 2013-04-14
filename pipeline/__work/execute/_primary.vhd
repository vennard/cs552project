library verilog;
use verilog.vl_types.all;
entity execute is
    port(
        alusrc_idex     : in     vl_logic;
        pc2_idex        : in     vl_logic_vector(15 downto 0);
        aluop_idex      : in     vl_logic_vector(4 downto 0);
        rd1_idex        : in     vl_logic_vector(15 downto 0);
        rd2_idex        : in     vl_logic_vector(15 downto 0);
        imm_idex        : in     vl_logic_vector(15 downto 0);
        aluf_idex       : in     vl_logic_vector(1 downto 0);
        branch_idex     : in     vl_logic;
        takebranch_exmem: out    vl_logic;
        dump_idex       : in     vl_logic;
        wrr_idex        : in     vl_logic_vector(2 downto 0);
        wrr_exmem       : out    vl_logic_vector(2 downto 0);
        regwrite_idex   : in     vl_logic;
        regwrite_exmem  : out    vl_logic;
        memtoreg_idex   : in     vl_logic;
        memwrite_idex   : in     vl_logic;
        memread_idex    : in     vl_logic;
        pcs_exmem       : out    vl_logic_vector(15 downto 0);
        imm_exmem       : out    vl_logic_vector(15 downto 0);
        aluo_exmem      : out    vl_logic_vector(15 downto 0);
        rd2_exmem       : out    vl_logic_vector(15 downto 0);
        memtoreg_exmem  : out    vl_logic;
        memwrite_exmem  : out    vl_logic;
        memread_exmem   : out    vl_logic;
        dump_exmem      : out    vl_logic;
        err             : out    vl_logic;
        clk             : in     vl_logic;
        rst             : in     vl_logic
    );
end execute;