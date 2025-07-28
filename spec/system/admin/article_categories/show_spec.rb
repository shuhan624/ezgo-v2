require 'rails_helper'

RSpec.describe "檢視單一最新消息分類頁面", type: :system do
  let(:category) { create(:article_category) }

  before(:all) do
    @permit_role = create(:role, permissions: {
      article_category: {
        index: true,
        show: true,
      }
    })

    @admin_has_permissions = create(:admin, role: @permit_role)
    @no_permissions_admin = create(:admin, :no_permissions)
  end

  after(:all) do
    Admin.delete_all
    Role.delete_all
  end

  it "沒有 show 權限者，不能到達" do
    category
    login_as(@no_permissions_admin, scope: :admin)
    visit admin_article_category_path(category)
    expect(page).to have_content("無權進行此操作")
  end

  it "有 show 權限者，可以到達" do
    category
    login_as(@admin_has_permissions, scope: :admin)
    visit admin_article_category_path(category)
    expect(page).to have_text(category.name)
  end


  context "頁面內容" do
    before { login_as(@admin_has_permissions, scope: :admin) }

    context "上方固定顯示內容" do
      before do
        category
        visit admin_article_category_path(category)
      end

      it "可以看到「更新時間」" do
        expect(page).to have_text('更新於')
        expect(page).to have_text(category.updated_at.strftime("%F %R"))
      end

      it "可以看到「建立時間」" do
        expect(page).to have_text('建立於')
        expect(page).to have_text(category.created_at.strftime("%F %R"))
      end
    end

    context "「中文」頁籤" do
      it "可以看到「分類名稱」" do
        category
        visit admin_article_category_path(category)
        find('.tabs-group .tabs-btn').click_link('中文')
        expect(page).to have_text('分類名稱')
        expect(page).to have_content(category.name)
      end

      context "當分類為「公開」狀態時" do
        let!(:published_category) { create(:article_category, :published_tw) }
        before do
          visit admin_article_category_path(published_category)
          find('.tabs-group .tabs-btn').click_link('中文')
        end

        it "可以看到有連結的「網址」" do
          host = Rails.application.config.action_mailer.default_url_options[:host]
          port = Capybara.current_session.server.port
          link = cate_articles_url(host: host, port: port, article_category: published_category.slug)
          expect(page).to have_text('網址')
          expect(page).to have_link(link, href: link)

          link_text = find("a", text: link)
          link_text.click
          expect(page.driver.browser.window_handles.count).to eq(2)
          new_window = page.driver.browser.window_handles.last
          page.driver.browser.switch_to.window(new_window)
          expect(page.current_url).to eq(link)
        end

        it "可以看到「綠色」圖示的「發布狀態」" do
          expect(page).to have_xpath("//img[contains(@src,admin/status_visible.svg)]")
        end
      end

      context "當分類為「未公開」狀態時" do
        let!(:hidden_category) { create(:article_category, :hidden_tw) }
        before do
          visit admin_article_category_path(hidden_category)
          find('.tabs-group .tabs-btn').click_link('中文')
        end

        it "可以看到未帶連結的「網址」" do
          host = Rails.application.config.action_mailer.default_url_options[:host]
          port = Capybara.current_session.server.port
          link = cate_articles_url(host: host, port: port, article_category: hidden_category.slug)
          expect(page).to have_text('網址')
          expect(page).to have_content(link)
          expect(page).not_to have_link(link, href: link)
        end

        it "可以看到「灰色」圖示的「發布狀態」" do
          expect(page).to have_xpath("//img[contains(@src,admin/status_invisible.svg)]")
        end
      end
    end

    context "「英文」頁籤" do
      it "可以看到「分類名稱」" do
        category
        visit admin_article_category_path(category)
        find('.tabs-group .tabs-btn').click_link('英文')
        expect(page).to have_content(category.name_en)
      end

      context "當分類為「公開」狀態時" do
        let!(:published_category) { create(:article_category, :published_en) }
        before do
          visit admin_article_category_path(published_category)
          find('.tabs-group .tabs-btn').click_link('英文')
        end

        it "可以看到有連結的「網址」，並可以另開新視窗方式開啟連結位置" do
          host = Rails.application.config.action_mailer.default_url_options[:host]
          port = Capybara.current_session.server.port
          link = cate_articles_url(host: host, port: port, locale: :en, article_category: published_category.slug)
          expect(page).to have_text('網址')
          expect(page).to have_link(link, href: link)

          link_text = find("a", text: link)
          link_text.click
          expect(page.driver.browser.window_handles.count).to eq(2)
          new_window = page.driver.browser.window_handles.last
          page.driver.browser.switch_to.window(new_window)
          expect(page.current_url).to eq(link)
        end

        it "可以看到「綠色」圖示的「發布狀態」" do
          expect(page).to have_xpath("//img[contains(@src,admin/status_visible.svg)]")
        end
      end

      context "當分類為「未公開」狀態時" do
        let!(:hidden_category) { create(:article_category, :hidden_en) }
        before do
          visit admin_article_category_path(hidden_category)
          find('.tabs-group .tabs-btn').click_link('英文')
        end

        it "可以看到未帶連結的「網址」" do
          host = Rails.application.config.action_mailer.default_url_options[:host]
          port = Capybara.current_session.server.port
          link = cate_articles_url(host: host, port: port, locale: :en, article_category: hidden_category.slug)
          expect(page).to have_text('網址')
          expect(page).to have_content(link)
        end

        it "可以看到「灰色」圖示的「發布狀態」" do
          expect(page).to have_xpath("//img[contains(@src,admin/status_invisible.svg)]")
        end
      end
    end

    context "「SEO」頁籤" do
      let(:category_with_seo) { create(:article_category, :with_seo) }

      before do
        visit admin_article_category_path(category_with_seo)
        find('.tabs-group .tabs-btn').click_link('SEO')
      end

      context "中文" do
        it "可以看到「H1」" do
          expect(page).to have_content(category_with_seo.name)
        end

        it "可以看到「Meta 標題」" do
          expect(page).to have_content(category_with_seo.meta_title)
        end

        it "可以看到「Meta 關鍵字」" do
          expect(page).to have_content(category_with_seo.meta_keywords)
        end

        it "可以看到「Meta 描述」" do
          expect(page).to have_content(category_with_seo.meta_desc)
        end

        it "可以看到「OG 標題」" do
          expect(page).to have_content(category_with_seo.og_title)
        end

        it "可以看到「OG 描述」" do
          expect(page).to have_content(category_with_seo.og_desc)
        end

        it "可以看到「OG 圖片」" do
          expect(page).to have_xpath("//img[contains(@src,category_with_seo.og_image)]")
        end
      end

      context "英文" do
        it "可以看到「H1」" do
          expect(page).to have_content(category_with_seo.name_en)
        end

        it "可以看到「Meta 標題」" do
          expect(page).to have_text(category_with_seo.meta_title(locale: :en))
        end

        it "可以看到「Meta 關鍵字」" do
          expect(page).to have_content(category_with_seo.meta_keywords(locale: :en))
        end

        it "可以看到「Meta 描述」" do
          expect(page).to have_content(category_with_seo.meta_desc(locale: :en))
        end

        it "可以看到「OG 標題」" do
          expect(page).to have_content(category_with_seo.og_title(locale: :en))
        end

        it "可以看到「OG 描述」" do
          expect(page).to have_content(category_with_seo.og_desc(locale: :en))
        end

        it "可以看到「OG 圖片」" do
          expect(page).to have_xpath("//img[contains(@src,category_with_seo.og_image_en)]")
        end
      end
    end
  end

  context "按鈕區塊" do
    let(:show_permission_role) { create(:role, permissions: {
      article_category: { index: true, show: true }
    }) }

    let(:edit_permission_role) { create(:role, permissions: {
      article_category: { index: true, show: true, edit: true }
    }) }

    let(:destroy_permission_role) { create(:role, permissions: {
      article_category: { index: true, show: true, destroy: true }
    }) }

    let(:show_permission_admin) { create(:admin, role: show_permission_role) }
    let(:edit_permission_admin) { create(:admin, role: edit_permission_role) }
    let(:destroy_permission_admin) { create(:admin, role: destroy_permission_role) }
    let!(:article_category) { create(:article_category) }
    context "編輯按鈕 (edit)" do
      it "沒有 edit 權限者，不可以看到" do
        login_as(show_permission_admin, scope: :admin)
        visit admin_article_category_path(article_category)
        expected_content = find('.float-btns')
        expect(expected_content).not_to have_content(I18n.t('btn.edit'))
      end

      it "有 edit 權限者，可以看到" do
        login_as(edit_permission_admin, scope: :admin)
        visit admin_article_category_path(article_category)
        expected_content = find('.float-btns')
        expect(expected_content).to have_content(I18n.t('btn.edit'))
      end
    end

    context "刪除按鈕 (destroy)" do
      it "沒有 destroy 權限者，不可以看到" do
        login_as(show_permission_admin, scope: :admin)
        visit admin_article_category_path(article_category)
        expected_content = find('.float-btns')
        expect(expected_content).not_to have_css('.btn-danger-light')
      end

      it "有 destroy 權限者，可以看到" do
        login_as(destroy_permission_admin, scope: :admin)
        visit admin_article_category_path(article_category)
        expected_content = find('.float-btns')
        expect(expected_content).to have_css('.btn-danger-light')
      end
    end
  end
end
