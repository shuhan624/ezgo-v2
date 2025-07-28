require 'rails_helper'

RSpec.describe "最新消息分類管理列表", type: :system do
  let(:article_category) { create(:article_category) }

  before(:all) do
    @permit_role = create(:role, permissions: {
      article_category: {
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
      context "依「名稱」搜尋" do
        it "篩選出完全符合「名稱」關鍵字搜尋項目" do
          create_list(:article_category, 5)
          visit admin_article_categories_path
          category = ArticleCategory.first
          fill_in("q_name_or_name_en_or_slug_cont", with: category.name)
          click_button(I18n.t('action.search'))
          search_result = find('.index-list')
          expect(search_result).to have_content(category.name)
        end

        it "篩選出「名稱」包含關鍵字的項目" do
          target = create(:article_category, name: 'some_name')
          target2 = create(:article_category, name: 'another_name')

          visit admin_article_categories_path
          fill_in("q_name_or_name_en_or_slug_cont", with: 'name')
          click_button(I18n.t('action.search'))
          search_result = find('.index-list')
          expect(search_result).to have_text(target.name)
          expect(search_result).to have_text(target2.name)
        end

        it "不符合「名稱」關鍵字的項目不會顯示" do
          target = create(:article_category, name: 'some_name')
          not_target = create(:article_category, name: 'another_name')

          visit admin_article_categories_path
          fill_in("q_name_or_name_en_or_slug_cont", with: target.name)
          click_button(I18n.t('action.search'))
          search_result = find('.index-list')
          expect(search_result).not_to have_text(not_target.name)
        end
      end

      context "依「英文名稱」搜尋" do
        it "篩選出完全符合「英文名稱」關鍵字搜尋項目" do
          create_list(:article_category, 5)
          visit admin_article_categories_path
          category = ArticleCategory.first
          fill_in("q_name_or_name_en_or_slug_cont", with: category.name_en)
          click_button(I18n.t('action.search'))
          search_result = find('.index-list')
          expect(search_result).to have_content(category.name)
        end

        it "篩選出「英文名稱」包含關鍵字的項目" do
          target = create(:article_category, name_en: 'some_name_en')
          target2 = create(:article_category, name_en: 'another_name_en')

          visit admin_article_categories_path
          fill_in("q_name_or_name_en_or_slug_cont", with: 'name_en')
          click_button(I18n.t('action.search'))
          search_result = find('.index-list')
          expect(search_result).to have_text(target.name_en)
          expect(search_result).to have_text(target2.name_en)
        end

        it "不符合「英文名稱」關鍵字的項目不會顯示" do
          target = create(:article_category, name_en: 'some_name_en')
          not_target = create(:article_category, name_en: 'another_name_en')

          visit admin_article_categories_path
          fill_in("q_name_or_name_en_or_slug_cont", with: target.name_en)
          click_button(I18n.t('action.search'))
          search_result = find('.index-list')
          expect(search_result).not_to have_text(not_target.name_en)
        end
      end

      context "依「網址」搜尋" do
        it "篩選出完全符合「網址」關鍵字搜尋項目" do
          create_list(:article_category, 5)
          visit admin_article_categories_path
          category = ArticleCategory.first
          fill_in("q_name_or_name_en_or_slug_cont", with: category.slug)
          click_button(I18n.t('action.search'))
          search_result = find('.index-list')
          expect(search_result).to have_text(category.name)
        end

        it "篩選出「網址」包含關鍵字的項目" do
          target = create(:article_category, slug: 'some-slug')
          target2 = create(:article_category, slug: 'another-slug')

          visit admin_article_categories_path
          fill_in("q_name_or_name_en_or_slug_cont", with: 'slug')
          click_button(I18n.t('action.search'))
          search_result = find('.index-list')
          expect(search_result).to have_text(target.name)
          expect(search_result).to have_text(target2.name)
        end

        it "不符合「網址」關鍵字的項目不會顯示" do
          target = create(:article_category, slug: 'some-slug')
          not_target = create(:article_category, slug: 'another-slug')

          visit admin_article_categories_path
          fill_in("q_name_or_name_en_or_slug_cont", with: target.slug)
          click_button(I18n.t('action.search'))
          search_result = find('.index-list')
          expect(search_result).not_to have_text(not_target.name)
        end
      end
    end

    context "以「中文狀態」搜尋項目" do
      it "當點選「公開」，可篩選出「公開」的項目" do
        published_category = create(:article_category, status: 'published')
        hidden_category = create(:article_category, status: 'hidden')

        visit admin_article_categories_path
        select('公開', from: 'q_status_eq', visible: false)
        click_button(I18n.t('action.search'))
        search_result = find('table tbody')
        expect(search_result).to have_text(published_category.name)
      end

      it "當點選「公開」，不可顯示出「隱藏」的項目" do
        published_category = create(:article_category, status: 'published')
        hidden_category = create(:article_category, status: 'hidden')

        visit admin_article_categories_path
        select('公開', from: 'q_status_eq', visible: false)
        click_button(I18n.t('action.search'))
        search_result = find('table tbody')
        expect(search_result).not_to have_text(hidden_category.name)
      end
    end

    context "以「英文狀態」搜尋項目" do
      it "當點選「公開」，可篩選出「公開」的項目" do
        published_category = create(:article_category, en_status: 'published')
        hidden_category = create(:article_category, en_status: 'hidden')

        visit admin_article_categories_path
        select('公開', from: 'q_en_status_eq', visible: false)
        click_button(I18n.t('action.search'))
        search_result = find('table tbody')
        expect(search_result).to have_text(published_category.name)
      end

      it "當點選「公開」，不可顯示出「隱藏」的項目" do
        published_category = create(:article_category, en_status: 'published')
        hidden_category = create(:article_category, en_status: 'hidden')

        visit admin_article_categories_path
        select('公開', from: 'q_en_status_eq', visible: false)
        click_button(I18n.t('action.search'))
        search_result = find('table tbody')
        expect(search_result).not_to have_text(hidden_category.name)
      end
    end
  end
end
