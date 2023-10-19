task :remove_pending_background_checks_by_id, [:dry_run] => :environment do |t, args|
  background_check_ids = args.extras
  dry_run = args[:dry_run] != "run"
  puts "DRY RUN: #{dry_run ? "on" : "off"}"

  background_check_ids.each do |id|
    background_check = BackgroundCheck.find(id)
    puts "Deleting background check #{background_check.id} - for Account #{background_check.account_id} located in #{background_check.account.country} - Candidate Id #{background_check.candidate_id}"

    if !dry_run
      background_check.destroy
      puts "Background check #{background_check.id} deleted"
    end
  end

  puts "Done"
end
