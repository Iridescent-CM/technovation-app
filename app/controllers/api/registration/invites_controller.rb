module Api::Registration
  class InvitesController < ActionController::API
    def show
      invite = RegistrationInviteValidator.new(invite_code: params[:id]).call

      render json: {
        isValid: invite.valid?,
        canRegisterAtAnyTime: invite.register_at_any_time?,
        profileType: invite.profile_type,
        friendlyProfileType: invite.friendly_profile_type
      }
    end
  end
end
