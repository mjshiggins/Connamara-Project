#!/usr/bin/env ruby

##################################################
#### Connamara "Homework"
#### MacCallister Higgins
#### mac@nevada.unr.edu
#### Functionality: Translates straight chained and branched alkanes from SMILES to IUPAC nomenclature
#### Alkanes: Substances consisting entirely of single-bonded carbon and hydrogen atoms and lacking functional groups
#### Branched Alkanes: Derived from the straight-chain alkanes system by removing one of the hydrogen atoms from a methylene group
#### Use: Run via command line using --> ruby orgChem_v2.rb "CCC"
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

  # Case 11 (Which for some reason is completely different. Yay organic chemistry)
  elsif carbonVal == 11
    temp.concat("undec")

  # Begin standard prefixing procedure by parsing each digit of the carbon count
  elsif carbonVal >= 10 
    while x > 0  do
      y = (x % 10)
      x = (x / 10)
      t = prefixer(y, counter)

      # Check for multiple vowel issues
      if ( t[1] == 'a' || t[1] == 'e' || t[1] == 'i' || t[1] == 'o' || t[1] == 'u' )
        if ( temp[-1] == 'a' || temp[-1] == 'e' || temp[-1] == 'i' || temp[-1] == 'o' || temp[-1] == 'u' )
          # Remove last character
          temp.chop!
        end
      end
      temp.concat()
      counter = counter + 1
    end
  end

  # Set final suffix for alkane or branch
  # Denpends on CnH2n+2 (ane) for alkanes or CnH2n+1 (yl) alkyl groups
  if !branched
    if ( temp[-1] == 'a' || temp[-1] == 'e' || temp[-1] == 'i' || temp[-1] == 'o' || temp[-1] == 'u' )
      # Remove last character
      temp.chop!
    end
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
    @branchArray = []
    # exploreArray is a stack for temporarily holding unexplored child nodes, potentially unneeded
    @exploreArray= []
  end


  ##################################################
  # Name: clearCopy
  # Functionality: Clears exploreArray, copies in next and branchArray
  # Pre:
  # Post: 
  ##################################################
  def clearCopy()
    # Erase and Prime exploreArray by copying next into exploreArray
    while @exploreArray.size > 0
      @exploreArray.pop
    end

    # Branch Array
    @next.each do |index|
      @exploreArray.push(index)
      end
    @branchArray.each do |index|
      @exploreArray.push(index)
      end
  end

end



##################################################
#### Class: Graph
#### Description: Directed Graph for representing the structure of compounds
##################################################
class Graph
  attr_accessor :head, :tail, :iterator, :return, :iupac, :firstRun, :maxLength, :carbonCount, :reverse

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
    @maxLength = 0
    @carbonCount = 0
    @reverse = false
  end

  ##################################################
  # Name: findTail
  # Functionality:  Returns tail of longest carbon chain from vertex
  # Pre: Branch pointers exist in next and branchArray, no duplicates
  # Post: Returns pointer to end of longest carbon chain, next and branchArr populated correctly, fixes locants
  ################################################## 
  def findTail(vertex)
    # Initializations
    counter = 1
    max = 0
    tail = vertex
    iterator = vertex
    branchArr = []

    # Prime iterator
    iterator.locant = counter
    iterator.clearCopy

    # Search
    while iterator != nil
      # Multiple children
      if(iterator.exploreArray.size > 1)
        # Save branch location
        branchArr.push(iterator)
        # Pop from exploreArray and increment iterator, do a max test, set tail
        iterator = iterator.exploreArray.pop
        # Prime iterator
        iterator.clearCopy
        counter += 1
        iterator.locant = counter

        if counter > max
          max = counter
          tail = iterator
          vertex.length = counter
        end

      # One child
      elsif (iterator.exploreArray.size == 1)
        iterator = iterator.exploreArray.pop
        # Prime iterator
        iterator.clearCopy
        counter += 1
        iterator.locant = counter
        if counter > max
          max = counter
          tail = iterator
          vertex.length = counter
        end
      
      # No child
      elsif (iterator.exploreArray.size == 0)
        # Send back to last branch
        if branchArr.size != 0
          # Set iterator to pop
          iterator = branchArr.pop
          # Reset counter
          counter = iterator.locant
        # No more branches, return tail
        elsif iterator.exploreArray.size == 0
          return tail
        end
      end 
    end
  
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
    if parentNode.locant != nil
      temp.previous = (parentNode)
      temp.locant = ((parentNode.locant) + 1)
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
  # Name: refactorGraph
  # Functionality:  Finds longest chain, renumbers all locants, tests for branches and sets bool for head
  #                 Rebuilds node child branches, runs refactorGraph recursively on each child branch, populates length
  # Pre: DAG w/all children in node.next, head vertex is part of longest chain due to SMILES formulation
  #      To run properly, call with @head and @tail in buildGraph
  # Post: Fully numbered and rebuilt nodes
  ##################################################
  def refactorGraph(head, tail)
    # Initializations
    branchFlag = false
    iterator = tail
    # Test
    if head == nil || tail == nil
      return nil
    end
    
    # Move backwards from tail to head while: 
      while (iterator != nil && iterator != head)
        # Checking for branches
        if iterator.previous != nil && iterator.previous.next.size > 1
          branchFlag = true
          # Rebuilding child branch directories
          iterator.previous.next.each do |x| 
            if x != iterator
              iterator.previous.branchArray.push(x)
              iterator.previous.next.delete(x)
            end
          end
          # Recursively call on each child
          iterator.previous.branchArray.each do |x|
            tailTemp = findTail(x)
            x.length = tailTemp.locant
            refactorGraph(x,tailTemp)
          end
        end
        # Renumbering locants check (useless on first round of recursion, but fixes DP done on branch nodes for finding the longest chain)
        if iterator.previous != nil && iterator != head
          if iterator.previous.locant != (iterator.locant - 1) 
            puts "Error in locant numbering"
          end
        end
        
        # Decrementing the iterator
        iterator = iterator.previous      
      end

    # Set branches for dynamic programming later (Does this node have any branches on its main carbon chain?)
    iterator = head
    if branchFlag
      iterator.branches = true
    end
    
    # Set node max branch length
    iterator.length = tail.locant

    return iterator.length

  end

  ##################################################
  # Name: reverseGraph
  # Functionality: Checks to see which side the main carbon chain should be numbered from
  # Pre: next only has a single node
  # Post: Returns true if reversal required, false otherwise
  ##################################################
  def reverseGraph(head, tail)
    c1 = 0
    c2 = 0
    iH = head
    iT = tail

    if (iH == iT || iT.previous == iH)
      return false
    end

    while(iH.branchArray.size == 0)
      c1 += 1
      iH = iH.next[0]
    end
    while (iT.previous != nil && iT.previous.branchArray.size == 0)
      c2 += 1
      iT = iT.previous
    end

    # Current numbering is correct
    if c1 < c2
      return false

    # Curent numbering is incorrect
    elsif c2 < c1
      return true

    # Equal
    elsif c1 == c2
      return false
        
    end
  end

  ##################################################
  # Name: buildGraph
  # Functionality: Builds graph from SMILES string
  # Pre: SMILES string formatted as "CCC(C)C"
  # Post: Fully populated and properly numbered graph
  ##################################################
  def buildGraph(smile)
    branchArr = []
    iterator = nil

      # Loop until end of string, uses a simulated stack to store branches in order and number
      smile.split("").each do |i|
        case i
        # If branch is found "(", push branch return pointer and continue
          when "("
            branchArr.push(iterator)
        # If end of branch is found ")", return to "popped" branch return pointer
          when ")"
            iterator = branchArr.pop
        # If simply another carbon, just add the new vertex to the parent node, increment and assign node value
          when "C"
            if iterator != nil
              temp = addVertex(iterator)
            else
              temp = addVertex
            end
            iterator = temp
        end
      end

      # Refactor and Reverse (if needed)
      refactorGraph(@head,@tail)

      if reverseGraph(@head, @tail)
        iterator = @head
        while iterator.next[0] != nil
          # Flip locant
          iterator.locant = (maxLength - iterator.locant + 1)
          iterator = iterator.next[0]
        end
      end

  end


  ##################################################
  # Name: buildString
  # Functionality: Recursively called in order to build IUPAC string
  # Pre: Fully processed DAG
  # Post: Returns fully concatenated build string
  ##################################################
  def buildString(vertex)
      # Initializations
      base = ""
      temp = ""
      iterator = vertex
      length = head.length
      hash = Hash.new
      counter = 0

      # Prime loop with base structure by checking first run and then flipping bool (firstRun)
      if @firstRun
        @firstRun = false
        base.concat(prefixBuilder(length, false))
      end


      while iterator.next[0] != nil

        if iterator.branchArray.size > 0
          iterator.branchArray.each do |x|
            # If the branch itself has branches (sub-branch problem)
            if x.branches
              z = buildString(x)
              y = "(#{z}#{prefixBuilder(x.length,true)})"
            # If it's just a standard branch
            else
              y = "#{prefixBuilder(x.length,true)}"
            end

            # Create hash if necessary
            if hash[y] == nil
              hash[y] = []
            end
              
            # Push locant to hash
            hash[y].push(iterator.locant)
          end
        end

        # Increment iterator
        iterator = iterator.next[0]
        counter += 1
      end


      # Begin sorted string building
      sorted = hash.sort_by {|k,v| k}
      temp = ""

      sorted.each do |x|        
        # Add locants for first group
        x[1].sort!
        x[1].each do |y|
          temp.concat(y.to_s)
          temp.concat(",")
        end

        # Remove last comma
        temp.chomp!(",")

        # Add dash
        temp.concat("-")

        # Add numerical prefix for number of identical branches
        case x[1].size
        when 2
          temp.concat("di")
        when 3
          temp.concat("tri")
        when 4
          temp.concat("tetra")
        when 5
          temp.concat("penta")
        when 6
          temp.concat("hexa")
        when 7
          temp.concat("hepta")
        when 8
          temp.concat("octa")
        when 9
          temp.concat("nona")
        when 10
          temp.concat("deca")
        end

        # Add regular prefix
        temp.concat("#{x[0]}-")
      end

      # Remove last dash
      temp.chomp!("-")

      return temp.concat(base)

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
  # Name: cleaner
  # Functionality:  Removes all "vowel" based naming issues
  #                 Examples: aa (decaane), ia (triaconta), heni/hene, icosa (drop 'i' when proceeded by vowel)
  #                 General Rule: Drop second vowel
  # Pre:  Requires populated iupac member, translate must be run
  # Post: Correctly formatted string
  ##################################################
  def cleaner()
    # tr doesn't do what I'd like it to do here
    iupac.tr!("aa", 'a')
    iupac.tr!('ia', 'i')
    iupac.tr!('ai', 'a')
    iupac.tr!('ei', 'e')
    iupac.tr!('ii', 'i')
    iupac.tr!('oi', 'o')
    iupac.tr!('ui', 'u')
    iupac.tr!(',-', '-')
    iupac.tr!('--', '-')
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
    iupac.concat(compoundGraph.buildString(compoundGraph.head))

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

