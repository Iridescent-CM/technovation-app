class LegalContact < ActiveRecord::Base
  belongs_to :chapter, optional: true

  has_one :legal_document, -> { where(active: true) }, class_name: "Document", as: :signer
  has_many :documents, as: :signer

  validates :email_address, presence: true, email: true
  validates :full_name, presence: true
end
