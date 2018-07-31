class SignupAttemptSerializer
  include FastJsonapi::ObjectSerializer
  set_key_transform :camel_lower

  attributes :email, :birth_year, :birth_month, :birth_day, :first_name,
    :last_name, :gender_identity, :school_company_name, :referred_by,
    :referred_by_other, :wizard_token

  attribute(:terms_agreed) do |attempt|
    attempt.terms_agreed?
  end
end
