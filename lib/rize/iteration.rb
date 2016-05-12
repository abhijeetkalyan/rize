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
  # @return elem The first element of the array.
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
  # @return tail [Array] An array containing all but the first element of the input.
  # @example Get all but the first element of the array.
  #   Rize.tl [1, 2, 3]
  #   [2, 3]
  # @example
  #   Rize.tl []
  #   []
  def tl(arr)
    arr.drop(1)
  end

  # Map over multiple arrays at the same time.
  #
  # The same as doing [block(a1, b1, c1), block(a2, b2, c2)]
  # for arrays [a1, b1, c1] and [a2, b2, c2].
  #
  # Raises an ArgumentError if arrays are of unequal length.
  #
  # @param *arrs [Array] A variable-length number of arrays.
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
  def map_n(*arrs)
    expected_length = arrs[0].length
    if arrs.any? { |arr| arr.length != expected_length }
      raise ArgumentError, "Expected all inputs to be of length #{expected_length}"
    end
    hd(arrs).zip(*tl(arrs)).map do |elems|
      yield(*elems)
    end
  end
end
