class AdminController < ApplicationController
  include Pundit::Authorization
  include AdminHelper
  before_action :authenticate_admin!
  before_action :set_admin_settings
  before_action :set_public_host

  def pundit_user
    current_admin
  end
end
