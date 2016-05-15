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

  def test_map_n
    res = RZ.map_n([1, 2, 3], [4, 5, 6], [7, 8, 9]) { |*args| args.reduce(:+) }
    assert_equal [12, 15, 18], res
    res2 = RZ.map_n([1, 2, 3], [4, 5, 6], [7, 8, 9]) { |a, b, c| (a - b) * c }
    assert_equal [-21, -24, -27], res2
    assert_raises(ArgumentError) do
      RZ.map_n([1, 2], [1, 2, 3]) { |*args| args.reduce(:+) }
    end
    res3 = RZ.map_n([1, 2, 3], [4, 5, 6], [7, 8, 9]) { |*args| args }
    assert_equal [[1, 4, 7], [2, 5, 8], [3, 6, 9]], res3
  end

  def test_each_n
    res = []
    RZ.each_n([1, 2, 3], [4, 5, 6], [7, 8, 9]) { |a, b, c| res << a << b << c }
    assert_equal [1, 4, 7, 2, 5, 8, 3, 6, 9], res
    assert_raises(ArgumentError) do
      RZ.each_n([1, 2, 3], [1, 2])
    end
  end

  def test_frequencies
    assert_equal(
      { 1 => 2, 2 => 1, 3 => 1 },
      RZ.frequencies([1, 2, 3, 1]) { |i| i }
    )
    assert_equal(
      { true => 1, false => 3 },
      RZ.frequencies([1, 2, 3, 1]) { |i| i.even? }
    )
  end

  def test_repeat
    a, b, c = RZ.repeat(3) { 3 }
    [a, b, c].each { |var| assert_equal 3, var }
    # Add a side-effect for a deterministic test.
    @rand_counter = 0
    d, e, f = RZ.repeat(3) do
      Integer("#{Random.new.rand(50)}#{@rand_counter}")
      @rand_counter += 1
    end
    assert((d != e) && (e != f) && (d != f))
    [d, e, f].each { |var| assert((0..502).cover?(var)) }
  end

  # TODO: Pull out shared logic between this and test_repeat
  def test_lazy_repeat
    assert RZ.lazy_repeat { 1 }.is_a?(Enumerator::Lazy)
    a, b, c = RZ.lazy_repeat { 3 }.first(3)
    [a, b, c].each { |var| assert_equal 3, var }
    # Add a side-effect for a deterministic test.
    @rand_counter = 0
    d, e, f = RZ.lazy_repeat do
      Integer("#{Random.new.rand(50)}#{@rand_counter}")
      @rand_counter += 1
    end.first(3)
    assert((d != e) && (e != f) && (d != f))
    [d, e, f].each { |var| assert((0..502).cover?(var)) }
  end

  def test_flatter_map
    expected_result = RZ.flatter_map([["a", "b"], [["c"], ["d"]]]) { |el| el.capitalize }
    assert_equal ["A", "B", "C", "D"], expected_result
    expected_result = Rize.flatter_map([["a", "b"], [["c"], ["d"]]]) { |el| [el, el.capitalize] }
    assert_equal ["a", "A", "b", "B", "c", "C", "d", "D"], expected_result
  end
end
