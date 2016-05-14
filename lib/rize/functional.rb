module Rize
  module_function

  # Returns a memoized version of a given proc, lambda, or method.
  #
  # @param func [Proc, Lambda, Method] The proc, lambda, or method to memoize.
  #
  # @return [Lambda] A lambda that is the memoized version of the input function.
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

  # Compose multiple procs, lambdas or methods.
  #
  # @param *funcs [Proc, Lambda, Method] A variable-length number of procs, lambdas or methods to compose.
  #
  # @return [Lambda] A lambda that is the composition of the inputs.
  # compose(f, g, h).call(arg) is the same as f(g(h.call(arg)))
  # @example Compose various mathematical operations together to compute (2(a + b))^2.
  #   f = lambda { |x| x**2 }
  #   g = lambda { |x| 2 * x }
  #   h = lambda { |x, y| x + y }
  #   composed = compose(f, g, h)
  #   composed.call(2, 3)
  #   100
  def compose(*funcs)
    -> (*args) { call_all(funcs, *args) }
  end

  # Partially supply the arguments to a proc, lambda, or method.
  #
  # @param func [Proc, Lambda, Method] The proc, lambda, or method to partially supply arguments to.
  # @param *args [Object] A variable-length number of positional arguments.
  # Use Rize::DC as a 'don't care' variable to signify that we'd like to supply this argument later.
  # This is useful, for example, if we have arguments 1 and 3, but are waiting on argument 2.
  # @param **kwargs [Object] A variable-length number of keyword arguments.
  #
  # @return [Lambda] A lambda that is the partially filled version of the input function.
  # @example Supply the second and third positional arguments, but not the first.
  #   final_lambda = lambda do |a, b, c|
  #     (a - b) * c
  #   end
  #   # Supply b and c.
  #   partial_lambda = Rize.partial(final_lambda, Rize::DC, 2, 3)
  #   # Supply a.
  #   partial_lambda.call(1)
  #   -3  # (1 - 2) * 3
  # @example Partial with keyword arguments.
  #   final_lambda = lambda do |a:, b:, c:|
  #     (a - b) * c
  #   end
  #   Supply a: and c:.
  #   partial_lambda = Rize.partial(final_lambda, a:1, c: 3)
  #   Supply b:.
  #   partial_lambda.call(b: 2)
  #   -3 # (1 - 2) * 3
  # @example Partial with positional and keyword arguments.
  #   final_lambda = lambda do |a, b, c:|
  #     (a - b) * c
  #   end
  #   Supply a and c:.
  #   partial_lambda = Rize.partial(final_lambda, 1, c: 3)
  #   Supply b.
  #   partial_lambda.call(2)
  #   -3 # (1 - 2) * 3
  def partial(func, *args, **kwargs)
    lambda do |*new_args, **new_kwargs|
      func.call(*(merge_positional(args, new_args) + merge_keyword(kwargs, new_kwargs)))
    end
  end

  # Internal method used by partial to handle positional arguments.
  # Given arrays [1, Rize::DC, 3] and [2], returns [1, 2, 3].
  # @param prefilled_args [Array] Prefilled args supplied to Rize.partial.
  # @param new_args [Array] Args supplied at call-time of the function.
  #
  # @return [Array] the merged arguments in the manner described above.
  def merge_positional(prefilled_args, new_args)
    tmp_new_args = new_args.dup
    prefilled_args.map do |elem|
      if elem == DC
        tmp_new_args.shift
      else
        elem
      end
    end + tmp_new_args
  end

  # Internal method used by partial to handle keyword arguments.
  # Returns [] if passed in empty hashes.
  # @param prefilled_kwargs [Hash] Prefilled kwargs supplied to Rize.partial.
  # @param new_kwargs [Hash] kwargs supplied at call-time of the function.
  #
  # @return [Array] An array holding the merged keyword arguments.
  def merge_keyword(prefilled_kwargs, new_kwargs)
    return [] if prefilled_kwargs.empty? && new_kwargs.empty?
    [prefilled_kwargs.merge(new_kwargs)]
  end

  # Internal helper used by compose to actually call functions.
  #
  # @param funcs [Array] An array of procs, lambdas or methods.
  # @param *args [Object] A variable-length number of arguments to call the actual functions with.
  def call_all(funcs, *args)
    return funcs[0].call(*args) if funcs.length == 1

    funcs[0].call(call_all(funcs.drop(1), *args))
  end
end
