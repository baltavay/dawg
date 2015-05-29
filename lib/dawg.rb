class DawgNode
  @@next_id = 0
  attr_accessor :edges,:final,:id
  def initialize
    @id = @@next_id
    @@next_id += 1
    @final = false
    @edges = {}
  end

  def to_s
    arr = []
    if @final
        arr<<"1"
    else
        arr<<"0"
    end

    for (label, node) in @edges
        arr << label
        arr << node.id.to_s
    end

    arr.join("_")
  end

  def hash
      to_s.hash
  end

  def eql?(other)
      to_s == other.to_s
  end
  def inspect
    "to_s"
  end
end

class Dawg
  def initialize
    @previousWord = ""
    @root = DawgNode.new

    # Here is a list of nodes that have not been checked for duplication.
    @uncheckedNodes = []

    # Here is a list of unique nodes that have been checked for
    # duplication.
    @minimizedNodes = {}
  end

  def save(filename)
    data = Marshal.dump(self)
    File.open(filename, 'w') { |file| file.write(data) }
  end

  def self.load(filename)
    dawg = Marshal.load( File.open(filename).read )
  end

  def insert( word )
    if word < @previousWord
        raise "Error: Words must be inserted in alphabetical order."
    end

    # find common prefix between word and previous word
    commonPrefix = 0
    for i in 0..[word.length-1, @previousWord.length-1].min
      break if word[i] != @previousWord[i]
      commonPrefix += 1
    end

    # Check the uncheckedNodes for redundant nodes, proceeding from last
    # one down to the common prefix size. Then truncate the list at that
    # point.
    _minimize( commonPrefix )

    # add the suffix, starting from the correct node mid-way through the
    # graph
    if @uncheckedNodes.length == 0
      node = @root
    else
      node = @uncheckedNodes[-1][2]
    end

    for letter in word.split("")[commonPrefix..-1]
      nextNode = DawgNode.new
      node.edges[letter] = nextNode
      @uncheckedNodes<< [node, letter, nextNode]
      node = nextNode
    end

    node.final = true
    @previousWord = word
  end
  def finish
    # minimize all uncheckedNodes
    _minimize( 0 )
  end

  def _minimize(downTo)
    # proceed from the leaf up to a certain point
    for i in (@uncheckedNodes.length - 1).downto(downTo)
        parent, letter, child = @uncheckedNodes[i]
        if @minimizedNodes.has_key? child
            # replace the child with the previously encountered one
            parent.edges[letter] = @minimizedNodes[child]
        else
            # add the state to the minimized nodes.
            @minimizedNodes[child] = child
        end
        @uncheckedNodes.pop
    end
  end

  def lookup(word)
    node = @root
    for letter in word.split("")
        return false if !node.edges.has_key? letter
        node = node.edges[letter]
    end
    node.final
  end

  def find_similar(word)
    node = @root
    for letter in word.split("")
        return [] if !node.edges.has_key? letter
        node = node.edges[letter]
    end
    results = get_recuirsively_all(node)

    return [word].product(results).map(&:join)
  end
 
  def get_recuirsively_all(node)
    suffixes = []

    node.edges.each do |key,value|
      results = get_recuirsively_all(value)

      # result.flatten! if result.length==2
      results.each do |result|
        suffixes << [[key] + [result]].flatten.join
      end

      suffixes << key if results.empty?


    end
    return suffixes
  end
  def nodeCount
    @minimizedNodes.length
  end

  def edgeCount
    count = 0
    for key,node in @minimizedNodes
      count += node.edges.length
    end
    count
  end
  def inspect
    "Dawg"    
  end
end