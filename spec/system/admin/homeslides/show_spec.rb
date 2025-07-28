require 'rails_helper'

RSpec.describe "檢視首頁輪播頁面", type: :system do
  let(:home_slide) { create(:home_slide, :with_title) }

  before(:all) do
    @permit_role = create(:role, permissions: {
      home_slide: {
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
    home_slide
    visit admin_home_slide_path(home_slide)
    expect(page).to have_content("無權進行此操作")
  end

  it "有 show 權限者，可以到達" do
    login_as(@admin_has_permissions, scope: :admin)
    home_slide
    visit admin_home_slide_path(home_slide)
    find('.tabs-group .tabs-btn').click_link('中文')
    expect(page).to have_text(home_slide.title)
  end

  context "頁面內容" do
    before { login_as(@admin_has_permissions, scope: :admin) }
    context "「共同資訊」" do
      let!(:home_slide) { create(:home_slide) }

      before do
        visit admin_home_slide_path(home_slide)
      end

      it "可以看到「更新時間」" do
        expect(page).to have_text('更新於')
        expect(page).to have_text(home_slide.updated_at.strftime("%F %R"))
      end

      it "可以看到「建立時間」" do
        expect(page).to have_text('建立於')
        expect(page).to have_text(home_slide.created_at.strftime("%F %R"))
      end
    end

    context "「中文」頁籤" do
      let(:home_slide) { create(:home_slide, :published_tw, :with_link, :with_title, :with_alt, :with_desc) }

      it "可以看到「標題」" do
        visit admin_home_slide_path(home_slide)
        find('.tabs-group .tabs-btn').click_link('中文')
        expect(page).to have_text('標題')
        expect(page).to have_content(home_slide.title)
      end

      it "可以看到「發布時間」" do
        visit admin_home_slide_path(home_slide)
        find('.tabs-group .tabs-btn').click_link('中文')
        expect(page).to have_text('發布時間')
        expect(page).to have_content(home_slide.published_at.strftime("%F %R"))
      end

      it "可以看到「下架時間」" do
        visit admin_home_slide_path(home_slide)
        find('.tabs-group .tabs-btn').click_link('中文')
        expect(page).to have_text('下架時間')
        expect(page).to have_content(home_slide.expired_at.strftime("%F %R"))
      end

      it "可以看到「描述」" do
        visit admin_home_slide_path(home_slide)
        find('.tabs-group .tabs-btn').click_link('中文')
        expect(page).to have_text('描述')
        expect(page).to have_content(home_slide.desc_zh_tw)
      end

      it "可以看到「輪播圖片連結」" do
        visit admin_home_slide_path(home_slide)
        host = Rails.application.config.action_mailer.default_url_options[:host]
        port = Capybara.current_session.server.port
        link = home_slide.link_zh_tw
        find('.tabs-group .tabs-btn').click_link('中文')
        expect(page).to have_text('輪播圖片連結')
        expect(page).to have_content(link)
      end

      it "可以看到「替代文字」" do
        visit admin_home_slide_path(home_slide)
        find('.tabs-group .tabs-btn').click_link('中文')
        expect(page).to have_text('圖片替代文字')
        expect(page).to have_content(home_slide.alt_zh_tw)
      end

      context "可以看到「發布狀態」" do
        it "首頁輪播中文狀態 為「公開」時，可以看到「綠色」圖示" do
          published_home_slide = create(:home_slide, :published_tw)
          visit admin_home_slide_path(published_home_slide)
          find('.tabs-group .tabs-btn').click_link('中文')
          expect(page).to have_xpath("//img[contains(@src,admin/status_visible.svg)]")
        end

        it "首頁輪播中文狀態 為「未公開」狀態時，可以看到「灰色」圖示" do
          hidden_home_slide = create(:home_slide)
          visit admin_home_slide_path(hidden_home_slide)
          find('.tabs-group .tabs-btn').click_link('中文')
          expect(page).to have_xpath("//img[contains(@src,admin/status_invisible.svg)]")
        end

        it "首頁輪播中文狀態 為「已過下架時間」狀態時，可以看到「灰色」圖示" do
          expired_home_slide = create(:home_slide, :expired_tw)
          visit admin_home_slide_path(expired_home_slide)
          find('.tabs-group .tabs-btn').click_link('中文')
          expect(page).to have_xpath("//img[contains(@src,admin/status_invisible.svg)]")
        end

        it "首頁輪播中文狀態 為「未到發布時間」狀態時，可以看到「灰色」圖示" do
          future_home_slide = create(:home_slide, :future_tw)
          visit admin_home_slide_path(future_home_slide)
          find('.tabs-group .tabs-btn').click_link('中文')
          expect(page).to have_xpath("//img[contains(@src,admin/status_invisible.svg)]")
        end
      end
    end

    context "「英文」頁籤" do
      let(:home_slide) { create(:home_slide, :with_banner_en, :published_en, :with_link, :with_title, :with_desc, :with_alt) }

      it "可以看到「英文標題」" do
        visit admin_home_slide_path(home_slide)
        find('.tabs-group .tabs-btn').click_link('英文')
        expect(page).to have_text('標題')
        expect(page).to have_content(home_slide.title_en)
      end

      it "可以看到「發布時間」" do
        visit admin_home_slide_path(home_slide)
        find('.tabs-group .tabs-btn').click_link('英文')
        expect(page).to have_text('發布時間')
        expect(page).to have_content(home_slide.published_at_en.strftime("%F %R"))
      end

      it "可以看到「下架時間」" do
        visit admin_home_slide_path(home_slide)
        find('.tabs-group .tabs-btn').click_link('英文')
        expect(page).to have_text('下架時間')
        expect(page).to have_content(home_slide.expired_at_en.strftime("%F %R"))
      end

      it "可以看到「英文描述」" do
        visit admin_home_slide_path(home_slide)
        find('.tabs-group .tabs-btn').click_link('英文')
        expect(page).to have_text('英文描述')
        expect(page).to have_content(home_slide.desc_en)
      end

      it "可以看到「英文輪播圖片連結」" do
        visit admin_home_slide_path(home_slide)
        host = Rails.application.config.action_mailer.default_url_options[:host]
        port = Capybara.current_session.server.port
        link = home_slide.link_en
        find('.tabs-group .tabs-btn').click_link('英文')
        expect(page).to have_text('英文輪播圖片連結')
        expect(page).to have_content(link)
      end

      it "可以看到「替代文字」" do
        visit admin_home_slide_path(home_slide)
        find('.tabs-group .tabs-btn').click_link('英文')
        expect(page).to have_text('英文圖片替代文字')
        expect(page).to have_content(home_slide.alt_en)
      end

      it "可以看到「英文輪播圖片連結」" do
        visit admin_home_slide_path(home_slide)
        host = Rails.application.config.action_mailer.default_url_options[:host]
        port = Capybara.current_session.server.port
        link = home_slide.link_en
        find('.tabs-group .tabs-btn').click_link('英文')
        expect(page).to have_text('英文輪播圖片連結')
        expect(page).to have_content(link)
      end

      it "可以看到「英文圖片替代文字」" do
        visit admin_home_slide_path(home_slide)
        find('.tabs-group .tabs-btn').click_link('英文')
        expect(page).to have_text('英文圖片替代文字')
        expect(page).to have_content(home_slide.alt_en)
      end

      context "可以看到「發布狀態」" do
        it "首頁輪播英文狀態 為「公開」時，可以看到「綠色」圖示" do
          published_home_slide = create(:home_slide, :published_en, :with_banner_en)
          visit admin_home_slide_path(published_home_slide)
          find('.tabs-group .tabs-btn').click_link('英文')
          expect(page).to have_xpath("//img[contains(@src,admin/status_visible.svg)]")
        end

        it "首頁輪播英文狀態 為「未公開」狀態時，可以看到「灰色」圖示" do
          hidden_home_slide = create(:home_slide, :expired_en)
          visit admin_home_slide_path(hidden_home_slide)
          find('.tabs-group .tabs-btn').click_link('英文')
          expect(page).to have_xpath("//img[contains(@src,admin/status_invisible.svg)]")
        end

        it "首頁輪播英文狀態 為「已過下架時間」狀態時，可以看到「灰色」圖示" do
          expired_home_slide = create(:home_slide, :expired_en)
          visit admin_home_slide_path(expired_home_slide)
          find('.tabs-group .tabs-btn').click_link('英文')
          expect(page).to have_xpath("//img[contains(@src,admin/status_invisible.svg)]")
        end

        it "首頁輪播英文狀態 為「未到發布時間」狀態時，可以看到「灰色」圖示" do
          future_home_slide = create(:home_slide, :future_en)
          visit admin_home_slide_path(future_home_slide)
          find('.tabs-group .tabs-btn').click_link('英文')
          expect(page).to have_xpath("//img[contains(@src,admin/status_invisible.svg)]")
        end
      end
    end
  end

  context "按鈕區塊" do
    let(:show_permission_role) { create(:role, permissions: {
      home_slide: { index: true, show: true }
    }) }

    let(:edit_permission_role) { create(:role, permissions: {
      home_slide: { index: true, show: true, edit: true }
    }) }

    let(:destroy_permission_role) { create(:role, permissions: {
      home_slide: { index: true, show: true, destroy: true }
    }) }

    let(:show_permission_admin) { create(:admin, role: show_permission_role) }
    let(:edit_permission_admin) { create(:admin, role: edit_permission_role) }
    let(:destroy_permission_admin) { create(:admin, role: destroy_permission_role) }
    let!(:home_slide) { create(:home_slide) }

    context "編輯按鈕 (edit)" do
      it "沒有 edit 權限者，不可以看到" do
        login_as(show_permission_admin, scope: :admin)
        visit admin_home_slide_path(home_slide)
        expected_content = find('.float-btns')
        expect(expected_content).not_to have_content(I18n.t('btn.edit'))
      end

      it "有 edit 權限者，可以看到" do
        login_as(edit_permission_admin, scope: :admin)
        visit admin_home_slide_path(home_slide)
        expected_content = find('.float-btns')
        expect(expected_content).to have_content(I18n.t('btn.edit'))
      end
    end

    context "刪除按鈕 (destroy)" do
      it "沒有 destroy 權限者，不可以看到" do
        login_as(show_permission_admin, scope: :admin)
        visit admin_home_slide_path(home_slide)
        expected_content = find('.float-btns')
        expect(expected_content).not_to have_css('.btn-danger-light')
      end

      it "有 destroy 權限者，可以看到" do
        login_as(destroy_permission_admin, scope: :admin)
        visit admin_home_slide_path(home_slide)
        expected_content = find('.float-btns')
        expect(expected_content).to have_css('.btn-danger-light')
      end
    end
  end
end
