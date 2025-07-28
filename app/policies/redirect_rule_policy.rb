class RedirectRulePolicy < ApplicationPolicy
  def permitted_attributes
    [:source_path, :target_path, :position]
  end

  def index?
    user.can?(:index, :redirect_rule) || chief?
  end

  def show?
    user.can?(:show, :redirect_rule) || chief?
  end

  def create?
    user.can?(:create, :redirect_rule) || chief?
  end

  def new?
    user.can?(:new, :redirect_rule) || chief?
  end

  def update?
    user.can?(:update, :redirect_rule) || chief?
  end

  def edit?
    user.can?(:edit, :redirect_rule) || chief?
  end

  def destroy?
    user.can?(:destroy, :redirect_rule) || chief?
  end

  def sort?
    user.can?(:sort, :redirect_rule) || chief?
  end
end
