class SignupAttemptSerializer
  include FastJsonapi::ObjectSerializer
  set_key_transform :camel_lower

  attributes :email, :birth_year, :birth_month, :birth_day, :profile_choice,
    :city, :state, :state_code, :country, :country_code, :latitude, :longitude, :first_name,
    :last_name, :gender_identity, :school_company_name, :job_title,
    :referred_by, :referred_by_other, :wizard_token, :mentor_type, :expertise_ids, :bio

  attribute(:terms_agreed) do |attempt|
    attempt.terms_agreed?
  end

  attribute(:terms_agreed_date) do |attempt|
    attempt.terms_agreed_at.strftime("%b %e") if attempt.terms_agreed?
  end
end
