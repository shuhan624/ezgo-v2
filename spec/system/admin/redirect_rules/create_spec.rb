require 'rails_helper'

RSpec.describe "新增轉址", type: :system do
  before(:all) do
    @permit_role = create(:role, permissions: {
      redirect_rule: {
        index: true,
        show: true,
        new: true,
        create: true,
        edit: true,
        update: true,
      }
    })
    @no_create_permit_role = create(:role, permissions: {
      redirect_rule: {
        index: true,
        show: true,
        new: true,
      }
    })

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

  context "新增轉址頁面 (new)" do
    it "沒有 new 權限者，不能到達" do
      login_as(@no_permissions_admin, scope: :admin)
      visit new_admin_redirect_rule_path
      expect(page).to have_content("無權進行此操作")
    end

    it "有 new 權限者，可以到達" do
      login_as(@admin_has_permissions, scope: :admin)
      visit new_admin_redirect_rule_path
      expect(page).to have_content("新增轉址")
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

  context "新增轉址 (Create)" do
    it "沒有 create 權限者，不能建立" do
      login_as(@no_create_permissions_admin, scope: :admin)
      fill_in_data_on_redirect_rule_form
      click_button("建立轉址")
      expect(page).to have_content("無權進行此操作")
    end

    it "有 create 權限者，可以建立" do
      login_as(@admin_has_permissions, scope: :admin)
      before_count = RedirectRule.count
      fill_in_data_on_redirect_rule_form
      click_button("建立轉址")

      expected_content = find('section.content')
      source_path = RedirectRule.order(position: :asc).first.source_path
      after_count = RedirectRule.count

      expect(page).to have_content('成功新增 轉址')
      expect(expected_content).to have_content(source_path)
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

  def fill_in_data_on_redirect_rule_form
    visit new_admin_redirect_rule_path
    source_path = "/old-path-#{Time.current.to_i}"
    target_path = "/new-path-#{Time.current.to_i}"

    fill_in("redirect_rule[source_path]", with: source_path)
    fill_in("redirect_rule[target_path]", with: target_path)
  end
end
