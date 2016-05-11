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
  # @yield [value] A block that acts upon the hash values.
  #
  # @return [Hash] Returns a new hash with updated values, and unchanged keys.
  # @example Map over a hash's values.
  #   Rize.hvalmap({a: 1, b: 2}, &:to_s)
  #   { a: "1", b: "2" }
  def hvalmap(hsh)
    Hash[hsh.map { |k, v| [k, yield(v)] }]
  end
end
