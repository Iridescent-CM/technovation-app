desc "Reset judge trainings for judges in the current season"
task reset_judge_training: :environment do
  accounts = Account.current.joins(:judge_profile).where.not(judge_profile: {completed_training_at: nil})
  judges_updated_count = 0

  accounts.each do |account|
    puts "Resetting judge training for account: #{account.id} - #{account.first_name} #{account.last_name}"

    account.judge_profile.update(completed_training_at: nil)
    judges_updated_count += 1
  end

  puts "Reset #{judges_updated_count} judges"
end
