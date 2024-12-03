desc "Assign students to chapters"
task assign_students_to_chapters: :environment do |task, args|
  chapter = Chapter.find(args.extras.last)

  puts "Assigning accounts to chapter #{chapter.name} (Chapter ID #{chapter.id})"
  args.extras[0..-2].each do |email_address|
    account = Account.find_by(email: email_address)

    if account.present? && account.student_profile.present?
      if account.chapter_assignments.empty?
        account.student_profile.chapter_assignments.create(
          account: account,
          chapter: chapter,
          season: Season.current.year,
          primary: true
        )

        puts "Assigned #{email_address} to #{chapter.name}"
      else
        puts "#{email_address} is already assigned to a chapter"
      end
    else
      puts "#{email_address} could not be found or is not a student"
    end
  end
end
