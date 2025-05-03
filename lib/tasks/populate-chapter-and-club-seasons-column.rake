desc "Populate chapter and club seasons column"
task populate_chapter_and_club_seasons_column: :environment do
  Chapter.update_all(seasons: [2025])
  puts "Populated all chapters with 2025 season"

  Club.update_all(seasons: [2025])
  puts "Populated all clubs with 2025 season"
end
