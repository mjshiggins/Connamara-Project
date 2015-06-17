#!/usr/bin/env ruby

##################################################
#### Connamara "Homework"
#### MacCallister Higgins
#### mac@nevada.unr.edu
#### Functionality: Translates straight chained and branched alkanes from SMILES to IUPAC nomenclature
#### Alkanes: Substances consisting entirely of single-bonded carbon and hydrogen atoms and lacking functional groups
#### Branched Alkanes: Derived from the straight-chain alkanes system by removing one of the hydrogen atoms from a methylene group
#### Use: Run via command line using "ruby orgChem.rb ARGUMENT"
##################################################


##################################################
#### Function: prefixer
#### Description: Translates an (int) into proper IUPAC string prefix
#### Dependencies: 
#### Returns: IUPAC prefix (string)
##################################################

def prefixer(valueTest, counter)
  # Intializations
  temp = ""
  standardFlag = false

  # Standard Prefix Test
  case valueTest
  when 1..3
    standardFlag = false
  when 4..9
    standardFlag = true
  end

  # Prefix values
  case valueTest

  # Standard Prefix Construction
  when 9
    temp.concat("nona")
  when 8
    temp.concat("octa")
  when 7
    temp.concat("hepta")
  when 6
    temp.concat("hexa")
  when 5
    temp.concat("penta")
  when 4
    temp.concat("tetra")

# Non-Standard Prefix Construction
  when 3
    temp.concat("tri")
    case counter
    when 1
      temp.concat("aconta")
    when 2
      temp.concat("cta")
    when 3
      temp.concat("lia")
    end

  when 2
    case counter
    when 0
      temp.concat("do")
    when 1
      temp.concat("icosa") #BUG: drop the 'i' when preceeded by a vowel
    when 2
      temp.concat("dicta")
    when 3
      temp.concat("dilia")
    end

  when 1 #BUG: Sometimes "hene" or "heni": potential linter in compound class to add?
    case counter
    when 0
      temp.concat("hen") #BUG: 11 is "undecane," however, hendecane is an accepted synonym
    when 1
      temp.concat("deca")
    when 2
      temp.concat("hecta")
    when 3
      temp.concat("kilia")
    end

  when 0
  end

# Add standard prefix endings
  if standardFlag
    case counter
    when 1
      temp.concat("conta")
    when 2
      temp.concat("cta")
    when 3
      temp.concat("lia")
    end
  end

  return temp;
end

##################################################
#### Function: prefixBuilder
#### Description: Concatenates all prefixes into the proper IUPAC format
#### Dependencies: prefixer() and carbonCount
#### Returns: Concatenated, IUPAC name (string)
##################################################

def prefixBuilder(carbonVal)
  # Initializations
  temp = ""
  x = carbonVal
  y = 0
  counter = 0

  # Set prefix for unique carbon counts
  if carbonVal < 10
    case carbonVal
    when 9
      temp.concat("nonane")
    when 8
      temp.concat("octane")
    when 7
      temp.concat("heptane")
    when 6
      temp.concat("hexane")
    when 5
      temp.concat("pentane")
    when 4
      temp.concat("butane")
    when 3
      temp.concat("propane")
    when 2
      temp.concat("ethane")
    when 1
      temp.concat("methane")
    end

  # Begin standard prefixing procedure by parsing each digit of the carbon count
  elsif carbonVal >= 10 
    while x > 0  do
      y = (x % 10)
      x = (x / 10)
      temp.concat(prefixer(y, counter))
      counter = counter + 1
    end

    # Add final suffix
    # Denpends on CnH2n+2 (ane) for alkanes or CnH2n+1 (yl) alkyl groups
    temp.concat("ne")
  end
  return temp
end

##################################################
#### Class: StanleyCup
#### Dependencies: Conference Playoffs
##################################################
class StanleyCup
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

##################################################
#### Class: Compound
#### Description: Data Structure for inputted compounds
##################################################
class Compound
  attr_accessor :smile
  attr_accessor :iupac
  attr_accessor :carbonCount
  attr_accessor :hydrogenCount

  # Create the Compound Object
  def initialize(smile = "CCCCCCCCCCCCCCCCCCCCCCCC", iupac = "")
    @smile = smile
    @iupac = iupac

    # Initialize Carbon and Hydrogen Counts
    carbonCount = smile.count("C")
    hydrogenCount = smile.count("H")
  end

  # Check for valdiity of straight chained or branched alkanes, reject other compounds
  # Must follow C(n)H(2n+2) format
  # Returns true if valid
  def alkaneCheck()
    if carbonCount == ((hydrogenCount*2)+2)
      return true
    end
    return false
  end


  # Translate Method
  # Converts member smile to correct iupac format in respective data locations
  def translate()
    @carbonCount = 0

    # Count the carbons for prefix
    puts smile.length
    iupac.concat(prefixBuilder(carbonCount))


    # Check for parantheses (Branched)

  end

  # Print Method
  # Displays SMILE and IUPAC data fields
  def print()
    puts "Compound Data"
    puts "SMILE: #{smile}"
    puts "IUPAC: #{iupac}"
  end

  # Carbon Count Getter
  def getCarbonCount()
    return carbonCount
  end

end

####################################################
## Main Program Code
####################################################

if __FILE__ == $0
  #m = StanleyCup.new
  #m.print()

  # Create object and input SMILE name (testing parameters already input)
  cmp = Compound.new
  # Actual Input
  # cmp.iupac = "2-acetoxybenzoic acid"

  # Check validity of compound, Translate and Output
  if cmp.alkaneCheck
    cmp.translate()
    cmp.print()  
  else
    puts "Compound is not a straight-chained or branched alkane"
  end

    

end
