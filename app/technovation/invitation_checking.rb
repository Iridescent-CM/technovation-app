class InvitationChecking
  def initialize(bg_check, options = {})
    @bg_check = bg_check
    @invitation = CustomCheckr::ApiClient.new.retrieve_invitation(@bg_check.invitation_id)
    @logger = options.fetch(:logger) { Logger.new("/dev/null") }
  end

  def execute
    if @invitation.success?
      if @invitation[:payload][:status] != @bg_check.invitation_status
        @bg_check.update(
          invitation_status: @invitation[:payload][:status]
        )
        @logger.info("Invitation Status UPDATED TO #{@invitation[:payload][:status]} for #{@bg_check.account.id}")
      end

      if @bg_check.report_id.blank? && @invitation[:payload][:report_id].present?
        @bg_check.update(
          report_id: @invitation[:payload][:report_id]
        )
        @logger.info("Report ID UPDATED TO #{@invitation[:payload][:report_id]} for #{@bg_check.account.id}")
      end

    else
      @logger.info("Issue getting invitation from checkr for #{@bg_check.account.id}")
    end
  end
end
