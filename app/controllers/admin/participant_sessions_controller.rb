module Admin
  class ParticipantSessionsController < AdminController
    def show
      participant = Account.find(params[:id])
      participant.regenerate_session_token
      set_cookie(:session_token, participant.session_token)
      redirect_to send("#{participant.scope_name}_dashboard_path")
    end

    def destroy
      participant = Account.find(params[:id])
      participant.regenerate_session_token
      remove_cookie(:session_token)
      redirect_to admin_participant_path(participant)
    end
  end
end
