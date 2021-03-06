//NEW MEMORY MODULE
//John Vennard and Nick Ambur
module memory(ALUO_EXMEM,ALUO_MEMWB,Rd2_EXMEM,takeBranch,
              takeBranch_EXMEM,MemWrite_EXMEM,RegWrite_EXMEM,RegWrite_MEMWB,
              MemRead_EXMEM,Dump_EXMEM,RdD_MEMWB,MemtoReg_EXMEM,MemtoReg_MEMWB,
              WrR_EXMEM, WrR_MEMWB, clk,rst,halt_EXMEM,freeze,mStallData,mStallInstr);

    //Non-Pipelined in/out
    input clk,rst,halt_EXMEM,freeze;

    //Input
    input [15:0] ALUO_EXMEM,Rd2_EXMEM;
    input takeBranch,takeBranch_EXMEM,MemtoReg_EXMEM,MemWrite_EXMEM, RegWrite_EXMEM
        ,MemRead_EXMEM,Dump_EXMEM,mStallInstr;
    input [2:0] WrR_EXMEM;

    //output
    output [15:0] RdD_MEMWB,ALUO_MEMWB;
    output MemtoReg_MEMWB, RegWrite_MEMWB,mStallData;
    output [2:0] WrR_MEMWB;

    //internal wire
    wire memReadorWrite,MemReadIn,Done,dMemStall,dMemErr,MemWriteActual,MemReadActual,dummy;
    wire testBenchRead, testBenchWrite;
    wire [15:0] RdD,memDataOut;
   
    //stall mux
    assign RegWrIn = (RegWrite_EXMEM) ? 1'b1 :
    ((takeBranch_EXMEM) ? 1'b0 : RegWrite_EXMEM);
    assign MemWrIn = (takeBranch_EXMEM | halt_EXMEM) ? 1'b0 : MemWriteActual;
    assign MemReadIn = (takeBranch_EXMEM) ? 1'b0 : MemReadActual;

    //Logic to stall mem read&load for freezes
    //assign MemReadActual = (MemRead_EXMEM & ~mStallInstr);
    //assign MemWriteActual = (MemWrite_EXMEM & ~mStallInstr);
    //assign MemReadActual = (MemRead_EXMEM & ~mStallInstr & ~Done);
    //assign MemWriteActual = (MemWrite_EXMEM & ~mStallInstr & ~Done);
    assign MemWriteActual = (MemWrite_EXMEM);
    assign MemReadActual = (MemRead_EXMEM);


    //Pipeline Register -- TODO swapped out for perfect mem use
    //reg16bit reg0(.clk(clk),.rst(rst),.en(freeze|Done),.in(RdD),.out(RdD_MEMWB));
    reg16bit reg0(.clk(clk),.rst(rst),.en(freeze),.in(RdD),.out(RdD_MEMWB));
    dff_en reg1(.clk(clk),.rst(rst),.en(freeze),.in(MemtoReg_EXMEM),.out(MemtoReg_MEMWB));
    dff_en reg2(.clk(clk),.rst(rst),.en(freeze),.in(RegWrIn),.out(RegWrite_MEMWB));
    reg3bit reg3(.clk(clk),.rst(rst),.en(freeze),.in(WrR_EXMEM),.out(WrR_MEMWB));
    reg16bit reg4(.clk(clk),.rst(rst),.en(freeze),.in(ALUO_EXMEM),.out(ALUO_MEMWB));

    //enable logic  
    assign memReadorWrite = (MemWrIn | MemReadIn);
    //assign testBenchRead = (MemRead_EXMEM & Done & freeze); //TODO swapped
    //assign testBenchWrite = (MemWrite_EXMEM & Done & freeze);
    assign testBenchRead = (MemRead_EXMEM);
    assign testBenchWrite = (MemWrite_EXMEM&(~halt_EXMEM));
    

    //Freeze Logic
    //assign mStallData = (MemReadIn & ~Done) | (MemWrIn & ~Done) | dMemStall;
    //assign mStallData = dMemStall; 
      assign mStallData = 1'b0;
    //Mem Register flop 
    //reg16bit reg5(.clk(clk),.rst(rst),.en(Done),.in(memDataOut),.out(RdD));

/*
    mem_system #(1) mem(.DataOut(RdD), .Done(Done), .Stall(dMemStall), .err(dMemErr),
        .Addr(ALUO_EXMEM), .DataIn(Rd2_EXMEM), .Rd(MemReadIn), .CacheHit(dummy),
        .Wr(MemWrIn), .createdump(Dump_EXMEM), .clk(clk), .rst(rst));
  */  
    memory2c testmem(.data_out(RdD),.data_in(Rd2_EXMEM),.addr(ALUO_EXMEM),.enable(memReadorWrite)
                    ,.wr(MemWrIn),.createdump(Dump_EXMEM),.clk(clk),.rst(rst));
endmodule
