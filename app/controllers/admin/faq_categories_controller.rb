# frozen_string_literal: true

class Admin::FaqCategoriesController < AdminController
  before_action :set_faq_category, only: %i[show edit update destroy sort]

  # GET /faq_categories
  def index
    authorize FaqCategory
    @q = FaqCategory.ransack(params[:q])
    @q.sorts = 'position asc'
    faq_categories = @q.result
    @pagy, @faq_categories = pagy(faq_categories)
    @faq_categories = @faq_categories.decorate
  end

  # GET /faq_categories/:id
  def show
    @faq_category.build_seo if @faq_category.seo.blank?
    @faq_category = @faq_category.decorate
  end

  # GET /faq_categories/new
  def new
    @faq_category = FaqCategory.new
    @faq_category.build_seo
    authorize @faq_category
  end

  # GET /faq_categories/:id/edit
  def edit
    @faq_category.build_seo if @faq_category.seo.blank?
  end

  # POST /faq_categories
  def create
    @faq_category = FaqCategory.new(permitted_attributes(FaqCategory))
    authorize @faq_category

    if @faq_category.save
      redirect_to admin_faq_category_path(@faq_category), notice: successful_message
    else
      @faq_category.build_seo if @faq_category.seo.blank?
      render :new
    end
  end

  # PATCH/PUT /faq_categories/:id
  def update
    if @faq_category.update(faq_category_params)
      redirect_to admin_faq_category_path(@faq_category), notice: successful_message
    else
      render :edit
    end
  end

  # DELETE /faq_categories/:id
  def destroy
    @faq_category.destroy
    redirect_to admin_faq_categories_url, notice: successful_message
  end

  def sort
    @faq_category.insert_at(params[:to].to_i + 1) if @faq_category.valid?
    if !@faq_category.valid? || @faq_category.errors.present?
      render js: notify_script(:alert, @faq_category.errors.full_messages)
    else
      render js: notify_script(:success, successful_message(model: FaqCategory, action: :update))
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_faq_category
    @faq_category = FaqCategory.includes(seo: { og_image_attachment: :blob }).friendly.find(params[:id])
    authorize @faq_category
  end

  # Only allow a list of trusted parameters through.
  def faq_category_params
    params.require(:faq_category).permit(policy(@faq_category).permitted_attributes)
  end
end
