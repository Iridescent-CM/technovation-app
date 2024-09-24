desc "Migrate Chapter Ambassador Chapter Assignments"
task migrate_cha_chapter_assignments: :environment do
  chapter_ambassadors_with_chapters = ChapterAmbassadorProfile
    .where.not(chapter_id: nil)

  if chapter_ambassadors_with_chapters.present?
    chapter_ambassadors_with_chapters.find_each do |chapter_ambassador|
      chapter_ambassador.account.chapter_assignments.create(
        chapter_id: chapter_ambassador.chapter_id,
        profile: chapter_ambassador,
        season: 2025,
        primary: true
      )

      chapter_ambassador.update_column(:chapter_id, nil)

      puts "Migrated #{chapter_ambassador.account.full_name} to new chapter assignments model"
    end
  end
end
