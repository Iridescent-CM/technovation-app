desc "Deactivate admin accounts inactive for 90+ days"
task deactivate_inactive_admins: :environment do
  count = Admin::DeactivateInactiveAccounts.call
  puts "Deactivated #{count} inactive admin account(s)"
end
