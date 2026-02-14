desc "Remove accounts from unaffilated list"
task remove_accounts_from_unaffilated_list: :environment do |task, args|
  puts "Removing accounts from the unaffilated list"

  args.extras.each do |email_address|
    account = Account.find_by(email: email_address)

    if account.blank?
      puts "#{email_address} could not be found"
    elsif account.no_chapterable_selected?
      account.update_column(:no_chapterable_selected, nil)

      puts "Removed #{email_address} from the unaffilated list"
    else
      puts "#{email_address} is not on the unaffilated list"
    end
  end
end
