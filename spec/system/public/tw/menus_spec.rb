require 'rails_helper'

RSpec.describe "中文版 - 首頁", type: :system do
  before(:all) do
    Menu.where.not(parent_id: nil).delete_all # 先刪除除了 Header 以外的 seed 資料
    create(:tw_published_menu, title: '關於我們', position: 1)
    create(:tw_published_menu, title: '各國移民', position: 2, link: '/global-immigration')
    create(:tw_published_menu, title: '外僑學校', position: 3)
    create(:tw_published_menu, title: '最新消息', position: 4)
  end

  it "可以正常顯示 menu" do
    visit root_path
    Menu.header.children.each do |menu_item|
      expect(page).to have_content(menu_item.title)
    end
  end

  it "可以正常顯示 menu 的子選單" do
    about_menu = Menu.find_by(title: '各國移民')
    create(:tw_published_menu, parent: about_menu, title: '美國', link: '/usa')
    create(:tw_published_menu, parent: about_menu, title: '加拿大', link: '/canada')
    create(:tw_published_menu, parent: about_menu, title: '澳洲', link: '/australia')
    create(:tw_published_menu, parent: about_menu, title: '葡萄牙', link: '/portugal')
    create(:tw_published_menu, parent: about_menu, title: '英國', link: '/uk')
    create(:tw_published_menu, parent: about_menu, title: '希臘', link: '/greece')
    visit root_path
    find('.header-menu-link', text: '各國移民').hover
    within('.header-menu-dropdown') do
      expect(page).to have_content('美國')
      expect(page).to have_content('加拿大')
      expect(page).to have_content('澳洲')
    end
  end

  it "若是有異動順序，可以正常顯示 menu 的排列順序" do
    menu_item = Menu.find_by(title: '外僑學校')
    menu_item.insert_at(1)
    visit root_path
    within('.header-menu') do
      menu_items = all('.header-menu-link').map(&:text)
      expect(menu_items[0]).to eq('外僑學校')
      expect(menu_items[1]).to eq('關於我們')
    end
  end

  context "外部連結" do
    it "若是有設定 target 為 true, 可以在新分頁開啟頁面" do
      create(:tw_published_menu, title: '外部連結', link: 'https://www.example.com', target: true)
      visit root_path
      within('.header-menu') do
        click_on('外部連結')
      end
      within_window windows.last do
        expect(page).to have_current_path('https://www.example.com')
      end
    end
  end
end
