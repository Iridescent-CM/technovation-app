class TeamRequestPolicy < ApplicationPolicy
  attr_reader :user, :team_request

  def initialize(user, team_request)
    @user = user
    @team_request = team_request
  end

  # the initiator OR recipient can destroy the request
  def destroy?
    team_request.user == user or user.teams.include? team_request.team
  end

  # the non-initiator must approve
  def approve?
    (team_request.user_request and user.teams.include? team_request.team) or #sent by user, approved by team
    (!team_request.user_request and team_request.user == user) #sent by team, approved by user
  end

end
