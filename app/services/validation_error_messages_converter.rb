class ValidationErrorMessagesConverter
  def initialize(errors:, error_key_conversions: DEFAULT_ERROR_KEY_CONVERSIONS)
    @errors = errors
    @error_key_conversions = error_key_conversions
  end

  def call
    json = {}

    errors.each do |error|
      converted_key = error_key_conversions.fetch(error.attribute.to_sym, error.attribute)

      json[converted_key] = error.message
    end

    json
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
    parent_guardian_email: "studentParentGuardianName",
    school_company_name: "mentorschoolCompanyName",
    school_name: "studentSchoolName"
  }
end
