require_relative "a_instruction"

describe AInstruction do
  describe ".initialize" do
    let(:instr) { AInstruction.new "@2" }
    it "sets address" do
      expect(instr.address).to eq 2
    end
  end
end
