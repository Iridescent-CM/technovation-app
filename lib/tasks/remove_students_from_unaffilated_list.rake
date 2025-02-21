desc "Remove students from unaffiliated list"
task remove_students_from_unaffiliated_list: :environment do |task, args|
  puts "Removing students from unaffiliated list"
  args.extras.each do |email_address|
    account = Account.find_by(email: email_address)

    if account.blank?
      puts "#{email_address} could not be found"
    elsif account.student_profile.blank?
      puts "#{email_address} is not a student"
    else
      account.update_columns(
        no_chapterable_selected: nil,
        no_chapterables_available: nil
      )

      puts "Removed #{email_address} from the unaffiliated list"
    end
  end
end
