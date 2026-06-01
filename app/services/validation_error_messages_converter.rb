class ValidationErrorMessagesConverter
  def initialize(errors:, record: nil, error_key_conversions: DEFAULT_ERROR_KEY_CONVERSIONS)
    @errors = errors
    @record = record
    @error_key_conversions = error_key_conversions
  end

  def individual_errors
    errors.each_with_object({}) do |error, result|
      converted_key = error_key_conversions.fetch(error.attribute.to_sym, error.attribute)

      result[converted_key] = Array(result[converted_key]) << error.message
    end
  end

  FILTERED_FULL_ERROR_MESSAGES = [
    "Account is invalid",
    "Mentor profile expertises is invalid"
  ].freeze

  def full_errors
    error_full_messages
      .concat(nested_association_error_messages)
      .prepend("Something went wrong saving your profile")
      .delete_if { |message| FILTERED_FULL_ERROR_MESSAGES.include?(message) }
      .uniq
  end

  private

  attr_accessor :errors, :record, :error_key_conversions

  def error_full_messages
    if errors.is_a?(ActiveModel::Errors)
      errors.map(&:full_message)
    else
      errors.full_messages
    end
  end

  def validation_record
    record || errors.instance_variable_get(:@base)
  end

  def nested_association_error_messages
    validation_record = self.validation_record
    return [] unless validation_record.respond_to?(:account)

    account = validation_record.account
    return [] unless account&.errors&.any?

    account.errors.full_messages
  end

  DEFAULT_ERROR_KEY_CONVERSIONS = {
    "account.date_of_birth": "dateOfBirth",
    "account.email": "email",
    "account.first_name": "firstName",
    "account.gender": "gender",
    "account.last_name": "lastName",
    "account.password": "password",
    "account.terms_agreed_at": "dataTermsAgreedTo",
    parent_guardian_email: "studentParentGuardianEmail",
    judge_types: "judgeTypes",
    school_company_name: "mentorschoolCompanyName",
    school_name: "studentSchoolName"
  }
end
