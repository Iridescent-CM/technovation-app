def reset_day?
  Date.today.month == Season::START_MONTH and
      Date.today.day == Season::START_DAY
end

desc "Reset data for the new season on season start date every year"
task :reset_for_season, [:force] => :environment do |t, args|
  if reset_day? || args[:force] == "force"
    puts "Resetting for new season"

    ConsentWaiver.nonvoid.find_each(&:void!)

    Account.update_all(terms_agreed_at: nil)

    StudentProfile.update_all(onboarded: false)
    JudgeProfile.update_all(onboarded: false)

    MentorProfile.update_all(training_completed_at: nil)
    JudgeProfile.update_all(completed_training_at: nil)
  end
end
