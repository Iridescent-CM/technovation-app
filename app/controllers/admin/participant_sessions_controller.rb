module Admin
  class ParticipantSessionsController < AdminController
    skip_before_action :require_current_admin, only: :destroy

    before_action :set_admin_id_performing_impersonation, only: :show

    def show
      participant = Account.find(params[:id])
      admin = current_account

      participant.regenerate_session_token
      set_cookie(CookieNames::SESSION_TOKEN, participant.session_token)

      SecurityEventLogger.log(
        event_type: "admin.impersonation.start",
        account: participant,
        actor: admin,
        request: request
      )

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
      actor = Account.find_by(id: session[:admin_account_id_performing_impersonation])

      SecurityEventLogger.log(
        event_type: "admin.impersonation.stop",
        account: participant,
        actor: actor,
        request: request
      )

      participant.regenerate_session_token
      remove_cookie(CookieNames::SESSION_TOKEN)
      session.delete(:admin_account_id_performing_impersonation)
      redirect_to admin_participant_path(participant)
    end

    private

    def set_admin_id_performing_impersonation
      if current_account.admin?
        session[:admin_account_id_performing_impersonation] = current_account.id
      end
    end
  end
end
