# frozen_string_literal: true

class Admin::MenusController < AdminController
  before_action :set_menu, only: %i[show edit update destroy sort]

  # GET /menus
  def index
    authorize Menu
    @header_menu = Menu.header
    @header_tree_nodes = to_tree_node(@header_menu)
  end

  # GET /menus/:id
  def show
  end

  # GET /menus/new
  def new
    @menu = Menu.new
    authorize @menu
  end

  # GET /menus/:id/edit
  def edit; end

  # POST /menus
  def create
    @menu = Menu.new(menu_params)
    @menu.parent = Menu.header
    authorize @menu

    if @menu.save
      redirect_to admin_menus_path, notice: successful_message
    else
      render :new
    end
  end

  # PATCH/PUT dmin/menus/:id
  def update
    if @menu.update(menu_params)
      redirect_to admin_menus_path, notice: successful_message
    else
      render :edit
    end
  end

  # DELETE /menus/:id
  def destroy
    @menu.destroy!
    redirect_to admin_menus_path, notice: successful_message
  end

  # PATCH /menus/:id/sort
  def sort
    if sort_params[:parent_id].to_i != @menu.parent_id
      parent = Menu.find(sort_params[:parent_id])
      @menu.move_to_child_of(parent)
    end

    result = @menu.insert_at(sort_params[:position])
    if result
      render js: notify_script(:success, successful_message(model: Menu, action: :update))
    elsif nil == result # 沒有任何變動會回傳 nil
      render js: '', status: :ok
    elsif false == result
      render js: notify_script(:alert, @menu.errors.full_messages)
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_menu
    @menu = Menu.find(params[:id])
    authorize @menu
  end

  # Only allow a list of trusted parameters through.
  def menu_params
    params.require(:menu).permit(policy(Menu).permitted_attributes)
  end

  def sort_params
    params.require(:menu).permit(:parent_id, :position)
  end

  def to_tree_node(menu)
    menu = menu.decorate
    {
      data: { root: menu.parent_id.blank?, id: menu.id, title: menu.title, title_en: menu.title_en, status: menu.status, en_status: menu.en_status, edit_path: edit_admin_menu_path(menu) },
      nodes: menu.children.map { |child| to_tree_node(child) }
    }
  end
end
