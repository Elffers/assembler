require 'pry'
require_relative 'symbol_table'
require_relative 'code'

class Assembler
  attr_accessor :instructions, :output, :symbols, :input, :resolved_instrs

  def initialize input
    @input = sanitize input
    @symbols = SymbolTable.new
    @resolved_instrs = resolve_symbols
    @instructions = []
    @output= []
  end

  def parse
    @resolved_instrs.each do |line|
      a_instr = /@/
      instruction =
        if a_instr =~ line
          AInstruction.new line
        else
          CInstruction.new line
        end
      @instructions << instruction
    end
  end

  def perform
    parse
    @instructions.each do |instr|
      instruction = Code.encode instr
      @output << instruction.concat("\n")
    end
    @output
  end

  def resolve_symbols
    instructions = []
    line_numbers = index @input
    @input.each_with_index do |instr, i|
      if /\((?<label>.+)\)/ =~ instr
        @symbols.table[label] = line_numbers[i]
      end
    end

    @input.each do |instr|
      if /@/ =~ instr
        address = instr.delete "@"
        if /\D+/ =~ address
          resolved_address = @symbols.table[address] || @symbols.insert(address)
          instr = "@" + resolved_address.to_s
          # address is a symbol; look it up or add to symbol table
        end
      end
      instructions << instr
    end
    instructions.reject { |instr| /\(.+\)/ =~ instr }
  end

  def index input
    line_numbers = []
    i = 0
    @input.each do |instr|
      if /\(.+\)/ =~ instr
        line_numbers << i
      else
        line_numbers << i
        i += 1
      end
    end
    line_numbers
  end

  def sanitize input
    # gets rid of whitespace and comments (not including inline comments)
    blank = /^\s+$/
    comment = /^\/\/.+$/
    lines = input.reject { |line| line.match(blank) || line.match(comment) }
    lines.map { |line| line.strip }.map do |line|
      strip_comments line
    end
  end

  # TODO incorporate into sanitize input
  def strip_comments(line)
    # Gets ride of comments following an instruction
    line.split(" ").first
  end
end

if $0 == __FILE__
  /\/(?<filename>\w+)./ =~ ARGV.first
  lines = ARGF.each_line
  assembler = Assembler.new lines
  assembler.perform
  file = open("#{filename}.hack", "w")
  assembler.output.each do |line|
    file.write line
  end
  file.close
end
