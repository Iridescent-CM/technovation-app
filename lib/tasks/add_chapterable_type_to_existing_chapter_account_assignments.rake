desc "Add chapterable type to existing chapter assignments"
task add_chapterable_type_to_existing_chapter_assignments: :environment do |_, args|
  ChapterableAccountAssignment.update_all(chapterable_type: "Chapter")

  puts "Successfully converted existing chapter assignments to new chapterable model"
end
