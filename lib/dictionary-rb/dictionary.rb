module DictionaryRB
  class Dictionary
    attr_reader :word, :meaning
    PREFIX = "http://www.thefreedictionary.com/"

    def initialize(word)
      @word = word if word.is_a? String
      @word = word.word if word.is_a? Word
    end

    def meanings
      url = PREFIX + CGI::escape(@word)
      @doc = Nokogiri::HTML(open(url))

      nodes = @doc.css('.ds-list')
      result = nodes.map do |node|
        unless node.children[0].text.strip.scan(/\d/).empty?
          node.children[1].text.strip
        else
          node.children[2].text.strip
        end
      end.reject(&:empty?).first(8)
      @meaning = result.first
      result
    end

    def examples

    end

    def to_s
      sprintf("Free Dictionary (word: %s, meaning: %s", @word, @meaning)
    end
  end
end