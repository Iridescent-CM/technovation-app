class JoinRequest < ActiveRecord::Base
  after_create :notify_requested_team

  scope :pending, -> { where('accepted_at IS NULL and declined_at IS NULL') }

  scope :for_students, -> { where(requestor_type: "StudentProfile") }

  scope :for_mentors, -> { where(requestor_type: "MentorProfile") }

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
      "Removed from team"
    elsif approved?
      "Accepted"
    elsif declined?
      "Declined"
    else
      "Pending review"
    end
  end

  private
  def notify_requested_team
    team.members.each do |recipient|
      TeamMailer.join_request(recipient, self).deliver_later
    end
  end
end
