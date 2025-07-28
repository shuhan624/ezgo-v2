require 'rails_helper'

RSpec.describe "最新消息管理", type: :system do
  let(:article_category) { create(:article_category) }
  let(:article) { create(:article) }

  before(:all) do
    @permit_role = create(:role, permissions: {
      article: {
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

  context "在側邊欄中的最新消息項目" do
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
      expect(menu).to have_text('最新消息')
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

  context "文章列表 (index)" do
    it "沒有 index 權限者，不可以看到" do
      login_as(@no_permissions_admin, scope: :admin)
      visit admin_articles_path
      expect(page).to have_content("無權進行此操作")
    end

    it "有 index 權限者，可以看到" do
      article
      login_as(@admin_has_permissions, scope: :admin)
      visit admin_articles_path
      expect(page).to have_text(article.title)
    end
  end

  context "頁面內容" do
    before { login_as(@admin_has_permissions, scope: :admin) }

    it "可以看到搜尋區塊" do
      visit admin_articles_path
      expect(page).to have_css('.index-search-form')
    end

    it "最新消息依照「中文發佈日期」排序，日期越接近現在的越上面" do
      article_0101 = create(:article, :post_tw, published_at: '2023-01-01')
      article_0228 = create(:article, :post_tw, published_at: '2023-02-28')
      article_0131 = create(:article, :post_tw, published_at: '2023-01-31')
      visit admin_articles_path
      articles = all('tr.article .title')
      expect(articles.count).to eq(3)

      # 預期的文章順序
      expected_articles = [
        "#{article_0228.title}\n#{article_0228.title_en}",
        "#{article_0131.title}\n#{article_0131.title_en}",
        "#{article_0101.title}\n#{article_0101.title_en}",
      ]

      articles.each_with_index do |article_element, index|
        expect(article_element.text).to eq(expected_articles[index])
      end
    end
  end

  context "列表項目" do
    before { login_as(@admin_has_permissions, scope: :admin) }
    let!(:article) { create(:article) }

    it "可以看到最新消息「中文」標題" do
      visit admin_articles_path
      expected_content = find('.index-list')
      expect(expected_content).to have_content(article.title)
    end

    it "可以看到預設分類" do
      visit admin_articles_path
      expected_content = find('.index-list')
      expect(expected_content).to have_content(article.default_category.name)
    end

    xit "可以看到所屬分類" do
      visit admin_articles_path
      expected_content = find('.index-list')
      expect(expected_content).to have_content(article.article_categories.last.name)
    end

    it "可以看到「中文發佈日期」" do
      published_article = create(:article, :post_tw, :published_tw)
      visit admin_articles_path
      expected_content = find('.index-list')
      expect(expected_content).to have_content(published_article.published_at.strftime("%F"))
    end

    context "文章類型 icon" do
      it "當文章類型為「文章內容」時，可以看到「文件」圖示" do
        post_type_article = create(:article, :post_tw)
        visit admin_articles_path
        expected_content = find('.index-list')
        expect(expected_content).to have_xpath("//img[contains(@src,admin/file.svg)]")
      end

      it "當文章類型為「連結」時，可以看到「連結」圖示" do
        link_type_article = create(:article, :link_tw)
        visit admin_articles_path
        expected_content = find('.index-list')
        expect(expected_content).to have_xpath("//img[contains(@src,admin/link.svg)]")
      end
    end

    context "可以看到「中文」是否公開狀態" do
      it "當文章為「公開」狀態時，可以看到「綠色」圖示" do
        published_article = create(:article, :post_tw, :published_tw)
        visit admin_articles_path
        expected_content = find('.index-list')
        expect(expected_content).to have_xpath("//img[contains(@src,admin/status_visible.svg)]")
      end

      it "當文章為「未公開」狀態時，可以看到「灰色」圖示" do
        unpublished_article = create(:article)
        visit admin_articles_path
        expected_content = find('.index-list')
        expect(expected_content).to have_xpath("//img[contains(@src,admin/status_invisible.svg)]")
      end

      it "當文章為「已過發佈時間」狀態時，可以看到「灰色」圖示" do
        expired_article = create(:article, :post_tw, :expired_tw)
        visit admin_articles_path
        expected_content = find('.index-list')
        expect(expected_content).to have_xpath("//img[contains(@src,admin/status_invisible.svg)]")
      end

      it "當文章為「未到發佈時間」狀態時，可以看到「灰色」圖示" do
        future_article = create(:article, :post_tw, :future_tw)
        visit admin_articles_path
        expected_content = find('.index-list')
        expect(expected_content).to have_xpath("//img[contains(@src,admin/status_invisible.svg)]")
      end
    end

    context "可以看到「英文」是否公開狀態" do
      it "當文章為「公開」狀態時，可以看到「綠色」圖示" do
        published_article = create(:article, :post_en, :published_en)
        visit admin_articles_path
        expected_content = find('.index-list')
        expect(expected_content).to have_xpath("//img[contains(@src,admin/status_visible.svg)]")
      end

      it "當文章為「未公開」狀態時，可以看到「灰色」圖示" do
        unpublished_article = create(:article)
        visit admin_articles_path
        expected_content = find('.index-list')
        expect(expected_content).to have_xpath("//img[contains(@src,admin/status_invisible.svg)]")
      end

      it "當文章為「已過發佈時間」狀態時，可以看到「灰色」圖示" do
        expired_article = create(:article, :post_en, :expired_en)
        visit admin_articles_path
        expected_content = find('.index-list')
        expect(expected_content).to have_xpath("//img[contains(@src,admin/status_invisible.svg)]")
      end

      it "當文章為「未到發佈時間」狀態時，可以看到「灰色」圖示" do
        future_article = create(:article, :post_en, :future_en)
        visit admin_articles_path
        expected_content = find('.index-list')
        expect(expected_content).to have_xpath("//img[contains(@src,admin/status_invisible.svg)]")
      end
    end
  end

  context "按鈕區塊" do
    let(:index_permission_role) { create(:role, permissions: {
      article: { index: true }
    }) }

    let(:show_permission_role) { create(:role, permissions: {
      article: { index: true, show: true }
    }) }

    let(:edit_permission_role) { create(:role, permissions: {
      article: { index: true, show: true, edit: true }
    }) }

    let(:destroy_permission_role) { create(:role, permissions: {
      article: { index: true, show: true, destroy: true }
    }) }

    let(:index_permission_admin) { create(:admin, role: index_permission_role) }
    let(:show_permission_admin) { create(:admin, role: show_permission_role) }
    let(:edit_permission_admin) { create(:admin, role: edit_permission_role) }
    let(:destroy_permission_admin) { create(:admin, role: destroy_permission_role) }
    let!(:article) { create(:article) }

    context "詳細按鈕 (show)" do
      it "沒有 show 權限者，不可以看到" do
        login_as(index_permission_admin, scope: :admin)
        visit admin_articles_path
        expected_content = find('td.index-table-action', match: :first)
        expect(expected_content).not_to have_content(I18n.t('btn.show'))
      end

      it "有 show 權限者，可以看到" do
        login_as(show_permission_admin, scope: :admin)
        visit admin_articles_path
        expected_content = find('td.index-table-action', match: :first)
        expect(expected_content).to have_content(I18n.t('btn.show'))
      end
    end

    context "編輯按鈕 (edit)" do
      it "沒有 edit 權限者，不可以看到" do
        login_as(show_permission_admin, scope: :admin)
        visit admin_articles_path
        expected_content = find('td.index-table-action', match: :first)
        expect(expected_content).not_to have_content(I18n.t('btn.edit'))
      end

      it "有 edit 權限者，可以看到" do
        login_as(edit_permission_admin, scope: :admin)
        visit admin_articles_path
        within('td.index-table-action', match: :first) do
          find('.dropdown').click
          expect(current_scope).to have_content(I18n.t('btn.edit'))
        end
      end
    end

    context "刪除按鈕 (destroy)" do
      it "沒有 destroy 權限者，不可以看到" do
        login_as(index_permission_admin, scope: :admin)
        visit admin_articles_path
        within('td.index-table-action', match: :first) do
          find('.dropdown').click
          expect(current_scope).not_to have_content(I18n.t('btn.delete'))
        end
      end

      it "有 destroy 權限者，不可以看到" do
        login_as(destroy_permission_admin, scope: :admin)
        visit admin_articles_path
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
        @articles = create_list(:article, 25)
      end

      after(:all) do
        Article.delete_all
        # ArticleCategory 要使用 destroy_all 才可以正確刪除多對多關聯的中間表
        ArticleCategory.destroy_all
      end

      before(:each) do
        visit admin_articles_path
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
        @articles = create_list(:article, 26)
      end

      after(:all) do
        Article.delete_all
        # ArticleCategory 要使用 destroy_all 才可以正確刪除多對多關聯的中間表
        ArticleCategory.destroy_all
      end

      before(:each) do
        visit admin_articles_path
      end

      it "可以看到共有幾筆資料" do
        expected_content = find('.pagy-info')
        scroll_to(expected_content, align: :top)
        expect(expected_content).to have_content('共 26 筆，顯示 1 - 25 筆')
      end

      it "每一頁不可以看到超過「25」筆資料" do
        article = Article.all.last # 取得第 26 筆資料
        scroll_to(find('table'), align: :bottom)
        expected_content = find('table')
        expect(expected_content).not_to eq(article.title)
        expect(expected_content).to have_css('tr.article', count: 25)
      end

      it "需看到分頁切換按鈕" do
        scroll_to(find('table'), align: :bottom)
        expect(page).to have_css('.pagination')
      end

      it "按下「指定分頁」按鈕，可以看到指定的分頁頁面" do
        within '.pagination' do
          click_link '2'
        end
        expect(page).to have_current_path(admin_articles_path(page: 2))
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
