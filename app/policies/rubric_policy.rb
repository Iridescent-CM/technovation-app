require "./app/policies/application_policy"

class RubricPolicy < ApplicationPolicy
  attr_reader :user, :rubric, :setting

  def initialize(user, rubric, setting = Setting)
    @user = user
    @rubric = rubric
    @setting = setting
  end

  def new?
    user.can_judge?(rubric.team) && setting.anyJudgingRoundActive?
  end

  def index?
    user.can_judge?
  end

  def show?
    user.can_judge? or (@rubric.team.members.include? @user)
  end

  def create?
    user.can_judge? and Setting.anyJudgingRoundActive?
  end

  def edit?
    user.can_judge? and Setting.anyJudgingRoundActive?
  end

  def update?
    user.can_judge? and Setting.anyJudgingRoundActive?
  end
end
