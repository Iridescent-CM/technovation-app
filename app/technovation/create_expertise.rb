module CreateExpertise
  def self.call(attrs)
    expertise_class.find_or_create_by(name: attrs.fetch(:name))
  end

  private
  def self.expertise_class
    ScoreCategory
  end
end
