desc "Restore mentor data from lib/restore_mentors.json"
task restore_mentors: :environment do
  ActiveRecord::Base.transaction do
    data = JSON.parse(File.read("./lib/restore_mentors.json"))

    data.each do |json|
      account = Account.find(json["account"]["id"])

      mentor = account.create_mentor_profile!({
        job_title: json["mentor"]["job_title"],
        school_company_name: json["mentor"]["school_company_name"],
        bio: json["mentor"]["bio"]
      })

      mentor.create_consent_waiver!({
        electronic_signature: json["consent_waiver"]["electronic_signature"]
      })

      json["team_ids"].each do |id|
        team = Team.find(id)
        TeamRosterManaging.add(team, mentor)
      end
    end
  end
end
