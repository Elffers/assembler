describe Assembler::Assembler do
  context "without symbols" do
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
    let(:assembler) { Assembler::Assembler.new input }

    describe "#initialize" do
      it "strips comments and whitespace from input" do
        expect(assembler.input.count).to eq 6
        expect(assembler.input.first).to eq "@2"
      end
    end

    describe "#perform" do
      it "generates binary instructions" do
        assembler.perform
        expect(assembler.output).to eq ["0000000000000010\n", "1110110000010000\n", "0000000000000011\n", "1110000010010000\n", "0000000000000000\n", "1110001100001000\n"]
      end
    end
  end

 context "with symbols" do
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

   let(:assembler) { Assembler::Assembler.new input }

   describe "#initialize" do
     it "strips comments and whitespace from input" do

# ["@R0", "D=M", "@R1", "D=D-M", "@OUTPUT_FIRST", "D;JGT", "@R1", "D=M", "@OUTPUT_D", "0;JMP", "(OUTPUT_FIRST)", "@R0", "D=M", "(OUTPUT_D)", "@R2", "M=D", "(INFINITE_LOOP)", "@INFINITE_LOOP", "0;JMP"]
       expect(assembler.input.count).to eq 19
       expect(assembler.input.first).to eq "@R0"
       expect(assembler.input[1]).to eq "D=M"
     end

     it "resolves symbols" do
       expect(assembler.resolved_instrs.first).to eq "@0"
       expect(assembler.resolved_instrs).to eq resolved_instructions.map { |line| line.strip! }
     end
   end

   describe "#perform" do
     it "generates binary instructions" do
       assembler.perform
       expect(assembler.output).to eq ["0000000000000000\n", "1111110000010000\n", "0000000000000001\n", "1111010011010000\n", "0000000000001010\n", "1110001100000001\n", "0000000000000001\n", "1111110000010000\n", "0000000000001100\n", "1110101010000111\n", "0000000000000000\n", "1111110000010000\n", "0000000000000010\n", "1110001100001000\n", "0000000000001110\n", "1110101010000111\n"]
     end
   end

   describe "#index" do
     it "returns line numbers" do
       expect(assembler.send(:index, assembler.input)).to eq [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 10, 11, 12, 12, 13, 14, 14, 15]
     end
   end

 end
end
