class ApplicationController < ActionController::Base
  include Pagy::Backend
  helper_method :current_model

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  protected

  def current_model
    unless 'dashboard' == controller_name
      @current_model ||= controller_name.classify.constantize
    end
  end

  def set_public_host
    @host = Rails.application.config.action_mailer.default_url_options[:host]
  end

  def set_admin_settings
    settings = Setting.with_attached_image
       @favicon = settings.find { |s| s.name == 'favicon' }&.image
    @site_title = settings.find { |s| s.name == 'site_title' }&.content || 'EZGO'
     @copyright = settings.find { |s| s.name == 'copyright' }&.content
    @admin_logo = settings.find { |s| s.name == 'admin_logo' }&.image
    @logo = settings.find { |s| s.name == 'logo' }&.image

    # 如果 admin_logo 有附加圖片，則使用 rails_storage_proxy_url 方法
    # 否則使用 image_url 方法找預設圖片 logo.png
    @admin_logo_url = if @admin_logo.attached?
                        rails_storage_proxy_url(@admin_logo)
                      else
                        ActionController::Base.helpers.image_url('logo2.png')
                      end
  end

  def user_not_authorized
    flash[:alert] = "無權進行此操作"
    respond_to do |format|
      format.js { render js: "window.location='#{request.referrer || root_path}'" }
      format.html { redirect_back(fallback_location: root_path) }
    end
  end

  def after_sign_in_path_for(user)
    if current_admin
      admin_root_path
    else
      super
    end
  end
end
