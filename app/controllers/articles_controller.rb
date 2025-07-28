class ArticlesController < PublicController
  PER_PAGE = 10

  def index
    page = CustomPage.find_by(slug: 'news')
    @page = page.decorate if page.present?

    if params[:article_category].present?
      @category = ArticleCategory.publishing.friendly.find(params[:article_category]).decorate
      @q = @category.articles.published.with_attached_image.ransack(params[:q])
      check_lang_display(@category)
      @meta_tag = @category
    else
      @q = Article.with_attached_image.published.ransack(params[:q])
      @meta_tag = @page
    end

    sort_columns = I18n.available_locales.map do |locale|
      [locale.to_s, "published_at_#{locale}"]
    end.to_h

    sort_column = (I18n.locale == :'zh-TW' ? 'published_at' : sort_columns[I18n.locale.to_s])

    @q.sorts = ['top asc', "#{sort_column} desc"]
    posts = @q.result(distinct: true)
    @pagy, @posts = pagy(posts, items: PER_PAGE)
    @posts = @posts.decorate
    set_meta_info
    show_index_title
  end

  def show
    page = CustomPage.find_by(slug: 'news')
    @page = page.decorate if page.present?
    @category = ArticleCategory.friendly.find(params[:article_category]).decorate
    @post = Article.post.with_attached_image.published.friendly.find(params[:id]).decorate
    @next_post = @post.next_post(@category)&.decorate
    @previous_post = @post.previous_post(@category)&.decorate
    check_lang_display(@post)
    @meta_tag = @post
    set_canonical
    set_meta_info
    show_index_title
  end

  # GET /preview/:id
  def preview
    page = CustomPage.find_by(slug: 'news')
    @page = page.decorate if page.present?
    @category = ArticleCategory.friendly.find(params[:article_category]).decorate
    @post = Article.post.with_attached_image.friendly.find(params[:id]).decorate
    @meta_tag = @post
    set_meta_info
    show_index_title
  end

  def tag
    @tag = params[:tag]
    articles = Article.tagged_with(@tag).includes(:article_categories, :tags, :rich_text_content).published
    @pagy, @articles = pagy(articles, items: PER_PAGE)
    @articles = @articles.decorate
  end

  def set_canonical
    @canonical = article_url(article_category: @post.default_category, id: @post.slug)
  end
end
