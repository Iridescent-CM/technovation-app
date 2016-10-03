class MigrateBackgroundChecks < ActiveRecord::Migration
  def up
    profiles = MentorProfile.where("background_check_report_id IS NOT NULL") +
                 RegionalAmbassadorProfile.where("background_check_report_id IS NOT NULL")

    profiles.each do |profile|
      puts ""

      report_id = profile.background_check_report_id
      report = BackgroundCheck::Report.retrieve(report_id)

      if report.status == "Not submitted"
        puts "Report NOT FOUND for #{profile.account.email}"
      else
        profile.account.create_background_check!({
          candidate_id: profile.background_check_candidate_id,
          report_id: report_id,
          status: BackgroundCheck.statuses[report.status],
        })
        puts "Migrated #{report.status} background check for #{profile.account.email}"
        puts "#{profile.account.email} is #{profile.account.background_check.status.upcase}!"
      end

      puts "--------------------------------------------------------------------------------"
    end
  end

  def down
    BackgroundCheck.find_each do |b|
      next if b.account.type_name == "judge"
      puts ""

      b.account.send("#{b.account.type_name}_profile").update_columns({
        background_check_candidate_id: b.candidate_id,
        background_check_report_id: b.report_id,
        background_check_completed_at: (Time.current if b.clear?),
      })

      report = BackgroundCheck::Report.retrieve(b.report_id)
      puts "Migrated legcy background check for #{b.account.email}"
      puts "#{b.account.email} is #{report.status.upcase}!"
      puts "--------------------------------------------------------------------------------"
    end
  end
end
