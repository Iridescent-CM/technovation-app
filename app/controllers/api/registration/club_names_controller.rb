module Api::Registration
  class ClubNamesController < ActionController::API
    def show
      invite = UserInvitation.find_by(admin_permission_token: params[:invite_code])

      render json: {
        clubName: invite.club.name
      }
    end
  end
end
