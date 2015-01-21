class TeamPolicy < ApplicationPolicy
  attr_reader :user, :team

  def initialize(user, team)
    @user = user
    @team = team
  end

  def index?
    true
  end

  def show?
    true
  end

  def create?
    !user.student? or !user.has_team_for_season?
  end

  def edit?
    member?
  end

  def update?
    member?
  end

  def join?
    !user.team_requests.exists?(team: team)
  end

  def leave?
    member?
  end

  def destroy?
    false
  end

  private
  def member?
    team.members.include? user
  end

end
