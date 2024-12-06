desc "Add chapterable type to existing chapter assignments"
task add_chapterable_type_to_existing_chapter_assignments: :environment do |_, args|
  ChapterAccountAssignment.update_all(chapterable_type: "Chapter")

  puts "Sucessfully converted existing chapter assignments to new chapterable model"
end
