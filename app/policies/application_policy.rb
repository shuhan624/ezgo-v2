# frozen_string_literal: true

class ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end

  def index?
    chief?
  end

  def show?
    chief?
  end

  def create?
    chief?
  end

  def new?
    chief?
  end

  def update?
    chief?
  end

  def edit?
    chief?
  end

  def destroy?
    chief?
  end

  class Scope
    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      raise NotImplementedError, "You must define #resolve in #{self.class}"
    end

    private

    attr_reader :user, :scope
  end

  private

  def chief?
    user.cw_chief?
  end
end
