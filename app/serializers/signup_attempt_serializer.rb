class SignupAttemptSerializer
  include FastJsonapi::ObjectSerializer
  set_key_transform :camel_lower

  attributes :email, :wizard_token

  attribute(:terms_agreed) do |attempt|
    attempt.terms_agreed?
  end
end
