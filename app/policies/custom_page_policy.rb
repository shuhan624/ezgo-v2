# frozen_string_literal: true

class CustomPagePolicy < ApplicationPolicy
  def permitted_attributes
    [:title, :title_en, :slug, :status, :en_status, :menu_zh_tw, :menu_en, :content, :content_en, :desc_zh_tw, :desc_en, seo_attributes: [:id, :meta_title_zh_tw, :meta_title_en, :meta_keywords_zh_tw, :meta_keywords_en, :meta_desc_zh_tw, :meta_desc_en, :og_title_zh_tw, :og_title_en, :og_desc_zh_tw, :og_desc_en, :og_image, :og_image_en, :canonical]]
  end

  def index?
    user.can?(:index, :custom_page) || chief?
  end

  def show?
    user.can?(:show, :custom_page) || chief?
  end

  def create?
    user.can?(:create, :custom_page) || chief?
  end

  def new?
    user.can?(:new, :custom_page) || chief?
  end

  def update?
    user.can?(:update, :custom_page) || chief?
  end

  def edit?
    user.can?(:edit, :custom_page) || chief?
  end

  def destroy?
    user.can?(:destroy, :custom_page) || chief?
  end
end
