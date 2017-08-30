module SweepBackgroundChecks
  def self.call(status)
    BackgroundCheck.send(status).each do |bg_check|
      puts ""
      BackgroundChecking.new(bg_check, logger: Logger.new(STDOUT)).execute
      puts "--------------------------------------------------------------------"
    end
  end
end
