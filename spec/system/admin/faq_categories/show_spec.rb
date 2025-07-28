require 'rails_helper'

RSpec.describe "檢視單一常見問題分類頁面", type: :system do
  let(:faq_category) { create(:faq_category) }

  before(:all) do
    @permit_role = create(:role, permissions: {
      faq_category: {
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
    faq_category = create(:faq_category)
    visit admin_faq_category_path(faq_category)
    expect(page).to have_content("無權進行此操作")
  end

  it "有 show 權限者，可以到達" do
    login_as(@admin_has_permissions, scope: :admin)
    faq_category = create(:faq_category)
    visit admin_faq_category_path(faq_category)
    expect(page).to have_text(faq_category.name)
  end


  context "頁面內容" do
    before { login_as(@admin_has_permissions, scope: :admin) }
    context "「基本資訊」頁籤" do
      let!(:faq_category) { create(:faq_category, :published_tw) }

      before do
        visit admin_faq_category_path(faq_category)
        find('.tabs-group .tabs-btn').click_link('基本資訊')
      end

      it "可以看到「更新時間」" do
        expect(page).to have_text('更新於')
        expect(page).to have_text(faq_category.updated_at.strftime("%F %R"))
      end

      it "可以看到「建立時間」" do
        expect(page).to have_text('建立於')
        expect(page).to have_text(faq_category.created_at.strftime("%F %R"))
      end
    end

    context "「中文」頁籤" do
      let(:faq_category) { create(:faq_category, :published_tw) }

      it "可以看到「標題」" do
        visit admin_faq_category_path(faq_category)
        find('.tabs-group .tabs-btn').click_link('中文')
        expect(page).to have_text('分類名稱')
        expect(page).to have_content(faq_category.name)
      end

      it "可以看到「網址」" do
        visit admin_faq_category_path(faq_category)
        host = Rails.application.config.action_mailer.default_url_options[:host]
        port = Capybara.current_session.server.port
        link = cate_faqs_url(host: host, port: port, faq_category: faq_category.slug)
        find('.tabs-group .tabs-btn').click_link('中文')
        expect(page).to have_text('網址')
        expect(page).to have_content(link)
      end

      context "可以看到「發布狀態」" do
        it "分類中文狀態 為「公開」時，可以看到「綠色」圖示" do
          published_category = create(:faq_category, :published_tw)
          visit admin_faq_category_path(published_category)
          find('.tabs-group .tabs-btn').click_link('中文')
          expect(page).to have_xpath("//img[contains(@src,admin/status_visible.svg)]")
        end

        it "分類中文狀態 為「未公開」狀態時，可以看到「灰色」圖示" do
          unpublished_category = create(:faq_category, :hidden_tw)
          visit admin_faq_category_path(unpublished_category)
          find('.tabs-group .tabs-btn').click_link('中文')
          expect(page).to have_xpath("//img[contains(@src,admin/status_invisible.svg)]")
        end
      end
    end

    context "「英文」頁籤" do
      let(:faq_category) { create(:faq_category, :published_en) }

      it "可以看到「分類英文名稱」" do
        visit admin_faq_category_path(faq_category)
        find('.tabs-group .tabs-btn').click_link('英文')
        expect(page).to have_content(faq_category.name_en)
      end

      it "可以看到「網址」" do
        visit admin_faq_category_path(faq_category)
        host = Rails.application.config.action_mailer.default_url_options[:host]
        port = Capybara.current_session.server.port
        link = cate_faqs_url(host: host, port: port, locale: :en, faq_category: faq_category.slug)
        find('.tabs-group .tabs-btn').click_link('英文')
        expect(page).to have_text('網址')
        expect(page).to have_content(link)
      end

      context "可以看到「發布狀態」" do
        it "分類英文狀態 為「公開」時，可以看到「綠色」圖示" do
          published_category = create(:faq_category, :published_en)
          visit admin_faq_category_path(published_category)
          find('.tabs-group .tabs-btn').click_link('英文')
          expect(page).to have_xpath("//img[contains(@src,admin/status_visible.svg)]")
        end

        it "分類英文狀態 為「未公開」狀態時，可以看到「灰色」圖示" do
          unpublished_category = create(:faq_category, :hidden_en)
          visit admin_faq_category_path(unpublished_category)
          find('.tabs-group .tabs-btn').click_link('英文')
          expect(page).to have_xpath("//img[contains(@src,admin/status_invisible.svg)]")
        end
      end
    end

    context "「SEO」頁籤" do
      let(:faq_category) { create(:faq_category, :with_seo) }

      before do
        visit admin_faq_category_path(faq_category)
        find('.tabs-group .tabs-btn').click_link('SEO')
      end

      context "中文" do
        it "可以看到「H1」" do
          expect(page).to have_content(faq_category.name)
        end

        it "可以看到「Meta 標題」" do
          expect(page).to have_content(faq_category.meta_title)
        end

        it "可以看到「Meta 關鍵字」" do
          expect(page).to have_content(faq_category.meta_keywords)
        end

        it "可以看到「Meta 描述」" do
          expect(page).to have_content(faq_category.meta_desc)
        end

        it "可以看到「OG 標題」" do
          expect(page).to have_content(faq_category.og_title)
        end

        it "可以看到「OG 描述」" do
          expect(page).to have_content(faq_category.og_desc)
        end

        it "可以看到「OG 圖片」" do
          expect(page).to have_xpath("//img[contains(@src,faq_category.og_image)]")
        end
      end

      context "英文" do
        it "可以看到「H1」" do
          expect(page).to have_content(faq_category.name_en)
        end

        it "可以看到「Meta 標題」" do
          expect(page).to have_text(faq_category.meta_title(locale: :en))
        end

        it "可以看到「Meta 關鍵字」" do
          expect(page).to have_content(faq_category.meta_keywords(locale: :en))
        end

        it "可以看到「Meta 描述」" do
          expect(page).to have_content(faq_category.meta_desc(locale: :en))
        end

        it "可以看到「OG 標題」" do
          expect(page).to have_content(faq_category.og_title(locale: :en))
        end

        it "可以看到「OG 描述」" do
          expect(page).to have_content(faq_category.og_desc(locale: :en))
        end

        it "可以看到「OG 圖片」" do
          expect(page).to have_xpath("//img[contains(@src,faq_category.og_image_en)]")
        end
      end
    end
  end

  context "按鈕區塊" do
    let(:show_permission_role) { create(:role, permissions: {
      faq_category: { index: true, show: true }
    }) }

    let(:edit_permission_role) { create(:role, permissions: {
      faq_category: { index: true, show: true, edit: true }
    }) }

    let(:destroy_permission_role) { create(:role, permissions: {
      faq_category: { index: true, show: true, destroy: true }
    }) }

    let(:show_permission_admin) { create(:admin, role: show_permission_role) }
    let(:edit_permission_admin) { create(:admin, role: edit_permission_role) }
    let(:destroy_permission_admin) { create(:admin, role: destroy_permission_role) }
    let!(:faq_category) { create(:faq_category) }

    context "編輯按鈕 (edit)" do
      it "沒有 edit 權限者，不可以看到" do
        login_as(show_permission_admin, scope: :admin)
        visit admin_faq_category_path(faq_category)
        expected_content = find('.float-btns')
        expect(expected_content).not_to have_content(I18n.t('btn.edit'))
      end

      it "有 edit 權限者，可以看到" do
        login_as(edit_permission_admin, scope: :admin)
        visit admin_faq_category_path(faq_category)
        expected_content = find('.float-btns')
        expect(expected_content).to have_content(I18n.t('btn.edit'))
      end
    end

    context "刪除按鈕 (destroy)" do
      it "沒有 destroy 權限者，不可以看到" do
        login_as(show_permission_admin, scope: :admin)
        visit admin_faq_category_path(faq_category)
        expected_content = find('.float-btns')
        expect(expected_content).not_to have_css('.btn-danger-light')
      end

      it "有 destroy 權限者，可以看到" do
        login_as(destroy_permission_admin, scope: :admin)
        visit admin_faq_category_path(faq_category)
        expected_content = find('.float-btns')
        expect(expected_content).to have_css('.btn-danger-light')
      end
    end
  end
end
