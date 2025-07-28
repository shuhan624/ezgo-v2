require 'rails_helper'

RSpec.describe "檢視單一頁面管理", type: :system do
  let(:custom_page) { create(:custom_page) }

  before(:all) do
    @permit_role = create(:role, permissions: {
      custom_page: {
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
    visit admin_custom_page_path(custom_page)
    expect(page).to have_content("無權進行此操作")
  end

  it "有 show 權限者，可以到達" do
    login_as(@admin_has_permissions, scope: :admin)
    visit admin_custom_page_path(custom_page)
    expect(page).to have_text(custom_page.title)
  end

  context "頁面內容" do
    before { login_as(@admin_has_permissions, scope: :admin) }
    context "「中文」頁籤" do
      it "可以看到「網址」" do
        visit admin_custom_page_path(custom_page)
        find('.tabs-group .tabs-btn').click_link('中文')
        expect(page).to have_text('網址')
        expect(page).to have_text(custom_page.slug)
      end

      it "可以看到「標題」" do
        visit admin_custom_page_path(custom_page)
        find('.tabs-group .tabs-btn').click_link('中文')
        expect(page).to have_text('標題')
        expect(page).to have_text(custom_page.title)
      end

      context "中文發布狀態" do
        context "預設頁面，不會看到發布狀態" do
          it "公開時，不會看到「綠色」圖示" do
            custom_page = create(:custom_page, :default_page, :published_tw)
            visit admin_custom_page_path(custom_page)
            find('.tabs-group .tabs-btn').click_link('中文')
            element = find('div#zh-hant')
            expect(element).not_to have_css("img[src*='admin/status_visible']")
          end

          it "隱藏時，不會看到「灰色」圖示" do
            custom_page = create(:custom_page, :default_page, :hidden_tw)
            visit admin_custom_page_path(custom_page)
            find('.tabs-group .tabs-btn').click_link('中文')
            element = find('div#zh-hant')
            expect(element).not_to have_css("img[src*='admin/status_invisible']")
          end
        end

        context "非預設頁面，可以看到發布狀態" do
          it "自訂中文狀態 為「公開」時，可以看到「綠色」圖示" do
            published_custom_page = create(:custom_page, :published_tw)
            visit admin_custom_page_path(published_custom_page)
            find('.tabs-group .tabs-btn').click_link('中文')
            element = find('div#zh-hant')
            expect(element).to have_css("img[src*='admin/status_visible']")
          end

          it "自訂中文狀態 為「未公開」狀態時，可以看到「灰色」圖示" do
            hidden_custom_page = create(:custom_page, :hidden_tw)
            visit admin_custom_page_path(hidden_custom_page)
            find('.tabs-group .tabs-btn').click_link('中文')
            element = find('div#zh-hant')
            expect(element).to have_css("img[src*='admin/status_invisible']")
          end
        end
      end

      context "中文內容" do
        it "類型為「頁面管理內容」時，可以看到「內容」欄位" do
          custom_page = create(:custom_page, :info)
          visit admin_custom_page_path(custom_page)
          find('.tabs-group .tabs-btn').click_link('中文')
          expect(page).to have_text('內容')
          expect(page).to have_text(custom_page.content)
        end

        it "類型為「設計」時，看不到「內容」欄位" do
          custom_page = create(:custom_page, :design)
          visit admin_custom_page_path(custom_page)
          find('.tabs-group .tabs-btn').click_link('中文')
          expect(page).not_to have_text('內容')
        end

        it "類型為「彙整頁」時，看不到「內容」欄位" do
          custom_page = create(:custom_page, :archive)
          visit admin_custom_page_path(custom_page)
          find('.tabs-group .tabs-btn').click_link('中文')
          expect(page).not_to have_text('內容')
        end
      end
    end

    context "「英文」頁籤" do
      it "可以看到「英文標題」" do
        visit admin_custom_page_path(custom_page)
        find('.tabs-group .tabs-btn').click_link('英文')
        expect(page).to have_text('英文標題')
        expect(page).to have_text(custom_page.title_en)
      end

      context "中文發布狀態" do
        context "預設頁面，不會看到發布狀態" do
          it "公開時，不會看到「綠色」圖示" do
            custom_page = create(:custom_page, :default_page, :published_tw)
            visit admin_custom_page_path(custom_page)
            find('.tabs-group .tabs-btn').click_link('英文')
            element = find('div#en')
            expect(element).not_to have_css("img[src*='admin/status_visible']")
          end

          it "隱藏時，不會看到「灰色」圖示" do
            custom_page = create(:custom_page, :default_page, :hidden_tw)
            visit admin_custom_page_path(custom_page)
            find('.tabs-group .tabs-btn').click_link('英文')
            element = find('div#en')
            expect(element).not_to have_css("img[src*='admin/status_invisible']")
          end
        end

        context "非預設頁面，可以看到發布狀態" do
          it "自訂英文狀態 為「公開」時，可以看到「綠色」圖示" do
            published_custom_page = create(:custom_page, :published_en)
            visit admin_custom_page_path(published_custom_page)
            find('.tabs-group .tabs-btn').click_link('英文')
            element = find('div#en')
            expect(element).to have_css("img[src*='admin/status_visible']")
          end

          it "自訂英文狀態 為「未公開」狀態時，可以看到「灰色」圖示" do
            hidden_custom_page = create(:custom_page, :hidden_en)
            visit admin_custom_page_path(hidden_custom_page)
            find('.tabs-group .tabs-btn').click_link('英文')
            element = find('div#en')
            expect(element).to have_css("img[src*='admin/status_invisible']")
          end
        end
      end

      context "英文內容" do
        it "類型為「頁面管理內容」時，可以看到「英文內容」欄位" do
          custom_page = create(:custom_page, :info)
          visit admin_custom_page_path(custom_page)
          find('.tabs-group .tabs-btn').click_link('英文')
          expect(page).to have_text('英文內容')
          expect(page).to have_text(custom_page.content_en)
        end

        it "類型為「設計」時，看不到「英文內容」欄位" do
          custom_page = create(:custom_page, :design)
          visit admin_custom_page_path(custom_page)
          find('.tabs-group .tabs-btn').click_link('英文')
          expect(page).not_to have_text('英文內容')
        end

        it "類型為「彙整頁」時，看不到「英文內容」欄位" do
          custom_page = create(:custom_page, :archive)
          visit admin_custom_page_path(custom_page)
          find('.tabs-group .tabs-btn').click_link('英文')
          expect(page).not_to have_text('英文內容')
        end
      end
    end

    context "「SEO」頁籤" do
      let(:custom_page) { create(:custom_page, :with_seo) }

      before do
        visit admin_custom_page_path(custom_page)
        find('.tabs-group .tabs-btn').click_link('SEO')
      end

      context "中文" do
        it "可以看到「H1」" do
          expect(page).to have_content(custom_page.title)
        end

        it "可以看到「Meta 標題」" do
          expect(page).to have_content(custom_page.meta_title)
        end

        it "可以看到「Meta 關鍵字」" do
          expect(page).to have_content(custom_page.meta_keywords)
        end

        it "可以看到「Meta 描述」" do
          expect(page).to have_content(custom_page.meta_desc)
        end

        it "可以看到「OG 標題」" do
          expect(page).to have_content(custom_page.og_title)
        end

        it "可以看到「OG 描述」" do
          expect(page).to have_content(custom_page.og_desc)
        end

        it "可以看到「OG 圖片」" do
          expect(page).to have_xpath("//img[contains(@src,custom_page.og_image)]")
        end
      end

      context "英文" do
        it "可以看到「H1」" do
          expect(page).to have_content(custom_page.title_en)
        end

        it "可以看到「Meta 標題」" do
          expect(page).to have_text(custom_page.meta_title(locale: :en))
        end

        it "可以看到「Meta 關鍵字」" do
          expect(page).to have_content(custom_page.meta_keywords(locale: :en))
        end

        it "可以看到「Meta 描述」" do
          expect(page).to have_content(custom_page.meta_desc(locale: :en))
        end

        it "可以看到「OG 標題」" do
          expect(page).to have_content(custom_page.og_title(locale: :en))
        end

        it "可以看到「OG 描述」" do
          expect(page).to have_content(custom_page.og_desc(locale: :en))
        end

        it "可以看到「OG 圖片」" do
          expect(page).to have_xpath("//img[contains(@src,custom_page.og_image_en)]")
        end
      end
    end
  end

  context "按鈕區塊" do
    let(:show_permission_role) { create(:role, permissions: {
      custom_page: { index: true, show: true }
    }) }

    let(:edit_permission_role) { create(:role, permissions: {
      custom_page: { index: true, show: true, edit: true }
    }) }

    let(:destroy_permission_role) { create(:role, permissions: {
      custom_page: { index: true, show: true, destroy: true }
    }) }

    let(:show_permission_admin) { create(:admin, role: show_permission_role) }
    let(:edit_permission_admin) { create(:admin, role: edit_permission_role) }
    let(:destroy_permission_admin) { create(:admin, role: destroy_permission_role) }
    let!(:custom_page) { create(:custom_page) }
    context "編輯按鈕 (edit)" do
      it "沒有 edit 權限者，不可以看到" do
        login_as(show_permission_admin, scope: :admin)
        visit admin_custom_page_path(custom_page)
        expected_content = find('.float-btns')
        expect(expected_content).not_to have_content(I18n.t('btn.edit'))
      end

      it "有 edit 權限者，可以看到" do
        login_as(edit_permission_admin, scope: :admin)
        visit admin_custom_page_path(custom_page)
        expected_content = find('.float-btns')
        expect(expected_content).to have_content(I18n.t('btn.edit'))
      end
    end

    context "刪除按鈕 (destroy)" do
      it "沒有 destroy 權限者，不可以看到" do
        login_as(show_permission_admin, scope: :admin)
        visit admin_custom_page_path(custom_page)
        expected_content = find('.float-btns')
        expect(expected_content).not_to have_css('.btn-danger-light')
      end

      it "有 destroy 權限者，可以看到" do
        login_as(destroy_permission_admin, scope: :admin)
        visit admin_custom_page_path(custom_page)
        expected_content = find('.float-btns')
        expect(expected_content).to have_css('.btn-danger-light')
      end
    end
  end
end
