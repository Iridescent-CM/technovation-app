module Mentor
  class MentorInvitesController < ApplicationController
    def show
      @invite = MentorInvite.find_by(invite_token: params.fetch(:id))
    end

    def update
      invite = MentorInvite.accept!(params.fetch(:id))
      SignIn.(invite.invitee, self,
              message: t("controllers.team_member_invite_acceptances.show.success"),
              redirect_to: mentor_team_path(invite.team))
    end
  end
end
