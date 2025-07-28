# frozen_string_literal: true

class Admin::AdminsController < AdminController
  before_action :set_admin, only: %i[show edit update destroy]

  # GET /admins
  def index
    authorize Admin
    @q = policy_scope(Admin).includes(:role).ransack(params[:q])
    @q.sorts = 'email asc'
    admins = @q.result
    @pagy, @admins = pagy(admins)
    @admins = @admins.decorate
  end

  # GET /admins/:id
  def show
    @admin = @admin.decorate
    records = CustomAudit.where(user_id: @admin.id)
                         .where(auditable_type: ActiveRecord::Base.descendants.map(&:name))
                         .order(created_at: :desc)
    @pagy, @records = pagy(records, items: 25)
    @records = @records.decorate
  end

  # GET /admins/new
  def new
    @admin = Admin.new
    authorize @admin
  end

  # GET /admins/:id/edit
  def edit
  end

  # POST /admins
  def create
    @admin = Admin.new(permitted_attributes(Admin))
    authorize @admin

    if @admin.save
      redirect_to admin_admin_path(@admin), notice: successful_message
    else
      render :new
    end
  end

  # PATCH/PUT /admins/:id
  def update
    update_params = admin_params.dup
    update_params = update_params.except(:password, :password_confirmation) unless params[:admin][:password].present?
    if @admin.update(update_params)
      redirect_to admin_admin_path(@admin), notice: successful_message
    else
      render :edit
    end
  end

  # DELETE /admins/:id
  def destroy
    @admin.destroy
    redirect_to admin_admins_url, notice: successful_message
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_admin
    @admin = policy_scope(Admin).find(params[:id])
    authorize @admin
  end

  # Only allow a list of trusted parameters through.
  def admin_params
    params.require(:admin).permit(policy(@admin).permitted_attributes)
  end
end
