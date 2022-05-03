module Admin
  class ParticipantSessionsController < AdminController
    def show
      participant = Account.find(params[:id])
      participant.regenerate_session_token
      set_cookie(CookieNames::SESSION_TOKEN, participant.session_token)

      if JudgeDashboardRedirector.new(account: participant).enabled?
        redirect_to judge_dashboard_path
      else
        redirect_to send(
          "#{participant.scope_name}_dashboard_path"
        )
      end
    end

    def destroy
      participant = Account.find(params[:id])
      participant.regenerate_session_token
      remove_cookie(CookieNames::SESSION_TOKEN)
      redirect_to admin_participant_path(participant)
    end
  end
end
