class MentorsController < ApplicationController
  def show
    @mentor = MentorAccount.find(params.fetch(:id))
    @team_member_invite = TeamMemberInvite.new
  end
end
