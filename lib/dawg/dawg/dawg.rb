module Dawg
  class Dawg
    extend Serialization
    include Serialization
    include Finder

    attr_accessor :minimized_nodes, :root

    def initialize
      @previous_word = ''
      @root = Node.new
      @unchecked_nodes = []
      @minimized_nodes = {}
      set_the_node(@root)
    end

    def insert(word)
      if word < @previous_word #TODO there's should be the way to make adding without this
        raise 'Error: Words must be inserted in alphabetical order.'
      end

      # find common prefix between word and previous word
      common_prefix = 0
      (0..[word.length-1, @previous_word.length-1].min).each do |i|
        break if word[i] != @previous_word[i]
        common_prefix += 1
      end

      # Check the uncheckedNodes for redundant nodes, proceeding from last
      # one down to the common prefix size. Then truncate the list at that
      # point.
      minimize(common_prefix)

      # add the suffix, starting from the correct node mid-way through the
      # graph
      if @unchecked_nodes.length == 0
        node = @root
      else
        node = @unchecked_nodes[-1][2]
      end

      word.split('')[common_prefix..-1].each do |letter|
        next_node = Node.new
        node.edges[letter] = next_node
        @unchecked_nodes << [node, letter, next_node]
        node = next_node
      end

      node.final = true
      @previous_word = word
    end

    def finish
      minimize 0
      @minimized_nodes[@root.hash] = @root
    end

    def minimize(down_to)
      (@unchecked_nodes.length - 1).downto(down_to) do |i|
        parent, letter, child = @unchecked_nodes[i]
        if @minimized_nodes.has_key? child.hash
          parent.edges[letter] = @minimized_nodes[child.hash]
        else
          child.index = @minimized_nodes.size
          @minimized_nodes[child.hash] = child
        end
        @unchecked_nodes.pop
      end
    end

    def node_count
      @minimized_nodes.length
    end

    def edge_count
      count = 0
      @minimized_nodes.each do |hash, node|
        count += node.edges.length
      end
      count
    end

    def inspect
      'Dawg'
    end


    def save(filename)
      dawg = self
      File.open(filename,'w') do |f|
        write_int(dawg.node_count, f) # overall nodes count
        write_int(dawg.edge_count, f) # overall edge count
        edges_pos = 0
        dawg.minimized_nodes.each do |hash, node|
          write_int(edges_pos, f)
          write_int(node.edges.keys.length, f)
          write_int(node.id, f)
          write_bool(node.final, f)
          write_bigint(hash, f)
          edges_pos += EDGE_SIZE * node.edges.keys.length # position of node's edges in a file
        end
        dawg.minimized_nodes.each do |hash, node|
          node.edges.each do |letter, n|
            write_bigint(n.hash, f)
            write_char(letter, f)
            write_int(n.index,f)
          end
        end
      end
    end

    def self.load(filename)
      dawg = Dawg.new
      File.open(filename) do |f|
        minimized_nodes_count = load_int(f)
        overall_edges_count = load_int(f)
        minimized_nodes_count.times do
          edges_pos = load_int(f)
          edge_count = load_int(f)
          id = load_int(f)
          final = load_bool(f)
          hash = load_bigint(f)
          node = Node.new(id: id, final: final, edge_count: edge_count)
          dawg.minimized_nodes[hash] = node
        end

        dawg.minimized_nodes.each do |hash, node|
          node.edge_count.times do
            hash2 = load_bigint(f)
            letter = load_char(f)
            node_index = load_int(f)
            node.edges[letter] = dawg.minimized_nodes[hash2]
          end
        end
        root_key = dawg.minimized_nodes.keys.last
        dawg.minimized_nodes[root_key].edges.each do |letter, node|
          dawg.root.edges[letter] = node
        end
      end
      dawg
    end
  end
end
