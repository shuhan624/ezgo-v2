require 'rails_helper'

RSpec.describe "管理帳號彙整頁", type: :system do
  let(:admin) { create(:admin) }

  before(:all) do
    @admin_index_role = create(:role, permissions: {
      admin: {
        index: true,
      }
    })
    @index_permissions_admin = create(:admin, role: @admin_index_role)
    @no_permissions_admin = create(:admin, :no_permissions)
  end

  after(:all) do
    Admin.delete_all
    Role.delete_all
  end

#   ▄▄▄▄▄▄▄▄▄▄▄  ▄▄▄▄▄▄▄▄▄▄▄  ▄▄▄▄▄▄▄▄▄▄   ▄▄▄▄▄▄▄▄▄▄▄
#  ▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌▐░░░░░░░░░░▌ ▐░░░░░░░░░░░▌
#  ▐░█▀▀▀▀▀▀▀▀▀  ▀▀▀▀█░█▀▀▀▀ ▐░█▀▀▀▀▀▀▀█░▌▐░█▀▀▀▀▀▀▀▀▀
#  ▐░▌               ▐░▌     ▐░▌       ▐░▌▐░▌
#  ▐░█▄▄▄▄▄▄▄▄▄      ▐░▌     ▐░▌       ▐░▌▐░█▄▄▄▄▄▄▄▄▄
#  ▐░░░░░░░░░░░▌     ▐░▌     ▐░▌       ▐░▌▐░░░░░░░░░░░▌
#   ▀▀▀▀▀▀▀▀▀█░▌     ▐░▌     ▐░▌       ▐░▌▐░█▀▀▀▀▀▀▀▀▀
#            ▐░▌     ▐░▌     ▐░▌       ▐░▌▐░▌
#   ▄▄▄▄▄▄▄▄▄█░▌ ▄▄▄▄█░█▄▄▄▄ ▐░█▄▄▄▄▄▄▄█░▌▐░█▄▄▄▄▄▄▄▄▄
#  ▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌▐░░░░░░░░░░▌ ▐░░░░░░░░░░░▌
#   ▀▀▀▀▀▀▀▀▀▀▀  ▀▀▀▀▀▀▀▀▀▀▀  ▀▀▀▀▀▀▀▀▀▀   ▀▀▀▀▀▀▀▀▀▀▀
#

  context "在側邊欄中的帳號管理項目" do
    it "沒有 index 權限者，不可以看到" do
      login_as(@no_permissions_admin, scope: :admin)
      visit admin_root_path
      menu = find('#leftsidebar')
      expect(menu).not_to have_text('後台帳號管理')
    end

    it "有 index 權限者，可以看到" do
      login_as(@index_permissions_admin, scope: :admin)
      visit admin_root_path
      menu = find('#leftsidebar')
      expect(menu).to have_text('後台帳號管理')
    end
  end

#   ▄▄▄▄▄▄▄▄▄▄▄  ▄▄        ▄  ▄▄▄▄▄▄▄▄▄▄   ▄▄▄▄▄▄▄▄▄▄▄  ▄       ▄
#  ▐░░░░░░░░░░░▌▐░░▌      ▐░▌▐░░░░░░░░░░▌ ▐░░░░░░░░░░░▌▐░▌     ▐░▌
#   ▀▀▀▀█░█▀▀▀▀ ▐░▌░▌     ▐░▌▐░█▀▀▀▀▀▀▀█░▌▐░█▀▀▀▀▀▀▀▀▀  ▐░▌   ▐░▌
#       ▐░▌     ▐░▌▐░▌    ▐░▌▐░▌       ▐░▌▐░▌            ▐░▌ ▐░▌
#       ▐░▌     ▐░▌ ▐░▌   ▐░▌▐░▌       ▐░▌▐░█▄▄▄▄▄▄▄▄▄    ▐░▐░▌
#       ▐░▌     ▐░▌  ▐░▌  ▐░▌▐░▌       ▐░▌▐░░░░░░░░░░░▌    ▐░▌
#       ▐░▌     ▐░▌   ▐░▌ ▐░▌▐░▌       ▐░▌▐░█▀▀▀▀▀▀▀▀▀    ▐░▌░▌
#       ▐░▌     ▐░▌    ▐░▌▐░▌▐░▌       ▐░▌▐░▌            ▐░▌ ▐░▌
#   ▄▄▄▄█░█▄▄▄▄ ▐░▌     ▐░▐░▌▐░█▄▄▄▄▄▄▄█░▌▐░█▄▄▄▄▄▄▄▄▄  ▐░▌   ▐░▌
#  ▐░░░░░░░░░░░▌▐░▌      ▐░░▌▐░░░░░░░░░░▌ ▐░░░░░░░░░░░▌▐░▌     ▐░▌
#   ▀▀▀▀▀▀▀▀▀▀▀  ▀        ▀▀  ▀▀▀▀▀▀▀▀▀▀   ▀▀▀▀▀▀▀▀▀▀▀  ▀       ▀
#

  context "管理帳號列表 (index)" do
    let!(:admin) { create(:admin) }
    it "沒有 index 權限者，不可以看到" do
      login_as(@no_permissions_admin, scope: :admin)
      visit admin_admins_path
      expect(page).to have_content("無權進行此操作")
    end

    it "有 index 權限者，可以看到" do
      login_as(@index_permissions_admin, scope: :admin)
      visit admin_admins_path
      expect(page).to have_text(admin.email)
    end
  end

  context "管理帳號列表頁面內容" do
    before { login_as(@index_permissions_admin, scope: :admin) }

    it "可以看到 email" do
      admin
      visit admin_admins_path
      expected_content = find('section.content table tbody')
      expect(expected_content).to have_content(admin.email)
    end

    it "可以看到 名稱" do
      admin = create(:admin, :with_name)
      visit admin_admins_path
      expected_content = find('section.content table tbody')
      expect(expected_content).to have_content(admin.name)
    end

    it "可以看到 角色" do
      admin = create(:admin)
      visit admin_admins_path
      expected_content = find('section.content table tbody')
      expect(expected_content).to have_content(admin.role.name)
    end
  end

  context "列表項目" do
    before { login_as(@index_permissions_admin, scope: :admin) }

    it "可以看到搜尋區塊" do
      visit admin_admins_path
      expect(page).to have_css('.index-search-form .search-form')
    end
  end

  context "分頁區塊" do
    before { login_as(@index_permissions_admin, scope: :admin) }
    it "可以看到分頁資訊" do
      visit admin_admins_path
      expect(page).to have_css('section .pagy-info')
    end

    context "未超過「25」筆資料" do
      before(:context) do
        @admins = create_list(:admin, 25 - Admin.count)
      end

      after(:context) do
        # 不能刪掉原本的登入角色，因此用 Model.delete(array) 刪除
        Admin.delete(@admins)
      end

      it "可以看到共有幾筆資料" do
        visit admin_admins_path
        expected_content = find('.pagy-info')
        scroll_to(expected_content, align: :top)
        expect(expected_content).to have_content('顯示 25 筆')
      end

      it "不可以看到分頁切換按鈕" do
        visit admin_admins_path
        expect(page).not_to have_css('.pagination')
      end
    end

    context "超過「25」筆資料" do
      before(:context) do
        @admins = create_list(:admin, 26 - Admin.count)
      end

      after(:context) do
        # 不能刪掉原本的登入角色，因此用 Model.delete(array) 刪除
        Admin.delete(@admins)
      end

      it "可以看到共有幾筆資料" do
        visit admin_admins_path
        expected_content = find('.pagy-info')
        scroll_to(expected_content, align: :top)
        expect(expected_content).to have_content('共 26 筆，顯示 1 - 25 筆')
      end

      it "每一頁不可以看到超過「25」筆資料" do
        admin = Admin.order(email: :asc).last # 取得最後一筆資料
        visit admin_admins_path
        scroll_to(find('table'), align: :bottom)
        expected_content = find('table')
        expect(expected_content).not_to have_content(admin.email)
        expect(expected_content).to have_css('tbody tr', count: 25)
      end

      it "需看到分頁切換按鈕" do
        visit admin_admins_path
        scroll_to(find('table'), align: :bottom)
        expect(page).to have_css('.pagination')
      end

      it "按下「指定分頁」按鈕，可以看到指定的分頁頁面" do
        visit admin_admins_path
        scroll_to(find('ul.pagination'), align: :bottom)
        click_link('2')
        expect(page).to have_current_path(admin_admins_path(page: 2))
        expect(page).to have_content('共 26 筆，顯示 26 - 26 筆')
      end

      it "按下「下一頁」按鈕，可以看到目前分頁的下一頁頁面" do
        visit admin_admins_path
        scroll_to(find('ul.pagination'), align: :bottom)

        find('ul.pagination li.next a').click
        expect(page).to have_current_path(admin_admins_path(page: 2))
        expect(page).to have_content('共 26 筆，顯示 26 - 26 筆')
      end

      it "按下「上一頁」按鈕，可以看到目前分頁的上一頁頁面" do
        visit admin_admins_path(page: 2)
        scroll_to(find('ul.pagination'), align: :bottom)

        find('ul.pagination li.prev a').click
        expect(page).to have_current_path(admin_admins_path)
        expect(page).to have_content('共 26 筆，顯示 1 - 25 筆')
      end

      it "當在第一頁時，「上一頁」按鈕，不可以點選" do
        visit admin_admins_path
        scroll_to(find('ul.pagination'), align: :bottom)
        expect(page).to have_css('ul.pagination li.prev.disabled')
      end

      it "當在最後一頁時，「下一頁」按鈕，不可以點選" do
        visit admin_admins_path(page: 2)
        scroll_to(find('ul.pagination'), align: :bottom)
        expect(page).to have_css('ul.pagination li.next.disabled')
      end
    end
  end

  context "按鈕區塊" do
    let(:index_permission_role) { create(:role, permissions: {
      admin: { index: true }
    }) }

    let(:show_permission_role) { create(:role, permissions: {
      admin: { index: true, show: true }
    }) }

    let(:edit_permission_role) { create(:role, permissions: {
      admin: { index: true, show: true, edit: true }
    }) }

    let(:destroy_permission_role) { create(:role, permissions: {
      admin: { index: true, show: true, destroy: true }
    }) }

    let(:index_permission_admin) { create(:admin, role: index_permission_role) }
    let(:show_permission_admin) { create(:admin, role: show_permission_role) }
    let(:edit_permission_admin) { create(:admin, role: edit_permission_role) }
    let(:destroy_permission_admin) { create(:admin, role: destroy_permission_role) }

    context "詳細按鈕 (show)" do
      it "沒有 show 權限者，不可以看到" do
        login_as(index_permission_admin, scope: :admin)
        visit admin_admins_path
        expected_content = find('td.index-table-action', match: :first)
        expect(expected_content).not_to have_content(I18n.t('btn.show'))
      end

      it "有 show 權限者，可以看到" do
        login_as(show_permission_admin, scope: :admin)
        visit admin_admins_path
        expected_content = find('td.index-table-action', match: :first)
        expect(expected_content).to have_content(I18n.t('btn.show'))
      end
    end

    context "編輯按鈕 (edit)" do
      it "沒有 edit 權限者，不可以看到" do
        login_as(show_permission_admin, scope: :admin)
        visit admin_admins_path
        expected_content = find('td.index-table-action', match: :first)
        expect(expected_content).not_to have_content(I18n.t('btn.edit'))
      end

      it "有 edit 權限者，可以看到" do
        login_as(edit_permission_admin, scope: :admin)
        visit admin_admins_path
        within('td.index-table-action', match: :first) do
          find('.dropdown').click
          expect(current_scope).to have_content(I18n.t('btn.edit'))
        end
      end
    end

    context "刪除按鈕 (destroy)" do
      it "沒有 destroy 權限者，不可以看到" do
        login_as(index_permission_admin, scope: :admin)
        visit admin_admins_path
        within('td.index-table-action', match: :first) do
          find('.dropdown').click
          expect(current_scope).not_to have_content(I18n.t('btn.delete'))
        end
      end

      it "有 destroy 權限者，不可以看到" do
        login_as(destroy_permission_admin, scope: :admin)
        visit admin_admins_path
        within('td.index-table-action', match: :first) do
          find('.dropdown').click
          expect(current_scope).not_to have_content(I18n.t('btn.delete'))
        end
      end
    end
  end
end
