# frozen_string_literal: true

class DocumentPolicy < ApplicationPolicy
  def permitted_attributes
    [:title, :slug, :file_type, :language, :link, :file]
  end

  def index?
    user.can?(:index, :document) || chief?
  end

  def show?
    user.can?(:show, :document) || chief?
  end

  def create?
    user.can?(:create, :document) || chief?
  end

  def new?
    user.can?(:new, :document) || chief?
  end

  def update?
    user.can?(:update, :document) || chief?
  end

  def edit?
    user.can?(:edit, :document) || chief?
  end

  def destroy?
    user.can?(:destroy, :document) || chief?
  end
end
