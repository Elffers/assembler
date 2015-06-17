describe Assembler::AInstruction do
  describe ".initialize" do
    let(:instr) { Assembler::AInstruction.new "@2" }
    it "sets address" do
      expect(instr.address).to eq 2
    end
  end
end
