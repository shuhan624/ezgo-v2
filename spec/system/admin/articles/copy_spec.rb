require 'rails_helper'

RSpec.describe "複製單一最新消息", type: :system do
  let(:article_category) { create(:article_category) }
  let(:article) { create(:article) }

  before(:all) do
    @permit_role = create(:role, permissions: {
      article: {
        index: true,
        show: true,
        edit: true,
        update: true,
        copy: true,
      }
    })
    @admin_has_permissions = create(:admin, role: @permit_role)
    @no_permissions_admin = create(:admin, :no_permissions)
  end

  after(:all) do
    Admin.delete_all
    Role.delete_all
  end

  context "在單一最新消息文章檢視頁的複製按鈕 (copy)" do
    it "沒有 copy 權限者，不可以看到" do
      login_as(@no_permissions_admin, scope: :admin)
      visit admin_article_path(article)
      expect(page).not_to have_css('#copy-btn', text: '複製')
    end

    it "有 copy 權限者，可以看到" do
      login_as(@admin_has_permissions, scope: :admin)
      visit admin_article_path(article)
      expect(page).to have_css('#copy-btn', text: '複製')
    end

    it "有 copy 權限者，可以複製的新文章「標題」為「原文章標題 - 複製」" do
      login_as(@admin_has_permissions, scope: :admin)
      visit admin_article_path(article)
      find('a#copy-btn').click
      expect(page).to have_text("#{article.title} - 複製")
    end

    it "有 copy 權限者，可以複製的新文章「slug」為「原文章 slug - copy」" do
      login_as(@admin_has_permissions, scope: :admin)
      visit admin_article_path(article)
      find('a#copy-btn').click
      input = find('input#article_slug')
      expect(input.value).to eq("#{article.slug}-copy")
    end
  end
end
