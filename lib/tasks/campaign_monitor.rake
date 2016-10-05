namespace :cm do
  desc "Remove students who are not permitted by their parents"
  task remove_unpermitted_students: :environment do
    auth = { api_key: ENV.fetch("CAMPAIGN_MONITOR_API_KEY") }

    StudentAccount.joins(season_registrations: :season)
                  .includes(:parental_consent)
                  .references(:parental_consents)
                  .where("seasons.year = ?", Season.current.year)
                  .where("parental_consents.id IS NULL")
                  .pluck(:email).each do |email|
      begin
        CreateSend::Subscriber.new(auth, ENV.fetch("STUDENT_LIST_ID"), email).delete
        puts "Removed #{email}"
      rescue
        puts "PROBLEM REMOVING #{email}"
      end
    end
  end

  desc "Remove mentors not passing BG check or consent signed"
  task remove_unapproved_mentors: :environment do
    auth = { api_key: ENV.fetch("CAMPAIGN_MONITOR_API_KEY") }

    MentorAccount.joins(season_registrations: :season)
                 .includes(:background_check, :consent_waiver)
                 .references(:background_checks, :consent_waivers)
                 .where("seasons.year = ?", Season.current.year)
                 .where("consent_waivers.id IS NULL OR (accounts.country = ? AND background_checks.id IS NULL)", "US")
                 .pluck(:email).each do |email|
      begin
        CreateSend::Subscriber.new(auth, ENV.fetch("MENTOR_LIST_ID"), email).delete
        puts "Removed #{email}"
      rescue
        puts "PROBLEM REMOVING #{email}"
      end
    end
  end
end
