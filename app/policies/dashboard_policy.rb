class DashboardPolicy < ApplicationPolicy
  attr_reader :user

  # _record in this example will just be :dashboard
  def initialize(user, _record)
    @user = user
  end

  def index?
    user.can?(:index, :dashboard) || chief?
  end

  def marketing?
    user.can?(:marketing, :dashboard) || chief?
  end
end
