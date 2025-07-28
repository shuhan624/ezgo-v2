require 'rails_helper'

RSpec.describe "刪除單一常見問題分類", type: :system do
  let(:faq_category) { create(:faq_category) }

  before(:all) do
    @permit_role = create(:role, permissions: {
      faq_category: {
        index: true,
        show: true,
        edit: true,
        destroy: true,
      }
    })
    @no_permit_role = create(:role, permissions: {
      faq_category: {
        index: true,
        show: true,
        edit: true,
      }
    })

    @admin_has_permissions = create(:admin, role: @permit_role)
    @no_permissions_admin = create(:admin, role: @no_permit_role)
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

  context "在單一常見問題分類編輯頁" do
    it "沒有 destroy 權限者，不可以看到「刪除」按鈕" do
      login_as(@no_permissions_admin, scope: :admin)
      visit edit_admin_faq_category_path(faq_category)
      expect(page).not_to have_css('.float-btns .btn-danger-light')
    end

    it "有 destroy 權限者，可以看到「刪除」按鈕" do
      login_as(@admin_has_permissions, scope: :admin)
      visit edit_admin_faq_category_path(faq_category)
      expect(page).to have_css('.float-btns .btn-danger-light')
    end

    it "有 destroy 權限者，可以「刪除」常見問題分類" do
      login_as(@admin_has_permissions, scope: :admin)
      destroy_faq_category_on_edit_page
      notice = find('.bootstrap-notify-container')
      expect(notice).to have_content('成功删除 常見問題分類')
      count = FaqCategory.count
      expect(count).to eq(4)
    end
  end

#   ▄▄▄▄▄▄▄▄▄▄▄  ▄         ▄  ▄▄▄▄▄▄▄▄▄▄▄  ▄         ▄
#  ▐░░░░░░░░░░░▌▐░▌       ▐░▌▐░░░░░░░░░░░▌▐░▌       ▐░▌
#  ▐░█▀▀▀▀▀▀▀▀▀ ▐░▌       ▐░▌▐░█▀▀▀▀▀▀▀█░▌▐░▌       ▐░▌
#  ▐░▌          ▐░▌       ▐░▌▐░▌       ▐░▌▐░▌       ▐░▌
#  ▐░█▄▄▄▄▄▄▄▄▄ ▐░█▄▄▄▄▄▄▄█░▌▐░▌       ▐░▌▐░▌   ▄   ▐░▌
#  ▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌▐░▌       ▐░▌▐░▌  ▐░▌  ▐░▌
#   ▀▀▀▀▀▀▀▀▀█░▌▐░█▀▀▀▀▀▀▀█░▌▐░▌       ▐░▌▐░▌ ▐░▌░▌ ▐░▌
#            ▐░▌▐░▌       ▐░▌▐░▌       ▐░▌▐░▌▐░▌ ▐░▌▐░▌
#   ▄▄▄▄▄▄▄▄▄█░▌▐░▌       ▐░▌▐░█▄▄▄▄▄▄▄█░▌▐░▌░▌   ▐░▐░▌
#  ▐░░░░░░░░░░░▌▐░▌       ▐░▌▐░░░░░░░░░░░▌▐░░▌     ▐░░▌
#   ▀▀▀▀▀▀▀▀▀▀▀  ▀         ▀  ▀▀▀▀▀▀▀▀▀▀▀  ▀▀       ▀▀
#

  context "在單一常見問題分類檢視頁" do
    it "沒有 destroy 權限者，不可以看到「刪除」按鈕" do
      login_as(@no_permissions_admin, scope: :admin)
      visit admin_faq_category_path(faq_category)
      expect(page).not_to have_css('.float-btns .btn-danger-light')
    end

    it "有 destroy 權限者，可以看到「刪除」按鈕" do
      login_as(@admin_has_permissions, scope: :admin)
      visit admin_faq_category_path(faq_category)
      expect(page).to have_css('.float-btns .btn-danger-light')
    end

    it "有 destroy 權限者，可以「刪除」常見問題分類" do
      login_as(@admin_has_permissions, scope: :admin)
      destroy_faq_category_on_show_page
      notice = find('.bootstrap-notify-container')
      expect(notice).to have_content('成功删除 常見問題分類')
      count = FaqCategory.count
      expect(count).to eq(4)
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

  def destroy_faq_category_on_edit_page
    faq_categories = create_list(:faq_category, 5)
    target_faq_category = faq_categories.first
    visit edit_admin_faq_category_path(target_faq_category)
    find('.float-btns .btn-danger-light', match: :first).click
    page.driver.browser.switch_to.alert.accept
  end

  def destroy_faq_category_on_show_page
    faq_categories = create_list(:faq_category, 5)
    target_faq_category = faq_categories.first
    visit admin_faq_category_path(target_faq_category)
    find('.float-btns .btn-danger-light', match: :first).click
    page.driver.browser.switch_to.alert.accept
  end
end
