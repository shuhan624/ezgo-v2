# frozen_string_literal: true

class ContactPolicy < ApplicationPolicy
  def permitted_attributes
    [:status, :admin_note]
  end

  def index?
    user.can?(:index, :contact) || chief?
  end

  def show?
    user.can?(:show, :contact) || chief?
  end

  def update?
    user.can?(:update, :contact) || chief?
  end

  def edit?
    user.can?(:edit, :contact) || chief?
  end
end
