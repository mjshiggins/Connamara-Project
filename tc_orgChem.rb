require_relative "orgChem"
require "test/unit"
 
class TestCompound < Test::Unit::TestCase
 
  def test_CompoundConstructor
    assert_equal("[O=C(Oc1ccccc1C(=O)O)C]", (Compound.new("[O=C(Oc1ccccc1C(=O)O)C]","2-acetoxybenzoic acid" )).smile )
    assert_equal("2-acetoxybenzoic acid", (Compound.new("[O=C(Oc1ccccc1C(=O)O)C]","2-acetoxybenzoic acid" )).iupac )

  end

  def test_CompoundTranslation
  	testCompound = Compound.new("CC(C)CC")
  	assert_equal("2-methylbutane", testCompound.iupac)

  end
 
end