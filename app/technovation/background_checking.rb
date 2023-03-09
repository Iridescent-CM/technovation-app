class BackgroundChecking
  def initialize(bg_check, options={})
    @bg_check = bg_check
    @report = options.fetch(:report) {
      BackgroundCheck::Report.retrieve(bg_check.report_id)
    }
    @logger = options.fetch(:logger) { Logger.new('/dev/null') }
  end

  def execute
    if @report.present?
      report_result = @report.adjudication == "engaged" ? "clear" : @report.result

      if report_result != @bg_check.status
        case report_result
        when "clear"
          @bg_check.clear!
          do_clear

          @logger.info("Report UPDATED TO CLEAR for #{@bg_check.account.email}")
        when "consider"
          @bg_check.consider!

          @logger.info("Report UPDATED TO CONSIDER for #{@bg_check.account.email}")
        else
          if @report.status != @bg_check.status
            if @bg_check.respond_to?("#{@report.status}!")
              @bg_check.send("#{@report.status}!")
              @logger.info(
                "Report UPDATED TO #{@bg_check.status.upcase} for #{@bg_check.account.email}"
              )
            else
              @logger.info(
                "Could not call ##{@report.status}! for #{@bg_check.account.email}"
              )
            end
            if respond_to?("do_#{@report.status}", :include_private)
              send("do_#{@report.status}")
            end
          else
            @logger.info(
              "Report STILL #{@bg_check.status} for #{@bg_check.account.email}"
            )
          end
        end
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
      account.mentor_profile.enable_searchability_with_save
    end
  end
end
