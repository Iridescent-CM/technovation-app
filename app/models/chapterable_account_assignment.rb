class ChapterableAccountAssignment < ApplicationRecord
  belongs_to :account
  belongs_to :chapterable, polymorphic: true
  belongs_to :profile, polymorphic: true

  validate :ensure_one_primary_assignment_per_profile_type_per_season, if: :new_record?

  scope :current, -> {
    where(season: Season.current.year)
  }

  scope :chapters, -> {
    where(chapterable_type: "Chapter")
  }

  scope :clubs, -> {
    where(chapterable_type: "Club")
  }

  private

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
