class SignupAttemptSerializer
  include FastJsonapi::ObjectSerializer
  set_key_transform :camel_lower

  attributes :email, :birth_year, :birth_month, :birth_day, :wizard_token

  attribute(:terms_agreed) do |attempt|
    attempt.terms_agreed?
  end
end
