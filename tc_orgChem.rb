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
  	assert_equal(8, (compoundGraph.findTail(compoundGraph.head)).locant)
  end

  def test_CompoundTranslation0
  	assert_equal("methane", (Compound.new("C","" )).iupac)
  end

  def test_CompoundTranslation1
  	assert_equal("2-methylbutane", (Compound.new("CC(C)CC","" )).iupac)
  end

  def test_CompoundTranslation2
  	assert_equal("2,5-dimethyloctane",(Compound.new("CC(C)CCC(CCC)C","" )).iupac)
  end
 
  def test_CompoundTranslation3
  	assert_equal("6-(1,1-dimethylethyl)-7-ethyl-3,5-dimethylundecane",(Compound.new("CCCCC(CC)C(C(C)CC(C)CC)C(C)(C)C","" )).iupac)
  end

end