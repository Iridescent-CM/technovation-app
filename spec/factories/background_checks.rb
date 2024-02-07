FactoryBot.define do
  factory :background_check do
    account
    status { BackgroundCheck.statuses[:clear] }
    report_id { "123abcREPORT_ID" }
    candidate_id { "123abcCANDIDATE_ID" }

    trait :invitation_pending do
      status { BackgroundCheck.statuses[:invitation_required] }
      invitation_id { "123abcINVITATION_ID" }
      invitation_status { BackgroundCheck.invitation_statuses[:pending] }
      candidate_id { nil }
      report_id { nil }
    end
  end
end
