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
    if mentor_account = Account.left_outer_joins(:regional_ambassador_profile)
                               .joins(:mentor_profile)
                               .where("regional_ambassador_profiles.id IS NULL")
                               .find_by(
                                 "lower(trim(both ' ' from email)) = ?",
                                 email
                               )

      profile = mentor_account.mentor_profile
      profile.update(account: nil, user_invitation: self)

      mentor_account.reload.destroy
    end
  }, on: :create

  after_commit -> {
    if mentor = MentorProfile.find_by(user_invitation: self) 
      account.mentor_profile = mentor
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
    elsif inviting_existing_account?
      errors.add(:email, :taken_by_account)
    end
  }, on: :create

  has_secure_token :admin_permission_token

  belongs_to :account, required: false

  delegate :name,
    to: :account,
    prefix: true,
    allow_nil: true

  def temporary_password?
    true
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

  def inviting_existing_account?
    Account.where("lower(trim(both ' ' from email)) = ?", email).exists?
  end
end
