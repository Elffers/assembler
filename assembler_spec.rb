require_relative 'assembler'

describe Assembler do
  context "with no symbols" do
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
        expect(assembler.input.count).to eq 6
      end
    end

    describe "#a_command" do
      it "returns binary instruction" do
        line = "@2"
        expect(assembler.a_command line).to eq "0000000000000010"
      end
    end

    describe "#c_command" do
      it "returns binary instruction" do
        line = "D=M"
        expect(assembler.c_command line).to eq "1111110000010000"
        line = "M=D+M"
        expect(assembler.c_command line).to eq "1111000010001000"
      end
    end

    describe "#parse" do
      it "parses instructions into binary" do
        assembler.parse
        puts assembler.instructions
        expect(assembler.instructions).to eq ["0000000000000010", "1110110000010000", "0000000000000011", "1110000010010000", "0000000000000000", "1110001100001000"]
      end
    end
  end
end
