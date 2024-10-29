desc "Convert primary chapter ambassador's location to chapter"
task convert_primary_chapter_ambassadors_location_to_chapter: :environment do |_, args|
  chapters_missing_location = Chapter
    .where(country: nil)
    .where.not(primary_account_id: nil)

  if chapters_missing_location.present?
    chapters_missing_location.find_each do |chapter|
      primary_contact = chapter.primary_contact

      chapter.update(
        city: primary_contact.city,
        state_province: primary_contact.state_province,
        country: primary_contact.country
      )

      puts "Set location for \"#{chapter.organization_name}\" to \"#{primary_contact.location}\""
    end
  else
    puts "No chapters to update"
  end
end
