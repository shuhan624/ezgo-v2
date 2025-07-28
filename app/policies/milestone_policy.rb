# frozen_string_literal: true

class MilestonePolicy < ApplicationPolicy
  def permitted_attributes
    [:title, :title_en, :date, :status, :en_status, :content, :content_en, :image, :alt_zh_tw, :alt_en]
  end

  def index?
    user.can?(:index, :milestone) || chief?
  end

  def show?
    user.can?(:show, :milestone) || chief?
  end

  def create?
    user.can?(:create, :milestone) || chief?
  end

  def new?
    user.can?(:new, :milestone) || chief?
  end

  def update?
    user.can?(:update, :milestone) || chief?
  end

  def edit?
    user.can?(:edit, :milestone) || chief?
  end

  def destroy?
    user.can?(:destroy, :milestone) || chief?
  end
end
