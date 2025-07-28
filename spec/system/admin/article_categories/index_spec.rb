require 'rails_helper'

RSpec.describe "最新消息分類管理", type: :system do
  before(:all) do
    @permit_role = create(:role, permissions: {
      article_category: {
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

  context "在側邊欄中的最新消息分類項目" do
    it "沒有 index 權限者，不可以看到" do
      login_as(@no_permissions_admin, scope: :admin)
      visit admin_root_path
      menu = find('#leftsidebar')
      expect(menu).not_to have_text('最新消息')
    end

    it "有 index 權限者，可以看到" do
      login_as(@admin_has_permissions, scope: :admin)
      visit admin_root_path
      menu = find('#leftsidebar')
      expect(menu).to have_css('.nav-item', text: '最新消息')
      expect(menu).to have_link('最新消息分類', href: admin_article_categories_path)
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

  context "分類列表 (index)" do
    let!(:category) { create(:article_category) }

    it "沒有 index 權限者，不可以看到" do
      login_as(@no_permissions_admin, scope: :admin)
      visit admin_article_categories_path
      expect(page).to have_content("無權進行此操作")
    end

    it "有 index 權限者，可以看到" do
      login_as(@admin_has_permissions, scope: :admin)
      visit admin_article_categories_path
      expect(page).to have_text(category.name)
    end
  end

  context "頁面內容" do
    before { login_as(@admin_has_permissions, scope: :admin) }

    it "可以看到搜尋區塊" do
      visit admin_article_categories_path
      expect(page).to have_css('.index-search-form')
    end

    it "分類項目依照「排序位置」排序，排序數字越小越上面" do
      category_1 = create(:article_category, position: '1')
      category_3 = create(:article_category, position: '3')
      category_2 = create(:article_category, position: '2')
      visit admin_article_categories_path
      categories = all('tr.sort-article_category')
      expect(categories.count).to eq(3)

      # 預期的分類順序
      expected_categories = [
        "#{category_1.name}\n#{category_1.name_en}",
        "#{category_2.name}\n#{category_2.name_en}",
        "#{category_3.name}\n#{category_3.name_en}",
      ]

      categories.each_with_index do |category_element, index|
        expect(category_element.text).to eq(expected_categories[index])
      end
    end
  end

  context "列表項目" do
    before { login_as(@admin_has_permissions, scope: :admin) }
    let!(:category) { create(:article_category) }

    it "可以看到分類「中文」名稱" do
      visit admin_article_categories_path
      expected_content = find('.index-list')
      expect(expected_content).to have_content(category.name)
    end

    it "可以看到分類「英文」名稱" do
      visit admin_article_categories_path
      expected_content = find('.index-list')
      expect(expected_content).to have_content(category.name_en)
    end

    context "可以看到「中文發布狀態」" do
      it "當分類為「公開」狀態時，可以看到「綠色」圖示" do
        published_category = create(:article_category, :published_tw)
        visit admin_article_category_path(published_category)
        expect(page).to have_text('狀態')
        expect(page).to have_xpath("//img[contains(@src,admin/status_visible.svg)]")
      end

      it "當分類為「未公開」狀態時，可以看到「灰色」圖示" do
        hidden_category = create(:article_category, :hidden_tw)
        visit admin_article_category_path(hidden_category)
        expect(page).to have_text('狀態')
        expect(page).to have_xpath("//img[contains(@src,admin/status_invisible.svg)]")
      end
    end

    context "可以看到「英文發布狀態」" do
      it "當分類為「公開」狀態時，可以看到「綠色」圖示" do
        published_category = create(:article_category, :published_en)
        visit admin_article_category_path(published_category)
        expect(page).to have_text('狀態')
        expect(page).to have_xpath("//img[contains(@src,admin/status_visible.svg)]")
      end

      it "當分類為「未公開」狀態時，可以看到「灰色」圖示" do
        hidden_category = create(:article_category, :hidden_en)
        visit admin_article_category_path(hidden_category)
        expect(page).to have_text('狀態')
        expect(page).to have_xpath("//img[contains(@src,admin/status_invisible.svg)]")
      end
    end
  end

#   ▄▄▄▄▄▄▄▄▄▄▄  ▄▄▄▄▄▄▄▄▄▄▄  ▄▄▄▄▄▄▄▄▄▄▄  ▄         ▄
#  ▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌▐░▌       ▐░▌
#  ▐░█▀▀▀▀▀▀▀█░▌▐░█▀▀▀▀▀▀▀█░▌▐░█▀▀▀▀▀▀▀▀▀ ▐░▌       ▐░▌
#  ▐░▌       ▐░▌▐░▌       ▐░▌▐░▌          ▐░▌       ▐░▌
#  ▐░█▄▄▄▄▄▄▄█░▌▐░█▄▄▄▄▄▄▄█░▌▐░▌ ▄▄▄▄▄▄▄▄ ▐░█▄▄▄▄▄▄▄█░▌
#  ▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌▐░▌▐░░░░░░░░▌▐░░░░░░░░░░░▌
#  ▐░█▀▀▀▀▀▀▀▀▀ ▐░█▀▀▀▀▀▀▀█░▌▐░▌ ▀▀▀▀▀▀█░▌ ▀▀▀▀█░█▀▀▀▀
#  ▐░▌          ▐░▌       ▐░▌▐░▌       ▐░▌     ▐░▌
#  ▐░▌          ▐░▌       ▐░▌▐░█▄▄▄▄▄▄▄█░▌     ▐░▌
#  ▐░▌          ▐░▌       ▐░▌▐░░░░░░░░░░░▌     ▐░▌
#   ▀            ▀         ▀  ▀▀▀▀▀▀▀▀▀▀▀       ▀
#

  context "分頁區塊" do
    before { login_as(@admin_has_permissions, scope: :admin) }

    context "未超過「25」筆資料" do
      before(:all) do
        @article_categories = create_list(:article_category, 25)
      end

      after(:all) do
        ArticleCategory.delete_all
      end

      before do
        visit admin_article_categories_path
      end

      it "可以看到共有幾筆資料" do
        expected_content = find('.pagy-info')
        scroll_to(expected_content, align: :top)
        expect(expected_content).to have_content('顯示 25 筆')
      end

      it "不可以看到分頁切換按鈕" do
        expect(page).not_to have_css('.pagination')
      end
    end

    context "超過「25」筆資料" do
      before(:all) do
        @article_categories = create_list(:article_category, 26)
      end

      after(:all) do
        ArticleCategory.delete_all
      end

      before do
        visit admin_article_categories_path
      end

      it "可以看到共有幾筆資料" do
        expected_content = find('.pagy-info')
        scroll_to(expected_content, align: :top)
        expect(expected_content).to have_content('共 26 筆，顯示 1 - 25 筆')
      end

      it "每一頁不可以看到超過「25」筆資料" do
        category = ArticleCategory.all.last # 取得第 26 筆資料
        scroll_to(find('table'), align: :bottom)
        expected_content = find('table')
        expect(expected_content).not_to have_content(category.name)
        expect(expected_content).to have_css('.sort-article_category', count: 25)
      end

      it "需看到分頁切換按鈕" do
        scroll_to(find('table'), align: :bottom)
        expect(page).to have_css('.pagination')
      end

      it "按下「指定分頁」按鈕，可以看到指定的分頁頁面" do
        within '.pagination' do
          click_link '2'
        end
        expect(page).to have_current_path(admin_article_categories_path(page: 2))
        expect(page).to have_content('共 26 筆，顯示 26 - 26 筆')
      end

      it "按下「下一頁」按鈕，可以看到目前分頁的下一頁頁面" do
        within '.pagination' do
          find('.next').click
        end
        expect(page).to have_content('共 26 筆，顯示 26 - 26 筆')
      end

      it "按下「上一頁」按鈕，可以看到目前分頁的上一頁頁面" do
        within '.pagination' do
          find('.next').click
          find('.prev').click
        end
        expect(page).to have_content('共 26 筆，顯示 1 - 25 筆')
      end

      it "當在第一頁時，「上一頁」按鈕，不可以點選" do
        expect(page).to have_selector('.pagination .prev.disabled', text: '‹')
      end

      it "當在最後一頁時，「下一頁」按鈕，不可以點選" do
        within '.pagination' do
          find('.next').click
        end
        expect(page).to have_selector('.pagination .next.disabled', text: '›')
      end
    end
  end

  context "按鈕區塊" do
    let(:index_permission_role) { create(:role, permissions: {
      article_category: { index: true }
    }) }

    let(:show_permission_role) { create(:role, permissions: {
      article_category: { index: true, show: true }
    }) }

    let(:edit_permission_role) { create(:role, permissions: {
      article_category: { index: true, show: true, edit: true }
    }) }

    let(:destroy_permission_role) { create(:role, permissions: {
      article_category: { index: true, show: true, destroy: true }
    }) }

    let(:index_permission_admin) { create(:admin, role: index_permission_role) }
    let(:show_permission_admin) { create(:admin, role: show_permission_role) }
    let(:edit_permission_admin) { create(:admin, role: edit_permission_role) }
    let(:destroy_permission_admin) { create(:admin, role: destroy_permission_role) }
    let!(:article_category) { create(:article_category) }

    context "詳細按鈕 (show)" do
      it "沒有 show 權限者，不可以看到" do
        login_as(index_permission_admin, scope: :admin)
        visit admin_article_categories_path
        expected_content = find('td.index-table-action', match: :first)
        expect(expected_content).not_to have_content(I18n.t('btn.show'))
      end

      it "有 show 權限者，可以看到" do
        login_as(show_permission_admin, scope: :admin)
        visit admin_article_categories_path
        expected_content = find('td.index-table-action', match: :first)
        expect(expected_content).to have_content(I18n.t('btn.show'))
      end
    end

    context "編輯按鈕 (edit)" do
      it "沒有 edit 權限者，不可以看到" do
        login_as(show_permission_admin, scope: :admin)
        visit admin_article_categories_path
        expected_content = find('td.index-table-action', match: :first)
        expect(expected_content).not_to have_content(I18n.t('btn.edit'))
      end

      it "有 edit 權限者，可以看到" do
        login_as(edit_permission_admin, scope: :admin)
        visit admin_article_categories_path
        within('td.index-table-action', match: :first) do
          find('.dropdown').click
          expect(current_scope).to have_content(I18n.t('btn.edit'))
        end
      end
    end

    context "刪除按鈕 (destroy)" do
      it "沒有 destroy 權限者，不可以看到" do
        login_as(index_permission_admin, scope: :admin)
        visit admin_article_categories_path
        within('td.index-table-action', match: :first) do
          find('.dropdown').click
          expect(current_scope).not_to have_content(I18n.t('btn.delete'))
        end
      end

      it "有 destroy 權限者，不可以看到" do
        login_as(destroy_permission_admin, scope: :admin)
        visit admin_article_categories_path
        within('td.index-table-action', match: :first) do
          find('.dropdown').click
          expect(current_scope).not_to have_content(I18n.t('btn.delete'))
        end
      end
    end
  end
end
