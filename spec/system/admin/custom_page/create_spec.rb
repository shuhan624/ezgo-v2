require 'rails_helper'

RSpec.describe "新增單一頁面管理", type: :system do
  let(:custom_page) { create(:custom_page) }

  before(:all) do
    @permit_role = create(:role, permissions: {
      custom_page: {
        index: true,
        show: true,
        new: true,
        create: true,
      }
    })

    @no_create_permit_role = create(:role, permissions: {
      custom_page: {
        index: true,
        show: true,
        new: true,
      }
    })

    @cw_admin = create(:cw_chief)
    @admin_has_permissions = create(:admin, role: @permit_role)
    @no_create_permissions_admin = create(:admin, role: @no_create_permit_role)
    @no_permissions_admin = create(:admin, :no_permissions)
  end

  after(:all) do
    Admin.delete_all
    Role.delete_all
  end

#   ▄▄        ▄  ▄▄▄▄▄▄▄▄▄▄▄  ▄         ▄
#  ▐░░▌      ▐░▌▐░░░░░░░░░░░▌▐░▌       ▐░▌
#  ▐░▌░▌     ▐░▌▐░█▀▀▀▀▀▀▀▀▀ ▐░▌       ▐░▌
#  ▐░▌▐░▌    ▐░▌▐░▌          ▐░▌       ▐░▌
#  ▐░▌ ▐░▌   ▐░▌▐░█▄▄▄▄▄▄▄▄▄ ▐░▌   ▄   ▐░▌
#  ▐░▌  ▐░▌  ▐░▌▐░░░░░░░░░░░▌▐░▌  ▐░▌  ▐░▌
#  ▐░▌   ▐░▌ ▐░▌▐░█▀▀▀▀▀▀▀▀▀ ▐░▌ ▐░▌░▌ ▐░▌
#  ▐░▌    ▐░▌▐░▌▐░▌          ▐░▌▐░▌ ▐░▌▐░▌
#  ▐░▌     ▐░▐░▌▐░█▄▄▄▄▄▄▄▄▄ ▐░▌░▌   ▐░▐░▌
#  ▐░▌      ▐░░▌▐░░░░░░░░░░░▌▐░░▌     ▐░░▌
#   ▀        ▀▀  ▀▀▀▀▀▀▀▀▀▀▀  ▀▀       ▀▀
#

  context "新增頁面管理 (new)" do
    it "沒有 new 權限者，不能到達" do
      login_as(@no_permissions_admin, scope: :admin)
      visit new_admin_custom_page_path
      expect(page).to have_content("無權進行此操作")
    end

    it "有 new 權限者，可以到達" do
      login_as(@admin_has_permissions, scope: :admin)
      visit new_admin_custom_page_path
      expect(page).to have_content("新增頁面管理")
    end
  end

#   ▄▄▄▄▄▄▄▄▄▄▄  ▄▄▄▄▄▄▄▄▄▄▄  ▄            ▄         ▄  ▄▄       ▄▄  ▄▄        ▄
#  ▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌▐░▌          ▐░▌       ▐░▌▐░░▌     ▐░░▌▐░░▌      ▐░▌
#  ▐░█▀▀▀▀▀▀▀▀▀ ▐░█▀▀▀▀▀▀▀█░▌▐░▌          ▐░▌       ▐░▌▐░▌░▌   ▐░▐░▌▐░▌░▌     ▐░▌
#  ▐░▌          ▐░▌       ▐░▌▐░▌          ▐░▌       ▐░▌▐░▌▐░▌ ▐░▌▐░▌▐░▌▐░▌    ▐░▌
#  ▐░▌          ▐░▌       ▐░▌▐░▌          ▐░▌       ▐░▌▐░▌ ▐░▐░▌ ▐░▌▐░▌ ▐░▌   ▐░▌
#  ▐░▌          ▐░▌       ▐░▌▐░▌          ▐░▌       ▐░▌▐░▌  ▐░▌  ▐░▌▐░▌  ▐░▌  ▐░▌
#  ▐░▌          ▐░▌       ▐░▌▐░▌          ▐░▌       ▐░▌▐░▌   ▀   ▐░▌▐░▌   ▐░▌ ▐░▌
#  ▐░▌          ▐░▌       ▐░▌▐░▌          ▐░▌       ▐░▌▐░▌       ▐░▌▐░▌    ▐░▌▐░▌
#  ▐░█▄▄▄▄▄▄▄▄▄ ▐░█▄▄▄▄▄▄▄█░▌▐░█▄▄▄▄▄▄▄▄▄ ▐░█▄▄▄▄▄▄▄█░▌▐░▌       ▐░▌▐░▌     ▐░▐░▌
#  ▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌▐░▌       ▐░▌▐░▌      ▐░░▌
#   ▀▀▀▀▀▀▀▀▀▀▀  ▀▀▀▀▀▀▀▀▀▀▀  ▀▀▀▀▀▀▀▀▀▀▀  ▀▀▀▀▀▀▀▀▀▀▀  ▀         ▀  ▀        ▀▀
#

  context "頁面管理-內容類型" do
    it "前網管理員可以看到 內容類型 欄位" do
      login_as(@cw_admin, scope: :admin)
      visit new_admin_custom_page_path
      expect(page).to have_css('fieldset.radio_buttons.custom_page_custom_type')
    end

    it "非前網管理員，看不到 內容類型 欄位" do
      login_as(@admin_has_permissions, scope: :admin)
      visit new_admin_custom_page_path
      expect(page).not_to have_css('fieldset.radio_buttons.custom_page_custom_type')
    end
  end

#   ▄▄▄▄▄▄▄▄▄▄▄  ▄▄▄▄▄▄▄▄▄▄▄  ▄▄▄▄▄▄▄▄▄▄▄  ▄▄▄▄▄▄▄▄▄▄▄  ▄▄▄▄▄▄▄▄▄▄▄  ▄▄▄▄▄▄▄▄▄▄▄
#  ▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌
#  ▐░█▀▀▀▀▀▀▀▀▀ ▐░█▀▀▀▀▀▀▀█░▌▐░█▀▀▀▀▀▀▀▀▀ ▐░█▀▀▀▀▀▀▀█░▌ ▀▀▀▀█░█▀▀▀▀ ▐░█▀▀▀▀▀▀▀▀▀
#  ▐░▌          ▐░▌       ▐░▌▐░▌          ▐░▌       ▐░▌     ▐░▌     ▐░▌
#  ▐░▌          ▐░█▄▄▄▄▄▄▄█░▌▐░█▄▄▄▄▄▄▄▄▄ ▐░█▄▄▄▄▄▄▄█░▌     ▐░▌     ▐░█▄▄▄▄▄▄▄▄▄
#  ▐░▌          ▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌     ▐░▌     ▐░░░░░░░░░░░▌
#  ▐░▌          ▐░█▀▀▀▀█░█▀▀ ▐░█▀▀▀▀▀▀▀▀▀ ▐░█▀▀▀▀▀▀▀█░▌     ▐░▌     ▐░█▀▀▀▀▀▀▀▀▀
#  ▐░▌          ▐░▌     ▐░▌  ▐░▌          ▐░▌       ▐░▌     ▐░▌     ▐░▌
#  ▐░█▄▄▄▄▄▄▄▄▄ ▐░▌      ▐░▌ ▐░█▄▄▄▄▄▄▄▄▄ ▐░▌       ▐░▌     ▐░▌     ▐░█▄▄▄▄▄▄▄▄▄
#  ▐░░░░░░░░░░░▌▐░▌       ▐░▌▐░░░░░░░░░░░▌▐░▌       ▐░▌     ▐░▌     ▐░░░░░░░░░░░▌
#   ▀▀▀▀▀▀▀▀▀▀▀  ▀         ▀  ▀▀▀▀▀▀▀▀▀▀▀  ▀         ▀       ▀       ▀▀▀▀▀▀▀▀▀▀▀
#

  context "建立頁面管理 (Create)" do
    it "沒有 create 權限者，不能建立" do
      login_as(@no_create_permissions_admin, scope: :admin)
      fill_in_data_on_custom_page_form
      click_button("建立頁面管理")
      expect(page).to have_content("無權進行此操作")
    end

    it "有 create 權限者，可以建立" do
      login_as(@admin_has_permissions, scope: :admin)
      before_count = CustomPage.count
      fill_in_data_on_custom_page_form
      click_button("建立頁面管理")

      expected_content = find('section.content')
      title = CustomPage.order(created_at: :desc).first.title
      after_count = CustomPage.count

      expect(page).to have_content('成功新增 頁面管理')
      expect(expected_content).to have_content(title)
      expect(after_count).to eq(before_count + 1)
    end
  end

#   ▄▄       ▄▄  ▄▄▄▄▄▄▄▄▄▄▄  ▄▄▄▄▄▄▄▄▄▄▄  ▄         ▄  ▄▄▄▄▄▄▄▄▄▄▄  ▄▄▄▄▄▄▄▄▄▄
#  ▐░░▌     ▐░░▌▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌▐░▌       ▐░▌▐░░░░░░░░░░░▌▐░░░░░░░░░░▌
#  ▐░▌░▌   ▐░▐░▌▐░█▀▀▀▀▀▀▀▀▀  ▀▀▀▀█░█▀▀▀▀ ▐░▌       ▐░▌▐░█▀▀▀▀▀▀▀█░▌▐░█▀▀▀▀▀▀▀█░▌
#  ▐░▌▐░▌ ▐░▌▐░▌▐░▌               ▐░▌     ▐░▌       ▐░▌▐░▌       ▐░▌▐░▌       ▐░▌
#  ▐░▌ ▐░▐░▌ ▐░▌▐░█▄▄▄▄▄▄▄▄▄      ▐░▌     ▐░█▄▄▄▄▄▄▄█░▌▐░▌       ▐░▌▐░▌       ▐░▌
#  ▐░▌  ▐░▌  ▐░▌▐░░░░░░░░░░░▌     ▐░▌     ▐░░░░░░░░░░░▌▐░▌       ▐░▌▐░▌       ▐░▌
#  ▐░▌   ▀   ▐░▌▐░█▀▀▀▀▀▀▀▀▀      ▐░▌     ▐░█▀▀▀▀▀▀▀█░▌▐░▌       ▐░▌▐░▌       ▐░▌
#  ▐░▌       ▐░▌▐░▌               ▐░▌     ▐░▌       ▐░▌▐░▌       ▐░▌▐░▌       ▐░▌
#  ▐░▌       ▐░▌▐░█▄▄▄▄▄▄▄▄▄      ▐░▌     ▐░▌       ▐░▌▐░█▄▄▄▄▄▄▄█░▌▐░█▄▄▄▄▄▄▄█░▌
#  ▐░▌       ▐░▌▐░░░░░░░░░░░▌     ▐░▌     ▐░▌       ▐░▌▐░░░░░░░░░░░▌▐░░░░░░░░░░▌
#   ▀         ▀  ▀▀▀▀▀▀▀▀▀▀▀       ▀       ▀         ▀  ▀▀▀▀▀▀▀▀▀▀▀  ▀▀▀▀▀▀▀▀▀▀
#

  def fill_in_data_on_custom_page_form
    slug = FFaker::Internet.slug(nil, '-') + FFaker::Lorem.characters.first(5)
    title = FFaker::Lorem.characters.first(20)
    title_en = FFaker::Lorem.characters.first(20)
    content = FFaker::HTMLIpsum.body
    content_en = FFaker::HTMLIpsum.body
    visit new_admin_custom_page_path

    find('.tabs-group .tabs-btn').click_link('中文')
    fill_in("custom_page[slug]", with: slug)
    within('fieldset.radio_buttons.custom_page_status') do
      choose('公開', allow_label_click: true)
    end
    fill_in("custom_page[title]", with: title)

    fill_in_editor('custom_page_content', with: content)

    find('.tabs-group .tabs-btn').click_link('英文')
    fill_in("custom_page[title_en]", with: title_en)
    within('fieldset.radio_buttons.custom_page_en_status') do
      choose('公開', allow_label_click: true)
    end
    fill_in_editor('custom_page_content_en', with: content_en)
    scroll_to(find('.form-actions'), align: :top)
  end
end
