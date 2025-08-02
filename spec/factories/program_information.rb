FactoryBot.define do
  factory :program_information do
    start_date { Time.now }
    meeting_times { build_list :meeting_time, 3 }
    meeting_facilitators { build_list :meeting_facilitator, 3 }
    sequence(:child_safeguarding_policy_and_process) { |n| "FactoryBot Safeguarding Policy #{n}" }
    organization_types { build_list :organization_type, 3 }
    meeting_formats { build_list :meeting_format, 1 }
    work_related_ambassador { true }

    association :program_length
  end
end
