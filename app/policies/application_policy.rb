# frozen_string_literal: true

class ApplicationPolicy
  def initialize(current_account, record)
    @current_account = current_account
    @record = record
  end

  def index?
    false
  end

  def show?
    false
  end

  def create?
    false
  end

  def new?
    create?
  end

  def update?
    false
  end

  def edit?
    update?
  end

  def destroy?
    false
  end

  private

  attr_reader :current_account, :record

  class Scope
    def initialize(current_account, scope)
      @current_account = current_account
      @scope = scope
    end

    def resolve
      raise NotImplementedError, "You must define #resolve in #{self.class}"
    end

    private

    attr_reader :current_account, :scope
  end
end
