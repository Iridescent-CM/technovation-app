desc "Bulk delete accounts by id"
task bulk_delete_accounts_by_id: :environment do |task, args|
  accounts = Account.where(id: [args.extras])

  MentorProfileMentorType.skip_callback(:commit, :after, :update_mentor_info_in_crm)
  accounts.each do |account|
    account.really_destroy!
  end
  MentorProfileMentorType.set_callback(:commit, :after, :update_mentor_info_in_crm)
  puts "Deleted #{accounts.size} accounts"
end
