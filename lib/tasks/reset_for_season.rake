def reset_day?
  Date.today.month == Season::START_MONTH and
      Date.today.day == Season::START_DAY
end

desc "Reset data for the new season on season start date every year"
task :reset_for_season, [:force] => :environment do |t, args|
  if reset_day? || args[:force] == "force"
    puts "Resetting consent waivers"
    ConsentWaiver.nonvoid.find_each(&:void!)

    puts "Resetting data use terms"
    Account.update_all(terms_agreed_at: nil)

    puts "Resetting onboarded flags"
    StudentProfile.update_all(onboarded: false)
    JudgeProfile.update_all(onboarded: false)

    puts "Resetting mentor trainings"
    MentorProfile.update_all(training_completed_at: nil)

    puts "Removing pending team invites to mentors"
    TeamMemberInvite.where(invitee_type: "MentorProfile", status: "pending").delete_all

    puts "Resetting judge trainings"
    JudgeProfile.update_all(completed_training_at: nil)

    puts "Finished resetting"
  else
    season_start_date = "#{Date.today.year}-#{Season::START_MONTH.to_s.rjust(2, "0")}-#{Season::START_DAY.to_s.rjust(2, "0")}"

    puts "The reset needs to happen on the season start date (#{season_start_date}) or you can run this rake task with the 'force' option (e.g. `bundle exec rake reset_for_season[force]`)"
  end
end
