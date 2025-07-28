require 'rails_helper'

RSpec.describe "檢視單一聯絡我們頁面", type: :system do
  let(:contact) { create(:contact) }

  before(:all) do
    @permit_role = create(:role, permissions: {
      contact: {
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
    visit admin_contact_path(contact)
    expect(page).to have_content("無權進行此操作")
  end

  it "有 show 權限者，可以到達" do
    login_as(@admin_has_permissions, scope: :admin)
    visit admin_contact_path(contact)
    expect(page).to have_text(contact.name)
  end

  context "頁面內容" do
    before { login_as(@admin_has_permissions, scope: :admin) }
    let!(:contact) { create(:contact, :note) }
    before do
      visit admin_contact_path(contact)
    end

    it "可以看到「姓名」" do
      expect(page).to have_text('姓名')
      expect(page).to have_content(contact.name)
    end

    it "可以看到「Email」" do
      expect(page).to have_text('Email')
      expect(page).to have_link(contact.email, href: "mailto:#{contact.email}")
    end

    it "可以看到「聯絡電話」" do
      expect(page).to have_text('聯絡電話')
      expect(page).to have_content(contact.phone)
    end

    it "可以看到「詢問內容」" do
      expect(page).to have_text('詢問內容')
      expect(page).to have_content(contact.content)
    end

    it "可以看到「填寫日期」" do
      expect(page).to have_text('填寫日期')
      expect(page).to have_content(I18n.l(contact.created_at, format: :table))
    end

    it "可以看到「狀態」" do
      expect(page).to have_text('狀態')
      expect(page).to have_content(I18n.t("simple_form.options.contact.status.#{contact.status}"))
    end

    it "可以看到「備註」" do
      expect(page).to have_text('備註')
      expect(page).to have_content(contact.note)
    end

    it "可以看到「更新於」" do
      expect(page).to have_text('更新於')
      expect(page).to have_content(I18n.l(contact.updated_at, format: :table))
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
      contact: { index: true, show: true }
    }) }

    let(:edit_permission_role) { create(:role, permissions: {
      contact: { index: true, show: true, edit: true }
    }) }

    let(:show_permission_admin) { create(:admin, role: show_permission_role) }
    let(:edit_permission_admin) { create(:admin, role: edit_permission_role) }
    let!(:contact) { create(:contact) }

    context "編輯按鈕 (edit)" do
      it "沒有 edit 權限者，不可以看到" do
        login_as(show_permission_admin, scope: :admin)
        visit admin_contact_path(contact)
        expected_content = find('.float-btns')
        expect(expected_content).not_to have_content(I18n.t('btn.edit'))
      end

      it "有 edit 權限者，可以看到" do
        login_as(edit_permission_admin, scope: :admin)
        visit admin_contact_path(contact)
        expected_content = find('.float-btns')
        expect(expected_content).to have_content(I18n.t('btn.edit'))
      end
    end

    context "刪除按鈕 (destroy)" do
      it "不可以看到刪除按鈕" do
        login_as(show_permission_admin, scope: :admin)
        visit admin_contact_path(contact)
        expected_content = find('.float-btns')
        expect(expected_content).not_to have_css('.btn-danger-light')
      end
    end
  end
end
