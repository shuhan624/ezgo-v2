# if Necessary
# To Prevent issue from 2 Devise Models
# Reference: https://github.com/heartcombo/devise/wiki/How-to-Setup-Multiple-Devise-User-Models#6-fix-cross-model-visits-fancy-name-for-users-can-visit-admins-login-and-viceversa-and-mess-up-your-auth-tokens

module Accessible
  extend ActiveSupport::Concern
  included do
    before_action :check_user
  end

  protected

  def check_user
    if current_admin
      flash.clear
      redirect_to(admin_root_path) and return
    elsif current_user
      flash.clear
      redirect_to(user_root_path) and return
    end
  end
end
