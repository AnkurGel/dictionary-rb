module DictionaryRB

  # Contains the word and offers methods for {Urban} and Reference {Dictionary}
  # Also provides methods like {#meaning}, {#urban_meaning} etc for direct access.
  # Lot of precautions has been taken to prevent repeated call on endpoints
  class Word

    # The associated word
    attr_reader :word
    # Urban Dictionary instance
    attr_reader :urban
    # Reference Dictionary instance
    attr_reader :dictionary


    # @param word [String] The word for Dictionary
    # @example
    #    word = DictionaryRB::Word.new('boast')
    def initialize(word)
      @word = word
    end

    # Gives Reference Dictionary instance object for word
    # @example
    #    word.dictionary.synonyms
    # @see Dictionary
    # @return [DictionaryRB::Dictionary] the associated object in `Dictionary`
    def dictionary
      @dictionary ||= Dictionary.new(@word)
    end

    # Gives dictionary meaning for the word
    # @example
    #    word.dictionary_meaning
    #    #or
    #    word.meaning
    # @note This method will hit the {Dictionary::PREFIX ENDPOINT} and will consume some time to generate result
    # @return [String] containing meaning from Reference {Dictionary} for the word
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

    # Fetches all meanings from Reference Dictionary for the word.
    # It is greedily evaluated to save computation when {#dictionary_meaning} is called.
    # @example
    #    word.dictionary_meanings
    #    #or
    #    word.meanings
    # @see #dictionary_meaning
    # @return [Array] array containing the meanings from Reference {Dictionary} for the word
    def dictionary_meanings
      if @dictionary_meanings.nil?
        dictionary_meaning
      end
      @dictionary_meanings
    end

    # Gives Urban Dictionary instance object for word
    # @example
    #    word.urban.synonyms
    # @see Urban
    # @return [DictionaryRB::Urban] the associated object in `Urban`
    def urban
      @urban ||= Urban.new(@word)
    end

    # Fetches the first meaning from Urban Dictionary for the word.
    # @note This method will hit the {Urban::PREFIX ENDPOINT} and will consume some time to generate result
    # @example
    #    word.urban_meaning
    # @see #urban_meanings
    # @return [String] containing meaning from {Urban} Dictionary for the word
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

    # Fetches all meanings from the Urban Dictionary for the word.
    # It is greedily evaluated when {#urban_meaning} is called
    # @example
    #    word.urban_meanings
    #    #=> ['brag', 'lie', 'boaster']
    # @see #urban_meaning
    # @return [Array] array containing meanings from {Urban} Dictionary for the word
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