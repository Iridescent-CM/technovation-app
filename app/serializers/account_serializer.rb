class AccountSerializer
  include FastJsonapi::ObjectSerializer
  set_key_transform :camel_lower

  set_id :random_id

  attributes :name, :email, :date_of_birth, :age, :city, :state, :country, :state_code,
    :country_code, :latitude, :longitude, :first_name, :last_name, :gender,
    :referred_by, :referred_by_other, :avatar_url

  attribute(:api_root) do |account|
    "#{account.scope_name}"
  end

  attribute(:birth_year) do |account|
    account.date_of_birth.to_s.split("-")[0]
  end

  attribute(:birth_month) do |account|
    account.date_of_birth.to_s.split("-")[1]
  end

  attribute(:birth_day) do |account|
    account.date_of_birth.to_s.split("-")[2]
  end

  attribute(:profile_choice) do |account|
    account.scope_name
  end

  attribute(:gender_identity) do |account|
    account.gender
  end

  attribute(:school_company_name) do |account|
    account.profile_school_company_name
  end

  attribute(:job_title) do |account|
    account.profile_job_title
  end

  attribute(:mentor_type_ids) do |account|
    account.profile_mentor_type_ids
  end

  attribute(:expertise_ids) do |account|
    account.profile_expertise_ids
  end

  attribute(:terms_agreed) do |account|
    account.terms_agreed?
  end

  attribute(:has_saved_parental_info) do |account|
    account.student_profile.present? &&
      account.student_profile.has_saved_parental_info?
  end

  attribute(:terms_agreed_date) do |account|
    if account.terms_agreed?
      account.terms_agreed_at.strftime("%b %e, %Y")
    else account.signup_attempt
      "never"
    end
  end

  attribute(:current_team_id) do |account|
    if account.student_profile
      account.student_profile.team_id
    end
  end
end
