# frozen_string_literal: true

class Admin::CustomPagesController < AdminController
  before_action :set_custom_page, only: %i[show edit update destroy]

  # GET /custom_pages
  def index
    authorize CustomPage
    # seo_pages: 1.預設頁面 2.custom_type: [design, archive]
    # content_pages: 1.預設頁面 2.custom_type: [info]
    # non_default_pages: 1.非預設頁面
    @seo_pages = CustomPage.default_pages.seo_pages.order(created_at: :asc).decorate
    @content_pages = CustomPage.default_pages.info.order(created_at: :asc).decorate
    @non_default_pages = CustomPage.non_default_pages.order(created_at: :asc).decorate
  end

  # GET /custom_pages/:id
  def show
    @custom_page = @custom_page.decorate
    @custom_page.build_seo if @custom_page.seo.blank?
  end

  # GET /custom_pages/new
  def new
    @custom_page = CustomPage.new
    @custom_page.build_seo
    authorize @custom_page
  end

  # GET /custom_pages/:id/edit
  def edit
    @custom_page.build_seo if @custom_page.seo.blank?
  end

  # POST /custom_pages
  def create
    @custom_page = CustomPage.new(permitted_attributes(CustomPage))
    authorize @custom_page

    if @custom_page.save
      redirect_to admin_custom_page_path(@custom_page), notice: successful_message
    else
      @custom_page.build_seo if @custom_page.seo.blank?
      render :new
    end
  end

  # PATCH/PUT /custom_pages/:id
  def update
    if @custom_page.update(custom_page_params)
      redirect_to admin_custom_page_path(@custom_page), notice: successful_message
    else
      render :edit
    end
  end

  # DELETE /custom_pages/:id
  def destroy
    @custom_page.destroy
    redirect_to admin_custom_pages_url, notice: successful_message
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_custom_page
    @custom_page = CustomPage.includes(seo: { og_image_attachment: :blob }).friendly.find(params[:id])
    authorize @custom_page
  end

  # Only allow a list of trusted parameters through.
  def custom_page_params
    params.require(:custom_page).permit(policy(@custom_page).permitted_attributes)
  end
end
