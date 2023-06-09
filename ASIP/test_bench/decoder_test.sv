module decoder_test();
	
    logic [15:0] instruction;
    logic MemoryWrite;
    logic [1:0] WriteRegFrom;
    logic [3:0] RegToWrite;
    logic [7:0] Immediate;
    logic writeMemFrom;
    logic RegWriteEnSc;
    logic RegWriteEnVec;
    logic OverWriteNz;
    logic [2:0] PcWriteEn;
    logic [2:0] AluOpCode;
	
	decoderStage decoder(.instruction(instruction),
                    .MemoryWrite(MemoryWrite),
                    .WriteRegFrom(WriteRegFrom),
                    .RegToWrite(RegToWrite),
                    .Immediate(Immediate),
                    .writeMemFrom(writeMemFrom),
                    .RegWriteEnSc(RegWriteEnSc),
                    .RegWriteEnVec(RegWriteEnVec),
                    .PcWriteEn(PcWriteEn),
                    .AluOpCode(AluOpCode),
                    .OverWriteNz(OverWriteNz));
	
	initial begin
        instruction = 0;
        // Tests:
        #10;
        // 1: lmem
        instruction = 16'hF510;
        #10;
        assert (PcWriteEn == 0) else $error("Test 1: PcWriteEn should be 0");
        assert (MemoryWrite == 0) else $error("Test 1: MemoryWrite should be 0");
        assert (WriteRegFrom == 0) else $error("Test 1: WriteRegFrom should be 0");
        assert (OverWriteNz == 0) else $error("Test 1: OverWriteNz should be 0");
        assert (RegToWrite == 5) else $error("Test 1: RegToWrite should be 5");
        assert (Immediate == 16) else $error("Test 1: Immediate should be 16");
        assert (RegWriteEnSc == 1) else $error("Test 1: RegWriteEnSc should be 1");
        assert (RegWriteEnVec == 0) else $error("Test 1: RegWriteEnVec should be 0");
        assert (writeMemFrom == 0) else $error("Test 1: writeMemFrom should be 0");
        #10;

        // 2: losc
        instruction = 16'h0612;
        #10;
        assert (PcWriteEn == 0) else $error("Test 2: PcWriteEn should be 0");
        assert (MemoryWrite == 0) else $error("Test 2: MemoryWrite should be 0");
        assert (WriteRegFrom == 2) else $error("Test 2: WriteRegFrom should be 2");
        assert (OverWriteNz == 0) else $error("Test 2: OverWriteNz should be 0");
        assert (RegToWrite == 6) else $error("Test 2: RegToWrite should be 6");
        assert (Immediate == 18) else $error("Test 2: Immediate should be 18");
        assert (RegWriteEnSc == 1) else $error("Test 2: RegWriteEnSc should be 1");
        assert (RegWriteEnVec == 0) else $error("Test 2: RegWriteEnVec should be 0");
        assert (writeMemFrom == 0) else $error("Test 2: writeMemFrom should be 0");
        #10;

        // 3: dcae (sub)
        instruction = 16'h3260;
        #10;
        assert (PcWriteEn == 0) else $error("Test 3: PcWriteEn should be 0");
        assert (MemoryWrite == 0) else $error("Test 3: MemoryWrite should be 0");
        assert (AluOpCode == 3) else $error("Test 3: AluOpCode should be 3");
        assert (WriteRegFrom == 1) else $error("Test 3: WriteRegFrom should be 1");
        assert (OverWriteNz == 1) else $error("Test 3: OverWriteNz should be 1");
        assert (RegToWrite == 2) else $error("Test 3: RegToWrite should be 2");
        assert (RegWriteEnSc == 0) else $error("Test 3: RegWriteEnSc should be 0");
        assert (RegWriteEnVec == 1) else $error("Test 3: RegWriteEnVec should be 1");
        assert (writeMemFrom == 0) else $error("Test 3: writeMemFrom should be 0");
        #10;

        // 4: jmp
        instruction = 16'hA015;
        #10;
        assert (PcWriteEn == 3'b100) else $error("Test 4: PcWriteEn should be 3'b100");
        assert (MemoryWrite == 0) else $error("Test 4: MemoryWrite should be 0");
        assert (OverWriteNz == 0) else $error("Test 4: OverWriteNz should be 0");
        assert (Immediate == 21) else $error("Test 4: Immediate should be 21");
        assert (RegWriteEnSc == 0) else $error("Test 4: RegWriteEnSc should be 0");
        assert (RegWriteEnVec == 0) else $error("Test 4: RegWriteEnVec should be 0");
        assert (writeMemFrom == 0) else $error("Test 4: writeMemFrom should be 0");
        
        // 5: je
        #10;
        instruction = 16'h8010;
        #10;
        assert (PcWriteEn == 3'b010) else $error("Test 5: PcWriteEn should be 3'b010");
        assert (MemoryWrite == 0) else $error("Test 5: MemoryWrite should be 0");
        assert (OverWriteNz == 0) else $error("Test 5: OverWriteNz should be 0");
        assert (Immediate == 16) else $error("Test 5: Immediate should be 16");
        assert (RegWriteEnSc == 0) else $error("Test 5: RegWriteEnSc should be 0");
        assert (RegWriteEnVec == 0) else $error("Test 5: RegWriteEnVec should be 0");
        assert (writeMemFrom == 0) else $error("Test 5: writeMemFrom should be 0");

        // 6: jne
        #10;
        instruction = 16'h9032;
        #10;
        assert (PcWriteEn == 3'b001) else $error("Test 6: PcWriteEn should be 3'b001");
        assert (MemoryWrite == 0) else $error("Test 6: MemoryWrite should be 0");
        assert (OverWriteNz == 0) else $error("Test 6: OverWriteNz should be 0");
        assert (Immediate == 50) else $error("Test 6: Immediate should be 50");
        assert (RegWriteEnSc == 0) else $error("Test 6: RegWriteEnSc should be 0");
        assert (RegWriteEnVec == 0) else $error("Test 6: RegWriteEnVec should be 0");
        assert (writeMemFrom == 0) else $error("Test 6: writeMemFrom should be 0");

        // Aritmeticas
        //7: xor
        #10;
        instruction = 16'h1370;
        #10;
        assert (PcWriteEn == 0) else $error("Test 7: PcWriteEn should be 0");
        assert (MemoryWrite == 0) else $error("Test 7: MemoryWrite should be 0");
        assert (AluOpCode == 1) else $error("Test 7: AluOpCode should be 1");
        assert (WriteRegFrom == 1) else $error("Test 7: WriteRegFrom should be 1");
        assert (OverWriteNz == 1) else $error("Test 7: OverWriteNz should be 1");
        assert (RegToWrite == 3) else $error("Test 7: RegToWrite should be 3");
        assert (RegWriteEnSc == 0) else $error("Test 7: RegWriteEnSc should be 0");
        assert (RegWriteEnVec == 1) else $error("Test 7: RegWriteEnVec should be 1");
        assert (writeMemFrom == 0) else $error("Test 7: writeMemFrom should be 0");
        #10;

        // 8: ecae (add)
        #10;
        instruction = 16'h2190;
        #10;
        assert (PcWriteEn == 0) else $error("Test 8: PcWriteEn should be 0");
        assert (MemoryWrite == 0) else $error("Test 8: MemoryWrite should be 0");
        assert (AluOpCode == 2) else $error("Test 8: AluOpCode should be 2");
        assert (WriteRegFrom == 1) else $error("Test 8: WriteRegFrom should be 1");
        assert (OverWriteNz == 1) else $error("Test 8: OverWriteNz should be 1");
        assert (RegToWrite == 1) else $error("Test 8: RegToWrite should be 1");
        assert (RegWriteEnSc == 0) else $error("Test 8: RegWriteEnSc should be 0");
        assert (RegWriteEnVec == 1) else $error("Test 8: RegWriteEnVec should be 1");
        assert (writeMemFrom == 0) else $error("Test 8: writeMemFrom should be 0");
        #10;

        // 9: mul
        instruction = 16'h4370;
        #10;
        assert (PcWriteEn == 0) else $error("Test 9: PcWriteEn should be 0");
        assert (MemoryWrite == 0) else $error("Test 9: MemoryWrite should be 0");
        assert (AluOpCode == 4) else $error("Test 9: AluOpCode should be 4");
        assert (WriteRegFrom == 1) else $error("Test 9: WriteRegFrom should be 1");
        assert (OverWriteNz == 1) else $error("Test 9: OverWriteNz should be 1");
        assert (RegToWrite == 3) else $error("Test 9: RegToWrite should be 3");
        assert (RegWriteEnSc == 0) else $error("Test 9: RegWriteEnSc should be 0");
        assert (RegWriteEnVec == 1) else $error("Test 9: RegWriteEnVec should be 1");
        assert (writeMemFrom == 0) else $error("Test 9: writeMemFrom should be 0");
        #10;

        // 10: rshf
        instruction = 16'h5160;
        #10;
        assert (PcWriteEn == 0) else $error("Test 10: PcWriteEn should be 0");
        assert (MemoryWrite == 0) else $error("Test 10: MemoryWrite should be 0");
        assert (AluOpCode == 5) else $error("Test 10: AluOpCode should be 5");
        assert (WriteRegFrom == 1) else $error("Test 10: WriteRegFrom should be 1");
        assert (OverWriteNz == 1) else $error("Test 10: OverWriteNz should be 1");
        assert (RegToWrite == 1) else $error("Test 10: RegToWrite should be 1");
        assert (RegWriteEnSc == 0) else $error("Test 10: RegWriteEnSc should be 0");
        assert (RegWriteEnVec == 1) else $error("Test 10: RegWriteEnVec should be 1");
        assert (writeMemFrom == 0) else $error("Test 10: writeMemFrom should be 0");
        #10;

        // 11: lshf
        instruction = 16'h6250;
        #10;
        assert (PcWriteEn == 0) else $error("Test 11: PcWriteEn should be 0");
        assert (MemoryWrite == 0) else $error("Test 11: MemoryWrite should be 0");
        assert (AluOpCode == 6) else $error("Test 11: AluOpCode should be 6");
        assert (WriteRegFrom == 1) else $error("Test 11: WriteRegFrom should be 1");
        assert (OverWriteNz == 1) else $error("Test 11: OverWriteNz should be 1");
        assert (RegToWrite == 2) else $error("Test 11: RegToWrite should be 2");
        assert (RegWriteEnSc == 0) else $error("Test 11: RegWriteEnSc should be 0");
        assert (RegWriteEnVec == 1) else $error("Test 11: RegWriteEnVec should be 1");
        assert (writeMemFrom == 0) else $error("Test 11: writeMemFrom should be 0");
        #10;

        // 12: inc
        instruction = 16'h7E00;
        #10;
        assert (PcWriteEn == 0) else $error("Test 12: PcWriteEn should be 0");
        assert (MemoryWrite == 0) else $error("Test 12: MemoryWrite should be 0");
        assert (AluOpCode == 7) else $error("Test 12: AluOpCode should be 7");
        assert (WriteRegFrom == 1) else $error("Test 12: WriteRegFrom should be 1");
        assert (OverWriteNz == 1) else $error("Test 12: OverWriteNz should be 1");
        assert (RegToWrite == 14) else $error("Test 12: RegToWrite should be 14");
        assert (RegWriteEnSc == 1) else $error("Test 12: RegWriteEnSc should be 1");
        assert (RegWriteEnVec == 0) else $error("Test 12: RegWriteEnVec should be 0");
        assert (writeMemFrom == 0) else $error("Test 12: writeMemFrom should be 0");
        #10;

        // 13: lopix
        instruction = 16'hD200;
        #10;
        assert (PcWriteEn == 0) else $error("Test 13: PcWriteEn should be 0");
        assert (MemoryWrite == 0) else $error("Test 13: MemoryWrite should be 0");
        assert (WriteRegFrom == 0) else $error("Test 13: WriteRegFrom should be 0");
        assert (OverWriteNz == 0) else $error("Test 13: OverWriteNz should be 0");
        assert (RegToWrite == 2) else $error("Test 13: RegToWrite should be 2");
        assert (RegWriteEnSc == 0) else $error("Test 13: RegWriteEnSc should be 0");
        assert (RegWriteEnVec == 1) else $error("Test 13: RegWriteEnVec should be 1");
        assert (writeMemFrom == 1) else $error("Test 13: writeMemFrom should be 1");
        #10;

        //14: svpix
        instruction = 16'hC300;
        #10;
        assert (PcWriteEn == 0) else $error("Test 14: PcWriteEn should be 0");
        assert (MemoryWrite == 1) else $error("Test 14: MemoryWrite should be 1");
        assert (OverWriteNz == 0) else $error("Test 14: OverWriteNz should be 0");
        assert (RegWriteEnSc == 0) else $error("Test 14: RegWriteEnSc should be 0");
        assert (RegWriteEnVec == 0) else $error("Test 14: RegWriteEnVec should be 0");
        assert (writeMemFrom == 1) else $error("Test 14: writeMemFrom should be 1");

        #20;
        $finish;
    end
endmodule	