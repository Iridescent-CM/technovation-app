module Mentor
  class InviteAcceptancesController < ApplicationController
    def show
      invite = TeamMemberInvite.find_with_token(params.fetch(:id))
      invite.accept!
      SignIn.(invite.invitee, self,
              message: t("controllers.team_member_invite_acceptances.show.success"),
              redirect_to: mentor_team_path(invite.team))
    end
  end
end
