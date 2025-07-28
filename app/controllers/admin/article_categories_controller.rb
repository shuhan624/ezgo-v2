# frozen_string_literal: true

class Admin::ArticleCategoriesController < AdminController
  before_action :set_article_category, only: %i[show edit update destroy sort]

  # GET /categories
  def index
    authorize ArticleCategory
    @q = ArticleCategory.ransack(params[:q])
    @q.sorts = 'position asc'
    article_categories = @q.result
    @pagy, @article_categories = pagy(article_categories)
    @article_categories = @article_categories.decorate
  end

  # GET /categories/:id
  def show
    @article_category.build_seo if @article_category.seo.blank?
    @article_category = @article_category.decorate
  end

  # GET /categories/new
  def new
    @article_category = ArticleCategory.new
    @article_category.build_seo
    authorize @article_category
  end

  # GET /categories/:id/edit
  def edit
    @article_category.build_seo if @article_category.seo.blank?
  end

  # POST /categories
  def create
    @article_category = ArticleCategory.new(permitted_attributes(ArticleCategory))
    authorize @article_category

    if @article_category.save
      redirect_to admin_article_categories_url, notice: successful_message
    else
      @article_category.build_seo if @article_category.seo.blank?
      render :new
    end
  end

  # PATCH/PUT /categories/:id
  def update
    if @article_category.update(article_category_params)
      redirect_to admin_article_categories_url, notice: successful_message
    else
      render :edit
    end
  end

  # DELETE /categories/:id
  def destroy
    @article_category.destroy
    redirect_to admin_article_categories_url, notice: successful_message
  end

  def sort
    @article_category.insert_at(params[:to].to_i + 1) if @article_category.valid?
    if !@article_category.valid? || @article_category.errors.present?
      render js: notify_script(:alert, @article_category.errors.full_messages)
    else
      render js: notify_script(:success, successful_message(model: ArticleCategory, action: :update))
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_article_category
    @article_category = ArticleCategory.includes(seo: { og_image_attachment: :blob }).friendly.find(params[:id])
    authorize @article_category
  end

  # Only allow a list of trusted parameters through.
  def article_category_params
    params.require(:article_category).permit(policy(@article_category).permitted_attributes)
  end
end
