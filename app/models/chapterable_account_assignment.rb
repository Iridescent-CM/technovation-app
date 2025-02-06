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

  validate :ambassador_chapterable_assignment_type

  private

  def ambassador_chapterable_assignment_type
    type = chapterable_type.capitalize

    if account.is_a_club_ambassador? && type == "Chapter"
      errors.add(:base, "Club ambassadors cannot be assigned to a chapter.")
    elsif account.is_an_ambassador? && type == "Club"
      errors.add(:base, "Chapter ambassadors cannot be assigned to a club.")
    end
  end
end
