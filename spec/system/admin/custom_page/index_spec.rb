require 'rails_helper'

RSpec.describe "頁面管理", type: :system do
  let(:custom_page) { create(:custom_page) }
  let(:default_custom_page) { create(:custom_page, :default_page) }

  before(:all) do
    @permit_role = create(:role, permissions: {
      custom_page: {
        index: true,
      }
    })
    @admin_has_permissions = create(:admin, role: @permit_role)
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

  context "在側邊欄中的頁面管理項目" do
    it "沒有 index 權限者，不可以看到" do
      login_as(@no_permissions_admin, scope: :admin)
      visit admin_root_path
      menu = find('#leftsidebar')
      expect(menu).not_to have_text('頁面管理')
    end

    it "有 index 權限者，可以看到" do
      login_as(@admin_has_permissions, scope: :admin)
      visit admin_root_path
      menu = find('#leftsidebar')
      expect(menu).to have_text('頁面管理')
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

  context "頁面管理列表 (index)" do
    let!(:custom_page) { create(:custom_page, :default_page, :design) }
    it "沒有 index 權限者，不可以看到" do
      login_as(@no_permissions_admin, scope: :admin)
      visit admin_custom_pages_path
      expect(page).to have_content("無權進行此操作")
    end

    it "有 index 權限者，可以看到" do
      login_as(@admin_has_permissions, scope: :admin)
      visit admin_custom_pages_path
      expect(page).to have_text(custom_page.title)
    end
  end

  context "頁面內容" do
    before { login_as(@admin_has_permissions, scope: :admin) }

    context "SEO 設定" do
      let!(:custom_page) { create(:custom_page, :default_page, :design) }
      before { visit admin_custom_pages_path }

      it "可以看到頁面管理「中文」標題" do
        expected_content = find('section.content table tbody')
        expect(expected_content).to have_content(custom_page.title)
      end

      it "可以看到頁面管理「英文」標題" do
        expected_content = find('section.content table tbody')
        expect(expected_content).to have_content(custom_page.title_en)
      end

      it "不會看到中文狀態圖示" do
        expect(page).not_to have_xpath("//img[contains(@src,'admin/status_visible.svg')]")
      end

      it "不會看到英文狀態圖示" do
        expect(page).not_to have_xpath("//img[contains(@src,'admin/status_visible.svg')]")
      end
    end

    context "修改內容" do
      let!(:custom_page) { create(:custom_page, :default_page) }
      before do
        visit admin_custom_pages_path
        find('.tabs-group .tabs-btn').click_link('修改內容')
      end

      it "可以看到頁面管理「中文」標題" do
        expected_content = find('section.content table tbody')
        expect(expected_content).to have_content(custom_page.title)
      end

      it "可以看到頁面管理「英文」標題" do
        expected_content = find('section.content table tbody')
        expect(expected_content).to have_content(custom_page.title_en)
      end

      it "不會看到中文狀態圖示" do
        expect(page).not_to have_xpath("//img[contains(@src,'admin/status_visible.svg')]")
      end

      it "不會看到英文狀態圖示" do
        expect(page).not_to have_xpath("//img[contains(@src,'admin/status_visible.svg')]")
      end
    end

    context "擴充頁面" do
      let!(:custom_page) { create(:custom_page, :non_default_page) }
      before do
        visit admin_custom_pages_path
        find('.tabs-group .tabs-btn').click_link('擴充頁面')
      end

      it "可以看到頁面管理「中文」標題" do
        expected_content = find('section.content table tbody')
        expect(expected_content).to have_content(custom_page.title)
      end

      it "可以看到頁面管理「英文」標題" do
        expected_content = find('section.content table tbody')
        expect(expected_content).to have_content(custom_page.title_en)
      end

      context "中文狀態" do
        it "當頁面管理為「公開」狀態時，可以看到「綠色」圖示" do
          expected_content = find('section.content table tbody td:nth-child(3)')
          expect(expected_content).to have_xpath(".//img[contains(@src,admin/status_visible.svg)]")
        end

        it "當頁面管理為「未公開」狀態時，可以看到「灰色」圖示" do
          expected_content = find('section.content table tbody td:nth-child(3)')
          expect(expected_content).to have_xpath(".//img[contains(@src,admin/status_invisible.svg)]")
        end
      end

      context "英文狀態" do
        it "當頁面管理為「公開」狀態時，可以看到「綠色」圖示" do
          expected_content = find('section.content table tbody td:nth-child(4)')
          expect(expected_content).to have_xpath(".//img[contains(@src,admin/status_visible.svg)]")
        end

        it "當頁面管理為「未公開」狀態時，可以看到「灰色」圖示" do
          expected_content = find('section.content table tbody td:nth-child(4)')
          expect(expected_content).to have_xpath(".//img[contains(@src,admin/status_invisible.svg)]")
        end
      end
    end
  end

  context "按鈕區塊" do
    let(:index_permission_role) { create(:role, permissions: {
      custom_page: { index: true }
    }) }

    let(:show_permission_role) { create(:role, permissions: {
      custom_page: { index: true, show: true }
    }) }

    let(:edit_permission_role) { create(:role, permissions: {
      custom_page: { index: true, show: true, edit: true }
    }) }

    let(:destroy_permission_role) { create(:role, permissions: {
      custom_page: { index: true, show: true, destroy: true }
    }) }

    let(:index_permission_admin) { create(:admin, role: index_permission_role) }
    let(:show_permission_admin) { create(:admin, role: show_permission_role) }
    let(:edit_permission_admin) { create(:admin, role: edit_permission_role) }
    let(:destroy_permission_admin) { create(:admin, role: destroy_permission_role) }
    let!(:custom_page) { create(:custom_page, :default_page, :design) }

    context "詳細按鈕 (show)" do
      it "沒有 show 權限者，不可以看到" do
        login_as(index_permission_admin, scope: :admin)
        visit admin_custom_pages_path
        expected_content = find('td.index-table-action', match: :first)
        expect(expected_content).not_to have_content(I18n.t('btn.show'))
      end

      it "有 show 權限者，可以看到" do
        login_as(show_permission_admin, scope: :admin)
        visit admin_custom_pages_path
        expected_content = find('td.index-table-action', match: :first)
        expect(expected_content).to have_content(I18n.t('btn.show'))
      end
    end

    context "編輯按鈕 (edit)" do
      it "沒有 edit 權限者，不可以看到" do
        login_as(show_permission_admin, scope: :admin)
        visit admin_custom_pages_path
        expected_content = find('td.index-table-action', match: :first)
        expect(expected_content).not_to have_content(I18n.t('btn.edit'))
      end

      it "有 edit 權限者，可以看到" do
        login_as(edit_permission_admin, scope: :admin)
        visit admin_custom_pages_path
        within('td.index-table-action', match: :first) do
          find('.dropdown').click
          expect(current_scope).to have_content(I18n.t('btn.edit'))
        end
      end
    end

    context "刪除按鈕 (destroy)" do
      it "沒有 destroy 權限者，不可以看到" do
        login_as(index_permission_admin, scope: :admin)
        visit admin_custom_pages_path
        within('td.index-table-action', match: :first) do
          find('.dropdown').click
          expect(current_scope).not_to have_content(I18n.t('btn.delete'))
        end
      end

      it "有 destroy 權限者，不可以看到" do
        login_as(destroy_permission_admin, scope: :admin)
        visit admin_custom_pages_path
        within('td.index-table-action', match: :first) do
          find('.dropdown').click
          expect(current_scope).not_to have_content(I18n.t('btn.delete'))
        end
      end
    end
  end
end
