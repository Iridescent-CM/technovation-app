desc "Reset data for the new season on season start date every year"
task :reset_for_season, :environment do

  if Date.today.month == Season::START_MONTH and
      Date.today.day == Season::START_DAY
    ConsentWaiver.nonvoid.find_each(&:void!)

    StudentProfile.update_all(onboarded: false)
    JudgeProfile.update_all(onboarded: false)

    MentorProfile.update_all(training_completed_at: nil)
    JudgeProfile.update_all(completed_training_at: nil)
  end
end
