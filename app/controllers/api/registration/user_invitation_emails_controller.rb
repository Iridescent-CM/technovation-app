module Api::Registration
  class UserInvitationEmailsController < ActionController::API
    def show
      invite = UserInvitation.find_by(admin_permission_token: params[:invite_code])

      render json: {
        email: invite.email
      }
    end
  end
end
