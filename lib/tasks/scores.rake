namespace :scores do
  desc "Set all nil to 0"
  task default_nil_to_zero: :environment do
    SubmissionScore.find_each do |score|
      score.attributes.each do |k, v|
        next if k.match(/comment/)
        next if k == "id"
        next if k.match(/_at$/)
        next if k.match(/_id$/)
        score[k] = 0 if v.nil?
      end

      score.save!
    end

    SubmissionScore.find_each do |score|
      score.attributes.each do |k, v|
        score[k] = nil if k.match(/comment/) && v == "0"
      end

      score.save!
    end
  end

  desc "Update all averages for completed scores"
  task set_average_of_completed: :environment do
    TeamSubmission.find_each do |ts|
      ts.update_average_score
      puts "Updated #{ts.app_name} avg to #{ts.reload.average_score}"
    end
  end

  desc "Export score summary csv"
  task export_summary: :environment do
    admin_email = ENV.fetch("ADMIN_EMAIL") { abort("Set ADMIN_EMAIL key to proceed") }
    email = ENV.fetch("EMAIL") { abort("Set EMAIL key to proceed") }
    account = Account.where("lower(email) = ?", admin_email.downcase).first
    if account.admin_profile.present?
      ExportScoresJob.perform_now(account.admin_profile, email, type="summary")
      puts "CSV emailed to #{email}"
    else
      abort("No admin profile associated with ADMIN_EMAIL=#{admin_email}")
    end
  end

  desc "Export score detail csv"
  task export_detail: :environment do
    admin_email = ENV.fetch("ADMIN_EMAIL") { abort("Set ADMIN_EMAIL key to proceed") }
    email = ENV.fetch("EMAIL") { abort("Set EMAIL key to proceed") }
    account = Account.where("lower(email) = ?", admin_email.downcase).first
    if account.admin_profile.present?
      ExportScoresJob.perform_now(account.admin_profile, email, type="detail")
      puts "CSV emailed to #{email}"
    else
      abort("No admin profile associated with ADMIN_EMAIL=#{admin_email}")
    end
  end
end
