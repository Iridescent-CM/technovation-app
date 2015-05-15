class UserPolicy < ApplicationPolicy
  attr_reader :current_user, :model
  def initialize(current_user, model)
    @current_user = current_user
    @user = model
  end

  def index?
    true
  end

  def get_certificate?
    current_user == user
  end

  def show?  # only allow viewing of students on same team for privacy
    (user == current_user) or
    (user.consented? and
      (!user.student? or
      (!current_user.nil? and !(current_user.teams & user.teams).empty?)))
  end

  def edit?
    current_user == user
  end

  def update?
    current_user == user
  end

  def mentor_coach?
    current_user == user
  end

  def invite?
    current_user.student? and
    not current_user.current_team.nil? and
    TeamRequest.find_by(team: current_user.current_team, user: user).nil?
  end

  class Scope < Scope
    def resolve
      scope.where.not(:consent_signed_at => nil).where("bg_check_submitted IS NOT NULL OR role != ? ", User.roles[:mentor])
    end
  end
end
