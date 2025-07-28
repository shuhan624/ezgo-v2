# frozen_string_literal: true

class Admin::DownloadCategoriesController < AdminController
  before_action :set_download_category, only: %i[show edit update destroy sort]

  # GET /download_categories
  def index
    authorize DownloadCategory
    @q = DownloadCategory.ransack(params[:q])
    @q.sorts = 'position asc'
    download_categories = @q.result
    @pagy, @download_categories = pagy(download_categories)
    @download_categories = @download_categories.decorate
  end

  # GET /download_categories/:id
  def show
    @download_category = @download_category.decorate
    @download_category.build_seo if @download_category.seo.blank?
  end

  # GET /download_categories/new
  def new
    @download_category = DownloadCategory.new
    @download_category.build_seo
    authorize @download_category
  end

  # GET /download_categories/:id/edit
  def edit
    @download_category.build_seo if @download_category.seo.blank?
  end

  # POST /download_categories
  def create
    @download_category = DownloadCategory.new(download_category_params)
    authorize @download_category

    if @download_category.save
      redirect_to admin_download_categories_url, notice: successful_message
    else
      @download_category.build_seo if @download_category.seo.blank?
      render :new
    end
  end

  # PATCH/PUT /download_categories/:id
  def update
    if @download_category.update(download_category_params)
      redirect_to admin_download_categories_url, notice: successful_message
    else
      render :edit
    end
  end

  # DELETE /download_categories/:id
  def destroy
    @download_category.destroy
    redirect_to admin_download_categories_url, notice: successful_message
  end

  def sort
    @download_category.insert_at(params[:to].to_i + 1) if @download_category.valid?
    if !@download_category.valid? || @download_category.errors.present?
      render js: notify_script(:alert, @download_category.errors.full_messages)
    else
      render js: notify_script(:success, successful_message(model: DownloadCategory, action: :update))
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_download_category
    @download_category = DownloadCategory.friendly.find(params[:id])
    authorize @download_category
  end

  # Only allow a list of trusted parameters through.
  def download_category_params
    params.require(:download_category).permit(:name, :name_en, :slug, :status, :en_status,seo_attributes: [:id, :meta_title_zh_tw, :meta_title_en, :meta_keywords_zh_tw, :meta_keywords_en, :meta_desc_zh_tw, :meta_desc_en, :og_title_zh_tw, :og_title_en, :og_desc_zh_tw, :og_desc_en, :og_image, :canonical])
  end
end
