class ArticleDecorator < ApplicationDecorator
  delegate_all

############################## 前台 Public ##############################
  def link(category = nil)
    if object.post_type == 'post'
      category ||= object.default_category
      h.article_path(article_category: category, id: object.slug)
    elsif object.post_type == 'link'
      (I18n.locale == :en) ? object.source_link_en : object.source_link_zh_tw
    end
  end

  def previous_post(category)
    category.articles.post.published
                     .where("published_at > ?", object.published_at)
                     .order(published_at: :asc)
                     .limit(1).take
  end

  def next_post(category)
    category.articles.post.published
                     .where("published_at < ?", object.published_at)
                     .order(published_at: :desc)
                     .limit(1).take
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

############################## 後台 Admin ##############################
  def link_to_slug
    @host = Rails.application.config.action_mailer.default_url_options[:host]
    link = h.article_url(host: @host, article_category: object.default_category, id: object.slug)
    text = h.content_tag(:i, nil, class: "zmdi zmdi-open-in-new") + h.content_tag(:span, link)

    case object.post_type
    when 'post'
      object.published? ? h.link_to(text, link, target: '_blank') : link
    when 'link'
      h.link_to(object.source_link_zh_tw, object.source_link_zh_tw, target: '_blank') if object.source_link_zh_tw.present?
    end
  end

  def link_to_slug_en
    @host = Rails.application.config.action_mailer.default_url_options[:host]
    link = h.article_url(host: @host, locale: 'en', article_category: object.default_category, id: object.slug)
    text = h.content_tag(:i, nil, class: "zmdi zmdi-open-in-new") + h.content_tag(:span, link)

    case object.post_type
    when 'post'
      object.en_published? ? h.link_to(text, link, target: '_blank') : link
    when 'link'
      h.link_to(object.source_link_en, object.source_link_en, target: '_blank') if object.source_link_en.present?
    end
  end

  def show_categories
    h.simple_format(object.article_categories.map(&:name).join("、"), {}, wrapper_tag: 'span')
  end

  def show_post_type
    h.t("simple_form.options.article.post_type.#{object.post_type}")
  end

  def show_post_type_icon
    case object.post_type
    when 'post'
      h.image_tag('icon/file.svg', alt: "文章", data: { toggle: 'tooltip', placement: 'top', title: '文章' })
    when 'link'
      h.image_tag('icon/link.svg', alt: "連結", data: { toggle: 'tooltip', placement: 'top', title: '連結' })
    end
  end
end
