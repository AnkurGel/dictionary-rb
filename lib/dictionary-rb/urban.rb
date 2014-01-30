module DictionaryRB
  class Urban
    attr_reader :word, :meaning
    PREFIX = "http://www.urbandictionary.com/define.php?term="

    def initialize(word)
      @word = word if word.is_a? String
      @word = word.word if word.is_a? Word
    end

    def meanings
      url = PREFIX + CGI::escape(@word)
      @doc = Nokogiri::HTML(open(url))

      node = @doc.css('div#outer.container div.row.three_columns div.span6 div#content div.box div.inner div.meaning')
      result = node.text.split("\n").reject(&:empty?)
      @meaning = result.first
      result
    end

    def examples
      @doc ||= Nokogiri::HTML(open(PREFIX + CGI::escape(@word)))
      node = @doc.css('div#outer.container div.row.three_columns div.span6 div#content div.box div.inner div.example')
      node.text.split("\n").reject(&:empty?)
    end

    def similar_words
      @doc ||= Nokogiri::HTML(open(PREFIX + CGI::escape(@word)))
      node = @doc.css('div#outer.container div.row.three_columns div.span6 div#content div.tags a')
      node.map(&:text).reject(&:empty?)
    end

    def to_s
      sprintf("Urban Dictionary (word: %s, meaning: %s)", @word, @meaning)
    end
  end
end