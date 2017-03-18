module Dawg
  class MemoryDawg
    include Serialization
    include Finder
    attr_accessor :slice, :node_count, :edge_count

    def initialize(slice)
      @slice = slice
      @node_count = get_node_count
      @edge_count = get_edge_count
      set_the_node(root)
    end



    def root
      @root = get_node_by_index(@node_count - 1)
    end

    def make_io(start, size)
      @slice.pos = start
      StringIO.new(@slice.read(size))
    end

    def get_node_count
      load_int(make_io(0,4))
    end

    def get_edge_count
      load_int(make_io(4,4))
    end

    def get_node_by_index(index)
      pos = NODE_START + (NODE_SIZE * index)
      io = make_io(pos, NODE_SIZE)
      edges_pos = load_int(io)
      edge_count = load_int(io)
      id = load_int(io)
      final = load_bool(io)
      hash = load_bigint(io)
      MemoryNode.new(self, index, edge_count, final, hash, edges_pos)
    end

    def each_edge(index, &block)
      pos = NODE_START + (NODE_SIZE * index)
      io = make_io(pos, 8)
      edges_pos = load_int(io)
      edge_count = load_int(io)
      edge_start = NODE_START + NODE_SIZE * @node_count
      position =  edge_start + edges_pos
      io = make_io(position, edge_count * EDGE_SIZE)

      edge_count.times do
        hash = load_bigint(io)
        char = load_char(io)
        node_index = load_int(io)
        yield char, node_index
      end
    end

    def self.load(filename)
      File.open(filename) do |f|
        slice = StringIO.new(f.read)
        return MemoryDawg.new(slice)
      end
    end
  end

end
