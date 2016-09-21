class StudentProfile < ActiveRecord::Base
  include Authenticatable

  belongs_to :student_account, foreign_key: :account_id

  after_update :reset_parent

  validates :school_name, presence: true

  def validate_parent_email
    required_email_attributes.select { |a| send(a).blank? }.each do |a|
      errors.add(a, :blank)
    end

    if parent_guardian_email == student_account.email
      errors.add(:parent_guardian_email, :matches_student_email)
    end

    errors.empty?
  end

  private
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
                                       ENV.fetch("PARENT_LIST_ID"))
    end
  end

  def required_email_attributes
    %i{
      parent_guardian_name
      parent_guardian_email
    }
  end
end
