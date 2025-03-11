desc "Bulk delete accounts by id"
task bulk_delete_accounts_by_id: :environment do |task, args|
  accounts = Account.where(id: [args.extras])

  accounts.each do |account|
    account.really_destroy!
  end

  puts "Deleted #{accounts.size} accounts"
end
