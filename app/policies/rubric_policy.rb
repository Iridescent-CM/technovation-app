require "./app/policies/application_policy"

class RubricPolicy < ApplicationPolicy
  attr_reader :user, :rubric, :referer, :setting

  def initialize(user, rubric, setting = Setting)
    @user = user.user
    @rubric = rubric
    @referer = user.referer
    @setting = setting
  end

  def new?
    !!referer &&
      !!referer.match(/\/rubrics\z/) &&
        user.can_judge? &&
          setting.anyJudgingRoundActive?
  end

  def index?
    user.can_judge?
  end

  def show?
    rubric.user == user && (user.can_judge? or rubric.team.members.include?(user))
  end

  def create?
    user.can_judge? and Setting.anyJudgingRoundActive?
  end

  def edit?
    user.can_judge? and !Semifinal.after_close? and rubric.user == user
  end

  def update?
    edit?
  end
end
