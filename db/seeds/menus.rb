header_menus = {
  title: '主選單',
  title_en: 'Header',
  children: [
    {
      title: '關於我們',
      title_en: 'About Us',
      link: '/about',
      link_en: '/en/about',
      position: 1,
    },
    {
      title: '移民國家',
      title_en: 'Global Immigration',
      link: '/global-immigration',
      link_en: '/en/global-immigration',
      position: 2,
    },
    {
      title: '外僑學校',
      title_en: 'International Schools',
      link: '/international-schools',
      link_en: '/en/international-schools',
      position: 3,
    },
    {
      title: '最新消息',
      title_en: 'News',
      link: '/news',
      link_en: '/en/news',
      position: 4,
    },
    {
      title: '聯絡我們',
      title_en: 'Contact Us',
      link: '/contact',
      link_en: '/en/contact',
      position: 5,
    },
  ]
}

def create_menu_recursively(menu_item, parent_id = nil)
  menu_data = menu_item.except(:children)
                       .merge(
                          parent_id: parent_id,
                          status: 'published',
                          en_status: 'published'
                       )
  created_menu = Menu.create!(menu_data)

  if menu_item[:children].present?
    menu_item[:children].each do |child|
      create_menu_recursively(child, created_menu.id)
    end
  end
end

create_menu_recursively(header_menus)
