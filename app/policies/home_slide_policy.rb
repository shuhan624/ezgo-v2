# frozen_string_literal: true

class HomeSlidePolicy < ApplicationPolicy
  def permitted_attributes
    [:status, :en_status, :slide_type, :title, :title_en, :desc_zh_tw, :desc_en, :link_zh_tw, :link_en, :alt_zh_tw, :alt_en, :banner, :banner_en, :banner_m, :banner_m_en, :published_at, :expired_at, :published_at_en, :expired_at_en]
  end

  def index?
    user.can?(:index, :home_slide) || chief?
  end

  def show?
    user.can?(:show, :home_slide) || chief?
  end

  def create?
    user.can?(:create, :home_slide) || chief?
  end

  def new?
    user.can?(:new, :home_slide) || chief?
  end

  def update?
    user.can?(:update, :home_slide) || chief?
  end

  def edit?
    user.can?(:edit, :home_slide) || chief?
  end

  def destroy?
    user.can?(:destroy, :home_slide) || chief?
  end

  def sort?
    user.can?(:sort, :home_slide) || chief?
  end
end
