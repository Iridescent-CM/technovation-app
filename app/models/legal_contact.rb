class LegalContact < ActiveRecord::Base
  NUMBER_OF_SEASONS_CHAPTER_AFFILIATION_AGREEMENT_IS_VALID_FOR = 3

  belongs_to :chapter, optional: true

  has_one :chapter_affiliation_agreement, -> { where(active: true) }, class_name: "Document", as: :signer
  has_many :documents, as: :signer

  validates :email_address, presence: true, email: true
  validates :full_name, presence: true

  def seasons_chapter_affiliation_agreement_is_valid_for
    if chapter_affiliation_agreement&.season_signed.present?
      Array(chapter_affiliation_agreement.season_signed...(chapter_affiliation_agreement.season_signed + NUMBER_OF_SEASONS_CHAPTER_AFFILIATION_AGREEMENT_IS_VALID_FOR))
    else
      []
    end
  end

  def update_onboarding_status
    chapter.update_onboarding_status
  end
end
