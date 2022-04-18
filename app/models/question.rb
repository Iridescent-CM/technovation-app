class Question
  attr_reader :section, :idx, :text, :worth, :score, :field, :submission_type
  attr_writer :score

  def initialize(attrs)
    attrs.symbolize_keys!
    @section = attrs[:section]
    @idx = attrs[:idx]
    @text = attrs[:text]
    @worth = attrs[:worth]
    @score = attrs[:score]
    @field = attrs[:field]
    @submission_type = attrs[:submission_type]
  end
end
