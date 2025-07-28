# frozen_string_literal: true

class UserPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def permitted_attributes
    [:email, :name, :phone, :password, :password_confirmation, :role, :account_active, :note, :country, :zip_code, :city, :dist, :address]
  end

  def index?
    user.can?(:index, :user) || chief?
  end

  def show?
    user.can?(:show, :user) || chief?
  end

  def create?
    user.can?(:create, :user) || chief?
  end

  def new?
    user.can?(:new, :user) || chief?
  end

  def update?
    user.can?(:update, :user) || chief?
  end

  def edit?
    user.can?(:edit, :user) || chief?
  end

  def destroy?
    user.can?(:destroy, :user) || chief?
  end

  def message?
    user.can?(:message, :user) || chief?
  end

  def push_message?
    user.can?(:push_message, :user) || chief?
  end
end
