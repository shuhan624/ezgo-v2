# frozen_string_literal: true

class ArticleCategoryPolicy < ApplicationPolicy
  def permitted_attributes
    [:name, :name_en, :slug, :status, :en_status, seo_attributes: [:id, :meta_title_zh_tw, :meta_title_en, :meta_keywords_zh_tw, :meta_keywords_en, :meta_desc_zh_tw, :meta_desc_en, :og_title_zh_tw, :og_title_en, :og_desc_zh_tw, :og_desc_en, :og_image, :og_image_en, :canonical]]
  end

  def index?
    user.can?(:index, :article_category) || chief?
  end

  def show?
    user.can?(:show, :article_category) || chief?
  end

  def create?
    user.can?(:create, :article_category) || chief?
  end

  def new?
    user.can?(:new, :article_category) || chief?
  end

  def update?
    user.can?(:update, :article_category) || chief?
  end

  def edit?
    user.can?(:edit, :article_category) || chief?
  end

  def destroy?
    user.can?(:destroy, :article_category) || chief?
  end

  def sort?
    user.can?(:sort, :article_category) || chief?
  end
end
