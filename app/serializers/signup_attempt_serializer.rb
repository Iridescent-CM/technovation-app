class SignupAttemptSerializer
  include FastJsonapi::ObjectSerializer
  set_key_transform :camel_lower

  attributes :email, :birth_year, :birth_month, :birth_day, :city, :state_code,
    :country_code, :latitude, :longitude, :first_name, :last_name,
    :gender_identity, :school_company_name, :referred_by, :referred_by_other,
    :wizard_token

  attribute(:terms_agreed) do |attempt|
    attempt.terms_agreed?
  end

  attribute(:state) do |attempt|
    if country = Carmen::Country.coded(attempt.country_code)
      country.subregions.coded(attempt.state_code.sub(".", ""))
    end
  end

  attribute(:country) do |attempt|
    Carmen::Country.coded(attempt.country_code).try(:name)
  end
end
