require 'rails_helper'

RSpec.describe "檔案管理列表", type: :system do
  let(:document) { create(:document) }

  before(:all) do
    @permit_role = create(:role, permissions: {
      document: {
        index: true,
      }
    })
    @admin_has_permissions = create(:admin, role: @permit_role)
  end

  after(:all) do
    Admin.delete_all
    Role.delete_all
  end

  context "搜尋功能" do
    before { login_as(@admin_has_permissions, scope: :admin) }

    context "以「關鍵字」搜尋項目" do
      context "依「標題」搜尋" do
        it "篩選出「完全符合」關鍵字的項目" do
          create_list(:document, 5)
          target = Document.first
          visit admin_documents_path
          fill_in("q_title_or_slug_cont", with: target.title)
          click_button(I18n.t('action.search'))

          search_result = find('section.content table tbody')
          expect(search_result).to have_content(target.title)
        end

        it "篩選出「包含」關鍵字的項目" do
          target = create(:document, title: 'some_title')
          target2 = create(:document, title: 'another_title')
          visit admin_documents_path
          fill_in("q_title_or_slug_cont", with: 'title')
          click_button(I18n.t('action.search'))
          search_result = find('section.content table tbody')

          expect(search_result).to have_text(target.title)
          expect(search_result).to have_text(target2.title)
        end

        it "不可以篩選出「不符合」關鍵字的項目" do
          target = create(:document, title: 'some_title')
          not_target = create(:document, title: 'another_title')
          visit admin_documents_path
          fill_in("q_title_or_slug_cont", with: target.title)
          click_button(I18n.t('action.search'))
          search_result = find('section.content table tbody')

          expect(search_result).not_to have_text(not_target.title)
        end
      end

      context "依「slug」搜尋" do
        it "篩選出「完全符合」關鍵字的項目" do
          create_list(:document, 5)
          target = Document.first
          visit admin_documents_path
          fill_in("q_title_or_slug_cont", with: target.slug)
          click_button(I18n.t('action.search'))
          search_result = find('section.content table tbody')

          expect(search_result).to have_content(target.title)
        end

        it "篩選出「包含」關鍵字的項目" do
          target = create(:document, slug: 'some_text')
          target2 = create(:document, slug: 'another_text')
          visit admin_documents_path
          fill_in("q_title_or_slug_cont", with: 'text')
          click_button(I18n.t('action.search'))
          search_result = find('section.content table tbody')

          expect(search_result).to have_text(target.title)
          expect(search_result).to have_text(target2.title)
        end

        it "不可以篩選出「不符合」關鍵字的項目" do
          target = create(:document, slug: 'some_text')
          not_target = create(:document, slug: 'another_text')
          visit admin_documents_path
          fill_in("q_title_or_slug_cont", with: target.slug)
          click_button(I18n.t('action.search'))
          search_result = find('section.content table tbody')

          expect(search_result).not_to have_text(not_target.title)
        end
      end
    end
  end
end
