module Assembler
  class Assembler
    attr_accessor :instructions, :output, :symbols, :input, :resolved_instrs

    def initialize input
      @input = sanitize input
      @symbols = SymbolTable.new
      @resolved_instrs = resolve_symbols
      @instructions = []
    end

    def perform
      parse
      @instructions.map do |instr|
        Code.encode instr
      end.join("\n")
    end

    private

    # Creates line numbers of instructions, ignoring instruction labels (i.e.
    # (OUTPUT), etc)
    def index input
      line_numbers = []
      i = 0
      @input.each do |instr|
        line_numbers << i
        # Only increments index if instruction is not a label
        unless /\(.+\)/ =~ instr
          i += 1
        end
      end
      line_numbers
    end

    def parse
      @resolved_instrs.each do |line|
        instruction =
          if /@/ =~ line
            AInstruction.new line
          else
            CInstruction.new line
          end
        @instructions << instruction
      end
    end

    def resolve_symbols
      instructions = []
      line_numbers = index @input
      # Sets addresses for labeled instructions
      @input.each_with_index do |instr, i|
        if /\((?<label>.+)\)/ =~ instr
          @symbols.table[label] = line_numbers[i]
        end
      end

      # Resolves addresses for A-instructions with labels/variables
      @input.each do |instr|
        if /@/ =~ instr
          address = instr.delete "@"
          if /\D+/ =~ address
            resolved_address = @symbols.table[address] || @symbols.insert(address)
            instr = "@" + resolved_address.to_s
          end
        end
        instructions << instr
      end
      # Deletes label instructions
      instructions.reject { |instr| /\(.+\)/ =~ instr }
    end

    # Gets rid of whitespace and comments (not including inline comments)
    def sanitize input
      sanitized = []
      blank_or_comment = /^(\s+$|\/\/.+)$/
      input.each do |line|
        next if line.match(blank_or_comment)
        sanitized << strip_comments(line)
      end
      sanitized
    end

    # Gets rid of inline comments
    def strip_comments(line)
      line.strip.split(" ").first
    end
  end

  if $0 == __FILE__
    /\/(?<filename>\w+)./ =~ ARGV.first
    lines = ARGF.each_line
    assembler = Assembler.new lines
    output = assembler.perform
    file = open("#{filename}.hack", "w")
    file.write output
    file.close
  end
end
