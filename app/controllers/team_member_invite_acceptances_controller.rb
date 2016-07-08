class TeamMemberInviteAcceptancesController < ApplicationController
  def show
    team_member_invite = TeamMemberInvite.find_with_token(params.fetch(:id))
    AcceptTeamMemberInvite.(team_member_invite, self)
  end
end
