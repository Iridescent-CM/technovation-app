class BackgroundChecking
  def initialize(bg_check, report: nil, logger: nil)
    @bg_check = bg_check
    @report = report || BackgroundCheck::Report.retrieve(bg_check.report_id)
    @logger = logger || Logger.new('/dev/null')
  end

  def execute
    if @report.present?
      new_status = "engaged" == @report.adjudication ? "clear" : @report.status

      if new_status != @bg_check.status
        if @bg_check.respond_to?("#{new_status}!")
          @bg_check.send("#{new_status}!")
          @logger.info("Report UPDATED TO #{@bg_check.status.upcase} for #{@bg_check.account.email}")
        else
          @logger.info("Could not call ##{new_status}! for #{@bg_check.account.email}")
        end
        if respond_to?("do_#{new_status}", :include_private)
          send("do_#{new_status}")
        end
      else
        @logger.info("Report STILL #{@bg_check.status} for #{@bg_check.account.email}")
      end
    else
      @logger.info("Report NOT FOUND for #{@bg_check.account.email}")
    end
  end

  private

  def do_clear
    account = @bg_check.account
    AccountMailer.background_check_clear(account).deliver_later

    if account.mentor_profile.present?
      account.mentor_profile.enable_searchability
    end
  end
end
