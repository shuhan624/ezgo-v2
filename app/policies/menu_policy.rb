# frozen_string_literal: true

class MenuPolicy < ApplicationPolicy
  def permitted_attributes
    [:parent_id, :position, :title, :title_en, :link, :link_en, :target, :status, :en_status]
  end

  def index?
    user.can?(:index, :menu) || chief?
  end

  def show?
    user.can?(:show, :menu) || chief?
  end

  def create?
    user.can?(:create, :menu) || chief?
  end

  def new?
    user.can?(:new, :menu) || chief?
  end

  def update?
    record.parent_id.present? && (user.can?(:update, :menu) || chief?)
  end

  def edit?
    record.parent_id.present? && (user.can?(:edit, :menu) || chief?)
  end

  def destroy?
    record.parent_id.present? && (user.can?(:destroy, :menu) || chief?)
  end

  def sort?
    record.parent_id.present? && (user.can?(:sort, :menu) || chief?)
  end
end
