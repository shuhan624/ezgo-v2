# frozen_string_literal: true

class SettingPolicy < ApplicationPolicy
  def index?
    user.can?(:index, :setting) || chief?
  end

  def show?
    user.can?(:show, :setting) || chief?
  end

  def update?
    user.can?(:update, :setting) || chief?
  end

  def edit?
    user.can?(:edit, :setting) || chief?
  end

  def sort?
    user.can?(:sort, :setting) || chief?
  end
end
