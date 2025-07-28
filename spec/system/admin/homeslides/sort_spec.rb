require 'rails_helper'

RSpec.describe "更新首頁輪播排序", type: :system do
  let(:home_slide) { create(:home_slide) }

  before(:all) do
    @role_can_sort = create(:role, permissions: {
      home_slide: {
        index: true,
        sort: true,
      }
    })
    @role_can_not_sort = create(:role, permissions: {
      home_slide: {
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

  it '有 sort 權限者，可以調整index頁面的 首頁輪播 順序' do
    login_as(@admin_can_sort, scope: :admin)
    create_list(:home_slide, 5)
    visit admin_home_slides_path
    main_content = find('section.content')
    expect(main_content).to have_css('table tbody.sortable-items')
    first = HomeSlide.first
    original_position = first.position
    last = HomeSlide.last
    source = main_content.find("tr[data-item='home_slide_#{first.id}'] th.handle")
    target = main_content.find("tr[data-item='home_slide_#{last.id}']")
    sleep 0.5 # 要稍微等一下，讓 JS 初始化才能 Drag & Drop
    source.drag_to(target)
    expect(page).to have_content('成功更新 首頁輪播')
    updated_position = HomeSlide.find(first.id).position
    expect(original_position).not_to eq(updated_position)
  end


  it "沒有 sort 權限者，不可以調整index頁面的 首頁輪播 順序" do
    login_as(@admin_can_not_sort, scope: :admin)
    create_list(:home_slide, 5)
    visit admin_home_slides_path
    main_content = find('section.content')
    expect(main_content).not_to have_css('table tbody.sortable-items')
  end
end
