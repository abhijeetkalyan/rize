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

  def test_hkeymap
    hsh = { a: 1, b: 2 }
    assert_equal hsh, RZ.hkeymap(hsh) { |k| k }
    val = RZ.hkeymap(hsh, &:to_s)
    assert_equal val, { "a" => 1, "b" => 2 }
  end

  def test_hvalmap
    hsh = { a: 1, b: 2 }
    assert_equal hsh, RZ.hvalmap(hsh) { |v| v }
    val = RZ.hvalmap(hsh, &:to_s)
    assert_equal val, { a: "1", b: "2" }
  end

  def test_hd
    assert_nil RZ.hd([])
    assert_equal 1, RZ.hd([1, 2, 3])
    assert_equal [1], RZ.hd([[1], 2, 3])
  end

  def test_tl
    assert_equal [], RZ.tl([])
    assert_equal [2, 3], RZ.tl([1, 2, 3])
    assert_equal [[2], 3], RZ.tl([1, [2], 3])
  end
end
