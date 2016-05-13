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
  end
end
