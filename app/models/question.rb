class Question
  attr_reader :section, :idx, :text, :worth, :score, :field
  attr_writer :score

  def initialize(attrs)
    attrs.symbolize_keys!
    @section = attrs[:section]
    @idx = attrs[:idx]
    @text = attrs[:text]
    @worth = attrs[:worth]
    @score = attrs[:score]
    @field = attrs[:field]
  end
end
