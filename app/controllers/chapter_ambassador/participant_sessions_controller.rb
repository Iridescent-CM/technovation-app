module ChapterAmbassador
  class ParticipantSessionsController < ChapterAmbassadorController
    def show
      participant = Account.in_region(current_ambassador).find(params[:id])
      participant.regenerate_session_token
      set_cookie(CookieNames::SESSION_TOKEN, participant.session_token)
      redirect_to send("#{participant.scope_name}_dashboard_path")
    end

    def destroy
      participant = Account.in_region(current_ambassador).find(params[:id])
      participant.regenerate_session_token
      remove_cookie(CookieNames::SESSION_TOKEN)
      redirect_to chapter_ambassador_participant_path(participant)
    end
  end
end
