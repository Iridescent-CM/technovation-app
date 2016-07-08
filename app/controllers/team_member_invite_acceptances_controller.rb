class TeamMemberInviteAcceptancesController < ApplicationController
  def show
    @team_member_invite = TeamMemberInvite.find_with_token(params.fetch(:id))
    @team_member_invite.accept!
    team = @team_member_invite.team

    if student = StudentAccount.find_by(email: @team_member_invite.invitee_email)
      team.members << student
      team.save
      SignIn.(student, self, redirect_to: student_team_path(team))
    elsif mentor = MentorAccount.find_by(email: @team_member_invite.invitee_email)
      team.members << mentor
      team.save
      SignIn.(mentor, self, redirect_to: mentor_team_path(team))
    else
      redirect_to student_signup_path(email: @team_member_invite.invitee_email)
    end
  end
end
