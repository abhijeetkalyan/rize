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
end
