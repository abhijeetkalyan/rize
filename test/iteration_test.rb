require 'minitest/autorun'
require 'test_helper'

class RizeIterationTest < Minitest::Test
  RZ = Rize

  def test_hmap
    hsh = { a: 1, b: 2 }
    assert_equal hsh, RZ.hmap(hsh) { |k, v| [k, v] }
    val = RZ.hmap(hsh) { |k, v| [k.to_s, v + 1] }
    assert_equal val, { "a" => 2, "b" => 3 }
  end
end
