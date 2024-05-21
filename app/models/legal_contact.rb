class LegalContact < ActiveRecord::Base
  NUMBER_OF_SEASONS_LEGAL_AGREEMENT_IS_VALID_FOR = 3

  belongs_to :chapter, optional: true

  has_one :legal_document, -> { where(active: true) }, class_name: "Document", as: :signer
  has_many :documents, as: :signer

  validates :email_address, presence: true, email: true
  validates :full_name, presence: true

  def seasons_legal_agreement_is_valid_for
    if legal_document&.season_signed.present?
      Array(legal_document.season_signed...(legal_document.season_signed + NUMBER_OF_SEASONS_LEGAL_AGREEMENT_IS_VALID_FOR))
    else
      []
    end
  end
end
