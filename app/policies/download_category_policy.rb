# frozen_string_literal: true

class DownloadCategoryPolicy < ApplicationPolicy
  def index?
    user.can?(:index, :download_category) || chief?
  end

  def show?
    user.can?(:show, :download_category) || chief?
  end

  def create?
    user.can?(:create, :download_category) || chief?
  end

  def new?
    user.can?(:new, :download_category) || chief?
  end

  def update?
    user.can?(:update, :download_category) || chief?
  end

  def edit?
    user.can?(:edit, :download_category) || chief?
  end

  def destroy?
    user.can?(:destroy, :download_category) || chief?
  end

  def sort?
    user.can?(:sort, :download_category) || chief?
  end
end
