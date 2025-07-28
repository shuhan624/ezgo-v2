require 'rails_helper'

RSpec.describe "最新消息分類列表頁", type: :system do
  let(:category) { create(:article_category) }
  let(:article_categories) { create_list(:article_category, 5) }

  before(:all) do
    @permit_role = create(:role, permissions: {
      article_category: {
        index: true,
        update: true,
        sort: true,
      }
    })
    @no_permit_role = create(:role, permissions: {
      article_category: {
        index: true,
      }
    })
    @no_update_permit_role = create(:role, permissions: {
      article_category: {
        index: true,
        sort: true,
      }
    })

    @admin_has_permissions = create(:admin, role: @permit_role)
    @no_permissions_admin = create(:admin, role: @no_permit_role)
    @no_update_permissions_admin = create(:admin, role: @no_update_permit_role)
  end

  after(:all) do
    Admin.delete_all
    Role.delete_all
  end

  it "沒有 sort 權限者，不可以更新分類排序" do
    login_as(@no_permissions_admin, scope: :admin)
    visit admin_article_categories_path
    main_content = find('section.content')
    expect(main_content).not_to have_css('table tbody.sortable-items')
  end

  it "有 sort 權限者，可以更新分類排序" do
    article_categories
    login_as(@admin_has_permissions, scope: :admin)
    visit admin_article_categories_path
    main_content = find('section.content')
    expect(main_content).to have_css('table tbody.sortable-items')
    first = ArticleCategory.first
    original_position = first.position
    last = ArticleCategory.last
    source = main_content.find("tr[data-item='article_category_#{first.id}'] th.handle")
    target = main_content.find("tr[data-item='article_category_#{last.id}']")
    sleep 0.5 # 要稍微等一下，讓 JS 初始化才能 Drag & Drop
    source.drag_to(target)
    expect(page).to have_content('成功更新 最新消息分類')
    updated_position = ArticleCategory.find(first.id).position
    expect(original_position).not_to eq(updated_position)
  end
end
