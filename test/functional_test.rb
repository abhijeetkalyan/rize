require 'minitest/autorun'
require 'test_helper'

class RizeFunctionalTest < Minitest::Test
  RZ = Rize

  def test_memoize
    @side_effect = 0
    test_lambda = lambda do |val|
      @side_effect += 1
      val
    end
    memoized_lambda = RZ.memoize(test_lambda)
    assert_equal 1, memoized_lambda.call(1)
    assert_equal 1, @side_effect

    # Calling the memoized function again with the same inputs should just
    # return the cached output.
    assert_equal 1, memoized_lambda.call(1)
    assert_equal 1, @side_effect

    # ...but new inputs would actually evaluate.
    assert_equal 2, memoized_lambda.call(2)
    assert_equal 2, @side_effect

    assert_equal 2, memoized_lambda.call(2)
    assert_equal 2, @side_effect

    # Try with a new lambda, to ensure no conflicts with the cache.
    @other_side_effect = 0
    test_lambda2 = lambda do |val|
      @other_side_effect += 1
      val * 2
    end
    memoized_lambda2 = RZ.memoize(test_lambda2)

    assert_equal 3, memoized_lambda.call(3)
    assert_equal 3, @side_effect

    assert_equal 6, memoized_lambda2.call(3)
    assert_equal 1, @other_side_effect

    assert_equal 3, memoized_lambda.call(3)
    assert_equal 3, @side_effect

    assert_equal 6, memoized_lambda2.call(3)
    assert_equal 1, @other_side_effect
  end

  def test_partial
    assert_equal(-1, Rize.partial(->(a, b) { a - b }, 1).call(2))
    positional_only_lambda = lambda do |a, b, c|
      (a - b) * c
    end
    # Supply args 1 and 3.
    partial_lambda = RZ.partial(positional_only_lambda, 1, RZ::DC, 3)
    # Supply arg 2.
    assert_equal(-3, partial_lambda.call(2))

    keyword_only_lambda = lambda do |a:, b:, c:|
      (a - b) * c
    end

    # Supply a: and c:.
    partial_lambda = RZ.partial(keyword_only_lambda, a: 2, c: 6)
    assert_equal(-12, partial_lambda.call(b: 4))

    positional_and_keyword_lambda = lambda do |a, b, c, d:, e:|
      (((a - b) * c) / d)**e
    end

    partial_lambda = RZ.partial(positional_and_keyword_lambda, RZ::DC, 2, RZ::DC, d: 3)
    # 4**5 == 1024
    assert_equal(1024, partial_lambda.call(4, 6, e: 5))
  end

  def test_compose
    f = lambda { |x| x**2 }
    g = lambda { |x| 2 * x }
    h = lambda { |x, y| x + y }
    composed = RZ.compose(f, g, h)
    # (2(2+3))^2 = 100
    assert_equal 100, composed.call(2, 3)

    # Test with array arguments to ensure no screwups in the unpacking.
    f = lambda { |x| x**2 }
    g = lambda { |x| x.reduce(:+) }
    composed = RZ.compose(f, g)
    # (1 + 2 + 3 + 4)^2
    assert_equal 100, composed.call([1, 2, 3, 4])

    # Test with keyword arguments.
    f = lambda { |c:, d:| c - d }
    g = lambda { |a:, b:| { c: a, d: b } }
    composed = RZ.compose(f, g)
    # 3 - 2, in a pretty roundabout way.
    assert_equal 1, composed.call(a: 3, b: 2)
  end

  def test_negate
    even = lambda { |x| x.even? }
    odd = RZ.negate(even)
    assert odd.call(3)
    assert !odd.call(4)
  end

  def test_at_most
    # Try with multiple lambdas to ensure no conflicts in tracking call counts.
    @lam1_call_count = 0
    @lam2_call_count = 0
    lam1 = RZ.at_most(lambda { @lam1_call_count += 1 }, 3)
    lam2 = RZ.at_most(lambda { @lam2_call_count += 1 }, 5)
    loop do
      begin
        lam1.call
      rescue RZ::TooManyCallsError
        break
      end
    end

    loop do
      begin
        lam2.call
      rescue RZ::TooManyCallsError
        break
      end
    end

    assert_equal 3, @lam1_call_count
    assert_equal 5, @lam2_call_count
  end

  def test_at_least
    # Try with multiple lambdas to ensure no conflicts in tracking call counts.
    @lam1_call_count = 0
    @lam2_call_count = 0
    lam1 = RZ.at_least(lambda { @lam1_call_count += 1 }, 3)
    lam2 = RZ.at_least(lambda { @lam2_call_count += 1 }, 5)
    loop do
      begin
        lam1.call
        # If a successful attempt, break
        break
      rescue RZ::TooFewCallsError
        # Keep trying if too few calls
        next
      end
    end

    loop do
      begin
        lam2.call
        break
      rescue RZ::TooFewCallsError
        next
      end
    end

    # Both functions should have been called exactly once before we broke out of the loop.
    assert_equal 1, @lam1_call_count
    assert_equal 1, @lam2_call_count
  end
end
