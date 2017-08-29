class BackgroundChecking
  def initialize(bg_check, report=nil)
    @bg_check = bg_check
    @report = report || BackgroundCheck::Report.retrieve(bg_check.report_id)
  end

  def execute()
    if @report.present?
      new_status = "engaged" == @report.adjudication ? "clear" : @report.status

      if new_status != @bg_check.status
        if @bg_check.respond_to?("#{new_status}!")
          @bg_check.send("#{new_status}!")
        end
        if respond_to?("do_#{new_status}", :include_private)
          send("do_#{new_status}")
        end
      end
    end
  end

  private

  def do_clear()
    account = @bg_check.account
    AccountMailer.background_check_clear(account).deliver_later

    if account.mentor_profile.present?
      account.mentor_profile.enable_searchability
    end
  end
end
