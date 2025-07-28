class ApplicationDecorator < Draper::Decorator

############################## 前台 Public ##############################
  def current_locale
    I18n.locale.to_s
  end

  def available_locales
    I18n.available_locales.map(&:to_s)
  end

  def share_image
    default_og_image = Setting.find_by(name: 'og_image')

    if object.og_image.present?
      if I18n.locale == :'zh-TW'
        Rails.application.routes.url_helpers.rails_storage_proxy_url(object.og_image)
      elsif I18n.locale == :en && object.og_image_en.present?
        Rails.application.routes.url_helpers.rails_storage_proxy_url(object.og_image_en)
      else
        Rails.application.routes.url_helpers.rails_storage_proxy_url(object.og_image)
      end
    elsif default_og_image.present?
      Rails.application.routes.url_helpers.rails_storage_proxy_url(default_og_image.image)
    else
      h.image_url('logo.png')
    end
  end

  def title_i18n
    title = (current_locale == 'zh-TW' ? :title : "title_#{current_locale}".to_sym)
    object.send(title)
  end

  def name_i18n
    name = (current_locale == 'zh-TW' ? :name : "name_#{current_locale}".to_sym)
    object.send(name)
  end

  def content_i18n
    content = (current_locale == 'zh-TW' ? :content : "content_#{current_locale}".to_sym)
    object.send(content)&.html_safe
  end

  def abstract_i18n
    abstract = "abstract_#{current_locale}".downcase.tr('-', '_').to_sym

    content = (current_locale == 'zh-TW' ? :content : "content_#{current_locale}".to_sym)

    object.send(abstract).presence || object.send(content)&.html_safe&.first(80)
  end

  def desc_i18n
    desc = "desc_#{current_locale}".downcase.tr('-', '_').to_sym
    object.send(desc)
  end

  def alt_i18n
    alt = "alt_#{current_locale}".downcase.tr('-', '_').to_sym
    object.send(alt)
  end

  def link_i18n
    link = "link_#{current_locale}".downcase.tr('-', '_').to_sym
    object.send(link)
  end

  def category_i18n(category = nil)
    category ||= object.default_category
    attribute = (current_locale == 'zh-TW' ? :name : "name_#{current_locale}".to_sym)
    category.send(attribute)
  end

  def published_date_i18n
    if current_locale == 'zh-TW'
      published_date = :published_at
    elsif available_locales.include?(current_locale)
      published_date = "published_at_#{current_locale}".to_sym
    else
      published_date = :published_at
    end

    I18n.l(object.send(published_date), default: '')
  end

  def documents_i18n
    I18n.locale == :en ? en_documents : tw_documents
  end

############################## 後台 Admin ##############################
  def default_category_name
    object.default_category.name
  end

  def show_name
    names = []
    names << name if object.name.present?
    names << name_en if object.name_en.present?
    h.simple_format( names.join("\n"), {}, wrapper_tag: 'span')
  end

  def show_title
    titles = []
    titles << title if object.title.present?
    titles << title_en if object.title_en.present?
    h.simple_format( titles.join("\n"), {}, wrapper_tag: 'span')
  end

  def publish_status
    status = object.published? ? 'published' : 'hidden'
    display_status_icon(status)
  end

  def en_publish_status
    status = object.en_published? ? 'published' : 'hidden'
    display_status_icon(status)
  end

  def status
    display_status_icon(object.status)
  end

  def en_status
    display_status_icon(object.en_status)
  end

  def published_at
    I18n.l(object.published_at, format: :simple, default: '')
  end

  def published_at_en
    I18n.l(object.published_at_en, format: :simple, default: '')
  end

  def published_at_datetime
    I18n.l(object.published_at, default: '')
  end

  def expired_at
    I18n.l(object.expired_at, format: :simple, default: '')
  end

  def expired_at_en
    I18n.l(object.expired_at_en, format: :simple, default: '')
  end

  def updated_at_datetime
    I18n.l(object.updated_at, format: :table, default: '')
  end

  def created_at_datetime
    I18n.l(object.created_at, format: :table, default: '')
  end

  def show_tags
    object.tag_list.map { |tag| h.tag.span(tag, class: 'badge badge-info')}.reduce(:+)
  end

  def tags_with_link
    object.tags.map { |tag| h.link_to(tag.name, h.tag_path(tag: tag.name), class: 'badge badge-info')}.reduce(:+)
  end

  def show_file_type
    case object.file_type
    when 'file'
      h.image_tag('icon/download.svg', alt: "檔案", data: { toggle: 'tooltip', placement: 'top', title: '檔案' })
    when 'link'
      h.image_tag('icon/link.svg', alt: "連結", data: { toggle: 'tooltip', placement: 'top', title: '連結' })
    end
  end

  def h1_tag
    object.respond_to?(:title) ? object.title : object.name
  end

  def h1_tag_en
    object.respond_to?(:title_en) ? object.title_en : object.name_en
  end

  private

  def display_status_icon(status)
    if status == 'published'
      h.image_tag('admin/status_visible.svg', alt: "公開", title: '公開', data: { bs_toggle: 'tooltip', placement: 'top' })
    elsif status == 'hidden'
      h.image_tag('admin/status_invisible.svg', alt: "不公開", title: '不公開', data: { bs_toggle: 'tooltip', placement: 'top' })
    else
      status
    end
  end
end
