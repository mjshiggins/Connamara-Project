#!/usr/bin/env ruby

##################################################
#### Connamara "Homework"
#### MacCallister Higgins
#### mac@nevada.unr.edu
#### Functionality: Translates straight chained and branched alkanes from SMILES to IUPAC nomenclature
#### Alkanes: Substances consisting entirely of single-bonded carbon and hydrogen atoms and lacking functional groups
#### Branched Alkanes: Derived from the straight-chain alkanes system by removing one of the hydrogen atoms from a methylene group
#### Use: Run via command line using --> ruby orgChem.rb "compound"
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
#### Dependencies: prefixer(), carbonCount, and "branched" bool
#### Returns: Concatenated, IUPAC name (string)
##################################################

def prefixBuilder(carbonVal, branched)
  # Initializations
  temp = ""
  x = carbonVal
  y = 0
  counter = 0

  # Set prefix for unique carbon counts
  if carbonVal < 10
    case carbonVal
    when 9
      temp.concat("non")
    when 8
      temp.concat("oct")
    when 7
      temp.concat("hept")
    when 6
      temp.concat("hex")
    when 5
      temp.concat("pent")
    when 4
      temp.concat("but")
    when 3
      temp.concat("prop")
    when 2
      temp.concat("eth")
    when 1
      temp.concat("meth")
    end


  # Begin standard prefixing procedure by parsing each digit of the carbon count
  elsif carbonVal >= 10 
    while x > 0  do
      y = (x % 10)
      x = (x / 10)
      temp.concat(prefixer(y, counter))
      counter = counter + 1
    end
  end

  # Set final suffix for alkane or branch
  # Denpends on CnH2n+2 (ane) for alkanes or CnH2n+1 (yl) alkyl groups
  if !branched
    temp.concat("ane")
  else
    temp.concat("yl")
  end

  # Return Final Prefix
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
#### Class: Node
#### Description: Node (carbon) for use in DAG structure
#### Vertex: 
##################################################
class Node
  attr_accessor :node, :next

  def initialize(node)
    @node = node
    # Create pointer array, scales on demand
    @next = {}
  end
end

##################################################
#### Class: Graph
#### Description: DAG for representing the structure of compounds
#### Vertex: 
##################################################
class Graph
  attr_accessor :head, :tail, :iterator, :branch, :iupac

    def initialize()
        #@vertices = {}
        @head = nil
        @tail = nil
        @iterator = nil
        @branch = {}
        @iupac = ""

    end
  
    # Adds vertex (carbon) to next available pointer in parameter (parent) node
    def add_vertex(parentNode)
      temp = Node.new
      parentNode.next.push(temp)
    end

    # Builds the entire graph from the SMILE string
    def buildGraph(smile)
      # Prime loop with first carbon, assign @head
      # Loop until end of string, uses a simulated stack to store branches in order
        # If branch is found "(", push branch return pointer and continue
        # If end of branch is found ")", return to "popped" branch pointer
        # If simply another carbon, just add the new vertex to the parent node
        # If end of string
      #
    end

    # Finds the longest chain from any given carbon molecule
    def findLength(vertex)
      # Initializations (counter to zero, clear the branch array)
      # Loop until max depth found, uses a simulated stack to store branches in order
        # If no children pointers are found, do max test/update and return to "popped" branch pointer
          # If branch array is nil, return counter
        # If multiple pointers to children are found, push to the branch array 
        # If only one child, iterate and update counter
    end

    # Recursively called in order to build IUPAC string
    def buildString(vertex)
    end

    # Potentially unneccesary
    def markBranches()
    end
    
    def to_s
        return @vertices.inspect
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
  def initialize(smile = "", iupac = "")
    @smile = smile
    @iupac = iupac
  end


  # Check for valdiity of straight chained or branched alkanes, reject other compounds
  # Must follow C(n)H(2n+2) format
  # Returns true if valid
  # DEPRECATED
  def alkaneCheck()
    if carbonCount == ((hydrogenCount*2)+2)
      return true
    end
    return false
  end


  # Translate Method
  # Converts member smile to correct iupac format in respective data locations
  def translate()
    # Initialize Carbon and Hydrogen Counts
    @carbonCount = smile.count("C")

    # Count the carbons for prefix
    # DEPRECATED
    #puts carbonCount
    iupac.concat(prefixBuilder(carbonCount,false))


    # Check for parantheses (Branched)

  end

  # Cleaner Method: Removes all "vowel" based naming issues
  # Examples: aa (decaane), ia (triaconta), heni/hene, icosa (drop 'i' when proceeded by vowel)
  # General Rule: Drop second vowel
  # Works on IUPAC member
  def cleaner()

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
  cmp = Compound.new(ARGV[0],"")


  # Check validity of compound, Translate and Output
  #if cmp.alkaneCheck
  if true
    cmp.translate()
    cmp.cleaner()
    cmp.print()  
  else
    puts "Compound is not a straight-chained or branched alkane"
  end

end
