class AInstruction
  attr_reader :address

  def initialize address
    @address = address.delete("@").to_i
  end
end
