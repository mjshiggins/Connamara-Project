require_relative "orgChem_v2"
require "test/unit"
 
class TestCompound < Test::Unit::TestCase
 
  def test_CompoundConstructor
    assert_equal("CC(C)CC", (Compound.new("CC(C)CC","" )).smile )
    assert_equal("2-methylbutane", (Compound.new("","2-methylbutane" )).iupac )
  end

  def test_CompoundCarbonCount
  	compoundGraph = Graph.new
  	compoundGraph.buildGraph("CC(C)CCCC(CC)C")
  	assert_equal(10, compoundGraph.carbonCount)
  end

  def test_CompoundCarbonChainLength
  	compoundGraph = Graph.new
  	compoundGraph.buildGraph("CC(C)CCCC(CC)C")
  	assert_equal(8, compoundGraph.maxLength)
  end

  def test_findTail
  	compoundGraph = Graph.new
  	compoundGraph.buildGraph("CC(C)CCCC(CC)C")
  	compoundGraph.refactorGraph(compoundGraph.head, compoundGraph.tail)
  	assert_equal(compoundGraph.tail.locant, compoundGraph.findTail(compoundGraph.head).locant)
  	assert_equal(8, compoundGraph.tail.locant)
  end

  def test_CompoundTranslation0
  	c = (Compound.new("C","" ))
  	c.translate
  	assert_equal("methane", c.iupac)
  end

  def test_CompoundTranslation1
  	c = (Compound.new("CC(C)CC","" ))
  	c.translate
  	assert_equal("2-methylbutane", c.iupac)
  end

  def test_CompoundTranslation2
  	c = (Compound.new("CC(C)CCC(CCC)C","" ))
  	c.translate
  	assert_equal("2,5-dimethyloctane", c.iupac)
  end
 
  def test_CompoundTranslation3
  	c = (Compound.new("CCC(C)C(C)(CC)CC","" ))
  	c.translate
  	assert_equal("3-ethyl-3,4-dimethylhexane", c.iupac)
  end

end