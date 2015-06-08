require 'pry'
require_relative 'symbol_table'
require_relative 'code'

class Assembler
  attr_accessor :instructions, :output, :symbols, :input, :resolved_instrs

  def initialize input
    @input = sanitize input
    @resolved_instrs = resolve_symbols
    @instructions = []
    @output= []
    @symbols = SymbolTable.new
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

  private

  def resolve_symbols
    @resolved_attrs = @input
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
  assembler.parse
  file = open("#{filename}.hack", "w")
  assembler.output.each do |line|
    file.write line
  end
  file.close
end
