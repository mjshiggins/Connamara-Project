#!/usr/bin/env ruby

class Compound
  attr_accessor :smile
  attr_accessor :iupac

  # Create the Compound Object
  def initialize(smile = "[O=C(Oc1ccccc1C(=O)O)C]", iupac = "Not Yet Computed") # Set defaults (2-acetoxybenzoic acid)
    @smile = smile
    @iupac = iupac
  end

  # Translate Method
  # Converts member smile to correct iupac format in respective data locations
  def translate()

  end

  # Print Method
  # Displays SMILE and IUPAC data fields
  def print()
    puts "Compound Data:"
    puts "SMILE: #{smile}"
    puts "IUPAC: #{iupac}"

  end

end



if __FILE__ == $0
  # Create object and input SMILE name (testing parameters already input)
  cmp = Compound.new
  # Actual Input
  # cmp.iupac = "2-acetoxybenzoic acid"

  # Translate and Output
  cmp.translate()
  cmp.print()
end
