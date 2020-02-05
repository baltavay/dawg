module Dawg
  module Finder
    def set_the_node(node)
      @the_node = node
    end

    def lookup(word)
      node = @the_node
      word.each_char do |letter|
        next_node = node[letter]
        return false if next_node.nil?

        node = next_node
      end
      node.final
    end

    # get all words with given prefix
    def query(word)
      node = @the_node

      word.split('').each do |letter|
        next_node = node[letter]
        return [] if next_node.nil?

        node = next_node
      end

      Enumerator.new do |result|
        result << Word.new(word, node.final).to_s if node.final
        get_childs(node).each do |s|
          current_word = (Word.new(word) + s)
          result << current_word.to_s if current_word.final
        end
      end
    end

    def get_childs(node)
      Enumerator.new do |result|
        node.each_edge do |letter|
          next_node = node[letter]
          next if next_node.nil?

          get_childs(next_node).each do |s|
            result << Word.new(letter) + s
          end
          result << Word.new(letter, next_node.final)
        end
      end
    end
  end
end
