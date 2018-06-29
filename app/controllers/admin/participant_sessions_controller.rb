module Admin
  class ParticipantSessionsController < AdminController
    def show
      participant = Account.find(params[:id])
      participant.regenerate_session_token
      set_cookie(CookieNames::SESSION_TOKEN, participant.session_token)

      redirect_to send(
        "#{participant.scope_name.sub(/^\w+_r/, "r")}_dashboard_path"
      )
    end

    def destroy
      participant = Account.find(params[:id])
      participant.regenerate_session_token
      remove_cookie(CookieNames::SESSION_TOKEN)
      redirect_to admin_participant_path(participant)
    end
  end
end
