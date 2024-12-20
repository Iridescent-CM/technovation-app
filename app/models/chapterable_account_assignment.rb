class ChapterableAccountAssignment < ApplicationRecord
  belongs_to :account
  belongs_to :chapterable, polymorphic: true
  belongs_to :profile, polymorphic: true

  scope :current, -> {
    where(season: Season.current.year)
  }

  scope :chapters, -> {
    where(chapterable_type: "Chapter")
  }

  scope :clubs, -> {
    where(chapterable_type: "Club")
  }
end
