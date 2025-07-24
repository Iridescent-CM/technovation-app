class ChapterableAccountAssignment < ApplicationRecord
  belongs_to :account
  belongs_to :chapterable, polymorphic: true
  belongs_to :profile, polymorphic: true
  belongs_to :assignment_by, polymorphic: true, optional: true

  scope :current, -> {
    where(season: Season.current.year)
  }

  scope :last_season, -> {
    where(season: Season.current.year - 1)
  }

  scope :chapters, -> {
    where(chapterable_type: "Chapter")
  }

  scope :clubs, -> {
    where(chapterable_type: "Club")
  }

  scope :mentors, -> {
    where(profile_type: "MentorProfile")
  }

  scope :students, -> {
    where(profile_type: "StudentProfile")
  }

  validate :ambassador_chapterable_assignment_type
  validate :ensure_one_primary_assignment_per_profile_type_per_season, if: :new_record?

  private

  def ambassador_chapterable_assignment_type
    type = chapterable_type.capitalize

    if account.club_ambassador? && type == "Chapter"
      errors.add(:base, "Club ambassadors cannot be assigned to a chapter.")
    elsif account.chapter_ambassador? && type == "Club"
      errors.add(:base, "Chapter ambassadors cannot be assigned to a club.")
    end
  end

  def ensure_one_primary_assignment_per_profile_type_per_season
    if primary && ChapterableAccountAssignment
        .where(
          account_id: account_id,
          profile_type: profile_type,
          profile_id: profile_id,
          season: season,
          primary: true
        )
        .exists?

      errors.add(:base, "This participant is already assigned to a chapter or club")
    end
  end
end
