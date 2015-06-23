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
#### Dependencies: valueTest is the number of carbons, counter is the position (tens,hundreds,thousandths)
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
##################################################
class Node
  attr_accessor :locant, :next, :previous, :branchArray, :exploreArray, :branches, :length

  def initialize(*node)
    # Locant (position) numbering
    @locant = nil
    # Branches is a bool that indicates whether or not the substituent has sub-branches
    @branches = false
    # Length is populated for nodes that start a new or substituent chain, and indicates base (longest) length
    @length = -1
    # Straight-Chained and Branched Compounds only require a single previous data member
    @previous = nil
    # "Pointer" arrays. @next will generally only have one member after the graph has been refactored by refactorGraph
    @next = []
    @explore = []
    # exploreArray is a stack for temporarily holding unexplored child nodes, potentially unneeded
    @exploreArray= []
  end

  ##################################################
  # Name: rebuild
  # Functionality: Separates the next node (main carbon chain) from the other branches, moves others to branch array
  # Pre: Requires all node.locant values to be numbered in graph correctly before use (this is done with a refactor, addVertex is not sufficient)
  # Post: Correct child nodes with branch and main carbon chain categories
  ##################################################
  def rebuild()
    tempArr = []
    while (@next.length > 1)
      temp = @next.pop
      if (temp.node == 1)
        @ebranches.push(temp)
      else
        @next.push(temp)
      end
    end
    # Clean main carbon chains from branch array
    while (@explore.length > 1)
      temp = @explore.pop
      if (temp.node == 1)
        explore.push(temp)
      end
    end
  end


end

##################################################
#### Class: Graph
#### Description: Directed Graph for representing the structure of compounds
##################################################
class Graph
  attr_accessor :head, :tail, :iterator, :return, :iupac, :firstRun, :maxLength, :carbonCount

  def initialize()
    # "Pointer" nils
    # @head and @tail should not be modified after being set. @iterator should be used for moving throughout graph
    @head = nil
    @tail = nil
    @iterator = nil
    # @return is a stack for holding branch nodes that must be returned to during iteration
    @return = []
    # IUPAC string placeholder
    @iupac = ""
    # firstRun is a boolean used to differentiate between the naming of the main carbon chain in the compound (alkane) and branches (alkyl)
    # After use must be set to false
    @firstRun = true
    # Used to keep track of largest chain and total number of carbons
    maxLength = 0
    carbonCount = 0
  end

 
  ##################################################
  # Name: addVertex
  # Functionality:  Adds vertex (carbon) to next available pointer in parameter (parent) node
  #                 Also creates reverse link and populates locant, begins graph for first carbon node
  # Pre: Parameter must be valid node, otherwise leave blank and default nil'ed vertex is created/used
  # Post: Vertex added to graph, linked to parentNode.previous, parentNode.next linked to new node, locant updated, max check, @head/@tail assignment
  ################################################## 
  def addVertex(parentNode = Node.new)
    temp = Node.new
    # If a standard addition
    if parentNode != nil
      temp.previous = (parentNode)
      temp.locant = (parentNode.locant + 1)
      # Max test
      if temp.locant > @maxLength
        @maxLength = temp.locant
        @tail = temp
      end
      parentNode.next.push(temp)
    # If first node being added to graph
    elsif parentNode.locant == nil
      @head = temp      
      @tail = temp
      temp.locant = 1
      @maxLength = temp.locant
    end
    @carbonCount += 1
    return temp
  end

  ##################################################
  # Name: buildGraph
  # Functionality: Builds graph from SMILES string
  # Pre: SMILES string formatted as "CCC(C)C"
  # Post: Directed Graph with all child nodes located in node.next, node.branches has not yet been populated
  ##################################################
  def buildGraph(smile)
  end

  ##################################################
  # Name: 
  # Functionality:
  # Pre:
  # Post:
  ##################################################
  def refactorGraph()
  end

  ##################################################
  # Name: 
  # Functionality:
  # Pre:
  # Post:
  ##################################################
  def reverseGraph()
  end

  ##################################################
  # Name: 
  # Functionality:
  # Pre:
  # Post:
  ##################################################
  def drawGraph()
  end

  ##################################################
  # Name: 
  # Functionality:
  # Pre:
  # Post:
  ##################################################
  def buildString()
  end


end


##################################################
#### Class: Compound
#### Description: Data Structure for inputted compounds
##################################################
class Compound
  attr_accessor :smile
  attr_accessor :iupac

  # Create the Compound Object
  def initialize(smile = "", iupac = "")
    @smile = smile
    @iupac = iupac
  end


  ##################################################
  # Name: translate
  # Functionality: Converts member smile to correct iupac format in respective data locations
  # Pre:
  # Post:
  ##################################################
  def translate()
    compoundGraph = Graph.new
    compoundGraph.buildGraph(@smile)
    iupac = compoundGraph.buildString(compoundGraph.getHead())
  end


  ##################################################
  # Name: cleaner
  # Functionality:  Removes all "vowel" based naming issues
  #                 Examples: aa (decaane), ia (triaconta), heni/hene, icosa (drop 'i' when proceeded by vowel)
  #                 General Rule: Drop second vowel
  # Pre:  Requires populated iupac member, translate must be run
  # Post: Correctly formatted string
  ##################################################
  def cleaner()

  end

  ##################################################
  # Name: print
  # Functionality: Displays SMILE and IUPAC data fields
  # Pre: Populated smile and iupac fields, translate and cleaner should have been run, except for debugging purposes
  # Post:
  ##################################################
  def print()
    puts "Compound Data"
    puts "SMILE: #{smile}"
    puts "IUPAC: #{iupac}"
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

  # Translate and Output
  cmp.translate()
  cmp.print()  

end
