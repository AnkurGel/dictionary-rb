module DictionaryRB

  # Parses the page for a word at {http://www.urbandictionary.com/ Urban Dictionary}
  # and extracts the {#meanings}, {#examples} and {#similar_words} for it.
  # Lot of take care has been taken to prevent it from hitting the {PREFIX ENDPOINT}
  # so as to make it quickly generate the other results, once a URL is parsed.
  class Urban

    #The associated word
    attr_reader :word
    # Endpoint for Urban Dictionary
    PREFIX = "http://www.urbandictionary.com/define.php?term="

    # @param word [String] The word for Urban Dictionary
    # @example
    #    word = DictionaryRB::Urban.new('Krunal')
    def initialize(word)
      @word = word if word.is_a? String
      @word = word.word if word.is_a? Word
    end

    # Fetches and gives the first meaning of the word.
    # @example
    #    word.meaning
    #    #=> "A fuck, nothing more, just a fuck"
    # @see #meanings
    # @return [String] containing meaning for the word
    def meaning
      meanings.first
    end

    # Fetches and gives meanings for the word from Urban Dictionary
    # @example
    #    word.meanings
    #    #=> ["A fuck, nothing more, just a fuck",
    #         "Describes someone as being the sexiest beast alive. Anyone who is blessed with the name Krunal should get a medal.",..]
    # @see #meaning
    # @return [Array] containing the meanings for the word.
    def meanings
      url = PREFIX + CGI::escape(@word)
      @doc ||= Nokogiri::HTML(open(url))

      nodes = @doc.css('div#outer.container div.row.three_columns div.span6 div#content div.box div.inner div.meaning')
      results = nodes.text.split("\n").reject(&:empty?)
      @meaning = results.first
      results
    end

    # Fetches and gives the examples for the word.
    # @example
    #    word.examples
    #    #=> ["I hate that guy, he is a krunal", "Hot chick - God i want ur Krunalness\rKrunal - I know...",]
    # @return [Array] containing the examples
    def examples
      @doc ||= Nokogiri::HTML(open(PREFIX + CGI::escape(@word)))
      nodes = @doc.css('div#outer.container div.row.three_columns div.span6 div#content div.box div.inner div.example')
      nodes.text.split("\n").reject(&:empty?)
    end

    # Fetches and gives synonyms for the word.
    # @example
    #    word.synonyms
    #    #=> ["agam", "indian", "kerpal",.. ]
    # @see #synonyms
    # @return [Array] containing synonyms for the word
    def similar_words
      @doc ||= Nokogiri::HTML(open(PREFIX + CGI::escape(@word)))
      nodes = @doc.css('div#outer.container div.row.three_columns div.span6 div#content div.tags a')
      nodes.map(&:text).reject(&:empty?)
    end

    alias_method :synonyms, :similar_words

    def to_s
      sprintf("Urban Dictionary (word: %s, meaning: %s)", @word, @meaning)
    end
  end
end