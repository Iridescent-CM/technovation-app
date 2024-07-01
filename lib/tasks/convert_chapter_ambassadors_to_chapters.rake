desc "Convert chapter ambassadors to chapters"
task convert_chapter_ambassadors_to_chapters: :environment do |_, args|
  args.extras.each do |arg|
    account_id = arg.split(";").first
    organization_name = arg.split(";").last
    chapter_ambassador = Account.find(account_id).chapter_ambassador_profile

    if chapter_ambassador.blank?
      puts "Skipping account #{account_id}, this isn't a chapter ambassador account"
    elsif chapter_ambassador.chapter_id.present?
      puts "Could not create chapter for #{chapter_ambassador.full_name}, they are already associated to #{chapter_ambassador.chapter.organization_name}"
    else
      chapter = Chapter.create(
        organization_name: organization_name,
        name: chapter_ambassador.program_name,
        summary: chapter_ambassador.intro_summary,
        city: chapter_ambassador.account.city,
        state_province: chapter_ambassador.account.state_province,
        country: chapter_ambassador.account.country
      )
      puts "Created new chapter #{chapter.organization_name}"

      chapter_ambassador.update_columns(chapter_id: chapter.id)
      puts "Associated #{chapter_ambassador.full_name} to #{chapter.organization_name}"
    end
  end
end
