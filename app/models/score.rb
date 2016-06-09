class Score
  include ActiveModel::Model

  def self.all
    Entry.all
  end

  def categories
    ScoreCategory.all
  end

  def entry
  end

  def entry=(entry)
    Entry.create(value: entry)
  end

  def save
    true
  end
end
