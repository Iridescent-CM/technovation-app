class Question
  attr_reader :section, :idx, :text, :worth, :score, :update, :field

  def initialize(attrs)
    attrs.symbolize_keys!
    @section = attrs[:section]
    @idx = attrs[:idx]
    @text = attrs[:text]
    @worth = attrs[:worth]
    @score = attrs[:score]
    @field = attrs[:field]
    @update = "/judge/scores/#{attrs[:submission_score].id}"
  end
end
