module Api::Registration
  class InvitesController < ActionController::API
    def show
      invite = RegistrationInviteCodeValidator.new(invite_code: params[:id]).call

      render json: {
        isValid: invite.valid?,
        canRegisterAtAnyTime: invite.register_at_any_time?,
        profileType: invite.registration_profile_type
      }
    end
  end
end
