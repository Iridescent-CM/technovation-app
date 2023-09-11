module Api
  class RegistrationInvitesController < ApplicationController
    def show
      invite = RegistrationInviteValidator.new(invite_code: params[:id]).call

      render json: {
        isValid: invite.valid?,
        profileType: invite.profile_type,
        friendlyProfileType: invite.friendly_profile_type
      }
    end
  end
end
