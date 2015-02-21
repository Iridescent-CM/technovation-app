class RubricPolicy < ApplicationPolicy
  attr_reader :team, :judge

  def initialize(team, judge)
    @judge = judge
    @team = team
  end

  def new?
    true
  end

  def index?
    true
  end

  def show?
    true
  end

  def create?
    true
  end

  def edit?
    true
  end

  def update?
    true
  end

  # private
  # def member?
  #   team.members.include? user
  # end

end
