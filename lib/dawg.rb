require 'stringio'
require_relative 'dawg/serialization'
require_relative 'dawg/finder'
require_relative 'dawg/word'
require_relative 'dawg/node/node'
require_relative 'dawg/node/memory_node'
require_relative 'dawg/dawg/dawg'
require_relative 'dawg/dawg/memory_dawg'

module Dawg
  NODE_START = 8
  NODE_SIZE = 21
  EDGE_SIZE = 16
  extend self

  def new
    Dawg.new
  end

  def load(filename, type = :small)
    return case type
    when :small
      MemoryDawg.load(filename)
    when :fast
      Dawg.load(filename)
    end
    dawg
  end

end
