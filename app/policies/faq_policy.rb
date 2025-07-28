# frozen_string_literal: true

class FaqPolicy < ApplicationPolicy
  def permitted_attributes
    [:faq_category_id, :title, :title_en, :status, :en_status, :slug, :content, :content_en]
  end

  def index?
    user.can?(:index, :faq) || chief?
  end

  def show?
    user.can?(:show, :faq) || chief?
  end

  def create?
    user.can?(:create, :faq) || chief?
  end

  def new?
    user.can?(:new, :faq) || chief?
  end

  def update?
    user.can?(:update, :faq) || chief?
  end

  def edit?
    user.can?(:edit, :faq) || chief?
  end

  def destroy?
    user.can?(:destroy, :faq) || chief?
  end

  def sort?
    user.can?(:sort, :faq) || chief?
  end
end
