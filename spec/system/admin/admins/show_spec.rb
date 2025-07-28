require 'rails_helper'

RSpec.describe "檢視單一管理帳號頁面", type: :system do
  let(:admin) { create(:admin) }

  before(:all) do
    @admin_show_role = create(:role, permissions: {
      admin: {
        index: true,
        show: true,
      }
    })
    @show_permissions_admin = create(:admin, role: @admin_show_role)
    @no_permissions_admin = create(:admin, :no_permissions)
  end

  after(:all) do
    Admin.delete_all
    Role.delete_all
  end

  context "權限" do
    it "沒有 show 權限者，不能到達" do
      login_as(@no_permissions_admin, scope: :admin)
      admin
      visit admin_admin_path(admin)
      expect(page).to have_content("無權進行此操作")
    end

    it "有 show 權限者，可以到達" do
      login_as(@show_permissions_admin, scope: :admin)
      admin
      visit admin_admin_path(admin)
      expect(page).to have_text(admin.email)
    end
  end

  context "頁面內容" do
    let(:admin) { create(:admin, :with_name) }

    context "基本資訊" do
      before do
        login_as(@show_permissions_admin, scope: :admin)
      end

      it "可以看到「電子郵件」" do
        visit admin_admin_path(admin)
        expect(page).to have_text(admin.email)
      end

      it "可以看到「名稱」" do
        visit admin_admin_path(admin)
        expect(page).to have_text(admin.name)
      end

      it "可以看到「角色名稱」" do
        visit admin_admin_path(admin)
        expect(page).to have_text(admin.role.name)
      end

      context "可以看到「帳號狀態」" do
        it "當帳號為「啟用」狀態時，可以看到「綠色」圖示" do
          admin.update(account_active: true)
          visit admin_admin_path(admin)
          expect(page).to have_xpath("//img[contains(@src,admin/status_visible.svg)]")
        end

        it "當帳號為「禁用」狀態時，可以看到「灰色」圖示" do
          admin.update(account_active: false)
          visit admin_admin_path(admin)
          expect(page).to have_xpath("//img[contains(@src,admin/status_invisible.svg)]")
        end
      end
    end

    context "時間資訊" do
      before do
        login_as(@show_permissions_admin, scope: :admin)
      end

      it "可以看到「上次登入於」" do
        admin.update(last_sign_in_at: Time.current)
        visit admin_admin_path(admin)
        expect(page).to have_text('上次登入於')
        expect(page).to have_text(admin.last_sign_in_at.strftime("%F %R"))
      end

      it "可以看到「更新於」" do
        visit admin_admin_path(admin)
        expect(page).to have_text('更新於')
        expect(page).to have_text(admin.updated_at.strftime("%F %R"))
      end

      it "可以看到「建立於」" do
        visit admin_admin_path(admin)
        expect(page).to have_text('建立於')
        expect(page).to have_text(admin.created_at.strftime("%F %R"))
      end
    end

    context "操作紀錄" do
      let(:audit_permission_role) { create(:role, permissions: {
        admin: { index: true, show: true, audit: true }
      }) }

      let(:audit_permission_admin) { create(:admin, role: audit_permission_role) }

      it "有 audit 權限者，可以看到「活動紀錄」" do
        login_as(audit_permission_admin, scope: :admin)
        visit admin_admin_path(admin)
        expect(page).to have_css('.record')
      end

      it "沒有 audit 權限者，看不到「活動紀錄」" do
        login_as(@show_permissions_admin, scope: :admin)
        visit admin_admin_path(admin)
        expect(page).not_to have_css('.record')
      end
    end
  end

  context "按鈕區塊" do
    let(:show_permission_role) { create(:role, permissions: {
      admin: { index: true, show: true }
    }) }

    let(:edit_permission_role) { create(:role, permissions: {
      admin: { index: true, show: true, edit: true }
    }) }

    let(:destroy_permission_role) { create(:role, permissions: {
      admin: { index: true, show: true, destroy: true }
    }) }

    let(:show_permission_admin) { create(:admin, role: show_permission_role) }
    let(:edit_permission_admin) { create(:admin, role: edit_permission_role) }
    let(:destroy_permission_admin) { create(:admin, role: destroy_permission_role) }

    context "編輯按鈕 (edit)" do
      it "沒有 edit 權限者，不可以看到" do
        login_as(show_permission_admin, scope: :admin)
        visit admin_admin_path(admin)
        expected_content = find('.float-btns')
        expect(expected_content).not_to have_content(I18n.t('btn.edit'))
      end

      it "有 edit 權限者，可以看到" do
        login_as(edit_permission_admin, scope: :admin)
        visit admin_admin_path(admin)
        expected_content = find('.float-btns')
        expect(expected_content).to have_content(I18n.t('btn.edit'))
      end
    end

    context "刪除按鈕 (destroy)" do
      it "沒有 destroy 權限者，不可以看到" do
        login_as(show_permission_admin, scope: :admin)
        visit admin_admin_path(admin)
        expected_content = find('.float-btns')
        expect(expected_content).not_to have_css('.btn-danger-light')
      end

      it "有 destroy 權限者，可以看到" do
        login_as(destroy_permission_admin, scope: :admin)
        visit admin_admin_path(admin)
        expected_content = find('.float-btns')
        expect(expected_content).to have_css('.btn-danger-light')
      end
    end
  end
end
