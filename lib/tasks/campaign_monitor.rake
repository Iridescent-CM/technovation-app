namespace :cm do
  desc "Remove students who are not permitted by their parents"
  task remove_unpermitted_students: :environment do
    auth = { api_key: ENV.fetch("CAMPAIGN_MONITOR_API_KEY") }

    StudentProfile.joins(:account)
                  .includes(:parental_consent)
                  .references(:parental_consents)
                  .where("parental_consents.id IS NULL")
                  .pluck("accounts.email").each do |email|
      begin
        CreateSend::Subscriber.new(auth, ENV.fetch("STUDENT_LIST_ID"), email).delete
        puts "Removed #{email}"
      rescue => e
        puts "PROBLEM REMOVING #{email}"
        puts e.message
      end
    end
  end

  desc "Add students who are permitted by their parents"
  task add_permitted_students: :environment do
    auth = { api_key: ENV.fetch("CAMPAIGN_MONITOR_API_KEY") }

    StudentProfile.joins(:account, :parental_consent).each do |profile|
      begin
        CreateSend::Subscriber.add(
          auth,
          ENV.fetch("STUDENT_LIST_ID"),
          profile.email,
          profile.full_name,
          [],
          false # resubscribe?
        )
        puts "Added #{email}"
      rescue => e
        puts "PROBLEM ADDING #{email}"
        puts e.message
      end
    end
  end

  desc "Remove mentors not passing BG check or consent signed"
  task remove_unapproved_mentors: :environment do
    auth = { api_key: ENV.fetch("CAMPAIGN_MONITOR_API_KEY") }

    Account.joins(:mentor_profile, season_registrations: :season)
           .includes(:background_check, :consent_waiver)
           .references(:background_checks, :consent_waivers)
           .where("consent_waivers.id IS NULL OR (accounts.country = ? AND background_checks.id IS NULL)", "US")
           .pluck(:email).each do |email|
      begin
        CreateSend::Subscriber.new(auth, ENV.fetch("MENTOR_LIST_ID"), email).delete
        puts "Removed #{email}"
      rescue => e
        puts "PROBLEM REMOVING #{email}"
        puts e.message
      end
    end
  end
end
