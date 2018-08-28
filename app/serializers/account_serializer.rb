class AccountSerializer
  include FastJsonapi::ObjectSerializer
  set_key_transform :camel_lower

  set_id :random_id

  has_one :student_profile, if: ->(record) { record.student_profile }
  has_one :mentor_profile,  if: Proc.new { |record| record.mentor_profile }

  attributes :email, :date_of_birth, :city, :latitude, :longitude, :first_name,
   :last_name, :gender, :referred_by, :referred_by_other

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

  attribute(:mentor_type) do |account|
    account.profile_mentor_type
  end

  attribute(:expertise_ids) do |account|
    account.profile_expertise_ids
  end

  attribute(:terms_agreed) do |attempt|
    true
  end

  attribute(:terms_agreed_date) do |account|
    if account.signup_attempt
      account.signup_attempt.terms_agreed_at.strftime("%b %e, %Y")
    else
      account.created_at.strftime("%b %e, %Y")
    end
  end

  attribute(:state) do |account|
    if country = Carmen::Country.coded(account.country)
      country.subregions.coded((account.state_province || "").sub(".", ""))
    end
  end

  attribute(:state_code) do |account|
    account.state_province
  end

  attribute(:country_code) do |account|
    account.country
  end

  attribute(:country) do |account|
    Carmen::Country.coded(account.country).try(:name)
  end

  attribute(:current_team_id) do |account|
    if account.student_profile
      account.student_profile.team_id
    end
  end
end
