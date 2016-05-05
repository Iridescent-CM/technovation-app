require "./app/policies/application_policy"
require "./app/models/submissions"

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
    (!user.student? || !user.has_team_for_season?) && Submissions.open?
  end

  def edit?
    member? && Submissions.open?
  end
  alias_method :edit_submission?, :edit?

  def update?
    member?
  end

  def event_signup?
    member?
  end

  def join?
    !user.team_requests.exists?(team: team)
  end

  def submit?
    member?
  end

  def leave?
    member?
  end

  def destroy?
    false
  end

  # def update_submissions?
  #   member?
  # end

  private
  def member?
    team.members.include? user
  end

end
