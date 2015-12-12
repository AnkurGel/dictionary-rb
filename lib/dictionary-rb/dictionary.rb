module DictionaryRB

  # Parses the page for a word at {http://dictionary.reference.com Reference Dictionary}
  # and extracts the {#meanings}, {#examples} and {#similar_words} for it.
  class Dictionary

    # The associated word
    attr_reader :word
    # Endpoint for Reference Dictionary
    PREFIX = "http://dictionary.reference.com/browse/"

    # Endpoint for Synonyms and Antonyms in Reference Dictionary
    OTHER_PREFIX = "http://www.thesaurus.com/browse/"
    # @param word [String] The word for Reference Dictionary
    # @example
    #    word = DictionaryRB::Dictionary.new('question')
    def initialize(word)
      @word = word if word.is_a? String
      @word = word.word if word.is_a? Word
      @examples = Array.new
    end

    # Fetches and gives meanings for word from Reference Dictionary
    # @note This method will hit the {PREFIX ENDPOINT} and will consume some time to generate result
    # @example
    #    word.meanings
    #    #=> ["a sentence in an interrogative form, addressed to someone in order to get information in reply",
    #         "a problem for discussion or under discussion",
    #         "a matter for investigation",... ]
    # @see #meaning
    # @return [Array] containing the meanings for the word
    def meanings
      url = PREFIX + CGI::escape(@word)
      begin
        @doc = Nokogiri::HTML(open(url))
      rescue Exception => e
        # TODO
      end
      results = []
      nodes = @doc && @doc.css('.def-list').first() && @doc.css('.def-list').first().css('.def-content')
      if nodes && nodes.children
        results = nodes.map{ |x| x.text }.map(&:strip)
      end
      results
    end

    # Fetches and gives first meaning for the word
    # @example
    #    word.meaning
    #    #=> "a sentence in an interrogative form, addressed to someone in order to get information in reply"
    # @see #meanings
    # @return [String] containing the meaning for the word
    def meaning
      meanings.first
    end

    # Fetches and gives the examples for the word
    # @example
    #    word.examples
    #    #=> ["There is an easy answer to this question, and it involves some good news and  some bad news.",
    #         "Then there was an awkward silence as though they were waiting for me to answer  another question.",..]

    # @return [Array] containing the examples.
    def examples
      @doc ||= Nokogiri::HTML(open(PREFIX + CGI::escape(@word)))
      @example_results ||= @doc.css('#source-example-sentences .partner-example-text').map { |x| x.text() }.map(&:strip)
    end

    # Fetches and gives synonyms for the word
    # @note This method will hit the {OTHER_PREFIX OTHER ENDPOINT} and will consume some time to generate the result
    # @example
    #    word.synonyms
    #    #=> => ["answer", "inquire", "question mark", "sentence",.. ]
    # @return [Array] containing similar words
    def synonyms
      begin
        @doc2 ||= Nokogiri::HTML(open(OTHER_PREFIX + CGI::escape(@word)))
      rescue Exception
        #TODO
      end
      @doc2.css('div.synonyms .relevancy-list li').text.gsub(/star/, '').split
    end

    # Fetches and gives antonyms for the word
    # @note This method will hit the {OTHER_PREFIX OTHER ENDPOINT} and will consume some time to generate the result
    # @example
    #    word.antonyms
    #    #=> => ["answer", "inquire", "question mark", "sentence",.. ]
    # @return [Array] containing similar words
    def antonyms
      begin
        @doc2 ||= Nokogiri::HTML(open(OTHER_PREFIX + CGI::escape(@word)))
      rescue Exception
        #TODO
      end
      @doc2.css('section.antonyms li').text.gsub(/star/, '').split
    end

    def to_s
      sprintf("Dictionary Reference(word: %s, meaning: %s", @word, @meaning)
    end

    private
    def initialize_doc(prefix = PREFIX)
      
    end
  end
end