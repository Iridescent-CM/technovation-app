module SweepBackgroundChecks
  def self.call(status)
    BackgroundCheck.send(status).each do |bg_check|
      report = BackgroundCheck::Report.retrieve(bg_check.report_id)

      puts ""

      if report.present? and report.status != bg_check.status
        bg_check.send("#{report.status}!")
        puts "Report UPDATED TO #{report.status.upcase} for #{bg_check.account.email}"
      elsif report.present?
        puts "Report STILL #{report.status.upcase} for #{bg_check.account.email}"
      else
        puts "Report NOT FOUND for #{bg_check.account.email}"
      end

      puts "--------------------------------------------------------------------"
    end
  end
end
