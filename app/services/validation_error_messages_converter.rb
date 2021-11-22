class ValidationErrorMessagesConverter
  def initialize(errors:, error_key_conversions: DEFAULT_ERROR_KEY_CONVERSIONS)
    @errors = errors
    @error_key_conversions = error_key_conversions
  end

  def individual_errors
    errors.each_with_object({}) do |error, result|
      converted_key = error_key_conversions.fetch(error.attribute.to_sym, error.attribute)

      result[converted_key] = Array(result[converted_key]) << error.message
    end
  end

  def full_errors
    errors.full_messages
      .prepend("Something went wrong saving your profile")
      .delete_if do |message|
      ["Account is invalid", "Mentor profile expertises is invalid"].include?(message)
    end
  end

  private

  attr_accessor :errors, :error_key_conversions

  DEFAULT_ERROR_KEY_CONVERSIONS = {
    "account.date_of_birth": "dateOfBirth",
    "account.email": "email",
    "account.first_name": "firstName",
    "account.gender": "gender",
    "account.last_name": "lastName",
    "account.password": "password",
    parent_guardian_email: "studentParentGuardianEmail",
    school_company_name: "mentorschoolCompanyName",
    school_name: "studentSchoolName"
  }
end
