describe Assembler::Code do
  describe ".encode" do
    context "A-instructions" do
      let(:instr) { Assembler::AInstruction.new "@2" }

      it "returns correct binary instruction" do
        expect(Assembler::Code.encode instr).to eq "0000000000000010"
      end
    end

    context "C-instructions" do
      let(:instr1) { Assembler::CInstruction.new "D=M" }
      let(:instr2) { Assembler::CInstruction.new "M=D+M" }

      context "without jump specification" do
        it "returns binary instruction" do
          expect(Assembler::Code.encode instr1).to eq "1111110000010000"
          expect(Assembler::Code.encode instr2).to eq "1111000010001000"
        end
      end

      context "with jump specification" do
        let(:instr1) { Assembler::CInstruction.new "0;JMP" }
        let(:instr2) { Assembler::CInstruction.new "D;JGT" }
        it "sets instruction bits when no destination specified" do
          expect(Assembler::Code.encode instr1).to eq "1110101010000111"
          expect(Assembler::Code.encode instr2).to eq "1110001100000001"
        end
      end
    end
  end
end
