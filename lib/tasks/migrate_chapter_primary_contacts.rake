desc "Migrate Chapter Primary Contacts"
task migrate_chapter_primary_contacts: :environment do
  chapters = Chapter
    .where.not(primary_contact_id: nil)

  if chapters.present?
    chapters.find_each do |chapter|
      primary_account = ChapterAmbassadorProfile.find(chapter.primary_contact_id).account

      chapter.update_column(:primary_account_id, primary_account.id)

      puts "Migrated primary contact #{primary_account.full_name} for chapter #{chapter.name}"
    end
  end
end
