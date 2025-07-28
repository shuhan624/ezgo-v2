# frozen_string_literal: true

class Devise::Users::SessionsController < Devise::SessionsController
  # include Accessible
  # skip_before_action :check_user, only: :destroy
  # before_action :configure_sign_in_params, only: [:create]
  after_action :clear_cart, only: [:destroy]
  after_action :order_belongs_to_user, only: [:create]

  # GET /resource/sign_in
  # def new
  #   session[:return_to] ||= request.referer
  #   super
  # end

  # POST /resource/sign_in
  # def create
  #   super
  # end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end

  def clear_cart
    session[:cart] = nil
    session[:order_token] = nil
  end

  def order_belongs_to_user
    if session[:order_token].present?
      order = Order.find_by(session_token: session[:order_token])
      order.update_attribute(:user_id, resource.id) if order.present? && order.user.nil?
    end
  end
end
