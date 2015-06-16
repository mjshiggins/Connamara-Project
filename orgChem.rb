#!/usr/bin/env ruby

class Stanley
  attr_accessor :year
  attr_accessor :champion

  def initialize(year = "2015", champion = "Chicago Blackhawks")
    @year = year
    @champion = champion
  end

  def print()
    puts "Congratulations to the #{year} Stanley Cup Champions: #{champion}"
  end
end


class Compound
  attr_accessor :smile
  attr_accessor :iupac

  # Create the Compound Object
  def initialize(smile = " ", iupac = "Not Yet Computed") # Set defaults (2-acetoxybenzoic acid)
    @smile = smile
    @iupac = iupac
  end

  # Translate Method
  # Converts member smile to correct iupac format in respective data locations
  def translate()
    @iupac = "2-acetoxybenzoic acid"
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
  #m = Stanley.new
  #m.print()

  # Create object and input SMILE name (testing parameters already input)
  cmp = Compound.new
  # Actual Input
  # cmp.iupac = "2-acetoxybenzoic acid"

  # Translate and Output
  cmp.translate()
  cmp.print()
end
