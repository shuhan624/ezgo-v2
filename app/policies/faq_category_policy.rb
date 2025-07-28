# frozen_string_literal: true

class FaqCategoryPolicy < ApplicationPolicy
  def permitted_attributes
    [:name, :name_en, :status, :en_status, :slug, seo_attributes: [:id, :meta_title_zh_tw, :meta_title_en, :meta_keywords_zh_tw, :meta_keywords_en, :meta_desc_zh_tw, :meta_desc_en, :og_title_zh_tw, :og_title_en, :og_desc_zh_tw, :og_desc_en, :og_image, :og_image_en, :canonical]]
  end

  def index?
    user.can?(:index, :faq_category) || chief?
  end

  def show?
    user.can?(:show, :faq_category) || chief?
  end

  def create?
    user.can?(:create, :faq_category) || chief?
  end

  def new?
    user.can?(:new, :faq_category) || chief?
  end

  def update?
    user.can?(:update, :faq_category) || chief?
  end

  def edit?
    user.can?(:edit, :faq_category) || chief?
  end

  def destroy?
    user.can?(:destroy, :faq_category) || chief?
  end

  def sort?
    user.can?(:sort, :faq_category) || chief?
  end
end
