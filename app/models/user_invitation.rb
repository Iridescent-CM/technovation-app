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

  validates :profile_type, :email, presence: true
  validates :email, uniqueness: true, email: true

  validate ->(invitation) {
    if Account.where("lower(trim(both ' ' from email)) = ?", email.strip.downcase).exists?
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
