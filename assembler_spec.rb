require_relative 'assembler'

describe Assembler do
  let(:input) { <<input.lines
// Computes R0 = 2 + 3

@2
D=A
@3
D=D+A
@0
M=D
input
 }
  let(:assembler) { Assembler.new input }
  describe "#initialize" do
    it "sets instructions from input file" do
      p assembler.input
      expect(assembler.input.count).to eq 6
    end
  end
end
