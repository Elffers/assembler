require_relative 'code'

describe Code do
  describe ".encode" do
    context "A-instructions" do
      let(:instr) { AInstruction.new "@2" }

      it "returns correct binary instruction" do
        expect(Code.encode instr).to eq "0000000000000010"
      end
    end
  end
end
