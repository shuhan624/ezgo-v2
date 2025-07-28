require 'rails_helper'

RSpec.describe "英文版 - 首頁", type: :system do
  before(:all) do
    Menu.where.not(parent_id: nil).delete_all # 先刪除除了 Header 以外的 seed 資料
    create(:en_published_menu, title_en: 'About Us', position: 1)
    create(:en_published_menu, title_en: 'Products', position: 2, link_en: '/products')
    create(:en_published_menu, title_en: 'Latest News', position: 3)
    create(:en_published_menu, title_en: 'FAQs', position: 4, link_en: '/faqs')
  end

  it "可以正常顯示 menu" do
    visit root_path
    within('.header-menu') do
      Menu.header.children.each do |menu_item|
        expect(page).to have_content(menu_item.title_en)
      end
    end
  end

  it "可以正常顯示 menu 的子選單" do
    about_menu = Menu.find_by(title_en: 'About Us')
    create(:en_published_menu, parent: about_menu, title_en: 'About EZGO', link_en: '/about')
    create(:en_published_menu, parent: about_menu, title_en: 'Team', link_en: '/team')
    create(:en_published_menu, parent: about_menu, title_en: 'Background', link_en: '/background')
    create(:en_published_menu, parent: about_menu, title_en: 'Milestones', link_en: '/milestones')
    create(:en_published_menu, parent: about_menu, title_en: 'Our Awards', link_en: '/our-awards')
    create(:en_published_menu, parent: about_menu, title_en: 'Future Vision', link_en: '/future-vision')
    visit root_path
    find('.header-menu-link', text: 'About Us').hover
    within('.header-menu-dropdown') do
      expect(page).to have_content('About EZGO')
      expect(page).to have_content('Team')
      expect(page).to have_content('Background')
      expect(page).to have_content('Milestones')
      expect(page).to have_content('Our Awards')
      expect(page).to have_content('Future Vision')
    end
  end

  it "若是有異動順序，可以正常顯示 menu 的排列順序" do
    menu_item = Menu.find_by(title_en: 'Products')
    menu_item.insert_at(1)
    visit root_path
    within('.header-menu') do
      menu_items = all('.header-menu-link').map(&:text)
      expect(menu_items[0]).to eq('Products')
      expect(menu_items[1]).to eq('About Us')
    end
  end

  context "外部連結" do
    it "若是有設定 target 為 true, 可以在新分頁開啟頁面" do
      create(:en_published_menu, title_en: 'External', link_en: 'https://www.example.com/en', target: true)
      visit root_path
      within('.header-menu') do
        click_on('External')
      end
      within_window windows.last do
        expect(page).to have_current_path('https://www.example.com/en')
      end
    end
  end
end

