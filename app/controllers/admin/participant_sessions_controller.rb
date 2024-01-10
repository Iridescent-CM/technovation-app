module Admin
  class ParticipantSessionsController < AdminController
    before_action :set_admin_id_performing_impersonation, only: :show
    before_action :delete_admin_id_performing_impersonation, only: :destroy

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

    private

    def set_admin_id_performing_impersonation
      if current_account.admin?
        session[:admin_account_id_performing_impersonation] = current_account.id
      end
    end

    def delete_admin_id_performing_impersonation
      session.delete(:admin_account_id_performing_impersonation)
    end
  end
end
