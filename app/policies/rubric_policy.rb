class RubricPolicy < ApplicationPolicy
  attr_reader :user, :rubric

  def initialize(user, rubric)
    @user = user
    @rubric = rubric
  end

  def new?
    user.can_judge? and Setting.anyJudgingRoundActive?
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

  # private
  # def member?
  #   team.members.include? user
  # end


  # def can_see_rubric?
  #   ## todo: depends whether this is a quaterfinal, semifinal, or final rubric
  #   ## get the rubric type
  #   ## see if the judging for that type has closed
  # end

end
