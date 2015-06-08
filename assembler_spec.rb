require_relative 'assembler'

describe Assembler do
  context "with no symbols" do
    let(:input) { <<input.lines
// Computes R0 = 2 + 3

@2  //comment
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

    describe "#a_command" do
      it "returns binary instruction" do
        line = "@2"
        expect(assembler.a_command line).to eq "0000000000000010"
      end
    end

    describe "#c_command" do
      it "returns binary instruction" do
        line = "D=M //comment"
        expect(assembler.c_command line).to eq "1111110000010000"
        line = "M=D+M"
        expect(assembler.c_command line).to eq "1111000010001000"
      end

      it "sets instruction bits when no destination specified" do
        line = "0;JMP"
        expect(assembler.c_command line).to eq "1110101010000111"
        line = "D;JGT"
        expect(assembler.c_command line).to eq "1110001100000001"
       end
    end

    describe "#parse" do
      it "parses instructions into binary" do
        assembler.parse
        expect(assembler.instructions).to eq ["0000000000000010\n", "1110110000010000\n", "0000000000000011\n", "1110000010010000\n", "0000000000000000\n", "1110001100001000\n"]
      end
    end
  end

 describe "with symbols" do
   let(:input) { <<input.lines
// Computes R2 = max(R0, R1)  (R0,R1,R2 refer to  RAM[0],RAM[1],RAM[2])

   @R0
   D=M              // D = first number
   @R1
   D=D-M            // D = first number - second number
   @OUTPUT_FIRST
   D;JGT            // if D>0 (first is greater) goto output_first
   @R1
   D=M              // D = second number
   @OUTPUT_D
   0;JMP            // goto output_d
(OUTPUT_FIRST)
   @R0
   D=M              // D = first number
(OUTPUT_D)
   @R2
   M=D              // M[2] = D (greatest number)
(INFINITE_LOOP)
   @INFINITE_LOOP
   0;JMP            // infinite loop
input
    }
   let(:resolved_instructions) { <<output.lines
@0
D=M
@1
D=D-M
@10
D;JGT
@1
D=M
@12
0;JMP
@0
D=M
@2
M=D
@14
0;JMP
output
   }

   let(:assembler) { Assembler.new input }

   describe "initialize" do
     it "resolves symbols" do
       expect(assembler.input).to eq resolved_instructions
     end

   end

   describe "parse" do
     xit "parses instructions into binary" do
       assembler.parse
       expect(assembler.instructions).to eq []
     end
   end

 end
end
