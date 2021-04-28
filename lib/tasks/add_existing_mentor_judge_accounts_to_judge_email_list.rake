desc "Add existing mentor-judge combo accounts to the judge's email list"
task add_existing_mentor_judge_accounts_to_judge_email_list: :environment do
  account_ids = Account
    .joins(:mentor_profile)
    .joins(:judge_profile)
    .where("'2021' = ANY(seasons)")
    .pluck(:id)

  account_ids.each_with_index do |account_id, index|
    puts "#{(index + 1).to_s.rjust(3)}: Calling AddProfileTypeToAccountOnEmailListJob for account_id: #{account_id}"

    AddProfileTypeToAccountOnEmailListJob.perform_later(profile_type: "judge", account_id: account_id)
  end
end
