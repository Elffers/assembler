module Assembler
  class CInstruction
    attr_reader :comp, :dest, :jump

    def initialize line
      parse_instruction line
    end

    def parse_instruction line
      instr, @jump = line.split ";"

      if /=/ =~ instr
        @dest, @comp = instr.split "="
      else
        @comp = instr
      end

    end
  end
end
