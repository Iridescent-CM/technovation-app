desc "Assign students to chapters"
task assign_students_to_chapters: :environment do |task, args|
  chapter = Chapter.find(args.extras.last)

  puts "Assigning accounts to chapter #{chapter.name} (Chapter ID #{chapter.id})"
  args.extras[0..-2].each do |email_address|
    account = Account.find_by(email: email_address)

    if account.blank?
      puts "#{email_address} could not be found"
    elsif account.student_profile.blank?
      puts "#{email_address} is not a student"
    elsif !account.current_season?
      puts "#{email_address} is not registered to the current season"
    elsif account.chapterable_assignments.present?
      puts "#{email_address} is already assigned to a chapter"
    else
      account.student_profile.chapterable_assignments.create(
        account: account,
        chapterable: chapter,
        season: Season.current.year,
        primary: true
      )

      puts "Assigned #{email_address} to #{chapter.name}"
    end
  end
end
