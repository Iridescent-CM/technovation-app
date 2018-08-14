class SignupAttempt < ActiveRecord::Base
  has_secure_password validations: false

  enum status: %i{
    pending
    active
    registered
    temporary_password
    wizard
  }

  enum profile_choice: %w{
    student
    mentor
    judge
    regional_ambassador
  }

  enum referred_by: REFERRED_BY_OPTIONS
  enum gender_identity: GENDER_IDENTITY_OPTIONS
  enum mentor_type: MENTOR_TYPE_OPTIONS

  belongs_to :account, required: false

  has_many :mentor_profile_expertises,
    dependent: :destroy

  has_many :expertises,
    through: :mentor_profile_expertises

  before_validation -> {
    self.email = (email || "").strip.downcase
  }

  validates :email, presence: true, email: true, if: :email_required?

  validates :password,
   presence: true,
   length: { minimum: 8 },
   if: :password_required?

  has_secure_token :pending_token
  has_secure_token :activation_token
  has_secure_token :signup_token
  has_secure_token :admin_permission_token
  has_secure_token :wizard_token

  def password_required?
    new_record? && !wizard?
  end

  def email_required?
    new_record? && !wizard? && !terms_agreed?
  end

  def terms_agreed?
    !!terms_agreed_at
  end

  def set_terms_agreed(bool)
    value = bool ? Time.current : nil
    self.terms_agreed_at = value
    save!
  end
end