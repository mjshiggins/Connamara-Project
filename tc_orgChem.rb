require_relative "orgChem"
require "test/unit"
 
class TestCompound < Test::Unit::TestCase
 
  def test_Compound
    assert_equal("[O=C(Oc1ccccc1C(=O)O)C]", (Compound.new("[O=C(Oc1ccccc1C(=O)O)C]","2-acetoxybenzoic acid" )).smile )
    assert_equal("2-acetoxybenzoic acid", (Compound.new("[O=C(Oc1ccccc1C(=O)O)C]","2-acetoxybenzoic acid" )).iupac )

  end
 
end