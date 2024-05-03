class LegalContact < ActiveRecord::Base
  belongs_to :chapter, optional: true

  validates :email_address, presence: true, email: true
  validates :full_name, presence: true
end
