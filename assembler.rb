require 'pry'
require_relative 'symbol_table'

class Assembler
  attr_accessor :input, :instructions, :symbols

  JUMP_CODE = {
    "JGT" => "001",
    "JEQ" => "010",
    "JGE" => "011",
    "JLT" => "100",
    "JNE" => "101",
    "JLE" => "110",
    "JMP" => "111"
  }

  DEST_CODE = {
    "M" => "001",
    "D" => "010",
    "MD" => "011",
    "A" => "100",
    "AM" => "101",
    "AD" => "110",
    "AMD" => "111"
  }

  COMP_CODE = {
    # when a = 0
    "0" => "0101010",
    "1" => "0111111",
    "-1" => "0111010",
    "D" => "0001100",
    "A" => "0110000",
    "M" => "1110000",
    "!D" => "0001101",
    "!A" => "0110001",
    "!M" => "1110001",
    "-D" => "0001111",
    "-A" => "0110011",
    "-M" => "1110011",
    "D+1" => "0011111",
    "A+1" => "0110111",
    "M+1" => "1110111",
    "D-1" => "0001110",
    "A-1" => "0110010",
    "M-1" => "1110010",
    "D+A" => "0000010",
    "D+M" => "1000010",
    "D-A" => "0010011",
    "D-M" => "1010011",
    "A-D" => "0000111",
    "M-D" => "1000111",
    "D&A" => "0000000",
    "D&M" => "1000000",
    "D|A" => "0010101",
    "D|M" => "1010101"
  }

  def initialize input
    @input = resolve_symbols input
    @instructions = []
    @symbols = SymbolTable.new
  end

  def parse
    input.each do |line|
      a_instr = /@/
      if a_instr =~ line
        instruction = a_command line
      else
        instruction = c_command line
      end
      instruction.concat "\n"
      instructions.push instruction
    end
  end

  def a_command line
    # line should be of format "@symbol" or "@integer"
    address = line.delete "@"
    if /\d+/ =~ address
      register = address.to_i
    else
      register = @symbols[symbol]
      # address is a symbol; look it up in symbol table
    end
    binary = register.to_s(2)
    sprintf("%016d", binary)
  end

  def c_command line
    instr, jump = line.split ";"
    jump_bits = ""

    if jump
      jump_bits = JUMP_CODE[jump]
    else
      jump_bits = "000"
    end

    instr_bits = parse_command instr

    # p head, comp_bits, dest_bits, jump_bits
    head = "111"
    head + instr_bits + jump_bits
  end

  private

  def parse_command instr
    if instr == "0"
      return "0101010000"
    end

    instr_bits = ""
    if /=/ =~ instr
      dest, comp = instr.split "="
      comp_bits = ""
      if comp
        comp = sanitize_instr(comp)
        comp_bits = COMP_CODE[comp]
      else
        comp_bits = "0000000"
      end
      dest_bits = DEST_CODE[dest]
      instr_bits = comp_bits + dest_bits
    else
      dest_bits = "000"
      instr_bits = COMP_CODE[instr] + dest_bits
    end
    instr_bits
  end

  def resolve_symbols input
    lines = sanitize input

  end

  def sanitize input
    # gets rid of whitespace and comments (not including inline comments)
    blank = /^\s+$/
    comment = /^\/\/.+$/
    lines = input.reject { |line| line.match(blank) || line.match(comment) }
    lines.map { |line| line.strip }
  end

  def sanitize_instr(comp)
    # Gets ride of comments following an instruction
    comp.split(" ").first
  end

end

if $0 == __FILE__
  /\/(?<filename>\w+)./ =~ ARGV.first
  lines = ARGF.each_line
  assembler = Assembler.new lines
  assembler.parse
  file = open("#{filename}.hack", "w")
  assembler.instructions.each do |line|
    file.write line
  end
  file.close
end
