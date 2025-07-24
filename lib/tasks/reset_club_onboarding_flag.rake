desc "Reset Club Onboarding Flag"
task reset_club_onboarding_flag: :environment do
  Club.update_all(onboarded: false)

  puts "Reset club onboarding flag"
end

