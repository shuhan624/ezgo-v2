# frozen_string_literal: true

class Admin::ArticlesController < AdminController
  before_action :set_article, only: %i[show edit update destroy copy]

  # GET /articles
  def index
    authorize Article
    @q = Article.includes(:default_category).ransack(params[:q])
    @q.sorts = ['top asc', 'published_at desc']
    articles = @q.result
    @pagy, @articles = pagy(articles)
    @articles = @articles.decorate
  end

  # GET /articles/:id
  def show
    @article.build_seo if @article.seo.blank?
    @article = @article.decorate
  end

  # GET /articles/new
  def new
    @article = Article.new
    @article.build_seo
    authorize @article
  end

  # GET /articles/:id/edit
  def edit
    @article.build_seo if @article.seo.blank?
  end

  # POST /articles
  def create
    @article = Article.new(permitted_attributes(Article))
    authorize @article

    if @article.save
      redirect_to admin_article_path(@article), notice: successful_message
    else
      @article.build_seo if @article.seo.blank?
      keep_images
      render :new
    end
  end

  # PATCH/PUT /articles/:id
  def update
    @article.image.purge if params[:destroy_image] == 'true'
    @article.image_en.purge if params[:destroy_image_en] == 'true'
    @article.og_image.purge if params[:destroy_og_image] == 'true'
    @article.og_image_en.purge if params[:destroy_og_image_en] == 'true'
    if @article.update(article_params)
      redirect_to admin_article_path(@article), notice: successful_message
    else
      keep_images
      render :edit
    end
  end

  # DELETE /articles/:id
  def destroy
    @article.destroy
    redirect_to admin_articles_url, notice: successful_message
  end

  def copy
    @new_article = @article.deep_clone(
      include: %i[
        article_categories
      ],
      except: %i[published_at expired_at top featured]
    )
    @new_article.title = @article.title + ' - 複製'
    @new_article.slug = @article.slug + '-copy'

    if @new_article.save
      redirect_to edit_admin_article_path(@new_article)
    else
      flash[:alert] = '複製失敗!' + @new_article.errors.full_messages.join(', ')
      @article.build_seo if @article.seo.blank?
      @article = @article.decorate
      render :show
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_article
    @article = Article.includes(seo: { og_image_attachment: :blob }).friendly.find(params[:id])
    authorize @article
  end

  #without this, ActiveSupport::MessageVerifier::InvalidSignature
  def keep_images
    @article.attachment_changes.each do |_, change|
      if change.is_a?(ActiveStorage::Attached::Changes::CreateOne)
        change.upload
        change.blob.save
      end
    end
  end

  # Only allow a list of trusted parameters through.
  def article_params
    params.require(:article).permit(policy(@article).permitted_attributes)
  end
end
