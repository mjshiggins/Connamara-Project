require_relative "orgChem_v2"
require "test/unit"
 
class TestCompound < Test::Unit::TestCase
 
  def test_CompoundConstructor
    assert_equal("CC(C)CC", (Compound.new("CC(C)CC","" )).smile )
    assert_equal("2-methylbutane", (Compound.new("","2-methylbutane" )).iupac )
  end

  def test_CompoundCarbonCount
  	temp = (Compound.new("CC(C)CCCC(CC)C",""))
  	compoundGraph = Graph.new
  	compoundGraph.buildGraph(temp.smile)
  	assert_equal(10, compoundGraph.carbonCount)
  end

  def test_CompoundCarbonChainLength
  	temp = (Compound.new("CC(C)CCCC(CC)C",""))
  	compoundGraph = Graph.new
  	compoundGraph.buildGraph(temp.smile)
  	assert_equal(10, compoundGraph.head.length)
  	assert_equal(compoundGraph.maxLength, compoundGraph.head.length)
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