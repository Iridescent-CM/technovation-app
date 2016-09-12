FactoryGirl.define do
  factory :student_profile do
    school_name { "FactoryGirl High" }
    association(:student_account)
  end

  factory :mentor_profile do
    school_company_name { "FactoryGirl" }
    job_title { "Engineer" }
    bio "A complete bio"
    background_check_completed_at Time.current
    association(:mentor_account)
  end

  factory :regional_ambassador_profile do
    organization_company_name { "FactoryGirl" }
    job_title { "Engineer" }
    ambassador_since_year { Time.current.year }
    bio "A complete bio"
    background_check_completed_at Time.current
    account
  end
end
