# frozen_string_literal: true

class AdminPolicy < ApplicationPolicy
  # include Permission
  class Scope < Scope
    def resolve
      if user.cw_chief?
        scope.all
      else
        scope.where(cw_chief: false)
      end
    end
  end

  def permitted_attributes
    [:tw, :en, :email, :name, :cw_chief, :role_id, :account_active, :password, :password_confirmation]
  end

  def index?
    user.can?(:index, :admin) || chief?
  end

  def show?
    user.can?(:show, :admin) || chief?
  end

  def create?
    user.can?(:create, :admin) || chief?
  end

  def new?
    user.can?(:new, :admin) || chief?
  end

  def update?
    user.can?(:update, :admin) || chief?
  end

  def edit?
    user.can?(:edit, :admin) || chief?
  end

  def destroy?
    user.can?(:destroy, :admin) || chief?
  end

  def audit?
    user.can?(:audit, :admin) || chief?
  end
end
