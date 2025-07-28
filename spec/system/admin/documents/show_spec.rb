require 'rails_helper'

RSpec.describe "檢視單一檔案頁面", type: :system do
  let(:document) { create(:document) }

  before(:all) do
    @permit_role = create(:role, permissions: {
      document: {
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
    document
    visit admin_document_path(document)
    expect(page).to have_content("無權進行此操作")
  end

  it "有 show 權限者，可以到達" do
    login_as(@admin_has_permissions, scope: :admin)
    document
    visit admin_document_path(document)
    expect(page).to have_text(document.title)
  end

  context "頁面內容" do
    before(:all) do
      @document = create(:document)
      @link_document = create(:document, :link)
      @file_document = create(:document, :file)
    end

    after(:all) do
      Document.delete_all
    end

    before do
      login_as(@admin_has_permissions, scope: :admin)
    end

    it "可以看到「檔案標題」" do
      visit admin_document_path(@document)
      expect(page).to have_text('檔案標題')
      expect(page).to have_content(@document.title)
    end

    it "可以看到「顯示在哪個語言」" do
      visit admin_document_path(@document)
      expect(page).to have_text('顯示在哪個語言')
      expect(page).to have_text('中文')
    end

    it "可以看到「更新時間」" do
      visit admin_document_path(@document)
      expect(page).to have_text('更新於')
      expect(page).to have_text(@document.updated_at.strftime("%F %R"))
    end

    it "可以看到「建立時間」" do
      visit admin_document_path(@document)
      expect(page).to have_text('建立於')
      expect(page).to have_text(@document.created_at.strftime("%F %R"))
    end

    context "當檔案類型為「檔案」時" do
      it "可以在「檔案類型」看到「下載圖示」" do
        visit admin_document_path(@file_document)
        expect(page).to have_xpath("//img[contains(@src,admin/file.svg)]")
      end

      it "可以在「檔案路徑」看到「slug」" do
        visit admin_document_path(@file_document)
        expect(page).to have_text('檔案路徑')
        expect(page).to have_content(@file_document.slug)
      end

      it "可以看到「檔案預覽」" do
        visit admin_document_path(@file_document)
        expect(page).to have_text('檔案')
        expect(page).to have_xpath("//img[contains(@src,@file_document.file)]")
      end
    end

    context "當檔案類型為「連結」時" do
      it "可以在「檔案類型」看到「連結圖示」" do
        visit admin_document_path(@link_document)
        expect(page).to have_xpath("//img[contains(@src,admin/link.svg)]")
      end

      it "可以在「檔案路徑」看到「連結」" do
        visit admin_document_path(@link_document)
        expect(page).to have_text('檔案路徑')
        expect(page).to have_content(@link_document.link)
      end
    end
  end

#   ▄▄▄▄▄▄▄▄▄▄   ▄         ▄  ▄▄▄▄▄▄▄▄▄▄▄  ▄▄▄▄▄▄▄▄▄▄▄  ▄▄▄▄▄▄▄▄▄▄▄  ▄▄        ▄
#  ▐░░░░░░░░░░▌ ▐░▌       ▐░▌▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌▐░░▌      ▐░▌
#  ▐░█▀▀▀▀▀▀▀█░▌▐░▌       ▐░▌ ▀▀▀▀█░█▀▀▀▀  ▀▀▀▀█░█▀▀▀▀ ▐░█▀▀▀▀▀▀▀█░▌▐░▌░▌     ▐░▌
#  ▐░▌       ▐░▌▐░▌       ▐░▌     ▐░▌          ▐░▌     ▐░▌       ▐░▌▐░▌▐░▌    ▐░▌
#  ▐░█▄▄▄▄▄▄▄█░▌▐░▌       ▐░▌     ▐░▌          ▐░▌     ▐░▌       ▐░▌▐░▌ ▐░▌   ▐░▌
#  ▐░░░░░░░░░░▌ ▐░▌       ▐░▌     ▐░▌          ▐░▌     ▐░▌       ▐░▌▐░▌  ▐░▌  ▐░▌
#  ▐░█▀▀▀▀▀▀▀█░▌▐░▌       ▐░▌     ▐░▌          ▐░▌     ▐░▌       ▐░▌▐░▌   ▐░▌ ▐░▌
#  ▐░▌       ▐░▌▐░▌       ▐░▌     ▐░▌          ▐░▌     ▐░▌       ▐░▌▐░▌    ▐░▌▐░▌
#  ▐░█▄▄▄▄▄▄▄█░▌▐░█▄▄▄▄▄▄▄█░▌     ▐░▌          ▐░▌     ▐░█▄▄▄▄▄▄▄█░▌▐░▌     ▐░▐░▌
#  ▐░░░░░░░░░░▌ ▐░░░░░░░░░░░▌     ▐░▌          ▐░▌     ▐░░░░░░░░░░░▌▐░▌      ▐░░▌
#   ▀▀▀▀▀▀▀▀▀▀   ▀▀▀▀▀▀▀▀▀▀▀       ▀            ▀       ▀▀▀▀▀▀▀▀▀▀▀  ▀        ▀▀
#

  context "按鈕區塊" do
    let(:show_permission_role) { create(:role, permissions: {
      document: { index: true, show: true }
    }) }

    let(:edit_permission_role) { create(:role, permissions: {
      document: { index: true, show: true, edit: true }
    }) }

    let(:destroy_permission_role) { create(:role, permissions: {
      document: { index: true, show: true, destroy: true }
    }) }

    let(:show_permission_admin) { create(:admin, role: show_permission_role) }
    let(:edit_permission_admin) { create(:admin, role: edit_permission_role) }
    let(:destroy_permission_admin) { create(:admin, role: destroy_permission_role) }
    let!(:document) { create(:document) }

    context "編輯按鈕 (edit)" do
      it "沒有 edit 權限者，不可以看到" do
        login_as(show_permission_admin, scope: :admin)
        visit admin_document_path(document)
        expected_content = find('.float-btns')
        expect(expected_content).not_to have_content(I18n.t('btn.edit'))
      end

      it "有 edit 權限者，可以看到" do
        login_as(edit_permission_admin, scope: :admin)
        visit admin_document_path(document)
        expected_content = find('.float-btns')
        expect(expected_content).to have_content(I18n.t('btn.edit'))
      end
    end

    context "刪除按鈕 (destroy)" do
      it "沒有 destroy 權限者，不可以看到" do
        login_as(show_permission_admin, scope: :admin)
        visit admin_document_path(document)
        expected_content = find('.float-btns')
        expect(expected_content).not_to have_css('.btn-danger-light')
      end

      it "有 destroy 權限者，可以看到" do
        login_as(destroy_permission_admin, scope: :admin)
        visit admin_document_path(document)
        expected_content = find('.float-btns')
        expect(expected_content).to have_css('.btn-danger-light')
      end
    end
  end
end
