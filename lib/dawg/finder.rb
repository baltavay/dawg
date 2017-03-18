module Dawg
  module Finder
    def set_the_node(node)
      @the_node = node
    end

    def lookup(word)
      node = @the_node
      word.each_char do |letter|
        next_node = node[letter]
        if next_node != nil
          node = next_node
          next
        else
          return ['']
        end
      end
      node.final
    end

    # get all words with given prefix
    def query(word)
      node = @the_node
      results = []
      word.split("").each do |letter|
        next_node = node[letter]
        if next_node != nil
          node = next_node
          next
        else
          return ['']
        end
      end
      results << Word.new(word, node.final)
      results += get_childs(node).map{|s| Word.new(word) + s}
      results.select{|r| r.final}.map{|r| r}
    end

    def get_childs(node)
      results = []
      node.each_edge do |letter|
        next_node = node[letter]
        if next_node != nil
          results += get_childs(next_node).map{|s| Word.new(letter) + s}
          results << Word.new(letter, next_node.final)
        end
      end
      results
    end
  end

end
