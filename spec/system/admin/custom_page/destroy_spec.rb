require 'rails_helper'

RSpec.describe "刪除單一頁面管理", type: :system do
  let(:custom_page) { create(:custom_page) }
  let(:default_custom_page) { create(:custom_page, :default_page) }

  before(:all) do
    @permit_role = create(:role, permissions: {
      custom_page: {
        index: true,
        show: true,
        edit: true,
        destroy: true,
      }
    })

    @no_permit_role = create(:role, permissions: {
      custom_page: {
        index: true,
        show: true,
        edit: true,
      }
    })

    @cw_admin = create(:cw_chief)
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

  context "在單一頁面管理編輯頁" do
    context "非預設頁面管理" do
      it "沒有 destroy 權限者，不可以看到「刪除」按鈕" do
        login_as(@no_permissions_admin, scope: :admin)
        visit edit_admin_custom_page_path(custom_page)
        expect(page).not_to have_css('.float-btns .btn-danger-light')
      end

      it "有 destroy 權限者，可以看到「刪除」按鈕" do
        login_as(@admin_has_permissions, scope: :admin)
        visit edit_admin_custom_page_path(custom_page)
        expect(page).to have_css('.float-btns .btn-danger-light')
      end

      it "有 destroy 權限者，可以「刪除」頁面管理" do
        login_as(@admin_has_permissions, scope: :admin)
        destroy_custom_page_on_edit_page
        notice = find('.bootstrap-notify-container')
        expect(notice).to have_content('成功删除 頁面管理')
        count = CustomPage.count
        expect(count).to eq(2)
      end

      it "前網管理員，可以「刪除」頁面管理" do
        login_as(@cw_admin, scope: :admin)
        destroy_custom_page_on_edit_page
        notice = find('.bootstrap-notify-container')
        expect(notice).to have_content('成功删除 頁面管理')
        count = CustomPage.count
        expect(count).to eq(2)
      end
    end

    context "預設頁面管理" do
      it "沒有 destroy 權限者，不可以看到「刪除」按鈕" do
        login_as(@no_permissions_admin, scope: :admin)
        visit edit_admin_custom_page_path(default_custom_page)
        expect(page).not_to have_css('.float-btns .btn-danger-light')
      end

      it "有 destroy 權限者，不可以看到「刪除」按鈕" do
        login_as(@admin_has_permissions, scope: :admin)
        visit edit_admin_custom_page_path(default_custom_page)
        expect(page).not_to have_css('.float-btns .btn-danger-light')
      end

      it "前網管理員，不可以看到「刪除」按鈕" do
        login_as(@cw_admin, scope: :admin)
        visit edit_admin_custom_page_path(default_custom_page)
        expect(page).not_to have_css('.float-btns .btn-danger-light')
      end
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

  context "在單一頁面管理檢視頁" do
    context "非預設頁面管理" do
      it "沒有 destroy 權限者，不可以看到「刪除」按鈕" do
        login_as(@no_permissions_admin, scope: :admin)
        visit admin_custom_page_path(custom_page)
        expect(page).not_to have_css('.float-btns .btn-danger-light')
      end

      it "有 destroy 權限者，可以看到「刪除」按鈕" do
        login_as(@admin_has_permissions, scope: :admin)
        visit admin_custom_page_path(custom_page)
        expect(page).to have_css('.float-btns .btn-danger-light')
      end

      it "有 destroy 權限者，可以「刪除」頁面管理" do
        login_as(@admin_has_permissions, scope: :admin)
        destroy_custom_page_on_show_page
        notice = find('.bootstrap-notify-container')
        expect(notice).to have_content('成功删除 頁面管理')
        count = CustomPage.count
        expect(count).to eq(2)
      end
    end

    context "預設頁面管理" do
      it "沒有 destroy 權限者，不可以看到「刪除」按鈕" do
        login_as(@no_permissions_admin, scope: :admin)
        visit edit_admin_custom_page_path(default_custom_page)
        expect(page).not_to have_css('.float-btns .btn-danger-light')
      end

      it "有 destroy 權限者，不可以看到「刪除」按鈕" do
        login_as(@admin_has_permissions, scope: :admin)
        visit edit_admin_custom_page_path(default_custom_page)
        expect(page).not_to have_css('.float-btns .btn-danger-light')
      end

      it "前網管理員，不可以看到「刪除」按鈕" do
        login_as(@cw_admin, scope: :admin)
        visit edit_admin_custom_page_path(default_custom_page)
        expect(page).not_to have_css('.float-btns .btn-danger-light')
      end
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

  def destroy_custom_page_on_edit_page
    custom_pages = create_list(:custom_page, 3)
    target_custom_page = custom_pages.first
    visit edit_admin_custom_page_path(target_custom_page)
    find('.float-btns .btn-danger-light', match: :first).click
    page.driver.browser.switch_to.alert.accept
  end

  def destroy_custom_page_on_show_page
    custom_pages = create_list(:custom_page, 3)
    target_custom_page = custom_pages.first
    visit admin_custom_page_path(target_custom_page)
    find('.float-btns .btn-danger-light', match: :first).click
    page.driver.browser.switch_to.alert.accept
  end
end
