require "rize/version"
require "rize/iteration"

module Rize
  def self.included(base)
    base.extend self
  end
end
