require 'rails_helper'

RSpec.describe "檢視單一最新消息文章頁面", type: :system do
  let(:article_category) { create(:article_category) }

  before(:all) do
    @permit_role = create(:role, permissions: {
      article: {
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
    login_as(@no_permissions_admin, scope: :admin)
    article = create(:article)
    visit admin_article_path(article)
    expect(page).to have_content("無權進行此操作")
  end

  it "有 show 權限者，可以到達" do
    login_as(@admin_has_permissions, scope: :admin)
    article = create(:article)
    visit admin_article_path(article)
    expect(page).to have_text(article.title)
  end


  context "頁面內容" do
    before { login_as(@admin_has_permissions, scope: :admin) }

    context "「基本資訊」頁籤" do
      let!(:article) { create(:article, :post_tw, featured: '1', top: '2') }

      before do
        visit admin_article_path(article)
        find('.tabs-group .tabs-btn').click_link('基本資訊')
      end

      it "可以看到「文章類型」" do
        expect(page).to have_text('文章類型')
        expect(page).to have_content('文章內容')
      end

      it "可以看到「精選項目」" do
        expect(page).to have_text('精選項目')
        expect(page).to have_text('1')
      end

      it "可以看到「置頂項目」" do
        expect(page).to have_text('置頂')
        expect(page).to have_text('2')
      end

      it "可以看到「預設分類」" do
        expect(page).to have_text('預設分類')
        expect(page).to have_text(article.default_category.name)
      end

      it "可以看到「所屬類別」" do
        expect(page).to have_text('所屬類別')
        expect(page).to have_content(article.article_categories.last.name)
      end

      it "可以看到「更新時間」" do
        expect(page).to have_text('更新於')
        expect(page).to have_text(article.updated_at.strftime("%F %R"))
      end

      it "可以看到「建立時間」" do
        expect(page).to have_text('建立於')
        expect(page).to have_text(article.created_at.strftime("%F %R"))
      end
    end

    context "「中文」頁籤" do
      let(:article) { create(:article, :post_tw, :published_tw) }

      it "可以看到「標題」" do
        visit admin_article_path(article)
        find('.tabs-group .tabs-btn').click_link('中文')
        expect(page).to have_text('標題')
        expect(page).to have_content(article.title)
      end

      it "可以看到「發布時間」" do
        visit admin_article_path(article)
        find('.tabs-group .tabs-btn').click_link('中文')
        expect(page).to have_text('發布時間')
        expect(page).to have_content(article.published_at.strftime("%F %R"))
      end

      it "可以看到「下架時間」" do
        visit admin_article_path(article)
        find('.tabs-group .tabs-btn').click_link('中文')
        expect(page).to have_text('下架時間')
        expect(page).to have_content(article.expired_at.strftime("%F %R"))
      end

      context "可以看到「網址」" do
        it "當文章為「公開」狀態時，可以看到有連結的「網址」，並可以另開新視窗方式開啟連結位置" do
          published_article = create(:article, :post_tw, :published_tw)
          host = Rails.application.config.action_mailer.default_url_options[:host]
          port = Capybara.current_session.server.port
          link = article_url(host: host, port: port, article_category: published_article.default_category, id: published_article.slug)
          visit admin_article_path(published_article)
          find('.tabs-group .tabs-btn').click_link('中文')
          expect(page).to have_text('網址')
          expect(page).to have_content(link)

          link_text = find("a", text: link)
          link_text.click
          expect(page.driver.browser.window_handles.count).to eq(2)
          new_window = page.driver.browser.window_handles.last
          page.driver.browser.switch_to.window(new_window)
          expect(page.current_url).to eq(link)
        end

        it "當文章為「未公開」狀態時，可以看到未帶連結的「網址」" do
          unpublished_article = create(:article, :post_tw)
          host = Rails.application.config.action_mailer.default_url_options[:host]
          port = Capybara.current_session.server.port
          link = article_url(host: host, port: port, article_category: unpublished_article.default_category, id: unpublished_article.slug)
          visit admin_article_path(unpublished_article)
          find('.tabs-group .tabs-btn').click_link('中文')
          expect(page).to have_text('網址')
          expect(page).to have_content(link)
        end
      end

      context "可以看到「發布狀態」" do
        it "當文章為「公開」狀態時，可以看到「綠色」圖示" do
          published_article = create(:article, :post_tw, :published_tw)
          visit admin_article_path(published_article)
          find('.tabs-group .tabs-btn').click_link('中文')
          expect(page).to have_xpath("//img[contains(@src,admin/status_visible.svg)]")
        end

        it "當文章為「未公開」狀態時，可以看到「灰色」圖示" do
          unpublished_article = create(:article, :post_tw)
          visit admin_article_path(unpublished_article)
          find('.tabs-group .tabs-btn').click_link('中文')
          expect(page).to have_xpath("//img[contains(@src,admin/status_invisible.svg)]")
        end

        it "當文章為「已過發佈時間」狀態時，可以看到「灰色」圖示" do
          expired_article = create(:article, :post_tw, :expired_tw)
          visit admin_article_path(expired_article)
          find('.tabs-group .tabs-btn').click_link('中文')
          expect(page).to have_xpath("//img[contains(@src,admin/status_invisible.svg)]")
        end

        it "當文章為「未到發佈時間」狀態時，可以看到「灰色」圖示" do
          future_article = create(:article, :post_tw, :future_tw)
          visit admin_article_path(future_article)
          find('.tabs-group .tabs-btn').click_link('中文')
          expect(page).to have_xpath("//img[contains(@src,admin/status_invisible.svg)]")
        end
      end

      it "可以看到「代表圖片」" do
        with_image_article = create(:article, :with_image)
        visit admin_article_path(with_image_article)
        find('.tabs-group .tabs-btn').click_link('中文')
        expect(page).to have_xpath("//img[contains(@src,article.image)]")
      end

      it "可以看到「圖片 alt 描述」" do
        with_image_alt_article = create(:article, :with_image_alt)
        visit admin_article_path(with_image_alt_article)
        find('.tabs-group .tabs-btn').click_link('中文')
        expect(page).to have_content(with_image_alt_article.alt_zh_tw)
      end
    end

    context "「英文」頁籤" do
      let(:article) { create(:article, :post_en, :published_en) }

      it "可以看到「標題」" do
        visit admin_article_path(article)
        find('.tabs-group .tabs-btn').click_link('英文')
        expect(page).to have_content(article.title_en)
      end

      it "可以看到「發布時間」" do
        visit admin_article_path(article)
        find('.tabs-group .tabs-btn').click_link('英文')
        expect(page).to have_content(article.published_at_en.strftime("%F %R"))
      end

      it "可以看到「下架時間」" do
        visit admin_article_path(article)
        find('.tabs-group .tabs-btn').click_link('英文')
        expect(page).to have_content(article.expired_at_en.strftime("%F %R"))
      end

      context "可以看到「網址」" do
        it "當文章為「公開」狀態時，可以看到有連結的「網址」，並可以另開新視窗方式開啟連結位置" do
          published_article = create(:article, :post_en, :published_en)
          host = Rails.application.config.action_mailer.default_url_options[:host]
          port = Capybara.current_session.server.port
          link = article_url(host: host, port: port, locale: :en, article_category: published_article.default_category, id: published_article.slug)
          visit admin_article_path(published_article)
          find('.tabs-group .tabs-btn').click_link('英文')
          expect(page).to have_text('網址')
          expect(page).to have_content(link)

          link_text = find("a", text: link)
          link_text.click
          expect(page.driver.browser.window_handles.count).to eq(2)
          new_window = page.driver.browser.window_handles.last
          page.driver.browser.switch_to.window(new_window)
          expect(page.current_url).to eq(link)
        end

        it "當文章為「未公開」狀態時，可以看到未帶連結的「網址」" do
          unpublished_article = create(:article, :post_en)
          host = Rails.application.config.action_mailer.default_url_options[:host]
          port = Capybara.current_session.server.port
          link = article_url(host: host, port: port, locale: :en, article_category: unpublished_article.default_category, id: unpublished_article.slug)
          visit admin_article_path(unpublished_article)
          find('.tabs-group .tabs-btn').click_link('英文')
          expect(page).to have_text('網址')
          expect(page).to have_content(link)
        end
      end

      context "可以看到「發布狀態」" do
        it "當文章為「公開」狀態時，可以看到「綠色」圖示" do
          published_article = create(:article, :post_en, :published_en)
          visit admin_article_path(published_article)
          find('.tabs-group .tabs-btn').click_link('英文')
          expect(page).to have_xpath("//img[contains(@src,admin/status_visible.svg)]")
        end

        it "當文章為「未公開」狀態時，可以看到「灰色」圖示" do
          unpublished_article = create(:article)
          visit admin_article_path(unpublished_article)
          find('.tabs-group .tabs-btn').click_link('英文')
          expect(page).to have_xpath("//img[contains(@src,admin/status_invisible.svg)]")
        end

        it "當文章為「已過發佈時間」狀態時，可以看到「灰色」圖示" do
          expired_article = create(:article, :post_en, :expired_en)
          visit admin_article_path(expired_article)
          find('.tabs-group .tabs-btn').click_link('英文')
          expect(page).to have_xpath("//img[contains(@src,admin/status_invisible.svg)]")
        end

        it "當文章為「未到發佈時間」狀態時，可以看到「灰色」圖示" do
          future_article = create(:article, :post_en, :future_en)
          visit admin_article_path(future_article)
          find('.tabs-group .tabs-btn').click_link('英文')
          expect(page).to have_xpath("//img[contains(@src,admin/status_invisible.svg)]")
        end
      end

      it "可以看到「代表圖片」" do
        with_image_article = create(:article, :with_image)
        visit admin_article_path(with_image_article)
        find('.tabs-group .tabs-btn').click_link('英文')
        expect(page).to have_xpath("//img[contains(@src,article.image_en)]")
      end

      it "可以看到「圖片 alt 描述」" do
        with_image_alt_article = create(:article, :with_image_alt)
        visit admin_article_path(with_image_alt_article)
        find('.tabs-group .tabs-btn').click_link('英文')
        expect(page).to have_content(with_image_alt_article.alt_en)
      end
    end

    context "「SEO」頁籤" do
      let(:article) { create(:article, :with_seo) }

      before do
        visit admin_article_path(article)
        find('.tabs-group .tabs-btn').click_link('SEO')
      end

      context "中文" do
        it "可以看到「H1」" do
          expect(page).to have_content(article.title)
        end

        it "可以看到「Meta 標題」" do
          expect(page).to have_content(article.meta_title)
        end

        it "可以看到「Meta 關鍵字」" do
          expect(page).to have_content(article.meta_keywords)
        end

        it "可以看到「Meta 描述」" do
          expect(page).to have_content(article.meta_desc)
        end

        it "可以看到「OG 標題」" do
          expect(page).to have_content(article.og_title)
        end

        it "可以看到「OG 描述」" do
          expect(page).to have_content(article.og_desc)
        end

        it "可以看到「OG 圖片」" do
          expect(page).to have_xpath("//img[contains(@src,article.og_image)]")
        end
      end

      context "英文" do
        it "可以看到「H1」" do
          expect(page).to have_content(article.title_en)
        end

        it "可以看到「Meta 標題」" do
          expect(page).to have_text(article.meta_title(locale: :en))
        end

        it "可以看到「Meta 關鍵字」" do
          expect(page).to have_content(article.meta_keywords(locale: :en))
        end

        it "可以看到「Meta 描述」" do
          expect(page).to have_content(article.meta_desc(locale: :en))
        end

        it "可以看到「OG 標題」" do
          expect(page).to have_content(article.og_title(locale: :en))
        end

        it "可以看到「OG 描述」" do
          expect(page).to have_content(article.og_desc(locale: :en))
        end

        it "可以看到「OG 圖片」" do
          expect(page).to have_xpath("//img[contains(@src,article.og_image_en)]")
        end
      end
    end
  end

  context "按鈕區塊" do
    let(:show_permission_role) { create(:role, permissions: {
      article: { index: true, show: true }
    }) }

    let(:edit_permission_role) { create(:role, permissions: {
      article: { index: true, show: true, edit: true }
    }) }

    let(:destroy_permission_role) { create(:role, permissions: {
      article: { index: true, show: true, destroy: true }
    }) }

    let(:show_permission_admin) { create(:admin, role: show_permission_role) }
    let(:edit_permission_admin) { create(:admin, role: edit_permission_role) }
    let(:destroy_permission_admin) { create(:admin, role: destroy_permission_role) }
    let!(:article) { create(:article) }
    context "編輯按鈕 (edit)" do
      it "沒有 edit 權限者，不可以看到" do
        login_as(show_permission_admin, scope: :admin)
        visit admin_article_path(article)
        expected_content = find('.float-btns')
        expect(expected_content).not_to have_content(I18n.t('btn.edit'))
      end

      it "有 edit 權限者，可以看到" do
        login_as(edit_permission_admin, scope: :admin)
        visit admin_article_path(article)
        expected_content = find('.float-btns')
        expect(expected_content).to have_content(I18n.t('btn.edit'))
      end
    end

    context "刪除按鈕 (destroy)" do
      it "沒有 destroy 權限者，不可以看到" do
        login_as(show_permission_admin, scope: :admin)
        visit admin_article_path(article)
        expected_content = find('.float-btns')
        expect(expected_content).not_to have_css('.btn-danger-light')
      end

      it "有 destroy 權限者，可以看到" do
        login_as(destroy_permission_admin, scope: :admin)
        visit admin_article_path(article)
        expected_content = find('.float-btns')
        expect(expected_content).to have_css('.btn-danger-light')
      end
    end
  end
end
