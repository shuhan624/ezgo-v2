require 'rails_helper'

RSpec.describe "編輯單一常見問題頁面", type: :system do
  let(:faq_category) { create(:faq_category) }
  let(:faq) { create(:faq) }
  let(:faqs) { create_list(:faq, 5) }

  before(:all) do
    @permit_role = create(:role, permissions: {
      faq: {
        index: true,
        show: true,
        new: true,
        create: true,
        edit: true,
        update: true,
      }
    })
    @no_permit_role = create(:role, permissions: {
      faq: {
        index: true,
        show: true,
        edit: true,
      }
    })
    @no_edit_permit_role = create(:role, permissions: {
      faq: {
        index: true,
        show: true,
      }
    })

    @admin_has_permissions = create(:admin, role: @permit_role)
    @no_permissions_admin = create(:admin, role: @no_permit_role)
    @no_edit_permissions_admin = create(:admin, role: @no_edit_permit_role)
  end

  after(:all) do
    Admin.delete_all
    Role.delete_all
  end


#   ▄▄▄▄▄▄▄▄▄▄▄  ▄▄▄▄▄▄▄▄▄▄   ▄▄▄▄▄▄▄▄▄▄▄  ▄▄▄▄▄▄▄▄▄▄▄
#  ▐░░░░░░░░░░░▌▐░░░░░░░░░░▌ ▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌
#  ▐░█▀▀▀▀▀▀▀▀▀ ▐░█▀▀▀▀▀▀▀█░▌ ▀▀▀▀█░█▀▀▀▀  ▀▀▀▀█░█▀▀▀▀
#  ▐░▌          ▐░▌       ▐░▌     ▐░▌          ▐░▌
#  ▐░█▄▄▄▄▄▄▄▄▄ ▐░▌       ▐░▌     ▐░▌          ▐░▌
#  ▐░░░░░░░░░░░▌▐░▌       ▐░▌     ▐░▌          ▐░▌
#  ▐░█▀▀▀▀▀▀▀▀▀ ▐░▌       ▐░▌     ▐░▌          ▐░▌
#  ▐░▌          ▐░▌       ▐░▌     ▐░▌          ▐░▌
#  ▐░█▄▄▄▄▄▄▄▄▄ ▐░█▄▄▄▄▄▄▄█░▌ ▄▄▄▄█░█▄▄▄▄      ▐░▌
#  ▐░░░░░░░░░░░▌▐░░░░░░░░░░▌ ▐░░░░░░░░░░░▌     ▐░▌
#   ▀▀▀▀▀▀▀▀▀▀▀  ▀▀▀▀▀▀▀▀▀▀   ▀▀▀▀▀▀▀▀▀▀▀       ▀
#

  context "編輯常見問題頁面 (edit)" do
    it "沒有 edit 權限者，不可以看到" do
      login_as(@no_edit_permissions_admin, scope: :admin)
      visit edit_admin_faq_path(faq)
      expect(page).to have_content("無權進行此操作")
    end

    it "有 edit 權限者，可以到達" do
      login_as(@admin_has_permissions, scope: :admin)
      visit edit_admin_faq_path(faq)
      expect(page).to have_content("編輯常見問題")
    end
  end

  context "按鈕區塊" do
    let(:edit_permission_role) { create(:role, permissions: {
      faq: { index: true, edit: true, }
    }) }

    let(:show_permission_role) { create(:role, permissions: {
      faq: { index: true, show: true, edit: true }
    }) }

    let(:destroy_permission_role) { create(:role, permissions: {
      faq: { index: true, show: true, edit: true, destroy: true }
    }) }

    let(:edit_permission_admin) { create(:admin, role: edit_permission_role) }
    let(:show_permission_admin) { create(:admin, role: show_permission_role) }
    let(:destroy_permission_admin) { create(:admin, role: destroy_permission_role) }

    context "詳細按鈕 (show)" do
      it "沒有 show 權限者，不可以看到" do
        login_as(edit_permission_admin, scope: :admin)
        visit edit_admin_faq_path(faq)
        expected_content = find('.float-btns')
        expect(expected_content).not_to have_content(I18n.t('btn.show'))
      end

      it "有 show 權限者，可以看到" do
        login_as(show_permission_admin, scope: :admin)
        visit edit_admin_faq_path(faq)
        expected_content = find('.float-btns')
        expect(expected_content).to have_content(I18n.t('btn.show'))
      end
    end

    context "刪除按鈕 (destroy)" do
      it "沒有 destroy 權限者，不可以看到" do
        login_as(edit_permission_admin, scope: :admin)
        visit edit_admin_faq_path(faq)
        expected_content = find('.float-btns')
        expect(expected_content).not_to have_css('.btn-danger-light')
      end

      it "有 destroy 權限者，可以看到" do
        login_as(destroy_permission_admin, scope: :admin)
        visit edit_admin_faq_path(faq)
        expected_content = find('.float-btns')
        expect(expected_content).to have_css('.btn-danger-light')
      end
    end
  end

#   ▄         ▄  ▄▄▄▄▄▄▄▄▄▄▄  ▄▄▄▄▄▄▄▄▄▄   ▄▄▄▄▄▄▄▄▄▄▄  ▄▄▄▄▄▄▄▄▄▄▄  ▄▄▄▄▄▄▄▄▄▄▄
#  ▐░▌       ▐░▌▐░░░░░░░░░░░▌▐░░░░░░░░░░▌ ▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌
#  ▐░▌       ▐░▌▐░█▀▀▀▀▀▀▀█░▌▐░█▀▀▀▀▀▀▀█░▌▐░█▀▀▀▀▀▀▀█░▌ ▀▀▀▀█░█▀▀▀▀ ▐░█▀▀▀▀▀▀▀▀▀
#  ▐░▌       ▐░▌▐░▌       ▐░▌▐░▌       ▐░▌▐░▌       ▐░▌     ▐░▌     ▐░▌
#  ▐░▌       ▐░▌▐░█▄▄▄▄▄▄▄█░▌▐░▌       ▐░▌▐░█▄▄▄▄▄▄▄█░▌     ▐░▌     ▐░█▄▄▄▄▄▄▄▄▄
#  ▐░▌       ▐░▌▐░░░░░░░░░░░▌▐░▌       ▐░▌▐░░░░░░░░░░░▌     ▐░▌     ▐░░░░░░░░░░░▌
#  ▐░▌       ▐░▌▐░█▀▀▀▀▀▀▀▀▀ ▐░▌       ▐░▌▐░█▀▀▀▀▀▀▀█░▌     ▐░▌     ▐░█▀▀▀▀▀▀▀▀▀
#  ▐░▌       ▐░▌▐░▌          ▐░▌       ▐░▌▐░▌       ▐░▌     ▐░▌     ▐░▌
#  ▐░█▄▄▄▄▄▄▄█░▌▐░▌          ▐░█▄▄▄▄▄▄▄█░▌▐░▌       ▐░▌     ▐░▌     ▐░█▄▄▄▄▄▄▄▄▄
#  ▐░░░░░░░░░░░▌▐░▌          ▐░░░░░░░░░░▌ ▐░▌       ▐░▌     ▐░▌     ▐░░░░░░░░░░░▌
#   ▀▀▀▀▀▀▀▀▀▀▀  ▀            ▀▀▀▀▀▀▀▀▀▀   ▀         ▀       ▀       ▀▀▀▀▀▀▀▀▀▀▀
#

  context '更新常見問題' do
    it "沒有 update 權限者，不可以更新" do
      login_as(@no_permissions_admin, scope: :admin)
      fill_in_data_on_faq_form
      click_button("更新常見問題")
      expect(page).to have_content("無權進行此操作")
    end

    it "有 update 權限者，可以更新" do
      login_as(@admin_has_permissions, scope: :admin)
      fill_in_data_on_faq_form
      click_button("更新常見問題")
      expect(page).to have_content('成功更新 常見問題')
      find('.tabs-group .tabs-btn').click_link('中文')
      expect(page).to have_content('新的常見問題標題')
      find('.tabs-group .tabs-btn').click_link('英文')
      expect(page).to have_content('New FAQ Title')
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

  def fill_in_data_on_faq_form
    faq_category
    faq
    title = '新的常見問題標題'
    title_en = 'New FAQ Title'
    visit edit_admin_faq_path(faq)

    within('fieldset.radio_buttons.faq_faq_category') do
      choose(faq_category.name, allow_label_click: true)
    end

    find('.tabs-group .tabs-btn').click_link('中文')
    fill_in("faq[title]", with: title)
    within('fieldset.radio_buttons.faq_status') do
      choose('公開', allow_label_click: true)
    end
    fill_in_editor('faq_content', with: FFaker::HTMLIpsum.body)

    find('.tabs-group .tabs-btn').click_link('英文')
    fill_in("faq[title_en]", with: title_en)
    within('fieldset.radio_buttons.faq_en_status') do
      choose('公開', allow_label_click: true)
    end
    fill_in_editor('faq_content_en', with: FFaker::HTMLIpsum.body)
  end
end
