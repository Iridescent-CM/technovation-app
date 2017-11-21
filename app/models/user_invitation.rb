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
                               .find_by(
                                 "lower(trim(both ' ' from email)) = ?",
                                 email
                               )
                               #.where("regional_ambassador_profiles.id IS NULL")

      profile = mentor_account.mentor_profile
      profile.update(account: nil, user_invitation: self)

      mentor_account.reload.destroy
    end
  }, on: :create

  after_commit -> {
    account.mentor_profile = MentorProfile.find_by(user_invitation: self)
    account.save!
  }, on: :update, if: -> { saved_change_to_status? and registered? }

  validates :profile_type, :email, presence: true
  validates :email, uniqueness: true, email: true

  validate ->(invitation) {
    if Account.left_outer_joins(:mentor_profile)
      .where("mentor_profiles.id IS NULL")
      .where(
         "lower(trim(both ' ' from email)) = ?",
         email
       ).exists?
      invitation.errors.add(:email, :taken_by_account)
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
end
