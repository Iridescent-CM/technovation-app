class UserInvitation < ApplicationRecord
  enum profile_type: %i{
    regional_ambassador
    judge
    mentor
    student
  }

  enum status: %i{
    sent
    opened
    registered
  }

  before_validation -> {
    self.email = email.strip.downcase
  }

  after_commit -> {
    if account = Account.left_outer_joins(
                   :regional_ambassador_profile
                 )
                 .left_outer_joins(:judge_profile, :mentor_profile)
                 .where(
                   "regional_ambassador_profiles.id " +
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

  validates :profile_type, :email, presence: true
  validates :email, uniqueness: true, email: true

  validate ->(invitation) {
    if inviting_existing_ra_to_be_an_ra?
      errors.add(:email, :taken_by_account)
    elsif inviting_existing_mentor_to_be_an_ra?
      true
    elsif inviting_existing_judge_to_be_an_ra?
      true
    elsif inviting_existing_account?
      errors.add(:email, :taken_by_account)
    end
  }, on: :create

  has_secure_token :admin_permission_token

  has_and_belongs_to_many :events, class_name: "RegionalPitchEvent"
  belongs_to :account, required: false

  delegate :name,
    to: :account,
    prefix: true,
    allow_nil: true

  def to_search_json
    {
      id: id,
      name: name,
      email: email,
      location: "Invitation: #{status}",
    }
  end

  def locale
    :en
  end

  def temporary_password?
    true
  end

  def to_cookie_params
    [:admin_permission_token, admin_permission_token]
  end

  private
  def inviting_existing_ra_to_be_an_ra?
    profile_type.to_s == "regional_ambassador" and
      Account.left_outer_joins(:regional_ambassador_profile)
        .where("regional_ambassador_profiles.id IS NOT NULL")
        .where("lower(trim(both ' ' from email)) = ?", email)
        .exists?
  end

  def inviting_existing_mentor_to_be_an_ra?
    profile_type.to_s == "regional_ambassador" and
      Account.joins(:mentor_profile)
        .where("lower(trim(both ' ' from email)) = ?", email)
        .exists?
  end

  def inviting_existing_judge_to_be_an_ra?
    profile_type.to_s == "regional_ambassador" and
      Account.joins(:judge_profile)
        .where("lower(trim(both ' ' from email)) = ?", email)
        .exists?
  end

  def inviting_existing_account?
    Account.where("lower(trim(both ' ' from email)) = ?", email).exists?
  end
end
