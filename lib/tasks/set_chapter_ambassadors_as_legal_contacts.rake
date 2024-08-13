desc "Set chapter ambassadors as legal contacts"
task set_chapter_ambassadors_as_legal_contacts: :environment do |_, args|
  args.extras.each do |arg|
    arg.split(",").each do |account_id|
      account = Account.find(account_id)
      chapter_ambassador = account&.chapter_ambassador_profile
      chapter = chapter_ambassador&.chapter

      if chapter_ambassador.blank?
        puts "Skipping account #{account_id}, this isn't a chapter ambassador account"
      elsif chapter.blank?
        puts "Skipping account #{account_id}, this chapter ambassador doesn't belong to a chapter"
      elsif chapter.legal_contact.present?
        puts "Skipping account #{account_id}, a legal contact is already setup for this chapter"
      else
        chapter.create_legal_contact(
          full_name: account.full_name,
          email_address: account.email
        )

        puts "Made #{account.full_name} the legal contact for #{chapter.organization_name}"
      end
    end
  end
end
