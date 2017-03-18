module Dawg
  class Word
    attr_accessor :final, :word

    def initialize( word = '', final = false)
      @word = word
      @final = final
    end

    def +(other)
      Word.new(@word + other.word, other.final)
    end

    def to_s
      @word
    end

    def inspect
      @word
    end
  end
end
