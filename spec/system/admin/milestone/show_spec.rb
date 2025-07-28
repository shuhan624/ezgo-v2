require 'rails_helper'

RSpec.describe "檢視單一里程碑頁面", type: :system do
  let(:milestone) { create(:milestone) }

  before(:all) do
    @permit_role = create(:role, permissions: {
      milestone: {
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
    milestone
    visit admin_milestone_path(milestone)
    expect(page).to have_content("無權進行此操作")
  end

  it "有 show 權限者，可以到達" do
    login_as(@admin_has_permissions, scope: :admin)
    milestone
    visit admin_milestone_path(milestone)
    find('.tabs-group .tabs-btn').click_link('中文')
    expect(page).to have_text(milestone.title)
  end

  context "頁面內容" do
    before { login_as(@admin_has_permissions, scope: :admin) }
    context "「基本資訊」頁籤" do
      let!(:milestone) { create(:milestone, :with_image) }

      before do
        visit admin_milestone_path(milestone)
        find('.tabs-group .tabs-btn').click_link('基本資訊')
      end

      it "可以看到 日期" do
        expect(page).to have_text('日期')
        expect(page).to have_text(milestone.date)
      end

      it "可以看到 圖片" do
        visit admin_milestone_path(milestone)
        element = find('.card img')
        expect(element[:src]).to include(milestone.image.filename.to_s)
      end

      it "可以看到「更新時間」" do
        expect(page).to have_text('更新於')
        expect(page).to have_text(milestone.updated_at.strftime("%F %R"))
      end

      it "可以看到「建立時間」" do
        expect(page).to have_text('建立於')
        expect(page).to have_text(milestone.created_at.strftime("%F %R"))
      end
    end

    context "「中文」頁籤" do
      let(:milestone) { create(:milestone, :with_image, :with_image_alt_tw) }

      it "可以看到「標題」" do
        visit admin_milestone_path(milestone)
        find('.tabs-group .tabs-btn').click_link('中文')
        expect(page).to have_text('標題')
        expect(page).to have_content(milestone.title)
      end

      it "可以看到「替代文字」" do
        visit admin_milestone_path(milestone)
        find('.tabs-group .tabs-btn').click_link('中文')
        expect(page).to have_text('圖片替代文字')
        expect(page).to have_content(milestone.alt_zh_tw)
      end

      it "可以看到「內容」" do
        visit admin_milestone_path(milestone)
        find('.tabs-group .tabs-btn').click_link('中文')
        expect(page).to have_text('內容')
        expect(page).to have_content(milestone.content)
      end

      context "可以看到「發布狀態」" do
        it "里程碑中文狀態 為「公開」時，可以看到「綠色」圖示" do
          published_milestone = create(:milestone, :published_tw, :with_image)
          visit admin_milestone_path(published_milestone)
          find('.tabs-group .tabs-btn').click_link('中文')
          expect(page).to have_xpath("//img[contains(@src,admin/status_visible.svg)]")
        end

        it "里程碑中文狀態 為「未公開」狀態時，可以看到「灰色」圖示" do
          hidden_milestone = create(:milestone, :hidden_tw)
          visit admin_milestone_path(hidden_milestone)
          find('.tabs-group .tabs-btn').click_link('中文')
          expect(page).to have_xpath("//img[contains(@src,admin/status_invisible.svg)]")
        end
      end
    end

    context "「英文」頁籤" do
      let(:milestone) { create(:milestone, :with_image, :with_image_alt_en) }

      it "可以看到「標題」" do
        visit admin_milestone_path(milestone)
        find('.tabs-group .tabs-btn').click_link('英文')
        expect(page).to have_text('標題')
        expect(page).to have_content(milestone.title_en)
      end

      it "可以看到「英文圖片替代文字」" do
        visit admin_milestone_path(milestone)
        find('.tabs-group .tabs-btn').click_link('英文')
        expect(page).to have_text('英文圖片替代文字')
        expect(page).to have_content(milestone.alt_en)
      end

      it "可以看到「英文內容」" do
        visit admin_milestone_path(milestone)
        find('.tabs-group .tabs-btn').click_link('英文')
        expect(page).to have_text('英文內容')
        expect(page).to have_content(milestone.content_en)
      end

      context "可以看到「發布狀態」" do
        it "里程碑英文狀態 為「公開」時，可以看到「綠色」圖示" do
          published_milestone = create(:milestone, :published_en, :with_image)
          visit admin_milestone_path(published_milestone)
          find('.tabs-group .tabs-btn').click_link('英文')
          expect(page).to have_xpath("//img[contains(@src,admin/status_visible.svg)]")
        end

        it "里程碑英文狀態 為「未公開」狀態時，可以看到「灰色」圖示" do
          hidden_milestone = create(:milestone, :hidden_en, :with_image)
          visit admin_milestone_path(hidden_milestone)
          find('.tabs-group .tabs-btn').click_link('英文')
          expect(page).to have_xpath("//img[contains(@src,admin/status_invisible.svg)]")
        end
      end
    end
  end

  context "按鈕區塊" do
    let(:show_permission_role) { create(:role, permissions: {
      milestone: { index: true, show: true }
    }) }

    let(:edit_permission_role) { create(:role, permissions: {
      milestone: { index: true, show: true, edit: true }
    }) }

    let(:destroy_permission_role) { create(:role, permissions: {
      milestone: { index: true, show: true, destroy: true }
    }) }

    let(:show_permission_admin) { create(:admin, role: show_permission_role) }
    let(:edit_permission_admin) { create(:admin, role: edit_permission_role) }
    let(:destroy_permission_admin) { create(:admin, role: destroy_permission_role) }
    let!(:milestone) { create(:milestone) }

    context "編輯按鈕 (edit)" do
      it "沒有 edit 權限者，不可以看到" do
        login_as(show_permission_admin, scope: :admin)
        visit admin_milestone_path(milestone)
        expected_content = find('.float-btns')
        expect(expected_content).not_to have_content(I18n.t('btn.edit'))
      end

      it "有 edit 權限者，可以看到" do
        login_as(edit_permission_admin, scope: :admin)
        visit admin_milestone_path(milestone)
        expected_content = find('.float-btns')
        expect(expected_content).to have_content(I18n.t('btn.edit'))
      end
    end

    context "刪除按鈕 (destroy)" do
      it "沒有 destroy 權限者，不可以看到" do
        login_as(show_permission_admin, scope: :admin)
        visit admin_milestone_path(milestone)
        expected_content = find('.float-btns')
        expect(expected_content).not_to have_css('.btn-danger-light')
      end

      it "有 destroy 權限者，可以看到" do
        login_as(destroy_permission_admin, scope: :admin)
        visit admin_milestone_path(milestone)
        expected_content = find('.float-btns')
        expect(expected_content).to have_css('.btn-danger-light')
      end
    end
  end
end
