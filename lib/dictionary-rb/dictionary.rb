module DictionaryRB

  # Parses the page for a word at {http://dictionary.reference.com Reference Dictionary}
  # and extracts the {#meanings}, {#examples} and {#similar_words} for it.
  # Lot of take care has been taken to prevent it from hitting the {PREFIX ENDPOINT}
  # so as to make it quickly generate the other results, once a URL is parsed.
  class Dictionary

    # The associated word
    attr_reader :word
    # Endpoint for Reference Dictionary
    PREFIX = "http://dictionary.reference.com/browse/"

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
      @doc = Nokogiri::HTML(open(url))

      nodes = [@doc.css('.luna-Ent .dndata')]
      nodes = [@doc.css('.pbk .luna-Ent')] if nodes.flatten.empty?

      (nodes ||= []).push(@doc.css(".td3n2")).flatten!
      results = nodes.map(&:text).map do |result|
        result.split ':'
      end.map { |x| x[0].split(/[.;]/) }.flatten.map(&:strip).reject(&:empty?)
      @meaning = results.first
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
      @example_results ||= @doc.css('.exsentences').map{ |x| x.text.strip }.reject(&:empty?).flatten
      @example_results #to prevent above computations on repeated call on object
    end

    # Fetches and gives synonyms for the word
    # @example
    #    word.similar_words
    #    #=> => ["answer", "inquire", "question mark", "sentence",.. ]
    # @return [Array] containing similar words
    def similar_words
      @doc ||= Nokogiri::HTML(open(PREFIX + CGI::escape(@word)))
      @similar_words = @doc.css("#relatedwords .fla a").map(&:text).reject(&:empty?)
      @similar_words
    end
    alias_method :synonyms, :similar_words

    def to_s
      sprintf("Free Dictionary (word: %s, meaning: %s", @word, @meaning)
    end
  end
end