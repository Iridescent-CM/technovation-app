FactoryBot.define do
  factory :chapter_program_information do
    sequence(:child_safeguarding_policy_and_process) { |n| "FactoryBot Safeguarding Policy #{n}" }
    sequence(:team_structure) { |n| "FactoryBot Team Structure #{n}" }
    sequence(:external_partnerships) { |n| "FactoryBot External Partnerships #{n}" }
    start_date { Time.now }
    sequence(:program_model) { |n| "FactoryBot Program Model #{n}" }
    sequence(:number_of_low_income_or_underserved_calculation) { |n| "FactoryBot Underserved Calculation #{n}" }
    organization_types { build_list :organization_type, 3 }
    meeting_times { build_list :meeting_time, 3 }
    meeting_facilitators { build_list :meeting_facilitator, 3 }

    association :chapter
    association :program_length
    association :participant_count_estimate
    association :low_income_estimate
  end
end
