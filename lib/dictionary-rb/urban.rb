module DictionaryRB
  class Urban
    attr_reader :word
    PREFIX = "http://www.urbandictionary.com/define.php?term="

    def initialize(word)
      @word = word if word.is_a? String
      @word = word.word if word.is_a? Word
    end

    def meaning
      url = PREFIX + CGI::escape(@word)
      @doc ||= Nokogiri::HTML(open(url))
      nodes = @doc.css('div#outer.container div.row.three_columns div.span6 div#content div.box div.inner div.meaning')
      results = nodes.text.split("\n").reject(&:empty?)
      results.first
    end

    def meanings
      url = PREFIX + CGI::escape(@word)
      @doc ||= Nokogiri::HTML(open(url))

      nodes = @doc.css('div#outer.container div.row.three_columns div.span6 div#content div.box div.inner div.meaning')
      results = nodes.text.split("\n").reject(&:empty?)
      @meaning = results.first
      results
    end

    def examples
      @doc ||= Nokogiri::HTML(open(PREFIX + CGI::escape(@word)))
      nodes = @doc.css('div#outer.container div.row.three_columns div.span6 div#content div.box div.inner div.example')
      nodes.text.split("\n").reject(&:empty?)
    end

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