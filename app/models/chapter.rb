class Chapter < ActiveRecord::Base
  include ActiveGeocoded

  belongs_to :primary_contact, class_name: "ChapterAmbassadorProfile", foreign_key: "primary_contact_id", optional: true

  has_one :legal_contact, dependent: :destroy
  has_one :chapter_program_information, dependent: :destroy

  has_many :chapter_ambassador_profiles
  has_many :chapter_links, dependent: :destroy
  has_many :student_profiles
  has_many :registration_invites, class_name: "UserInvitation", dependent: :destroy

  accepts_nested_attributes_for :chapter_links, reject_if: ->(attrs) {
    attrs.reject { |k, _| k.to_s == "custom_label" }.values.any?(&:blank?)
  }, allow_destroy: true

  after_update :update_onboarding_status

  validates :summary, length: {maximum: 280}

  scope :signed_legal_agreements, -> {
    joins(legal_contact: :documents)
      .where("documents.active = TRUE AND documents.signed_at IS NOT NULL")
  }

  scope :not_signed_legal_agreements, -> {
    joins(legal_contact: :documents)
      .where("documents.active = TRUE AND documents.signed_at IS NULL")
  }

  scope :not_sent_legal_agreements, -> {
    left_joins(legal_contact: :documents)
      .where("documents.active != TRUE OR documents.active IS NULL")
      .where("documents.id IS NULL")
  }

  delegate :seasons_legal_agreement_is_valid_for, to: :legal_contact

  def legal_document
    legal_contact&.legal_document
  end

  def can_be_marked_onboarded?
    !!(legal_document_signed? &&
      chapter_info_complete? &&
      location_complete? &&
      program_info_complete?)
  end

  def update_onboarding_status
    update_column(:onboarded, can_be_marked_onboarded?)
  end

  def legal_document_signed?
    !!legal_document&.signed?
  end

  def chapter_info_complete?
    [
      name,
      summary,
      primary_contact,
      chapter_links
    ].all?(&:present?)
  end

  def location_complete?
    organization_headquarters_location.present?
  end

  def program_info_complete?
    chapter_program_information&.complete?
  end
end
