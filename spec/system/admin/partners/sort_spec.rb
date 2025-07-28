require 'rails_helper'

RSpec.describe "更新合作夥伴排序", type: :system do
  let(:partner) { create(:partner) }

  before(:all) do
    @role_can_sort = create(:role, permissions: {
      partner: {
        index: true,
        sort: true,
      }
    })
    @role_can_not_sort = create(:role, permissions: {
      partner: {
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

  it '有 sort 權限者，可以調整index頁面的 合作夥伴 順序' do
    login_as(@admin_can_sort, scope: :admin)
    create_list(:partner, 5)
    visit admin_partners_path
    main_content = find('section.content')
    expect(main_content).to have_css('table tbody.sortable-items')
    first = Partner.first
    original_position = first.position
    last = Partner.last
    source = main_content.find("tr[data-item='partner_#{first.id}'] th.handle")
    target = main_content.find("tr[data-item='partner_#{last.id}']")
    sleep 0.5 # 要稍微等一下，讓 JS 初始化才能 Drag & Drop
    source.drag_to(target)
    expect(page).to have_content('成功更新 合作夥伴')
    updated_position = Partner.find(first.id).position
    expect(original_position).not_to eq(updated_position)
  end


  it "沒有 sort 權限者，不可以調整index頁面的 合作夥伴 順序" do
    login_as(@admin_can_not_sort, scope: :admin)
    create_list(:partner, 5)
    visit admin_partners_path
    main_content = find('section.content')
    expect(main_content).not_to have_css('table tbody.sortable-items')
  end
end
