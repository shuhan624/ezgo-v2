require 'rails_helper'

RSpec.describe "新增單一管理帳號", type: :system do
  let(:admin) { create(:admin) }

  before(:all) do
    @permit_role = create(:role,
      name: 'permit_role',
      permissions: {
        admin: {
          index: true,
          show: true,
          new: true,
          create: true,
        }
      }
    )

    @no_create_permit_role = create(:role,
      name: 'no_create_permit_role',
      permissions: {
        admin: {
          index: true,
          show: true,
          new: true,
        }
      }
    )

    @admin_has_permissions = create(:admin, role: @permit_role)
    @no_create_permissions_admin = create(:admin, role: @no_create_permit_role)
    @no_permissions_admin = create(:admin, :no_permissions)
  end

  after(:all) do
    Admin.delete_all
    Role.delete_all
  end

#   ▄▄        ▄  ▄▄▄▄▄▄▄▄▄▄▄  ▄         ▄
#  ▐░░▌      ▐░▌▐░░░░░░░░░░░▌▐░▌       ▐░▌
#  ▐░▌░▌     ▐░▌▐░█▀▀▀▀▀▀▀▀▀ ▐░▌       ▐░▌
#  ▐░▌▐░▌    ▐░▌▐░▌          ▐░▌       ▐░▌
#  ▐░▌ ▐░▌   ▐░▌▐░█▄▄▄▄▄▄▄▄▄ ▐░▌   ▄   ▐░▌
#  ▐░▌  ▐░▌  ▐░▌▐░░░░░░░░░░░▌▐░▌  ▐░▌  ▐░▌
#  ▐░▌   ▐░▌ ▐░▌▐░█▀▀▀▀▀▀▀▀▀ ▐░▌ ▐░▌░▌ ▐░▌
#  ▐░▌    ▐░▌▐░▌▐░▌          ▐░▌▐░▌ ▐░▌▐░▌
#  ▐░▌     ▐░▐░▌▐░█▄▄▄▄▄▄▄▄▄ ▐░▌░▌   ▐░▐░▌
#  ▐░▌      ▐░░▌▐░░░░░░░░░░░▌▐░░▌     ▐░░▌
#   ▀        ▀▀  ▀▀▀▀▀▀▀▀▀▀▀  ▀▀       ▀▀
#

  context "新增管理帳號頁面 (new)" do
    it "沒有 new 權限者，不能到達" do
      login_as(@no_permissions_admin, scope: :admin)
      visit new_admin_admin_path
      expect(page).to have_content("無權進行此操作")
    end

    it "有 new 權限者，可以到達" do
      login_as(@admin_has_permissions, scope: :admin)
      visit new_admin_admin_path
      expect(page).to have_content("新增管理帳號")
    end
  end

#   ▄▄▄▄▄▄▄▄▄▄▄  ▄▄▄▄▄▄▄▄▄▄▄  ▄▄▄▄▄▄▄▄▄▄▄  ▄▄▄▄▄▄▄▄▄▄▄  ▄▄▄▄▄▄▄▄▄▄▄  ▄▄▄▄▄▄▄▄▄▄▄
#  ▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌
#  ▐░█▀▀▀▀▀▀▀▀▀ ▐░█▀▀▀▀▀▀▀█░▌▐░█▀▀▀▀▀▀▀▀▀ ▐░█▀▀▀▀▀▀▀█░▌ ▀▀▀▀█░█▀▀▀▀ ▐░█▀▀▀▀▀▀▀▀▀
#  ▐░▌          ▐░▌       ▐░▌▐░▌          ▐░▌       ▐░▌     ▐░▌     ▐░▌
#  ▐░▌          ▐░█▄▄▄▄▄▄▄█░▌▐░█▄▄▄▄▄▄▄▄▄ ▐░█▄▄▄▄▄▄▄█░▌     ▐░▌     ▐░█▄▄▄▄▄▄▄▄▄
#  ▐░▌          ▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌     ▐░▌     ▐░░░░░░░░░░░▌
#  ▐░▌          ▐░█▀▀▀▀█░█▀▀ ▐░█▀▀▀▀▀▀▀▀▀ ▐░█▀▀▀▀▀▀▀█░▌     ▐░▌     ▐░█▀▀▀▀▀▀▀▀▀
#  ▐░▌          ▐░▌     ▐░▌  ▐░▌          ▐░▌       ▐░▌     ▐░▌     ▐░▌
#  ▐░█▄▄▄▄▄▄▄▄▄ ▐░▌      ▐░▌ ▐░█▄▄▄▄▄▄▄▄▄ ▐░▌       ▐░▌     ▐░▌     ▐░█▄▄▄▄▄▄▄▄▄
#  ▐░░░░░░░░░░░▌▐░▌       ▐░▌▐░░░░░░░░░░░▌▐░▌       ▐░▌     ▐░▌     ▐░░░░░░░░░░░▌
#   ▀▀▀▀▀▀▀▀▀▀▀  ▀         ▀  ▀▀▀▀▀▀▀▀▀▀▀  ▀         ▀       ▀       ▀▀▀▀▀▀▀▀▀▀▀
#

  context "建立管理帳號 (Create)" do
    it "沒有 create 權限者，不能建立" do
      login_as(@no_create_permissions_admin, scope: :admin)
      fill_in_data_on_admin_form
      click_button("建立管理帳號")
      expect(page).to have_content("無權進行此操作")
    end

    it "有 create 權限者，可以建立" do
      login_as(@admin_has_permissions, scope: :admin)
      before_count = Admin.count
      fill_in_data_on_admin_form
      click_button("建立管理帳號")

      expected_content = find('section.content')
      name = Admin.order(created_at: :desc).first.name
      after_count = Admin.count

      expect(page).to have_content('成功新增 管理帳號')
      expect(expected_content).to have_content(name)
      expect(after_count).to eq(before_count + 1)
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

  def fill_in_data_on_admin_form
    name = FFaker::Lorem.characters.first(20)
    email = FFaker::Internet.email
    password = FFaker::Lorem.characters.first(20)
    visit new_admin_admin_path

    fill_in("admin[name]", with: name)
    fill_in("admin[email]", with: email)
    fill_in("admin[password]", with: password)
    fill_in("admin[password_confirmation]", with: password)

    within('fieldset.radio_buttons.admin_account_active') do
      choose(I18n.t('simple_form.options.admin.account_active.true'), allow_label_click: true)
    end
    select(@permit_role.name, from: 'admin_role_id', visible: false)

    scroll_to(find('.form-actions'), align: :top)
  end
end
