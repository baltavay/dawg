module Dawg
  class Node
    @@next_id = 0
    @id = 0
    attr_accessor :edges, :id, :edge_count, :index, :final

    def initialize(id: @@next_id, final: false, edge_count: 0, index: -1)
      @id = id
      @@next_id += 1
      @final = final
      @edge_count = edge_count
      @index = index
      @edges = {}
    end

    def to_s
      arr = []
      if @final
          arr<<'1'
      else
          arr<<'0'
      end

      @edges.each do |label,node|
          arr << label.to_s
          arr << node.id.to_s
      end

      arr.join('_')

    end

    def hash
      to_s.hash
    end

    def ==(other)
      to_s == other.to_s
    end

    def [](letter)
      @edges[letter]
    end

    def each_edge(&block)
      @edges.each do |letter, node|
        yield letter
      end
    end
  end

end
