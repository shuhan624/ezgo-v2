class PagesController < PublicController
  def index
    @popup = Setting.find_by(name: 'popup_homepage')
    @home_slides = HomeSlide.published.with_attached_banner.with_attached_banner_m.order(position: :asc).decorate
    @articles = Article.includes(:default_category).published.with_attached_image.order(published_at: :desc).decorate.limit(3)
    set_meta_tags title: @meta_title.presence || @site_title.presence || t('meta_tags.site_title'), site: nil
  end

  %w(about privacy terms thanks global_immigration international_schools).each do |slug|
    define_method(slug) do
      @page = CustomPage.find_by(slug: slug.dasherize)&.decorate
      @meta_tag = @page
      show_index_title
      set_meta_info
    end
  end

  def show
    @page = CustomPage.publishing.friendly.find(params[:id])&.decorate
    @meta_tag = @page
    set_meta_info
    check_lang_display(@page)
  end

  def robots
    openness = ('admin'.in?(request.subdomains) || %w(nier2b.com cw1.dev).include?(request.domain)) ? 'block' : 'public'
    robots = File.read("#{Rails.root}/public/robots.#{openness}.txt")
    render plain: robots
  end
end
