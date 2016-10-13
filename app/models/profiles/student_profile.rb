class StudentProfile < ActiveRecord::Base
  include Authenticatable

  belongs_to :student_account, foreign_key: :account_id

  after_update :reset_parent

  validates :school_name, presence: true

  validate :parent_guardian_email, -> { validate_valid_parent_email }

  def validate_parent_email
    %i{parent_guardian_name parent_guardian_email}.select { |a| send(a).blank? }.each do |a|
      errors.add(a, :blank)
    end

    if parent_guardian_email == student_account.email
      errors.add(:parent_guardian_email, :matches_student_email)
    end

    validate_valid_parent_email

    errors.empty?
  end

  private
  def validate_valid_parent_email
    return if parent_guardian_email.blank? || (!parent_guardian_email_changed? && parent_guardian_email == "ON FILE")

    if StudentAccount.where("lower(email) = ?", parent_guardian_email.downcase).any?
      errors.add(:parent_guardian_email, :found_in_student_accounts)
    end

    if not parent_guardian_email.match(/@/) or parent_guardian_email.match(/\.$/)
      errors.add(:parent_guardian_email, :invalid)
    end
  end

  def reset_parent
    if parent_guardian_email_changed? and parent_guardian_email.present?
      student_account.void_parental_consent!
      ParentMailer.consent_notice(parent_guardian_email,
                                  parent_guardian_name,
                                  student_account.consent_token).deliver_later
    end

    if parent_guardian_name_changed? or parent_guardian_email_changed? and parent_guardian_email.present?
      UpdateEmailListJob.perform_later(parent_guardian_email_was,
                                       parent_guardian_email,
                                       parent_guardian_name,
                                       "PARENT_LIST_ID")
    end
  end
end
