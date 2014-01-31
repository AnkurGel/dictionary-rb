class String
  self.class_eval do
    %w(meaning urban_meaning to_urban to_dictionary).each do |method|
      define_method method do
        if obj=method.match(/^to_(.*)/)
          DictionaryRB::Word.new(self).method(obj[1]).call
        else
          DictionaryRB::Word.new(self).method(method).call
        end
      end
    end

    def to_word
      DictionaryRB::Word.new(self)
    end
  end

  def respond_to?(method)
    %w(meaning urban_meaning to_urban to_dictionary to_word).include?(method) || super
  end
end
