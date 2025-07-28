# frozen_string_literal: true

class PartnerPolicy < ApplicationPolicy
  def permitted_attributes
    [:name, :name_en, :status, :en_status, :link_zh_tw, :link_en, :image, :image_en]
  end

  def index?
    user.can?(:index, :partner) || chief?
  end

  def show?
    user.can?(:show, :partner) || chief?
  end

  def create?
    user.can?(:create, :partner) || chief?
  end

  def new?
    user.can?(:new, :partner) || chief?
  end

  def update?
    user.can?(:update, :partner) || chief?
  end

  def edit?
    user.can?(:edit, :partner) || chief?
  end

  def destroy?
    user.can?(:destroy, :partner) || chief?
  end

  def sort?
    user.can?(:sort, :partner) || chief?
  end
end
