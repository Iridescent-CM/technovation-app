class UserInvitation < ApplicationRecord
  enum profile_type: %i{
    chapter_ambassador
    judge
    mentor
    student
    parent_student
  }

  enum status: %i{
    sent
    opened
    registered
  }

  PROFILE_TYPES = UserInvitation.profile_types.keys.map do |profile_type|
    if profile_type == "student"
      ["Student (Jr/Sr Division)", profile_type]
    elsif profile_type == "parent_student"
      ["Parent (Beginner Division)", profile_type]
    else
      [profile_type.titleize, profile_type]
    end
  end

  validates :profile_type, :email, presence: true
  validates :email, uniqueness: true, email: true

  validate ->(invitation) {
    if inviting_existing_chapter_ambassador_to_be_a_chapter_ambassador?
      errors.add(:email, :taken_by_account)
    elsif inviting_existing_mentor_to_be_a_chapter_ambassador?
      true
    elsif inviting_existing_judge_to_be_a_chapter_ambassador?
      true
    elsif inviting_existing_account?
      errors.add(:email, :taken_by_account)
    end
  }, on: :create

  has_secure_token :admin_permission_token

  has_and_belongs_to_many :events, class_name: "RegionalPitchEvent"
  belongs_to :account, required: false
  belongs_to :current_account, -> { current }, required: false
  belongs_to :invited_by, class_name: "Account", required: false

  has_many :judge_assignments, as: :assigned_judge, dependent: :destroy
  has_many :assigned_teams,
    through: :judge_assignments,
    source: :team

  delegate :name,
    to: :account,
    prefix: true,
    allow_nil: true

  before_validation -> {
    self.email = email.strip.downcase
  }

  after_commit -> {
    if account = Account.left_outer_joins(
                   :chapter_ambassador_profile
                 )
                 .includes(:judge_profile, :mentor_profile)
                 .where(
                   "chapter_ambassador_profiles.id " +
                   "IS NULL"
                 )
                 .find_by(
                   "lower(trim(both ' ' from email)) = ?",
                   email
                 )

      if mentor_profile = account.mentor_profile
        mentor_profile.update(account: nil, user_invitation: self)
      end

      if judge_profile = account.judge_profile
        judge_profile.update(account: nil, user_invitation: self)
      end

      account.reload.destroy
    end
  }, on: :create

  after_commit -> {
    if mentor = MentorProfile.find_by(user_invitation: self)
      account.mentor_profile = mentor
      account.save!
    end

    if judge = JudgeProfile.find_by(user_invitation: self)
      account.judge_profile = judge
      account.save!
    end
  }, on: :update, if: -> { saved_change_to_status? and registered? }

  scope :by_query, ->(query) {
    sanitized = sanitize_sql_like(query)
    where("lower(unaccent(email)) ILIKE '#{sanitized.downcase}%'")
  }

  def submission_scores
    SubmissionScore.none
  end

  def is_team?
    false
  end

  def virtual_event?
    false
  end

  def pending?
    !registered?
  end

  def human_status
    case status
    when "sent", "opened"; "must sign up"
    when "registered";     "must complete training"
    else; "status missing (bug)"
    end
  end

  def friendly_status
    case status
    when "sent", "opened"; "Sign up now"
    when "registered";     "Complete your judge profile"
    else; "status missing (bug)"
    end
  end

  def status_explained
    case status
    when "sent", "opened"
      "This person was sent an email to sign up"
    when "registered"
      "This person has signed up and needs to finish their profile"
    else
      "Status is missing, this is a bug"
    end
  end

  def first_name
    email
  end

  def id_for_event
    if persisted?
      id
    else
      SecureRandom.hex(16)
    end
  end

  def in_event?(event)
    events.include?(event)
  end

  def event_scope
    "UserInvitation"
  end

  def locale
    :en
  end

  def ambassador_route_key
    false
  end

  def temporary_password?
    true
  end

  def to_cookie_params
    [CookieNames::ADMIN_PERMISSION_TOKEN, admin_permission_token]
  end

  def scope_name
    profile_type
  end

  def mailer_token
    admin_permission_token
  end

  private
  def inviting_existing_chapter_ambassador_to_be_a_chapter_ambassador?
    profile_type.to_s == "chapter_ambassador" and
      Account.left_outer_joins(:chapter_ambassador_profile)
        .where("chapter_ambassador_profiles.id IS NOT NULL")
        .where("lower(trim(both ' ' from email)) = ?", email)
        .exists?
  end

  def inviting_existing_mentor_to_be_a_chapter_ambassador?
    profile_type.to_s == "chapter_ambassador" and
      Account.joins(:mentor_profile)
        .where("lower(trim(both ' ' from email)) = ?", email)
        .exists?
  end

  def inviting_existing_judge_to_be_a_chapter_ambassador?
    profile_type.to_s == "chapter_ambassador" and
      Account.joins(:judge_profile)
        .where("lower(trim(both ' ' from email)) = ?", email)
        .exists?
  end

  def inviting_existing_account?
    Account.where("lower(trim(both ' ' from email)) = ?", email).exists?
  end
end
