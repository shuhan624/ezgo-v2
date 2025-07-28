require 'rails_helper'

RSpec.describe "常見問題管理", type: :system do
  let(:faq_category) { create(:faq_category) }
  let(:faq) { create(:faq) }

  before(:all) do
    @permit_role = create(:role, permissions: {
      faq: {
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

  context "在側邊欄中的常見問題項目" do
    it "沒有 index 權限者，不可以看到" do
      login_as(@no_permissions_admin, scope: :admin)
      visit admin_root_path
      menu = find('#leftsidebar')
      expect(menu).not_to have_text('常見問題')
    end

    it "有 index 權限者，可以看到" do
      login_as(@admin_has_permissions, scope: :admin)
      visit admin_root_path
      menu = find('#leftsidebar')
      expect(menu).to have_text('常見問題')
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

  context "常見問題列表 (index)" do
    it "沒有 index 權限者，不可以看到" do
      login_as(@no_permissions_admin, scope: :admin)
      visit admin_faqs_path
      expect(page).to have_content("無權進行此操作")
    end

    it "有 index 權限者，可以看到" do
      faq
      login_as(@admin_has_permissions, scope: :admin)
      visit admin_faqs_path
      expect(page).to have_text(faq.title)
    end
  end

  context "頁面內容" do
    before { login_as(@admin_has_permissions, scope: :admin) }

    it "可以看到搜尋區塊" do
      visit admin_faqs_path
      expect(page).to have_css('.index-search-form')
    end

    it "常見問題項目依照「排序位置」排序，排序數字越小越上面" do
      faq_1 = create(:faq, position: '1')
      faq_3 = create(:faq, position: '3')
      faq_2 = create(:faq, position: '2')
      visit admin_faqs_path
      faqs = all('tr.sort-faq .title')
      expect(faqs.count).to eq(3)

      # 預期的分類順序
      expected_faqs = [
        "#{faq_1.title}\n#{faq_1.title_en}",
        "#{faq_2.title}\n#{faq_2.title_en}",
        "#{faq_3.title}\n#{faq_3.title_en}",
      ]

      faqs.each_with_index do |faq_element, index|
        expect(faq_element.text).to eq(expected_faqs[index])
      end
    end
  end

  context "列表項目" do
    before { login_as(@admin_has_permissions, scope: :admin) }
    let!(:faq) { create(:faq) }

    it "可以看到常見問題「中文」標題" do
      visit admin_faqs_path
      expected_content = find('.index-list')
      expect(expected_content).to have_content(faq.title)
    end

    it "可以看到所屬分類" do
      visit admin_faqs_path
      expected_content = find('.index-list')
      expect(expected_content).to have_content(faq.faq_category.name)
    end

    context "可以看到「中文」是否公開狀態" do
      it "當常見問題為「公開」狀態時，可以看到「綠色」圖示" do
        published_faq = create(:faq, :published_tw)
        visit admin_faqs_path
        expected_content = find('.index-list')
        expect(expected_content).to have_xpath("//img[contains(@src,admin/status_visible.svg)]")
      end

      it "當常見問題為「未公開」狀態時，可以看到「灰色」圖示" do
        hidden_faq = create(:faq)
        visit admin_faqs_path
        expected_content = find('.index-list')
        expect(expected_content).to have_xpath("//img[contains(@src,admin/status_invisible.svg)]")
      end
    end

    context "可以看到「英文」是否公開狀態" do
      it "當常見問題為「公開」狀態時，可以看到「綠色」圖示" do
        published_faq = create(:faq, :published_en)
        visit admin_faqs_path
        expected_content = find('.index-list')
        expect(expected_content).to have_xpath("//img[contains(@src,admin/status_visible.svg)]")
      end

      it "當常見問題為「未公開」狀態時，可以看到「灰色」圖示" do
        unpublished_faq = create(:faq)
        visit admin_faqs_path
        expected_content = find('.index-list')
        expect(expected_content).to have_xpath("//img[contains(@src,admin/status_invisible.svg)]")
      end
    end
  end

  context "按鈕區塊" do
    let(:index_permission_role) { create(:role, permissions: {
      faq: { index: true }
    }) }

    let(:show_permission_role) { create(:role, permissions: {
      faq: { index: true, show: true }
    }) }

    let(:edit_permission_role) { create(:role, permissions: {
      faq: { index: true, show: true, edit: true }
    }) }

    let(:destroy_permission_role) { create(:role, permissions: {
      faq: { index: true, show: true, destroy: true }
    }) }

    let(:index_permission_admin) { create(:admin, role: index_permission_role) }
    let(:show_permission_admin) { create(:admin, role: show_permission_role) }
    let(:edit_permission_admin) { create(:admin, role: edit_permission_role) }
    let(:destroy_permission_admin) { create(:admin, role: destroy_permission_role) }
    let!(:faq) { create(:faq) }

    context "詳細按鈕 (show)" do
      it "沒有 show 權限者，不可以看到" do
        login_as(index_permission_admin, scope: :admin)
        visit admin_faqs_path
        expected_content = find('td.index-table-action', match: :first)
        expect(expected_content).not_to have_content(I18n.t('btn.show'))
      end

      it "有 show 權限者，可以看到" do
        login_as(show_permission_admin, scope: :admin)
        visit admin_faqs_path
        expected_content = find('td.index-table-action', match: :first)
        expect(expected_content).to have_content(I18n.t('btn.show'))
      end
    end

    context "編輯按鈕 (edit)" do
      it "沒有 edit 權限者，不可以看到" do
        login_as(show_permission_admin, scope: :admin)
        visit admin_faqs_path
        expected_content = find('td.index-table-action', match: :first)
        expect(expected_content).not_to have_content(I18n.t('btn.edit'))
      end

      it "有 edit 權限者，可以看到" do
        login_as(edit_permission_admin, scope: :admin)
        visit admin_faqs_path
        within('td.index-table-action', match: :first) do
          find('.dropdown').click
          expect(current_scope).to have_content(I18n.t('btn.edit'))
        end
      end
    end

    context "刪除按鈕 (destroy)" do
      it "沒有 destroy 權限者，不可以看到" do
        login_as(index_permission_admin, scope: :admin)
        visit admin_faqs_path
        within('td.index-table-action', match: :first) do
          find('.dropdown').click
          expect(current_scope).not_to have_content(I18n.t('btn.delete'))
        end
      end

      it "有 destroy 權限者，不可以看到" do
        login_as(destroy_permission_admin, scope: :admin)
        visit admin_faqs_path
        within('td.index-table-action', match: :first) do
          find('.dropdown').click
          expect(current_scope).not_to have_content(I18n.t('btn.delete'))
        end
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
        @faqs = create_list(:faq, 25)
      end

      after(:all) do
        Faq.delete_all
        FaqCategory.delete_all
      end

      before do
        visit admin_faqs_path
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
        @faqs = create_list(:faq, 26)
      end

      after(:all) do
        Faq.delete_all
        FaqCategory.delete_all
      end

      before do
        visit admin_faqs_path
      end

      it "可以看到共有幾筆資料" do
        expected_content = find('.pagy-info')
        scroll_to(expected_content, align: :top)
        expect(expected_content).to have_content('共 26 筆，顯示 1 - 25 筆')
      end

      it "每一頁不可以看到超過「25」筆資料" do
        faq = Faq.all.last # 取得第 26 筆資料
        scroll_to(find('table'), align: :bottom)
        expected_content = find('table')
        expect(expected_content).not_to have_content(faq.title)
        expect(expected_content).to have_css('tr.sort-faq', count: 25)
      end

      it "需看到分頁切換按鈕" do
        scroll_to(find('table'), align: :bottom)
        expect(page).to have_css('.pagination')
      end

      it "按下「指定分頁」按鈕，可以看到指定的分頁頁面" do
        within '.pagination' do
          click_link '2'
        end
        expect(page).to have_current_path(admin_faqs_path(page: 2))
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
end
