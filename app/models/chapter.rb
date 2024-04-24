class Chapter < ActiveRecord::Base
  include ActiveGeocoded

  has_many :chapter_ambassador_profiles
  belongs_to :primary_contact, class_name: "ChapterAmbassadorProfile", foreign_key: "primary_contact_id", optional: true
  has_many :student_profiles
  has_many :registration_invites, class_name: "UserInvitation"

  validates :summary, length: {maximum: 280}

  validates :legal_contact_email_address,
    email: true,
    if: -> { legal_contact_email_address.present? }
end
