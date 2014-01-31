module DictionaryRB
  class Word
    attr_reader :word
    attr_reader :urban, :dictionary

    def initialize(word)
      @word = word
    end

    def dictionary
      @dictionary ||= Dictionary.new(@word)
    end

    def dictionary_meaning
      if @dictionary_meaning.nil?
        @dictionary = Dictionary.new(@word)
        meanings = @dictionary.meanings
        if meanings.is_a? Array and not meanings.empty?
          @dictionary_meanings = meanings
          @dictionary_meaning = @dictionary.meaning
        end
      end
      @dictionary_meaning
    end

    def dictionary_meanings
      if @dictionary_meanings.nil?
        dictionary_meaning
      end
      @dictionary_meanings
    end

    #Urban
    def urban
      @urban ||= Urban.new(@word)
    end

    def urban_meaning
      if @urban_meaning.nil?
        @urban = Urban.new(@word)
        meanings = @urban.meanings
        if meanings.is_a?(Array) and not meanings.empty?
          @urban_meanings = meanings
          @urban_meaning = @urban.meaning
        end
      end
      @urban_meaning
    end

    def urban_meanings
      if @urban_meanings.nil?
        urban_meaning
      end
      @urban_meanings
    end

    alias meaning dictionary_meaning
    alias meanings dictionary_meanings

    def to_s
      sprintf("%s", word)
    end
  end
end