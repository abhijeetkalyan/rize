module Rize
  module_function

  # Map over the keys and values of a hash.
  #
  # @param hsh [Hash] The hash to be mapped over.
  # @yield [key, value] A block which returns in the form [key, value].
  #
  # @return [Hash] Returns a new hash with the results of running the block over it.
  # @example Map over a hash
  #   Rize.hmap({a: 1, b: 2}) { |k,v| [k.to_s, v + 1] }
  #   { "a" => 2, "b" => 3 }
  def hmap(hsh)
    Hash[hsh.map { |k, v| yield(k, v) }]
  end

  # Map over the keys of a hash.
  #
  # @param hsh [Hash] The hash to be mapped over.
  # @yield [key] A block that acts upon the hash keys.
  #
  # @return [Hash] Returns a new hash with updated keys, and unchanged values.
  # @example Map over a hash's keys.
  #   Rize.hkeymap({a: 1, b: 2}, &:to_s)
  #   { "a" => 1, "b" => 2 }
  def hkeymap(hsh)
    Hash[hsh.map { |k, v| [yield(k), v] }]
  end

  # Map over the values of a hash.
  #
  # @param hsh [Hash] The hash to be mapped over.
  # @yield [value] A block that acts upon the hash values
  #
  # @return [Hash] Returns a new hash with updated values, and unchanged keys.
  # @example Map over a hash's values.
  #   Rize.hvalmap({a: 1, b: 2}, &:to_s)
  #   { a: "1", b: "2" }
  def hvalmap(hsh)
    Hash[hsh.map { |k, v| [k, yield(v)] }]
  end

  # Returns the first element of an array, or nil if the array is empty.
  #
  # @param arr [Array] The array from which we want the head.
  #
  # @return [Object] The first element of the array.
  # @example Get the first element of an array.
  #   Rize.hd [1, 2, 3]
  #   1
  # @example
  #   Rize.hd []
  #   nil
  def hd(arr)
    arr[0]
  end

  # Returns all but the first element of the array.
  #
  # @param arr [Array] The array from which we want the tail.
  #
  # @return [Array] An array containing all but the first element of the input.
  # @example Get all but the first element of the array.
  #   Rize.tl [1, 2, 3]
  #   [2, 3]
  # @example
  #   Rize.tl []
  #   []
  def tl(arr)
    arr.drop(1)
  end

  # Find how many times a block evaluates to a particular result in an array.
  #
  # @param arr [Array] The array over which we're counting frequencies.
  # @yield [elem] A block whose results we use to calculate frequencies.
  #
  # @return [Hash] A hash containing the count of each of block's output values from the array.
  # The keys are the various outputs, and the values are the number of times said outputs occurred.
  # @example Count the elements in an array.
  #   Rize.frequencies([1, 2, 3, 1]) { |el| el }
  #   { 1 => 2, 2 => 1, 3 => 1 }
  # @example Count the even numbers in an array.
  #   Rize.frequencies([1, 2, 3, 1]) { |el| el.even? }
  #   { true => 1, false => 3 }
  def frequencies(arr)
    hvalmap(arr.group_by { |el| yield(el) }, &:length)
  end

  # Map over multiple arrays together.
  #
  # The same as doing [block(a1, b1, c1), block(a2, b2, c2)]
  # for arrays [a1, b1, c1] and [a2, b2, c2].
  #
  # Raises an ArgumentError if arrays are of unequal length.
  #
  # @param args [Array] A variable-length number of arrays.
  # @yield [*args] A block that acts upon elements at a particular index in the array.
  #
  # @return [Array] The result of calling the block over the matching array elements.
  # @example Sum all the elements at the same position across multiple arrays.
  #   Rize.map_n([1, 2, 3], [4, 5, 6], [7, 8, 9]) { |*args| args.reduce(:+) }
  #   [12, 15, 18]
  # @example Subtract the second array's element from the first, and multiply by the third.
  #   Rize.map_n([1, 2, 3], [4, 5, 6], [7, 8, 9]) { |a, b, c| (a - b) * c }
  #   [-21, -24, -27]
  # @example Try with arrays of unequal length.
  #   Rize.map_n([1, 2], [1, 2, 3]) { |*args| args.reduce(:+) }
  #   ArgumentError: Expected all inputs to be of length 2
  def map_n(*args)
    expected_length = args[0].length
    if args.any? { |arr| arr.length != expected_length }
      raise ArgumentError, "Expected all inputs to be of length #{expected_length}"
    end
    hd(args).zip(*tl(args)).map do |elems|
      yield(*elems)
    end
  end

  # Iterate over multiple arrays together.
  #
  # The same as doing [block(a1, b1, c1), block(a2, b2, c2)]
  # for arrays [a1, b1, c1] and [a2, b2, c2].
  #
  # Raises an ArgumentError if arrays are of unequal length.
  #
  # @param args [Array] A variable-length number of arrays.
  # @yield [*args] A block that acts upon elements at a particular index in the array.
  #
  # @return [Array] The input arrays.
  # @example Print the transposed version of an array of arrays.
  #   Rize.each_n([1, 2, 3], [4, 5, 6], [7, 8, 9]) { |a, b, c| puts "#{a} #{b} #{c}" }
  #   1 4 7
  #   2 5 8
  #   3 6 9
  def each_n(*args)
    expected_length = args[0].length
    if args.any? { |arr| arr.length != expected_length }
      raise ArgumentError, "Expected all inputs to be of length #{expected_length}"
    end
    hd(args).zip(*tl(args)).each do |elems|
      yield(*elems)
    end
  end

  # Repeat a block N times, and return an array of the results.
  #
  # @param count [Fixnum] The number of times to repeat a block.
  # @yield The block to be called.
  #
  # @return [Array] The result of running block, `count` times.
  # @example Mass-assign several variables to different random numbers.
  #   a, b, c = Rize.repeat { Random.new.rand(50) }
  #   a
  #   24
  #   b
  #   10
  #   c
  #   18
  # @example Initialize multiple FactoryGirl objects in one go.
  #   u1, u2, u3 = Rize.repeat { FactoryGirl.create(:user) }
  #   u1
  #   <User Object 1>
  #   u2
  #   <User Object 2>
  #   u3
  #   <User Object 3>
  def repeat(count)
    result = []
    count.times { result << yield }
    result
  end

  # Lazy version of repeat.
  # Repeat a block N times, and return a lazy enumerator which can be forced for results.
  #
  # @yield The block to be called.
  #
  # @return [Enumerator::Lazy] A lazy enumerator that can be evaluated for the desired number of results.
  # @example Mass-assign several variables to different random numbers.
  #   a, b, c = Rize.repeat { Random.new.rand(50) }.first(3)
  #   a
  #   24
  #   b
  #   10
  #   c
  #   18
  # @example Initialize multiple FactoryGirl objects in one go.
  #   u1, u2, u3 = Rize.repeat { FactoryGirl.create(:user) }.first(3)
  #   u1
  #   <User Object 1>
  #   u2
  #   <User Object 2>
  #   u3
  #   <User Object 3>
  def lazy_repeat
    (1..Float::INFINITY).lazy.map { yield }
  end
end
