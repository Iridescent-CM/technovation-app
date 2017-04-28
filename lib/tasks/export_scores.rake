desc "Export team scores csv"
task export_scores: :environment do
  admin_email = ENV.fetch("ADMIN_EMAIL") { abort("Set ADMIN_EMAIL key to proceed") }
  email = ENV.fetch("EMAIL") { abort("Set EMAIL key to proceed") }
  account = Account.where("lower(email) = ?", admin_email.downcase).first
  if account.admin_profile.present?
    ExportScoresJob.perform_now(account.admin_profile, email)
    puts "CSV emailed to #{email}"
  else
    abort("No admin profile associated with ADMIN_EMAIL=#{admin_email}")
  end
end
