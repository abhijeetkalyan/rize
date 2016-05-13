module Rize
  module_function

    # Returns a memoized version of a given proc, lambda, or method.
    #
    # @param func [Proc, Lambda, Method] The proc, lambda, or method to memoize.
    #
    # @return [Lambda] A lambda that is the memoized version of the passed in function.
    # @example Memoize an expensive function.
    #   expensive_lambda = lambda do |arg|
    #     puts "very expensive computation"
    #     arg
    #   end
    #   memoized = Rize.memoize(expensive_lambda)
    #
    #   memoized.call(1)
    #   "very expensive computation"
    #   1
    #   memoized.call(1)
    #   1
    #   memoized.call(2)
    #   "very expensive computation"
    #   2
    #   memoized.call(2)
    #   2
    def memoize(func)
      memo = {}
      call_count = Hash.new(0)
      lambda do |*args|
        return memo[args] if call_count[args] == 1
        memo[args] = func.call(*args)
        call_count[args] += 1
        memo[args]
      end
    end
end
