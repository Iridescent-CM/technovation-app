desc "Update ALL Salesforce contacts"
task update_all_salesforce_contacts: :environment do
  Account.not_admin.current.find_in_batches(batch_size: 500) do |accounts|
    account_ids = accounts.pluck(:id).join(",")

    system("bundle exec rake update_salesforce_contacts[#{account_ids}]")

    sleep 15.minutes
  end
end
