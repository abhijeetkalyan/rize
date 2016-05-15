require "rize/version"
require "rize/iteration"
require "rize/functional"

module Rize
  # A class used when partially supplying positional
  # arguments for a function.
  class DontCare
  end

  DC = DontCare.new

  # Error when the function from `after` hasn't been called enough times.
  class TooFewCallsError < StandardError; end

  # Error when the function from `before` has been called too many times.
  class TooManyCallsError < StandardError; end
end
