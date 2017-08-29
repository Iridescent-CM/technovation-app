module SweepBackgroundChecks
  def self.call(status)
    BackgroundCheck.send(status).each do |bg_check|
      old_status = bg_check.status
      BackgroundChecking.new(bg_check).execute()

      puts ""

      if old_status != bg_check.status
        puts "Report UPDATED TO #{bg_check.status.upcase} for #{bg_check.account.email}"
      else
        puts "Report STILL #{old_status} for #{bg_check.account.email}"
      end

      puts "--------------------------------------------------------------------"
    end
  end
end
