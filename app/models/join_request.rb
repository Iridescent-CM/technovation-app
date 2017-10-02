class JoinRequest < ActiveRecord::Base
  after_create :notify_requested_team

  scope :pending, -> { where('accepted_at IS NULL and declined_at IS NULL') }

  scope :for_students, -> { where(requestor_type: "StudentProfile") }

  scope :for_mentors, -> { where(requestor_type: "MentorProfile") }

  validates :team, uniqueness: { scope: [:requestor_type, :requestor_id] }

  belongs_to :requestor, polymorphic: true
  belongs_to :team, touch: true

  delegate :name,
           :team_photo_url,
           :division_name,
           :primary_location,
    to: :team,
    prefix: true

  delegate :first_name,
           :scope_name,
           :full_name,
           :email,
           :account_id,
    to: :requestor,
    prefix: true

  has_secure_token :review_token

  def to_param
    review_token
  end

  def requestor_name
    requestor_full_name
  end

  def approved!
    ActiveSupport::Deprecation.warn(
      "JoinRequest#approved! is deprecated. Please use JoinRequestApproved.(join_request)"
    )
  end

  def approved?
    !!accepted_at
  end

  def declined!
    ActiveSupport::Deprecation.warn(
      "JoinRequest#declined! is deprecated. Please use JoinRequestDeclined.(join_request)"
    )
  end

  def declined?
    !!declined_at
  end

  def pending?
    not approved? and not declined? and not deleted?
  end

  def deleted?
    !!deleted_at
  end

  def deleted!
    update_attributes(deleted_at: Time.current)
  end

  def status
    if deleted?
      :deleted
    elsif approved?
      :accepted
    elsif declined?
      :declined
    else
      :pending
    end
  end

  private
  def notify_requested_team
    team.members.each do |recipient|
      TeamMailer.join_request(recipient, self).deliver_later
    end
  end
end
