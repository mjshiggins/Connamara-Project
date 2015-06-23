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
##################################################
class Node
  attr_accessor :node, :next, :previous, :explore, :branches, :carbonLen, :explore2

  def initialize(*node)
    # Node name will be used as locant numbering
    @node = nil
    # Branches is a bool that indicates whether or not the substituent has sub-branches
    @branches = false
    # CarbonLen is only populated for nodes that start a new or substituent chain, and indicates base (longest) length
    @carbonLen = -1
    # Create pointer hashes, scales on demand
    @previous = nil
    @next = []
    @explore = []
    # Explore 2 is a stack for all child nodes, including mainline during findLength
    @explore2 = []
  end

  # Separates the next node in the main branch from the other branches, moves others to explore hash
  # Requires all node.node values to be numbered in graph correctly before use
  def rebuild()
    tempArr = []
    while (@next.length > 1)
      temp = @next.pop
      if (temp.node == 1)
        @explore.push(temp)
      else
        tempArr.push(temp)
      end
    end
    # Clean main carbon chains from branch explore array
    while (@explore.length > 1)
      temp = @explore.pop
      if (temp.node == 1)
        explore.push(temp)
      end
    end
    @next.push(tempArr.pop)
    # Move saved explore nodes back over
    #while (@explore2.length > 0)
      #explore.push(@explore2.pop)
    #end
  end

end

##################################################
#### Class: Graph
#### Description: Directed Graph for representing the structure of compounds
##################################################
class Graph
  attr_accessor :head, :tail, :iterator, :return, :iupac, :firstRun, :baseCount

    def initialize()
        @head = nil
        @tail = nil
        @iterator = nil
        @return = {}
        @iupac = ""
        @firstRun = true
        @baseCount = 0

    end

  
    # Adds vertex (carbon) to next available pointer in parameter (parent) node
    # Also creates reverse link for numbering function
    def add_vertex(parentNode = Node.new)
      temp = Node.new
      if parentNode != nil
        temp.previous = (parentNode)
        parentNode.next.push(temp)
      end
      return temp
    end

    # Head getter function
    def getHead()
      return @head
    end



    # Rebuilds all nodes in graph
    def rebuildAll
    end

    # Finds the longest chain from any given carbon molecule
    # Returns either length count or pointer to tail, depending on parameter and purpose
    def findLength(vertex, tailBool)
      # Initializations (counter to one, clear the branch array)
      counter = 1
      maxVal = 0
      branchArr = []
      @iterator = vertex
      flag = true
      branchFlag = true

      # Loop until max depth found, uses a simulated stack to store branches in order
      while flag
        # If no children pointers are found, 
        if @iterator.next.length == 0
          # Do max test/update
          if counter > maxVal
            # Update maxVal
            maxVal = counter
            # Update @tail pointer if new max
            @tail = @iterator
          end

          # While flag
          while branchFlag
            returnNode = branchArr.pop
            # If branch return array isnt empty
            if returnNode != nil
              # If explore isn't empty
              @iterator = returnNode
              counter = @iterator.node
              exploreNode = @iterator.explore2.pop

              if exploreNode != nil
                # Push branch back onto stack
                branchArr.push(@iterator)
                # Set iterator to explore and save explore node
                @iterator = exploreNode
                counter += 1
                @iterator.node = counter
                # Flag 
                branchFlag = false             
              end
            elsif returnNode == nil
              # Set tail and renumber main carbon line
              @tail = @iterator
              baseCount = maxVal
              if tailBool
                return @tail
              else
                return maxVal
              end
              branchFlag = false
            end
          end
          branchFlag = true

        # If multiple pointers to children are found
        elsif ( @iterator.next.length > 1 || @iterator.explore.length > 0)
          # Push node to the branch return array
          branchArr.push(@iterator)
          # Check for a populated explore stack on node, first run
          if (@iterator.explore.length == 0)
            # If explore stack empty, populate explore and explore2 with all branches
            @iterator.next.each {|x| @iterator.explore2.push(x)}
            @iterator.next.each {|x| @iterator.explore.push(x)}
            @iterator.rebuild()
          end
          # Check for a populated explore2 stack on node, subsequent runs
          if (@iterator.explore2.length == 0)
            # If explore stack empty, populate explore and explore2 with all branches
            @iterator.explore.each {|x| @iterator.explore2.push(x)}
            @iterator.rebuild()
          end
          # Set iterator to pop explore
          @iterator = @iterator.explore2.pop
          counter += 1
          @iterator.node = counter

        # If only one child, iterate and update counter, next.length = 1
        elsif (@iterator.next.length == 1)
          @iterator = iterator.next[0]
          counter += 1
          @iterator.node = counter

        end
      end
    end

    # Checks for branches
    def branchCheck(head, tail)
      while(tail != head)
        if(tail.explore.length > 0)
          return true
        end
        tail = tail.previous
      end
      return false
    end

    # Renumbers all branches (recursively) with correct locants, enables dynamic programming
    def renumber(head)
      # Find length from head, assigning proper locants
      head.carbonLen = findLength(head, false)

      # Find branches, recursively call renumber() on each branch
      while(head != nil)
        # If a branch exists, renumber it and populate carbonLen fields
        if (head.explore.length > 0)
          head.explore.each {|x| renumber(x) }
        end
        head = head.next[0]
      end
    end

    # Checks main carbon string to see if number reversal is necessary
    # returns pointer to proper tail due to recursive structure
    def reverseCheck(head, tail)
    end

    # Accepts computed tail as parameter and switches all previous/next pointers and @head/@tail members, renumbers carbons
    # Used when main chain is determined to be backwards in rebuildGraph
    def numberReverse(tail)

    end

    # Builds the entire graph from the SMILE string
    def buildGraph(smile)
      branchArr = []
      @iterator = nil

      # Prime loop with first carbon, assign @head
      # Loop until end of string, uses a simulated stack to store branches in order and number
      smile.split("").each do |i|
        case i
        # If branch is found "(", push branch return pointer and continue
          when "("
            branchArr.push(@iterator)
        # If end of branch is found ")", return to "popped" branch return pointer
          when ")"
            @iterator = branchArr.pop
        # If simply another carbon, just add the new vertex to the parent node, increment and assign node value
          when "C"
            if(@head == nil)
              @head = add_vertex()
              @iterator = @head
            else
              temp = add_vertex(@iterator)
              @iterator = temp
            end
        end
      end
      
      # Determine correct numbering scheme for compound, populates number values, carbonLen, and branches
      puts findLength(@head, false)
      # Assign head, tail and rebuild all nodes
      renumber(@head)
      # Check for renumbering
        # Reverse main chain numbers
        # Rebuild nodes if renumbering was required (potentially not necessary)
    end

    # Recursively called in order to build IUPAC string
    # Returns fully concatenated build string
    def buildString(vertex)
      # Initializations
      base = ""
      @iterator = vertex
      length = @iterator.carbonLen

      # Prime loop with base structure by checking first run and then flipping bool (firstRun)
      if (@iterator.explore.length > 0)
        @iterator.explore.each {|x| @iterator.explore2.push(x)}
      end

      # Find length
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
    compoundGraph = Graph.new
    compoundGraph.buildGraph(@smile)
    iupac = compoundGraph.buildString(compoundGraph.getHead())
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
