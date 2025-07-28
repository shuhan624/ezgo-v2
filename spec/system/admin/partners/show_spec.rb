require 'rails_helper'

RSpec.describe "檢視單一合作夥伴頁面", type: :system do
  let(:partner) { create(:partner) }

  before(:all) do
    @permit_role = create(:role, permissions: {
      partner: {
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
    partner
    visit admin_partner_path(partner)
    expect(page).to have_content("無權進行此操作")
  end

  it "有 show 權限者，可以到達" do
    login_as(@admin_has_permissions, scope: :admin)
    partner
    visit admin_partner_path(partner)
    find('.tabs-group .tabs-btn').click_link('中文')
    expect(page).to have_text(partner.name)
  end

  context "頁面內容" do
    before { login_as(@admin_has_permissions, scope: :admin) }
    context "「基本資訊」頁籤" do
      let!(:partner) { create(:partner) }

      before do
        visit admin_partner_path(partner)
        find('.tabs-group .tabs-btn').click_link('基本資訊')
      end

      it "可以看到「更新時間」" do
        expect(page).to have_text('更新於')
        expect(page).to have_text(partner.updated_at.strftime("%F %R"))
      end

      it "可以看到「建立時間」" do
        expect(page).to have_text('建立於')
        expect(page).to have_text(partner.created_at.strftime("%F %R"))
      end
    end

    context "「中文」頁籤" do
      let(:partner) { create(:partner, :with_image, :with_image_alt_tw, :link_tw) }

      it "可以看到「Logo」" do
        visit admin_partner_path(partner)
        find('.tabs-group .tabs-btn').click_link('中文')
        expect(page).to have_xpath("//img[contains(@src,partner.image)]")
      end

      it "可以看到「名稱」" do
        visit admin_partner_path(partner)
        find('.tabs-group .tabs-btn').click_link('中文')
        expect(page).to have_text('名稱')
        expect(page).to have_content(partner.name)
      end

      it "可以看到「連結」" do
        visit admin_partner_path(partner)
        host = Rails.application.config.action_mailer.default_url_options[:host]
        port = Capybara.current_session.server.port
        link = partner.link_zh_tw
        find('.tabs-group .tabs-btn').click_link('中文')
        expect(page).to have_text('連結')
        expect(page).to have_content(link)
      end

      it "可以看到「替代文字」" do
        visit admin_partner_path(partner)
        find('.tabs-group .tabs-btn').click_link('中文')
        expect(page).to have_text('圖片替代文字')
        expect(page).to have_content(partner.alt_zh_tw)
      end

      context "可以看到「發布狀態」" do
        it "合作夥伴中文狀態 為「公開」時，可以看到「綠色」圖示" do
          published_partner = create(:partner, :published_tw, :with_image)
          visit admin_partner_path(published_partner)
          find('.tabs-group .tabs-btn').click_link('中文')
          expect(page).to have_xpath("//img[contains(@src,admin/status_visible.svg)]")
        end

        it "合作夥伴中文狀態 為「未公開」狀態時，可以看到「灰色」圖示" do
          hidden_partner = create(:partner, :hidden_tw)
          visit admin_partner_path(hidden_partner)
          find('.tabs-group .tabs-btn').click_link('中文')
          expect(page).to have_xpath("//img[contains(@src,admin/status_invisible.svg)]")
        end
      end
    end

    context "「英文」頁籤" do
      let(:partner) { create(:partner, :with_image_en, :with_image_alt_en, :link_en) }

      it "可以看到「英文 Logo」" do
        visit admin_partner_path(partner)
        find('.tabs-group .tabs-btn').click_link('英文')
        expect(page).to have_xpath("//img[contains(@src,partner.image_en)]")
      end

      it "可以看到「英文名稱」" do
        visit admin_partner_path(partner)
        find('.tabs-group .tabs-btn').click_link('英文')
        expect(page).to have_text('英文名稱')
        expect(page).to have_content(partner.name_en)
      end

      it "可以看到「英文連結」" do
        visit admin_partner_path(partner)
        host = Rails.application.config.action_mailer.default_url_options[:host]
        port = Capybara.current_session.server.port
        link = partner.link_en
        find('.tabs-group .tabs-btn').click_link('英文')
        expect(page).to have_text('英文連結')
        expect(page).to have_content(link)
      end

      it "可以看到「英文圖片替代文字」" do
        visit admin_partner_path(partner)
        find('.tabs-group .tabs-btn').click_link('英文')
        expect(page).to have_text('英文圖片替代文字')
        expect(page).to have_content(partner.alt_en)
      end

      context "可以看到「發布狀態」" do
        it "合作夥伴英文狀態 為「公開」時，可以看到「綠色」圖示" do
          published_partner = create(:partner, :published_en, :with_image_en)
          visit admin_partner_path(published_partner)
          find('.tabs-group .tabs-btn').click_link('英文')
          expect(page).to have_xpath("//img[contains(@src,admin/status_visible.svg)]")
        end

        it "合作夥伴英文狀態 為「未公開」狀態時，可以看到「灰色」圖示" do
          hidden_partner = create(:partner, :hidden_en, :with_image_en)
          visit admin_partner_path(hidden_partner)
          find('.tabs-group .tabs-btn').click_link('英文')
          expect(page).to have_xpath("//img[contains(@src,admin/status_invisible.svg)]")
        end
      end
    end
  end

  context "按鈕區塊" do
    let(:show_permission_role) { create(:role, permissions: {
      partner: { index: true, show: true }
    }) }

    let(:edit_permission_role) { create(:role, permissions: {
      partner: { index: true, show: true, edit: true }
    }) }

    let(:destroy_permission_role) { create(:role, permissions: {
      partner: { index: true, show: true, destroy: true }
    }) }

    let(:show_permission_admin) { create(:admin, role: show_permission_role) }
    let(:edit_permission_admin) { create(:admin, role: edit_permission_role) }
    let(:destroy_permission_admin) { create(:admin, role: destroy_permission_role) }
    let!(:partner) { create(:partner) }

    context "編輯按鈕 (edit)" do
      it "沒有 edit 權限者，不可以看到" do
        login_as(show_permission_admin, scope: :admin)
        visit admin_partner_path(partner)
        expected_content = find('.float-btns')
        expect(expected_content).not_to have_content(I18n.t('btn.edit'))
      end

      it "有 edit 權限者，可以看到" do
        login_as(edit_permission_admin, scope: :admin)
        visit admin_partner_path(partner)
        expected_content = find('.float-btns')
        expect(expected_content).to have_content(I18n.t('btn.edit'))
      end
    end

    context "刪除按鈕 (destroy)" do
      it "沒有 destroy 權限者，不可以看到" do
        login_as(show_permission_admin, scope: :admin)
        visit admin_partner_path(partner)
        expected_content = find('.float-btns')
        expect(expected_content).not_to have_css('.btn-danger-light')
      end

      it "有 destroy 權限者，可以看到" do
        login_as(destroy_permission_admin, scope: :admin)
        visit admin_partner_path(partner)
        expected_content = find('.float-btns')
        expect(expected_content).to have_css('.btn-danger-light')
      end
    end
  end
end
