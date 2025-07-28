require 'rails_helper'

RSpec.describe "檢視單一會員頁面", type: :system do
  let(:user) { create(:user, :confirmed, :with_name) }

  before(:all) do
    @permit_role = create(:role, permissions: {
      user: {
        index: true,
        show: true,
      }
    })
    @has_full_permit_role = create(:role, permissions: {
      user: {
        index: true,
        show: true,
        edit: true,
        update: true,
        destroy: true,
      }
    })
    @admin_has_permissions = create(:admin, role: @permit_role)
    @admin_has_full_permissions = create(:admin, role: @has_full_permit_role)
    @no_permissions_admin = create(:admin, :no_permissions)
  end

  after(:all) do
    Admin.delete_all
    Role.delete_all
  end

  it "沒有 show 權限者，不能到達" do
    login_as(@no_permissions_admin, scope: :admin)
    user
    visit admin_user_path(user)
    expect(page).to have_content("無權進行此操作")
  end

  it "有 show 權限者，可以到達" do
    login_as(@admin_has_permissions, scope: :admin)
    user
    visit admin_user_path(user)
    expect(page).to have_text(user.name)
  end

  context "頁面內容" do
    before { login_as(@admin_has_permissions, scope: :admin) }
    let!(:user) { create(:user, :confirmed, :active, :with_full_data) }
    before { visit admin_user_path(user) }

    it "可以看到「電子信箱」" do
      expect(page).to have_text('電子信箱')
      expect(page).to have_content(user.email)
    end

    it "可以看到「啟用帳號」" do
      expect(page).to have_text('啟用帳號')
      expect(page).to have_content(I18n.t(user.account_active, scope: 'simple_form.options.user.account_active'))
    end

    it "可以看到「姓名」" do
      expect(page).to have_text('姓名')
      expect(page).to have_content(user.name)
    end

    it "可以看到「聯絡電話」" do
      expect(page).to have_text('聯絡電話')
      expect(page).to have_content(user.phone)
    end

    it "可以看到「會員級別」" do
      expect(page).to have_text('會員級別')
      expect(page).to have_content(I18n.t(user.role, scope: 'simple_form.options.user.role'))
    end

    it "可以看到「國家」" do
      expect(page).to have_text('國家')
      expect(page).to have_content(user.decorate.country_name)
    end

    it "可以看到「縣市」" do
      expect(page).to have_text('縣市')
      expect(page).to have_content(user.city)
    end

    it "可以看到「區域」" do
      expect(page).to have_text('區域')
      expect(page).to have_content(user.dist)
    end

    it "可以看到「地址」" do
      expect(page).to have_text('地址')
      expect(page).to have_content(user.address)
    end

    it "可以看到「備註」" do
      expect(page).to have_text('備註')
      expect(page).to have_content(user.note)
    end

    it "可以看到「更新時間」" do
      expect(page).to have_text('更新於')
      expect(page).to have_text(user.updated_at.strftime("%F %R"))
    end

    it "可以看到「建立時間」" do
      expect(page).to have_text('建立於')
      expect(page).to have_text(user.created_at.strftime("%F %R"))
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
      user: { index: true, show: true }
    }) }

    let(:edit_permission_role) { create(:role, permissions: {
      user: { index: true, show: true, edit: true }
    }) }

    let(:destroy_permission_role) { create(:role, permissions: {
      user: { index: true, show: true, destroy: true }
    }) }

    let(:show_permission_admin) { create(:admin, role: show_permission_role) }
    let(:edit_permission_admin) { create(:admin, role: edit_permission_role) }
    let(:destroy_permission_admin) { create(:admin, role: destroy_permission_role) }

    context "編輯按鈕 (edit)" do
      it "沒有 edit 權限者，不可以看到" do
        login_as(show_permission_admin, scope: :admin)
        visit admin_user_path(user)
        expected_content = find('.float-btns')
        expect(expected_content).not_to have_content(I18n.t('btn.edit'))
      end

      it "有 edit 權限者，可以看到" do
        login_as(edit_permission_admin, scope: :admin)
        visit admin_user_path(user)
        expected_content = find('.float-btns')
        expect(expected_content).to have_content(I18n.t('btn.edit'))
      end
    end

    context "刪除按鈕 (destroy)" do
      it "沒有 destroy 權限者，不可以看到" do
        login_as(show_permission_admin, scope: :admin)
        visit admin_user_path(user)
        expected_content = find('.float-btns')
        expect(expected_content).not_to have_css('.btn-danger-light')
      end

      it "有 destroy 權限者，可以看到" do
        login_as(destroy_permission_admin, scope: :admin)
        visit admin_user_path(user)
        expected_content = find('.float-btns')
        expect(expected_content).to have_css('.btn-danger-light')
      end
    end
  end
end
