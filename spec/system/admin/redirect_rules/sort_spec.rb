require 'rails_helper'

RSpec.describe "更新轉址排序", type: :system do
  let(:redirect_rule) { create(:redirect_rule) }

  before(:all) do
    @role_can_sort = create(:role, permissions: {
      redirect_rule: {
        index: true,
        sort: true,
      }
    })
    @role_can_not_sort = create(:role, permissions: {
      redirect_rule: {
        index: true,
      }
    })

    @admin_can_sort = create(:admin, role: @role_can_sort)
    @admin_can_not_sort = create(:admin, role: @role_can_not_sort)
  end

  after(:all) do
    Admin.delete_all
    Role.delete_all
  end

  it '有 sort 權限者，可以更新轉址順序' do
    login_as(@admin_can_sort, scope: :admin)
    create_list(:redirect_rule, 5)
    visit admin_redirect_rules_path
    main_content = find('section.content')
    expect(main_content).to have_css('table tbody.sortable-items')
    first = RedirectRule.first
    original_position = first.position
    last = RedirectRule.last
    source = main_content.find("tr[data-item='redirect_rule_#{first.id}'] th.handle")
    target = main_content.find("tr[data-item='redirect_rule_#{last.id}']")
    sleep 0.5 # 要稍微等一下，讓 JS 初始化才能 Drag & Drop
    source.drag_to(target)
    expect(page).to have_content('成功更新 轉址')
    updated_position = RedirectRule.find(first.id).position
    expect(original_position).not_to eq(updated_position)
  end

  it "沒有 sort 權限者，不可以更新轉址順序" do
    login_as(@admin_can_not_sort, scope: :admin)
    create_list(:redirect_rule, 5)
    visit admin_redirect_rules_path
    main_content = find('section.content')
    expect(main_content).not_to have_css('table tbody.sortable-items')
  end
end
