class PublicController < ApplicationController
  layout 'public'
  before_action :store_current_location, unless: :devise_controller?
  around_action :switch_locale
  after_action :track_action, unless: -> { Rails.env.local? }

  private

  # Ref: https://stackoverflow.com/a/26544722
  def store_current_location
    store_location_for(:user, request.url) unless request.xhr?
  end

  def switch_locale(&action)
    locale = locale_from_url || I18n.default_locale
    I18n.with_locale(locale) do
      set_settings
      header_menus
    end
    I18n.with_locale(locale, &action)
  end

  def locale_from_url
    locale = params[:locale]
    return locale if I18n.available_locales.map(&:to_s).include?(locale)
  end

  def set_settings
    settings = Setting.with_attached_image
       @site_title = settings.find { |s| s.name == 'site_title' }&.content || 'CIANWANG'
        @copyright = settings.find { |s| s.name == 'copyright' }&.content
               @ga = settings.find { |s| s.name == 'ga' }&.content
              @gtm = settings.find { |s| s.name == 'gtm' }&.content
         @fb_pixel = settings.find { |s| s.name == 'fb_pixel' }&.content
              @tel = settings.find { |s| s.name == 'tel' }&.content
              @fax = settings.find { |s| s.name == 'fax' }&.content
            @email = settings.find { |s| s.name == 'email' }&.content
          @address = settings.find { |s| s.name == 'address' }&.content
        @messenger = settings.find { |s| s.name == 'messenger' }&.content
       @meta_title = settings.find { |s| s.name == 'meta_title' }&.content
    @meta_keywords = settings.find { |s| s.name == 'meta_keywords' }&.content
        @meta_desc = settings.find { |s| s.name == 'meta_desc' }&.content
         @og_title = settings.find { |s| s.name == 'og_title' }&.content
          @og_desc = settings.find { |s| s.name == 'og_desc' }&.content
         @facebook = settings.find { |s| s.name == 'facebook' }&.content
          @youtube = settings.find { |s| s.name == 'youtube' }&.content
     @social_items = settings.social

    if I18n.locale == :'zh-TW'
         @favicon = settings.find { |s| s.name == 'favicon' }&.image
            @logo = settings.find { |s| s.name == 'logo' }&.image
        @og_image = settings.find { |s| s.name == 'og_image' }&.image
    else
      settings = Setting.with_attached_image_en
         @favicon = settings.find { |s| s.name == 'favicon' }&.image_en
            @logo = settings.find { |s| s.name == 'logo' }&.image_en
        @og_image = settings.find { |s| s.name == 'og_image' }&.image_en
    end

    # 如果 logo 有附加圖片，則使用 rails_storage_proxy_url 方法
    # 否則使用 image_url 方法找預設圖片 logo.png
  @logo_url = if @logo && @logo.attached?
               rails_storage_proxy_url(@logo)
             else
               view_context.asset_path('logo2.png')
             end

    @og_image_url = if @og_image && @og_image.attached?
                   rails_storage_proxy_url(@og_image)
                 else
                   ActionController::Base.helpers.image_url('logo2.png')
                 end
  end

  def header_menus
    @header_menus ||= Menu.header&.children&.publics(I18n.locale)
  end

  def track_action
    ahoy.track "#{controller_name}\##{action_name}", request.path_parameters
  end

  def set_meta_info
    if @meta_tag.present?
      title = if @meta_tag.respond_to?(:title)
                @meta_tag.meta_title.presence || @meta_tag.title_i18n.presence || @meta_title.presence || t('meta_tags.meta_title')
              else
                @meta_tag.meta_title.presence || @meta_tag.name_i18n.presence || @meta_title.presence || t('meta_tags.meta_title')
              end

      keywords = @meta_tag.meta_keywords.presence || @meta_keywords.presence || t('meta_tags.meta_keywords')
          desc = @meta_tag.meta_desc.presence || @meta_desc.presence || t('meta_tags.meta_description')
      og_title = @meta_tag.og_title.presence || @og_title.presence || t('meta_tags.og_title')
      og_desc = @meta_tag.og_desc.presence || @og_desc.presence || t('meta_tags.og_desc')
      og_image = @meta_tag.share_image

      canonical = if @meta_tag.canonical.present?
                    "#{request.base_url}/#{@meta_tag.canonical}"
                  else
                    @canonical || url_for(only_path: false, params: request.params.except(:param, :locale, :id, :article_category, :showcase_category, :faq_category, :controller, :action))
                  end
    else
      title = @meta_title.presence || t('meta_tags.meta_title')
      keywords = @meta_keywords.presence || t('meta_tags.meta_keywords')
      desc = @meta_desc.presence || t('meta_tags.meta_description')
      og_title = @og_title.presence || t('meta_tags.og_title')
      og_desc = @og_desc.presence || t('meta_tags.og_desc')
      og_image = @og_image
      canonical = @canonical || url_for(only_path: false, params: request.params.except(:param, :locale, :id, :article_category, :showcase_category, :faq_category, :controller, :action))
    end

    set_meta_tags title: title,
                  keywords: keywords,
                  description: desc,
                  og: {
                    title: og_title,
                    url: canonical,
                    description: og_desc,
                    site_name: (@site_title.presence || t('.meta_tags.site_title')),
                    image: og_image
                  },
                  canonical: canonical
  end

  def show_index_title
    if @page.present?
      @index_title = @page.title_i18n
      @index_title_en = @page.title_en
    elsif @category.present?
      @index_title = @category.name_i18n
      @index_title_en = @category.name_en
    else
      @index_title = t('.title')
      @index_title_en = t('.title_en')
    end
  end

  def check_lang_display(object)
    @no_other_language = object.no_other_lang?
  end
end
