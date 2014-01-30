module DictionaryRB
  class Word
    attr_reader :word
    attr_reader :urban, :meaning
    attr_reader :urbans, :meanings

    def initialize(word)
      @word = word
    end

    def dictionary_meaning

    end

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

    def to_s
      sprintf("%s", word)
    end
  end
end