desc "Update background check internal invitation status"
task :update_bg_check_internal_invitation_status, [:dry_run] => :environment do |t, args|
  dry_run = args[:dry_run] != "run"

  background_checks = BackgroundCheck.where.not(invitation_status: nil)

  puts "DRY RUN: #{dry_run ? "on" : "off"}"
  puts("Updating internal invitation status for #{background_checks.count} background checks")

  if !dry_run
    puts("Starting update")
    background_checks.find_each do |background_check|
      background_check.update_column(:internal_invitation_status, 1)
    end
    puts("Update complete")
  end
end
