class String
  def meaning
    DictionaryRB::Word.new(self)
  end

  def urban_meaning
    DictionaryRB::Word.new(self).urban_meaning
  end

  def to_urban
    DictionaryRB::Word.new(self).urban
  end
end
