# frozen_string_literal: true

class Admin::RolesController < AdminController
  before_action :set_role, only: %i[show edit update destroy]
  before_action :set_permissions, only: %i[new create edit update]

  # GET /roles
  def index
    authorize Role
    roles = Role.order(id: :asc)
    @pagy, @roles = pagy(roles)
  end

  # GET /roles/:id
  def show
  end

  # GET /roles/new
  def new
    @role = Role.new
    authorize @role
  end

  # GET /roles/:id/edit
  def edit; end

  # POST /roles
  def create
    @role = Role.new(role_params)
    authorize @role

    if @role.save
      redirect_to admin_roles_url, notice: successful_message
    else
      render :new
    end
  end

  # PATCH/PUT /roles/:id
  def update
    if @role.update(role_params)
      redirect_to admin_roles_url, notice: successful_message
    else
      render :edit
    end
  end

  # DELETE /roles/:id
  def destroy
    @role.destroy
    redirect_to admin_roles_url, notice: successful_message
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_role
    @role = Role.find(params[:id])
    authorize @role
  end

  def set_permissions
    # Ref: https://stackoverflow.com/a/52292285/2132273
    @permissions = {}
    crud = %w(index show new create edit update destroy sort)
    Role.default_permissions.each do |target, model|
      klass = (model == 'headless') ? target : model.constantize
      policy = Pundit.policy(current_admin, klass)
      actions = policy.public_methods(false).map { |action| action.to_s.delete_suffix('?') }
      ordered_actions = actions.excluding('permitted_attributes').sort_by do |action|
                          [crud.index(action) ? 0 : 1, crud.index(action)]
                        end
      @permissions[target] = ordered_actions
    end
    @permissions
  end

  # Only allow a list of trusted parameters through.
  def role_params
    params.require(:role).permit(:name, permissions: {})
  end
end
