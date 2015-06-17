require_relative "orgChem"
require "test/unit"
 
class TestCompound < Test::Unit::TestCase
 
  def test_CompoundConstructor
    assert_equal("[O=C(Oc1ccccc1C(=O)O)C]", (Compound.new("[O=C(Oc1ccccc1C(=O)O)C]","2-acetoxybenzoic acid" )).smile )
    assert_equal("2-acetoxybenzoic acid", (Compound.new("[O=C(Oc1ccccc1C(=O)O)C]","2-acetoxybenzoic acid" )).iupac )
  end

  def test_CompoundTranslation
  	assert_equal("2-methylbutane", (Compound.new("[CC(C)CC]","" )).iupac)
  end

  def test_CompoundTranslation
  	assert_equal(10,(Compound.new("[CC(C)CC]","" )).getCarbonCount)
  end
 
end