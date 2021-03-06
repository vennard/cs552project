module fetch(PCS,PC_IDEX,Dump,clk,rst,PC_IFID,PC2_IFID,instr_IFID,takeBranch,loadDetect,storeDetect
            ,takeBranch_EXMEM,stallCtrl,halt_IFID,err,startStall,freeze,mStallInstr,mStallData);

input [15:0] PCS,PC_IDEX;
input clk,rst,Dump,stallCtrl,takeBranch_EXMEM,takeBranch,startStall,freeze,mStallData;
output [15:0] instr_IFID, PC2_IFID,PC_IFID;
output halt_IFID,err,mStallInstr,loadDetect,storeDetect;
wire [15:0] PC_FF_in,addr, pcCurrent,dummy,instrTemp ;
wire dummy1,halt,haltTemp,stBit,iMemStall,Done,iMemErr,add0Err,add1Err,dummy2;
wire [15:0] instr,PC2,PC2_out,instrTempIn,pcCurrTemp,dummy3,memDataOut;

assign err = iMemErr | add0Err | add1Err;

//TODO added for forwarding
assign loadDetect = ((instr_IFID[15])&(~(|(instr_IFID[14:12])))&(instr_IFID[11])); //load instr = 10001
assign storeDetect = ((instr_IFID[15]&(~(|instr_IFID[14:11])))); //store instr = 10000

//Pipelined register output
reg16bit reg0(.clk(clk),.rst(rst),.en((~stallCtrl)&(freeze)),.in(instrTempIn),.out(instrTemp));
reg16bit reg1(.clk(clk),.rst(rst),.en(freeze),.in(PC2_out),.out(PC2_IFID));
dff_en reg2(.out(halt_IFID),.in(haltTemp),.en(freeze),.clk(clk),.rst(rst));
reg16bit reg3(.clk(clk),.rst(rst),.en(freeze),.in(PC_FF_in),.out(PC_IFID));

//Status bit register - - for halt control
dff_en streg(.clk(clk),.rst(1'b0),.en(freeze),.in(rst),.out(stBit));

//Clear for halt signal
assign haltTemp = stBit ? 1'b0 : (takeBranch_EXMEM ? 1'b0 : halt);

//Insert nops for stall and flush
assign instrTempIn = (takeBranch_EXMEM | stallCtrl) ? (16'b00001_00000000000) : instr;
assign instr_IFID = (takeBranch_EXMEM) ? (16'b00001_00000000000) : instrTemp;

//Create PC FF
reg16bit pcReg0(.clk(clk),.rst(rst),.en((~stallCtrl)&(freeze)),.in(PC_FF_in),.out(pcCurrTemp));

//Current PC recycle when you see start stall
assign pcCurrent = startStall ? PC_IDEX : pcCurrTemp;

//Instantiate Fetch Memory
//assign mStallInstr = (iMemStall | (~Done));
assign mStallInstr = 1'b0;
//reg16bit reg4(.clk(clk),.rst(rst),.en(Done),.in(memDataOut),.out(instr));

//TODO added ~mStallData to .Rd input signal
//TODO testing perfect mem with mem_system in datamemory
memory2c imem (.data_out(instr), .data_in(dummy), .addr(pcCurrent), .enable(1'b1), .wr(1'b0),
    .createdump(Dump), .clk(clk), .rst(rst));

/*
mem_system #(0) Imem(.DataOut(instr), .Done(Done), .Stall(iMemStall), .err(iMemErr), .Addr(pcCurrent),
    .Rd(~Done), .Wr(1'b0), .CacheHit(dummy2), .DataIn(dummy3), .createdump(Dump), .clk(clk), .rst(rst));
*/

//Instantiate 16bit Adder
carryLA_16b adder0(.A(pcCurrent),.B(16'h0002),.SUM(PC2),.CI(1'b0),.CO(dummy1),.Ofl(add0Err));
carryLA_16b adder1(.A(PC_FF_in),.B(16'h0002),.SUM(PC2_out),.CI(1'b0),.CO(dummy1),.Ofl(add1Err));

//PC select mux logic w/ pipeline logic
assign PC_FF_in = (takeBranch_EXMEM) ? PCS : (stallCtrl ? pcCurrTemp : PC2);

//changed to reflect instruction actually passed through
assign halt = ~(|instr_IFID);

endmodule
