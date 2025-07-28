class UserController < PublicController
  before_action :authenticate_user!, :set_user

  def profile
    @processing_orders_count = @user.orders.in_processing.count
  end

  def edit
  end

  def update
    if @user.update(user_params)
      redirect_to user_profile_path, notice: '個人資料變更成功！'
    else
      :edit
    end
  end

  def edit_password
  end

  def update_password
    if @user.update_with_password(password_params)
      # Sign in the user by passing validation in case their password changed
      bypass_sign_in @user, scope: :user
      redirect_to user_profile_path, notice: '密碼變更成功！'
    else
      render :edit_password
    end
  end

  def orders
    @orders = @user.valid_orders.order(created_at: :desc)&.decorate
  end

  def order_show
    @order = @user.orders.find_by(order_number: params[:order_number])&.decorate
  end

  def item_details
    @item = OrderItem.find(params[:id])&.decorate
    if @item.order.user == current_user
      render 'order/item_details'
    else
      render js: '', status: :not_found
    end
  end

  private

  def set_user
    @user = current_user
  end

  def user_params
    params.require(:user).permit(:name, :phone, :country, :zip_code, :city, :dist, :address, :organization, :department, :tax_number)
  end

  def password_params
    params.require(:user).permit(:current_password, :password, :password_confirmation)
  end
end
