class UserPolicy < ApplicationPolicy
  attr_reader :current_user, :model
  def initialize(current_user, model)
    @current_user = current_user
    @user = model
  end

  def show?
    @user.consented?
  end

  def edit?
    current_user == user
  end

  def invite?
    current_user.student? and
    not current_user.current_team.nil? and
    TeamRequest.find_by(team: current_user.current_team, user: @user).nil?
  end

  class Scope < Scope
    def resolve
      scope
    end
  end
end
