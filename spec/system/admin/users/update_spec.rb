require 'rails_helper'

RSpec.describe "編輯單一會員頁面", type: :system do
  let(:user) { create(:user, :confirmed) }
  let(:users) { create_list(:user, 5, :confirmed) }

  before(:all) do
    @permit_role = create(:role, permissions: {
      user: {
        index: true,
        show: true,
        new: true,
        create: true,
        edit: true,
        update: true,
      }
    })
    @no_permit_role = create(:role, permissions: {
      user: {
        index: true,
        show: true,
        edit: true,
      }
    })
    @no_edit_permit_role = create(:role, permissions: {
      user: {
        index: true,
        show: true,
      }
    })

    @admin_has_permissions = create(:admin, role: @permit_role)
    @no_permissions_admin = create(:admin, role: @no_permit_role)
    @no_edit_permissions_admin = create(:admin, role: @no_edit_permit_role)
  end

  after(:all) do
    Admin.delete_all
    Role.delete_all
  end


#   ▄▄▄▄▄▄▄▄▄▄▄  ▄▄▄▄▄▄▄▄▄▄   ▄▄▄▄▄▄▄▄▄▄▄  ▄▄▄▄▄▄▄▄▄▄▄
#  ▐░░░░░░░░░░░▌▐░░░░░░░░░░▌ ▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌
#  ▐░█▀▀▀▀▀▀▀▀▀ ▐░█▀▀▀▀▀▀▀█░▌ ▀▀▀▀█░█▀▀▀▀  ▀▀▀▀█░█▀▀▀▀
#  ▐░▌          ▐░▌       ▐░▌     ▐░▌          ▐░▌
#  ▐░█▄▄▄▄▄▄▄▄▄ ▐░▌       ▐░▌     ▐░▌          ▐░▌
#  ▐░░░░░░░░░░░▌▐░▌       ▐░▌     ▐░▌          ▐░▌
#  ▐░█▀▀▀▀▀▀▀▀▀ ▐░▌       ▐░▌     ▐░▌          ▐░▌
#  ▐░▌          ▐░▌       ▐░▌     ▐░▌          ▐░▌
#  ▐░█▄▄▄▄▄▄▄▄▄ ▐░█▄▄▄▄▄▄▄█░▌ ▄▄▄▄█░█▄▄▄▄      ▐░▌
#  ▐░░░░░░░░░░░▌▐░░░░░░░░░░▌ ▐░░░░░░░░░░░▌     ▐░▌
#   ▀▀▀▀▀▀▀▀▀▀▀  ▀▀▀▀▀▀▀▀▀▀   ▀▀▀▀▀▀▀▀▀▀▀       ▀
#

  context "編輯會員頁面 (edit)" do
    it "沒有 edit 權限者，不可以看到" do
      login_as(@no_edit_permissions_admin, scope: :admin)
      visit edit_admin_user_path(user)
      expect(page).to have_content("無權進行此操作")
    end

    it "有 edit 權限者，可以到達" do
      login_as(@admin_has_permissions, scope: :admin)
      visit edit_admin_user_path(user)
      expect(page).to have_content("編輯會員")
    end
  end

  context "按鈕區塊" do
    let(:edit_permission_role) { create(:role, permissions: {
      user: { index: true, edit: true, }
    }) }

    let(:show_permission_role) { create(:role, permissions: {
      user: { index: true, show: true, edit: true }
    }) }

    let(:destroy_permission_role) { create(:role, permissions: {
      user: { index: true, show: true, edit: true, destroy: true }
    }) }

    let(:edit_permission_admin) { create(:admin, role: edit_permission_role) }
    let(:show_permission_admin) { create(:admin, role: show_permission_role) }
    let(:destroy_permission_admin) { create(:admin, role: destroy_permission_role) }

    context "詳細按鈕 (show)" do
      it "沒有 show 權限者，不可以看到" do
        login_as(edit_permission_admin, scope: :admin)
        visit edit_admin_user_path(user)
        expected_content = find('.float-btns')
        expect(expected_content).not_to have_content(I18n.t('btn.show'))
      end

      it "有 show 權限者，可以看到" do
        login_as(show_permission_admin, scope: :admin)
        visit edit_admin_user_path(user)
        expected_content = find('.float-btns')
        expect(expected_content).to have_content(I18n.t('btn.show'))
      end
    end

    context "刪除按鈕 (destroy)" do
      it "沒有 destroy 權限者，不可以看到" do
        login_as(edit_permission_admin, scope: :admin)
        visit edit_admin_user_path(user)
        expected_content = find('.float-btns')
        expect(expected_content).not_to have_css('.btn-danger-light')
      end

      it "有 destroy 權限者，可以看到" do
        login_as(destroy_permission_admin, scope: :admin)
        visit edit_admin_user_path(user)
        expected_content = find('.float-btns')
        expect(expected_content).to have_css('.btn-danger-light')
      end
    end
  end

#   ▄         ▄  ▄▄▄▄▄▄▄▄▄▄▄  ▄▄▄▄▄▄▄▄▄▄   ▄▄▄▄▄▄▄▄▄▄▄  ▄▄▄▄▄▄▄▄▄▄▄  ▄▄▄▄▄▄▄▄▄▄▄
#  ▐░▌       ▐░▌▐░░░░░░░░░░░▌▐░░░░░░░░░░▌ ▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌
#  ▐░▌       ▐░▌▐░█▀▀▀▀▀▀▀█░▌▐░█▀▀▀▀▀▀▀█░▌▐░█▀▀▀▀▀▀▀█░▌ ▀▀▀▀█░█▀▀▀▀ ▐░█▀▀▀▀▀▀▀▀▀
#  ▐░▌       ▐░▌▐░▌       ▐░▌▐░▌       ▐░▌▐░▌       ▐░▌     ▐░▌     ▐░▌
#  ▐░▌       ▐░▌▐░█▄▄▄▄▄▄▄█░▌▐░▌       ▐░▌▐░█▄▄▄▄▄▄▄█░▌     ▐░▌     ▐░█▄▄▄▄▄▄▄▄▄
#  ▐░▌       ▐░▌▐░░░░░░░░░░░▌▐░▌       ▐░▌▐░░░░░░░░░░░▌     ▐░▌     ▐░░░░░░░░░░░▌
#  ▐░▌       ▐░▌▐░█▀▀▀▀▀▀▀▀▀ ▐░▌       ▐░▌▐░█▀▀▀▀▀▀▀█░▌     ▐░▌     ▐░█▀▀▀▀▀▀▀▀▀
#  ▐░▌       ▐░▌▐░▌          ▐░▌       ▐░▌▐░▌       ▐░▌     ▐░▌     ▐░▌
#  ▐░█▄▄▄▄▄▄▄█░▌▐░▌          ▐░█▄▄▄▄▄▄▄█░▌▐░▌       ▐░▌     ▐░▌     ▐░█▄▄▄▄▄▄▄▄▄
#  ▐░░░░░░░░░░░▌▐░▌          ▐░░░░░░░░░░▌ ▐░▌       ▐░▌     ▐░▌     ▐░░░░░░░░░░░▌
#   ▀▀▀▀▀▀▀▀▀▀▀  ▀            ▀▀▀▀▀▀▀▀▀▀   ▀         ▀       ▀       ▀▀▀▀▀▀▀▀▀▀▀
#

  context '更新會員' do
    it "沒有 update 權限者，不可以更新" do
      login_as(@no_permissions_admin, scope: :admin)
      fill_in_data_on_user_form
      click_button("更新會員")
      expect(page).to have_content("無權進行此操作")
    end

    it "有 update 權限者，可以更新" do
      login_as(@admin_has_permissions, scope: :admin)
      fill_in_data_on_user_form
      click_button("更新會員")
      expect(page).to have_content('成功更新 會員')
      expect(page).to have_content('新的會員名稱')
    end
  end

#   ▄▄       ▄▄  ▄▄▄▄▄▄▄▄▄▄▄  ▄▄▄▄▄▄▄▄▄▄▄  ▄         ▄  ▄▄▄▄▄▄▄▄▄▄▄  ▄▄▄▄▄▄▄▄▄▄
#  ▐░░▌     ▐░░▌▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌▐░▌       ▐░▌▐░░░░░░░░░░░▌▐░░░░░░░░░░▌
#  ▐░▌░▌   ▐░▐░▌▐░█▀▀▀▀▀▀▀▀▀  ▀▀▀▀█░█▀▀▀▀ ▐░▌       ▐░▌▐░█▀▀▀▀▀▀▀█░▌▐░█▀▀▀▀▀▀▀█░▌
#  ▐░▌▐░▌ ▐░▌▐░▌▐░▌               ▐░▌     ▐░▌       ▐░▌▐░▌       ▐░▌▐░▌       ▐░▌
#  ▐░▌ ▐░▐░▌ ▐░▌▐░█▄▄▄▄▄▄▄▄▄      ▐░▌     ▐░█▄▄▄▄▄▄▄█░▌▐░▌       ▐░▌▐░▌       ▐░▌
#  ▐░▌  ▐░▌  ▐░▌▐░░░░░░░░░░░▌     ▐░▌     ▐░░░░░░░░░░░▌▐░▌       ▐░▌▐░▌       ▐░▌
#  ▐░▌   ▀   ▐░▌▐░█▀▀▀▀▀▀▀▀▀      ▐░▌     ▐░█▀▀▀▀▀▀▀█░▌▐░▌       ▐░▌▐░▌       ▐░▌
#  ▐░▌       ▐░▌▐░▌               ▐░▌     ▐░▌       ▐░▌▐░▌       ▐░▌▐░▌       ▐░▌
#  ▐░▌       ▐░▌▐░█▄▄▄▄▄▄▄▄▄      ▐░▌     ▐░▌       ▐░▌▐░█▄▄▄▄▄▄▄█░▌▐░█▄▄▄▄▄▄▄█░▌
#  ▐░▌       ▐░▌▐░░░░░░░░░░░▌     ▐░▌     ▐░▌       ▐░▌▐░░░░░░░░░░░▌▐░░░░░░░░░░▌
#   ▀         ▀  ▀▀▀▀▀▀▀▀▀▀▀       ▀       ▀         ▀  ▀▀▀▀▀▀▀▀▀▀▀  ▀▀▀▀▀▀▀▀▀▀
#

  def fill_in_data_on_user_form
    name = '新的會員名稱'
    visit edit_admin_user_path(user)
    fill_in("user[name]", with: name)
  end
end
