FactoryGirl.define do
  factory :background_check do
    account
    status BackgroundCheck.statuses[:clear]
    report_id "123abcREPORT_ID"
    candidate_id "123abcCANDIDATE_ID"
  end
end
