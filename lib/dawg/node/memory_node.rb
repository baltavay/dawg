module Dawg
  class MemoryNode
    attr_accessor :index, :io, :edge_count, :final, :hash, :edges_pos
    def initialize(io, index , edge_count , final, hash, edges_pos )
      @io = io
      @index = index
      @edge_count = edge_count
      @final = final
      @hash = hash
      @edges_pos = edges_pos
    end

    def [](letter)
      @io.each_edge @index do |char, node_index|
        if letter == char
          return @io.get_node_by_index(node_index)
        end
      end

      nil
    end

    def each_edge(&block)
      @io.each_edge @index do |char, node_index|
        yield char
      end

    end
  end

end
