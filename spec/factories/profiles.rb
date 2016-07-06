FactoryGirl.define do
  factory :student_profile do
    school_name { "FactoryGirl High" }
    is_in_secondary_school { true }
    parent_guardian_name { "Thoughtbot" }
    parent_guardian_email { "factorygirl@thoughtbot.com" }
    account
  end

  factory :mentor_profile do
    school_company_name { "FactoryGirl" }
    job_title { "Engineer" }
  end
end
