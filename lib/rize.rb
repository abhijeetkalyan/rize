require "rize/version"
require "rize/iteration"
require "rize/functional"

module Rize
  # A class used when partially supplying positional
  # arguments for a function.
  class DontCare
  end

  DC = DontCare.new
end
