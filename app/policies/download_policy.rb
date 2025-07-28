# frozen_string_literal: true

class DownloadPolicy < ApplicationPolicy
  def index?
    user.can?(:index, :download) || chief?
  end

  def show?
    user.can?(:show, :download) || chief?
  end

  def create?
    user.can?(:create, :download) || chief?
  end

  def new?
    user.can?(:new, :download) || chief?
  end

  def update?
    user.can?(:update, :download) || chief?
  end

  def edit?
    user.can?(:edit, :download) || chief?
  end

  def destroy?
    user.can?(:destroy, :download) || chief?
  end

  def sort?
    user.can?(:sort, :download) || chief?
  end
end
