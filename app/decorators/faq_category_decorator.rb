class FaqCategoryDecorator < ApplicationDecorator
  delegate_all

  ############################## 後台 Admin ##############################
  def link_to_slug
    @host = Rails.application.config.action_mailer.default_url_options[:host]
    link = h.cate_faqs_url(host: @host, faq_category: object.slug)
    text = h.content_tag(:i, nil, class: "zmdi zmdi-open-in-new") + h.content_tag(:span, link)

    object.zh_tw_published? ? h.link_to(text, link, target: '_blank') : link
  end

  def link_to_slug_en
    @host = Rails.application.config.action_mailer.default_url_options[:host]
    link = h.cate_faqs_url(host: @host, locale: :en, faq_category: object.slug)
    text = h.content_tag(:i, nil, class: "zmdi zmdi-open-in-new") + h.content_tag(:span, link)

    object.en_published? ? h.link_to(text, link, target: '_blank') : link
  end
end
