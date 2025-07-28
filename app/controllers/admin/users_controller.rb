# frozen_string_literal: true

class Admin::UsersController < AdminController
  before_action :set_user, only: %i[show edit update destroy message push_message]

  # GET /users
  def index
    authorize User
    @q = policy_scope(User).ransack(params[:q])
    @q.sorts = 'created_at desc'
    users = @q.result
    @pagy, @users = pagy(users)
    @users = @users.decorate
  end

  # GET /users/:id
  def show
    @user = @user.decorate
  end

  # GET /users/new
  def new
    @user = User.new
    authorize @user
  end

  # GET /users/:id/edit
  def edit; end

  # POST /users
  def create
    @user = User.new(permitted_attributes(User))
    authorize @user

    @user.skip_confirmation!
    if @user.save
      redirect_to admin_user_path(@user), notice: successful_message
    else
      render :new
    end
  end

  # PATCH/PUT /users/:id
  def update
    update_params = user_params.dup
    update_params = update_params.except(:password, :password_confirmation) unless params[:user][:password].present?
    if @user.update(update_params)
      redirect_to admin_user_path(@user), notice: successful_message
    else
      render :edit
    end
  end

  # DELETE /users/:id
  def destroy
    @user.destroy
    redirect_to admin_users_url, notice: successful_message
  end

  def message
    respond_to do |format|
      format.js
    end
  end

  def push_message
    message = {
      type: 'text',
      text: params[:message]
    }

    line = LineMessage.new
    @response = line.push_message(@user.line_uid, message)

    respond_to do |format|
      format.js { render 'message_response' }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = policy_scope(User).find(params[:id])
    authorize @user
  end

  # Only allow a list of trusted parameters through.
  def user_params
    params.require(:user).permit(policy(@user).permitted_attributes)
  end
end
