module ChapterAmbassador
  class EventJudgeInvitationsController < ChapterAmbassadorController
    def new
      @event = RegionalPitchEvent.in_region(current_ambassador).find(params[:event_id])
      @invitation = UserInvitation.new
    end

    def create
      @event = RegionalPitchEvent.in_region(current_ambassador).find(params[:event_id])

      CreateEventAssignment.call(@event, {
        invited_by_id: current_ambassador.account.id,
        invites: {
          "0" => [
            {
              scope: "UserInvitation",
              email: invitation_params[:email],
              name: invitation_params[:name]
            }
          ]
        }
      })

      flash.now[:success] = "Invitation sent to #{invitation_params[:email]}"
      @invitation = UserInvitation.new

      respond_to do |format|
        format.turbo_stream
      end
    rescue ActiveRecord::RecordInvalid => e
      @invitation = e.record

      respond_to do |format|
        format.turbo_stream
      end
    end

    private

    def invitation_params
      params.require(:user_invitation).permit(:email, :name)
    end
  end
end
