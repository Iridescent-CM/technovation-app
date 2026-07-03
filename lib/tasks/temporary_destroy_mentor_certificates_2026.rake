# Temporary task for #6175 — remove after 2026 mentor certificates are regenerated.
namespace :certificates do
  desc "Destroy mentor certificates for a season (default 2026). Dry run by default; pass 'run' as the second argument to destroy."
  task :destroy_mentor_certificates_2026, [:season, :dry_run] => :environment do |_t, args|
    season = (args[:season].presence || 2026).to_i
    dry_run = args[:dry_run] != "run"

    certificates = Certificate.mentor.by_season(season).includes(:account, :team)
    count = certificates.count

    puts "DRY RUN: #{dry_run ? "on" : "off"}"
    puts "Season: #{season}"
    puts "Found #{count} mentor certificate(s) to destroy"

    certificates.find_each do |certificate|
      account_label = "Account##{certificate.account_id}"
      team_label = certificate.team_id ? " Team##{certificate.team_id}" : ""
      puts "DESTROY Certificate##{certificate.id} (#{account_label}#{team_label})"
      certificate.destroy unless dry_run
    end

    if dry_run
      puts "Pass 'run' as the second task argument to turn off dry run and destroy certificates"
      puts "Example: rake certificates:destroy_mentor_certificates_2026[2026,run]"
    else
      puts "Destroyed #{count} mentor certificate(s) for season #{season}"
    end
  end
end
