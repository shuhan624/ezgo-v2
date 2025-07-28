require 'rails_helper'

RSpec.describe "里程碑管理", type: :system do
  let(:milestone) { create(:milestone) }

  before(:all) do
    @permit_role = create(:role, permissions: {
      milestone: {
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

  context "在側邊欄中的里程碑項目" do
    it "沒有 index 權限者，不可以看到" do
      login_as(@no_permissions_admin, scope: :admin)
      visit admin_root_path
      menu = find('#leftsidebar')
      expect(menu).not_to have_text('里程碑')
    end

    it "有 index 權限者，可以看到" do
      login_as(@admin_has_permissions, scope: :admin)
      visit admin_root_path
      menu = find('#leftsidebar')
      expect(menu).to have_text('里程碑')
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

  context "里程碑列表 (index)" do
    let!(:milestone) { create(:milestone) }
    it "沒有 index 權限者，不可以看到" do
      login_as(@no_permissions_admin, scope: :admin)
      visit admin_milestones_path
      expect(page).to have_content("無權進行此操作")
    end

    it "有 index 權限者，可以看到" do
      login_as(@admin_has_permissions, scope: :admin)
      visit admin_milestones_path
      expect(page).to have_text(milestone.decorate.short_content)
    end
  end

  context "頁面內容" do
    before { login_as(@admin_has_permissions, scope: :admin) }

    it "可以看到搜尋區塊" do
      visit admin_milestones_path
      expect(page).to have_css('.index-search-form')
    end

    it "可以看到里程碑「中文」內容" do
      milestone
      visit admin_milestones_path
      expected_content = find('section.content table tbody')
      expect(expected_content).to have_content(milestone.decorate.short_content)
    end

    context "可以看到「中文」是否公開狀態" do
      it "當里程碑為「公開」狀態時，可以看到「綠色」圖示" do
        published_milestone = create(:milestone, :published_tw)
        visit admin_milestones_path
        expected_content = find('section.content table tbody')
        expect(expected_content).to have_xpath("//img[contains(@src,admin/status_visible.svg)]")
      end

      it "當里程碑為「未公開」狀態時，可以看到「灰色」圖示" do
        hidden_milestone = create(:milestone, :hidden_tw)
        visit admin_milestones_path
        expected_content = find('section.content table tbody')
        expect(expected_content).to have_xpath("//img[contains(@src,admin/status_invisible.svg)]")
      end
    end

    context "可以看到「英文」是否公開狀態" do
      it "當里程碑為「公開」狀態時，可以看到「綠色」圖示" do
        published_milestone = create(:milestone, :published_en)
        visit admin_milestones_path
        expected_content = find('section.content table tbody')
        expect(expected_content).to have_xpath("//img[contains(@src,admin/status_visible.svg)]")
      end

      it "當里程碑為「未公開」狀態時，可以看到「灰色」圖示" do
        hidden_milestone = create(:milestone, :hidden_en)
        visit admin_milestones_path
        expected_content = find('section.content table tbody')
        expect(expected_content).to have_xpath("//img[contains(@src,admin/status_invisible.svg)]")
      end
    end
  end

  context "分頁區塊" do
    before { login_as(@admin_has_permissions, scope: :admin) }

    context "未超過「25」筆資料" do
      before(:all) do
        @milestones = create_list(:milestone, 25)
      end

      after(:all) do
        Milestone.delete_all
      end

      it "可以看到共有幾筆資料" do
        visit admin_milestones_path
        expected_content = find('.pagy-info')
        scroll_to(expected_content, align: :top)
        expect(expected_content).to have_content('顯示 25 筆')
      end

      it "不可以看到分頁切換按鈕" do
        visit admin_milestones_path
        expect(page).not_to have_css('.pagination')
      end
    end

    context "超過「25」筆資料" do
      before(:all) do
        @milestones = create_list(:milestone, 26)
      end

      after(:all) do
        Milestone.delete_all
      end

      it "可以看到共有幾筆資料" do
        visit admin_milestones_path
        expected_content = find('.pagy-info')
        scroll_to(expected_content, align: :top)
        expect(expected_content).to have_content('共 26 筆，顯示 1 - 25 筆')
      end

      it "每一頁不可以看到超過「25」筆資料" do
        milestone = Milestone.all.last # 取得第 26 筆資料
        visit admin_milestones_path
        scroll_to(find('table'), align: :bottom)
        expected_content = find('table')
        expect(expected_content).not_to have_content(milestone.title)
        expect(expected_content).to have_css('tbody tr', count: 25)
      end

      it "需看到分頁切換按鈕" do
        visit admin_milestones_path
        scroll_to(find('table'), align: :bottom)
        expect(page).to have_css('.pagination')
      end

      it "按下「指定分頁」按鈕，可以看到指定的分頁頁面" do
        visit admin_milestones_path
        scroll_to(find('ul.pagination'), align: :bottom)
        click_link('2')
        expect(page).to have_current_path(admin_milestones_path(page: 2))
        expect(page).to have_content('共 26 筆，顯示 26 - 26 筆')
      end

      it "按下「下一頁」按鈕，可以看到目前分頁的下一頁頁面" do
        visit admin_milestones_path
        scroll_to(find('ul.pagination'), align: :bottom)

        find('ul.pagination li.next a').click
        expect(page).to have_current_path(admin_milestones_path(page: 2))
        expect(page).to have_content('共 26 筆，顯示 26 - 26 筆')
      end

      it "按下「上一頁」按鈕，可以看到目前分頁的上一頁頁面" do
        visit admin_milestones_path(page: 2)
        scroll_to(find('ul.pagination'), align: :bottom)

        find('ul.pagination li.prev a').click
        expect(page).to have_current_path(admin_milestones_path)
        expect(page).to have_content('共 26 筆，顯示 1 - 25 筆')
      end

      it "當在第一頁時，「上一頁」按鈕，不可以點選" do
        visit admin_milestones_path
        scroll_to(find('ul.pagination'), align: :bottom)
        expect(page).to have_css('ul.pagination li.prev.disabled')
      end

      it "當在最後一頁時，「下一頁」按鈕，不可以點選" do
        visit admin_milestones_path(page: 2)
        scroll_to(find('ul.pagination'), align: :bottom)
        expect(page).to have_css('ul.pagination li.next.disabled')
      end
    end
  end

  context "按鈕區塊" do
    let(:index_permission_role) { create(:role, permissions: {
      milestone: { index: true }
    }) }

    let(:show_permission_role) { create(:role, permissions: {
      milestone: { index: true, show: true }
    }) }

    let(:edit_permission_role) { create(:role, permissions: {
      milestone: { index: true, show: true, edit: true }
    }) }

    let(:destroy_permission_role) { create(:role, permissions: {
      milestone: { index: true, show: true, destroy: true }
    }) }

    let(:index_permission_admin) { create(:admin, role: index_permission_role) }
    let(:show_permission_admin) { create(:admin, role: show_permission_role) }
    let(:edit_permission_admin) { create(:admin, role: edit_permission_role) }
    let(:destroy_permission_admin) { create(:admin, role: destroy_permission_role) }
    let!(:milestone) { create(:milestone) }

    context "詳細按鈕 (show)" do
      it "沒有 show 權限者，不可以看到" do
        login_as(index_permission_admin, scope: :admin)
        visit admin_milestones_path
        expected_content = find('td.index-table-action', match: :first)
        expect(expected_content).not_to have_content(I18n.t('btn.show'))
      end

      it "有 show 權限者，可以看到" do
        login_as(show_permission_admin, scope: :admin)
        visit admin_milestones_path
        expected_content = find('td.index-table-action', match: :first)
        expect(expected_content).to have_content(I18n.t('btn.show'))
      end
    end

    context "編輯按鈕 (edit)" do
      it "沒有 edit 權限者，不可以看到" do
        login_as(show_permission_admin, scope: :admin)
        visit admin_milestones_path
        expected_content = find('td.index-table-action', match: :first)
        expect(expected_content).not_to have_content(I18n.t('btn.edit'))
      end

      it "有 edit 權限者，可以看到" do
        login_as(edit_permission_admin, scope: :admin)
        visit admin_milestones_path
        within('td.index-table-action', match: :first) do
          find('.dropdown').click
          expect(current_scope).to have_content(I18n.t('btn.edit'))
        end
      end
    end

    context "刪除按鈕 (destroy)" do
      it "沒有 destroy 權限者，不可以看到" do
        login_as(index_permission_admin, scope: :admin)
        visit admin_milestones_path
        within('td.index-table-action', match: :first) do
          find('.dropdown').click
          expect(current_scope).not_to have_content(I18n.t('btn.delete'))
        end
      end

      it "有 destroy 權限者，不可以看到" do
        login_as(destroy_permission_admin, scope: :admin)
        visit admin_milestones_path
        within('td.index-table-action', match: :first) do
          find('.dropdown').click
          expect(current_scope).not_to have_content(I18n.t('btn.delete'))
        end
      end
    end
  end
end
