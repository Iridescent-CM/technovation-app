class AcceptTeamMemberInvitesController < ApplicationController
  def show
    @team_member_invite = TeamMemberInvite.find_with_token(params.fetch(:id))
    @team_member_invite.accept!
    redirect_to student_signup_path(email: @team_member_invite.invitee_email)
  end
end
