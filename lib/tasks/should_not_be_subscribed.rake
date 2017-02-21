desc "CSV of mentors who should not be subscribed"
task csv_mentors_no_subscribe: :environment do
  CSV.open("non_participating_mentors.csv", "wb") do |csv|
    csv << %i{email}

    Account.joins(:mentor_profile)
      .includes(:background_check, :consent_waiver)
      .references(:background_checks, :consent_waivers)
      .where("consent_waivers.id IS NULL OR (accounts.country = ? AND background_checks.id IS NULL)", "US")
      .pluck(:email).each do |email|

      csv << [email]
    end
  end
end
