# frozen_string_literal: true

class ArticlePolicy < ApplicationPolicy
  def permitted_attributes
    [:default_category_id, :title, :title_en, :slug, :post_type, :featured, :top, :published_at, :published_at_en, :expired_at, :expired_at_en, :abstract_zh_tw, :abstract_en, :content, :content_en, :source_link_zh_tw, :source_link_en, :image, :alt_zh_tw, :alt_en, article_category_ids: [], tw_documents_attributes: [:id, :title, :slug, :language, :file_type, :file, :link, :_destroy], en_documents_attributes: [:id, :title, :slug, :language, :file_type, :file, :link, :_destroy], tag_list: [], en_tag_list: [], seo_attributes: [:id, :meta_title_zh_tw, :meta_title_en, :meta_keywords_zh_tw, :meta_keywords_en, :meta_desc_zh_tw, :meta_desc_en, :og_title_zh_tw, :og_title_en, :og_desc_zh_tw, :og_desc_en, :og_image, :og_image_en, :canonical]]
  end

  def index?
    user.can?(:index, :article) || chief?
  end

  def show?
    user.can?(:show, :article) || chief?
  end

  def preview?
    user.can?(:preview, :article) || chief?
  end

  def new?
    user.can?(:new, :article) || chief?
  end

  def create?
    user.can?(:create, :article) || chief?
  end

  def update?
    user.can?(:update, :article) || chief?
  end

  def edit?
    user.can?(:edit, :article) || chief?
  end

  def destroy?
    user.can?(:destroy, :article) || chief?
  end

  def copy?
    user.can?(:copy, :article) || chief?
  end

  def show_tags?
    user.can?(:show_tags, :article) || chief?
  end
end
