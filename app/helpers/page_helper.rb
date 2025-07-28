# frozen_string_literal: true

module PageHelper
  def zmdi_icon(icon, options = {})
    content_tag(:i, nil, class: "zmdi zmdi-#{icon}") + content_tag(:span, options[:text])
  end

  # def fas_icon(icon, options = {})
  #   content_tag(:i, nil, class: "fas fa-#{icon}") + content_tag(:span, options[:text])
  # end

  # def fab_icon(icon, options = {})
  #   content_tag(:i, nil, class: "fab fa-#{icon}") + content_tag(:span, options[:text])
  # end

  def fa_icon(icon, options = {})
    content_tag(:i, nil, class: "fa-solid fa-#{icon}") + content_tag(:span, options[:text])
  end

  def handle_icon(title: '拖曳排序', th_class: 'handle check-column-th')
    content_tag(:th, class: th_class) do
      image_tag("admin/handle.svg", title: title, data: { bs_toggle: 'tooltip', placement: 'top' })
    end
  end

  def render_sidebar(links)
    links.reduce(''.html_safe) do |content, link|
      next content unless link[:display]

      content + (link[:dropdown] ? render_sidebar_dropdown_block(link) : render_sidebar_link(link))
    end
  end

  def render_sidebar_link(link)
    li_classes = ['nav-item']
    li_classes << 'active open' if link[:active]

    a_classes = ['nav-link']
    a_classes << 'active' if link[:active]

    content_tag(:li, class: li_classes.compact.join(' ')) do
      link_to(link[:title], link[:url], class: a_classes.compact.join(' '))
    end
  end

  def render_sidebar_dropdown_block(link)
    li_classes = ['nav-item']
    li_classes << 'active open' if link[:active]
    content_tag(:li, class: li_classes.compact.join(' ')) do
      link_to(link[:title], 'javascript:void(0);', class: "nav-link menu-toggle") + content_tag(:ul, class: 'ml-menu') do
        link[:dropdown].reduce(''.html_safe) do |content, sublink|
          next content unless sublink[:display]
          content + render_sidebar_dropdown_link(sublink)
        end
      end
    end
  end

  def render_sidebar_dropdown_link(link)
    content_tag(:li, class: ('active' if link[:active])) do
      link_to link[:title], link[:url], class: ('' if link[:active])
    end
  end

  ####### Sidebar in Public Start #######
  def public_sidebar(items)
    items.reduce(''.html_safe) do |content, item|
      content + (item[:sub_menu] ? public_sidebar_sub_menu(item) : public_sidebar_link(item))
    end
  end

  def public_sidebar_link(item)
    content_tag :li, class: (current_page?(item[:path]) ? 'static-menu-item active' : 'static-menu-item') do
      link_to item[:title], item[:path], target: item[:target]
    end
  end

  def public_sidebar_sub_menu(item)
    content_tag(:li, class: 'left-nav-item') do
      active_ul = item[:sub_menu].find { |sub_item| current_page?(sub_item[:path]) }.present? ? 'active' : ''
      link_to(item[:title], 'javascript:void(0);') + content_tag(:ul, class: active_ul) do
        item[:sub_menu].reduce(''.html_safe) do |content, sublink|
          content + public_sidebar_sub_menu_link(sublink)
        end
      end
    end
  end

  def public_sidebar_sub_menu_link(item)
    content_tag(:li, class: ('active' if current_page?(item[:path]))) do
      link_to item[:title], item[:path]
    end
  end
  ####### Sidebar in Public End #######

  ####### Header Menu in Public Start #######
  def render_header(menus)
    menus.reduce(''.html_safe) do |content, item|
      # leaf? 表示是否為葉子節點 (沒有子節點)
      content + (item.leaf? ? header_link(item.decorate) : header_dropdown_menu(item.decorate))
    end
  end

  def header_link(item)
    content_tag :li, class: 'header-menu-link' do
      link_to item.title_i18n, item.link_i18n, class: 'menu-link', target: (item.target ? '_blank' : nil)
    end
  end

  def header_dropdown_menu(item)
    content_tag :li, class: 'header-menu-link dropdown' do
      content_tag(:div, item.title_i18n, class: 'menu-link') +
      content_tag(:div, class: 'header-menu-dropdown') do
        item.children.publics(I18n.locale).reduce(''.html_safe) do |content, child|
          content + (child.leaf? ? link_item(child.decorate) : sub_dropdown_menu(child.decorate))
        end
      end
    end
  end

  def sub_dropdown_menu(item)
    content_tag :div, class: 'dropdown-link dropdown' do
      content_tag(:div, item.title_i18n, class: 'menu-link') +
      content_tag(:div, class: 'sub-menu-dropdown') do
        content_tag(:div, class: 'sub-menu-dropdown-inner') do
          item.children.publics(I18n.locale).reduce(''.html_safe) do |content, child|
            content + (child.leaf? ? link_item(child.decorate) : sub_dropdown_menu(child.decorate))
          end
        end
      end
    end
  end

  def link_item(item)
    link_to(item.title_i18n, item.link_i18n, class: 'dropdown-link', target: (item.target ? '_blank' : nil))
  end

  ####### Header Menu in Public End #######

  def external_url(url)
    return if url.blank?
    url.start_with?('http') ? url : "https://#{url}"
  end
end
