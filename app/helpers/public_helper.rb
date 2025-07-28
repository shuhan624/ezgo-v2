module PublicHelper
  def image_tag(image_path, options = {})
    super if image_path
  rescue StandardError
    if options[:onerror]
      image_tag options.delete(:onerror), options
    else
      image_tag '', options
    end
  end

  def favicon_helper
    @favicon.attached? ? favicon_link_tag(rails_blob_path(@favicon)) : favicon_link_tag
  end

  def slide_picture_tag(slide, options = {})
    content_tag(:picture) do
      concat content_tag(:source, nil, srcset: rails_storage_proxy_url(slide.banner_m.variant(resize_to_fill: [640, 540], convert: :webp, format: :webp, saver: {strip: true, quality: 80 }).processed, only_path: true), media: "(max-width: 600px)") if slide.banner_m.attached?
      concat content_tag(:source, nil, srcset: rails_storage_proxy_url(slide.banner.variant(resize_to_fill: [2000, 722], convert: :webp, format: :webp, saver: {strip: true, quality: 80 }).processed, only_path: true), type: "image/webp") if slide.banner.attached?
      concat image_tag(slide.banner.variant(resize_to_fill: [2000, 722]).processed, alt: slide.title, class: 'img-ab-cover')
    end
  end

  def default_meta_tags
    # alternate_links = {
    #                     locales[:'zh-TW'][:lang] => url_for(host: locales[:'zh-TW'][:domain], only_path: false, params: request.params.except(:id, :category, :controller, :action)),
    #                     'x-default' => url_for(host: locales[:'zh-TW'][:domain], only_path: false, params: request.params.except(:id, :category, :controller, :action))
    #                   }
    # alternate_links[locales[:en][:lang]] = url_for(host: locales[:en][:domain], only_path: false, params: request.params.except(:id, :category, :controller, :action)) if have_en_page?

    {
      site: @site_title,
      reverse: true,
      keywords: @meta_keywords,
      description: @meta_desc,
      og: {
        type: 'website',
        title: @og_title,
        url: url_for(only_path: false),
        description: @og_desc,
        site_name: @site_title,
        image: {
          _: @og_image_url,
          width: 1200,
          height: 630
        }
      },
      canonical: url_for(only_path: false),
      # TODO: setup alternate herflang link for Multiple Languages for SEO
      # alternate: alternate_links
      # alternate: {
      #   locales[:'zh-TW'][:lang] => url_for(host: locales[:'zh-TW'][:domain], only_path: false),
      #   locales[:en][:lang] => url_for(host: locales[:en][:domain], only_path: false),
      #   'x-default' => url_for(host: locales[:'zh-TW'][:domain], only_path: false)
      # }
    }
  end
end
