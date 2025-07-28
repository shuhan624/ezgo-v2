require 'rails_helper'

RSpec.describe "刪除單一管理帳號", type: :system do
  let(:admin) { create(:admin) }

  before(:all) do
    @permit_role = create(:role,
      name: 'permit_role',
      permissions: {
        admin: {
          index: true,
          show: true,
          edit: true,
          destroy: true,
        }
      }
    )

    @no_permit_role = create(:role,
      name: 'no_permit_role',
      permissions: {
        admin: {
          index: true,
          show: true,
          edit: true,
        }
      }
    )

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

  context "在單一管理帳號編輯頁" do
    it "沒有 destroy 權限者，不可以看到「刪除」按鈕" do
      login_as(@no_permissions_admin, scope: :admin)
      visit edit_admin_admin_path(admin)
      expect(page).not_to have_css('a.btn-danger-light')
    end

    it "有 destroy 權限者，可以看到「刪除」按鈕" do
      login_as(@admin_has_permissions, scope: :admin)
      visit edit_admin_admin_path(admin)
      expect(page).to have_css('a.btn-danger-light')
    end

    it "有 destroy 權限者，可以「刪除」管理帳號" do
      login_as(@admin_has_permissions, scope: :admin)
      destroy_admin_on_edit_page
      notice = find('.bootstrap-notify-container')
      expect(notice).to have_content('成功删除 管理帳號')
      count = Admin.count
      expect(count).to eq(6) # 要加上兩個 admin 的預設帳號(permit_role, no_permit_role)
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

  context "在單一管理帳號檢視頁" do
    it "沒有 destroy 權限者，不可以看到「刪除」按鈕" do
      login_as(@no_permissions_admin, scope: :admin)
      visit admin_admin_path(admin)
      expect(page).not_to have_css('a.btn-danger-light')
    end

    it "有 destroy 權限者，可以看到「刪除」按鈕" do
      login_as(@admin_has_permissions, scope: :admin)
      visit admin_admin_path(admin)
      expect(page).to have_css('a.btn-danger-light')
    end

    it "有 destroy 權限者，可以「刪除」管理帳號" do
      login_as(@admin_has_permissions, scope: :admin)
      destroy_admin_on_show_page
      notice = find('.bootstrap-notify-container')
      expect(notice).to have_content('成功删除 管理帳號')
      count = Admin.count
      expect(count).to eq(6) # 要加上兩個 admin 的預設帳號(permit_role, no_permit_role)
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

  def destroy_admin_on_edit_page
    admins = create_list(:admin, 5)
    target_admin = admins.first
    visit edit_admin_admin_path(target_admin)
    find('a.btn-danger-light', match: :first).click
    page.driver.browser.switch_to.alert.accept
  end

  def destroy_admin_on_show_page
    admins = create_list(:admin, 5)
    target_admin = admins.first
    visit admin_admin_path(target_admin)
    find('a.btn-danger-light', match: :first).click
    page.driver.browser.switch_to.alert.accept
  end
end
