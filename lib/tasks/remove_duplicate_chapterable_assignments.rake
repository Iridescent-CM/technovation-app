desc "Remove duplicate chapterable assignments"
task remove_duplicate_chapterable_assignments: :environment do |task, args|
  count_of_removed_assignments = ChapterableAccountAssignment.where(id: [args.extras]).delete_all

  puts "Removed #{count_of_removed_assignments} chapterable assignments"
end
