require_relative "c_instruction"

describe CInstruction do
  describe ".initialize" do
    let(:instr) { CInstruction.new "D=M" }
    let(:instr2) { CInstruction.new "M=M+1" }
    let(:instr3) { CInstruction.new "D;JMP" }

    it "sets dest, comp and jump" do
      expect(instr.jump).to be_nil
      expect(instr.comp).to eq "M"
      expect(instr.dest).to eq "D"

      expect(instr2.jump).to be_nil
      expect(instr2.comp).to eq "M+1"
      expect(instr2.dest).to eq "M"

      expect(instr3.jump).to eq "JMP"
      expect(instr3.comp).to eq "D"
      expect(instr3.dest).to be_nil
    end
  end
end
