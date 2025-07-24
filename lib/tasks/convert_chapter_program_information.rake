desc "Convert Chapter Program Information"
task convert_chapter_program_information: :environment do
  ProgramInformation
    .where.not(chapter_id: nil)
    .update_all("chapterable_id = chapter_id, chapterable_type = 'Chapter'")

  puts "Updated chapter program information"
end
