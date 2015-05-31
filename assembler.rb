class Assembler
  attr_accessor :input, :instructions

  def initialize input
    @input = sanitize input
    @instructions = []
  end

  def sanitize input
    # gets rid of whitespace and comments
    blank = /^\s+$/
    comment = /\/\/\s/
    lines = input.reject { |line| line.match(blank) || line.match(comment) }
    lines.map { |line| line.delete("\n") }
  end
end

if $0 == __FILE__
  lines = ARGF.each_line
  assembler = Assembler.new lines
end
