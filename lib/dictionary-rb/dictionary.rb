module DictionaryRB
  class Dictionary
    attr_reader :word
    PREFIX = "http://dictionary.reference.com/browse/"

    def initialize(word)
      @word = word if word.is_a? String
      @word = word.word if word.is_a? Word
      @examples = Array.new
    end

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

    def meaning
      meanings.first
    end

    def examples
      @doc ||= Nokogiri::HTML(open(PREFIX + CGI::escape(@word)))
      @example_results ||= @doc.css('.exsentences').map{ |x| x.text.strip }.reject(&:empty?).flatten
      @example_results #to prevent above computations on repeated call on object
    end

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