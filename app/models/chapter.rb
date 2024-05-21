class Chapter < ActiveRecord::Base
  include ActiveGeocoded

  belongs_to :primary_contact, class_name: "ChapterAmbassadorProfile", foreign_key: "primary_contact_id", optional: true

  has_one :legal_contact
  has_one :chapter_program_information

  has_many :chapter_ambassador_profiles
  has_many :chapter_links, class_name: "RegionalLink"
  has_many :student_profiles
  has_many :registration_invites, class_name: "UserInvitation"

  accepts_nested_attributes_for :chapter_links, reject_if: ->(attrs) {
    attrs.reject { |k, _| k.to_s == "custom_label" }.values.any?(&:blank?)
  }, allow_destroy: true

  validates :summary, length: {maximum: 280}

  delegate :seasons_legal_agreement_is_valid_for, to: :legal_contact

  def legal_document
    legal_contact&.legal_document
  end
end
