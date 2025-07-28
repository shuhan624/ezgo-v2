require 'rails_helper'

RSpec.describe "最新消息管理列表", type: :system do
  let(:article_category) { create(:article_category) }
  let(:article) { create(:article) }

  before(:all) do
    @permit_role = create(:role, permissions: {
      article: {
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

    context "以「分類」搜尋項目" do
      it "篩選出屬於點選的「分類」的項目" do
        create_list(:article, 5)
        visit admin_articles_path
        article = Article.first
        category = article.article_categories.first
        select(category.name, from: 'q_article_categories_id_eq', visible: false)
        click_button(I18n.t('action.search'))
        search_result = find('.index-list')

        expect(search_result).to have_content(article.title)
      end

      it "當以「分類 A」為條件搜尋時，不可以出現「分類 B」的項目" do
        category_a = create(:article_category)
        category_b = create(:article_category)
        category_a_article = create(:article, default_category: category_a, article_categories: [category_a])
        category_b_article = create(:article, default_category: category_b, article_categories: [category_b])

        visit admin_articles_path
        select(category_a.name, from: 'q_article_categories_id_eq', visible: false)
        click_button(I18n.t('action.search'))
        search_result = find('.index-list')

        expect(search_result).not_to have_content(category_b_article.title)
      end
    end

    context "以「關鍵字」搜尋項目" do
      context "依「標題」搜尋" do
        it "篩選出「完全符合」關鍵字的項目" do
          article
          visit admin_articles_path
          fill_in("q_title_or_title_en_or_slug_cont", with: article.title)
          click_button(I18n.t('action.search'))
          search_result = find('.index-list')

          expect(search_result).to have_content(article.title)
        end

        it "篩選出「包含」關鍵字的項目" do
          target = create(:article, title: 'some_title')
          target2 = create(:article, title: 'another_title')
          visit admin_articles_path
          fill_in("q_title_or_title_en_or_slug_cont", with: 'title')
          click_button(I18n.t('action.search'))
          search_result = find('.index-list')

          expect(search_result).to have_text(target.title)
          expect(search_result).to have_text(target2.title)
        end

        it "不可以篩選出「不符合」關鍵字的項目" do
          target = create(:article, title: 'some_title')
          not_target = create(:article, title: 'another_title')
          visit admin_articles_path
          fill_in("q_title_or_title_en_or_slug_cont", with: target.title)
          click_button(I18n.t('action.search'))
          search_result = find('.index-list')

          expect(search_result).not_to have_text(not_target.title)
        end
      end

      context "依「英文標題」搜尋" do
        it "篩選出「完全符合」關鍵字的項目" do
          article
          visit admin_articles_path
          fill_in("q_title_or_title_en_or_slug_cont", with: article.title_en)
          click_button(I18n.t('action.search'))
          search_result = find('.index-list')

          expect(search_result).to have_content(article.title)
        end

        it "篩選出「包含」關鍵字的項目" do
          target = create(:article, title_en: 'some_title_en')
          target2 = create(:article, title_en: 'another_title_en')
          visit admin_articles_path
          fill_in("q_title_or_title_en_or_slug_cont", with: 'title_en')
          click_button(I18n.t('action.search'))
          search_result = find('.index-list')

          expect(search_result).to have_text(target.title)
          expect(search_result).to have_text(target2.title)
        end

        it "不可以篩選出「不符合」關鍵字的項目" do
          target = create(:article, title_en: 'some_title_en')
          not_target = create(:article, title_en: 'another_title_en')
          visit admin_articles_path
          fill_in("q_title_or_title_en_or_slug_cont", with: target.title_en)
          click_button(I18n.t('action.search'))
          search_result = find('.index-list')

          expect(search_result).not_to have_text(not_target.title_en)
        end
      end

      context "依「網址」搜尋" do
        it "篩選出「完全符合」關鍵字的項目" do
          article
          visit admin_articles_path
          fill_in("q_title_or_title_en_or_slug_cont", with: article.slug)
          click_button(I18n.t('action.search'))
          search_result = find('.index-list')
          expect(search_result).to have_text(article.title)
        end

        it "篩選出「包含」關鍵字的項目" do
          target = create(:article, slug: 'some-slug')
          target2 = create(:article, slug: 'another-slug')

          visit admin_articles_path
          fill_in("q_title_or_title_en_or_slug_cont", with: 'slug')
          click_button(I18n.t('action.search'))
          search_result = find('.index-list')
          expect(search_result).to have_text(target.title)
          expect(search_result).to have_text(target2.title)
        end

        it "不可以篩選出「不符合」關鍵字的項目" do
          target = create(:article, slug: 'some-slug')
          not_target = create(:article, slug: 'another-slug')

          visit admin_articles_path
          fill_in("q_title_or_title_en_or_slug_cont", with: target.slug)
          click_button(I18n.t('action.search'))
          search_result = find('.index-list')
          expect(search_result).not_to have_text(not_target.title)
        end
      end
    end
  end
end
