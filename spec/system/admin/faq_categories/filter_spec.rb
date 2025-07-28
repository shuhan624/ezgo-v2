require 'rails_helper'

RSpec.describe "常見問題分類管理列表", type: :system do
  let(:faq_category) { create(:faq_category) }

  before(:all) do
    @permit_role = create(:role, permissions: {
      faq_category: {
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
        it "篩選出「完全符合」關鍵字的項目" do
          create_list(:faq_category, 5)
          target = FaqCategory.first
          visit admin_faq_categories_path
          fill_in("q_name_or_name_en_or_slug_cont", with: target.name)
          click_button(I18n.t('action.search'))

          search_result = find('.index-list')
          expect(search_result).to have_content(target.name)
        end

        it "篩選出「包含」關鍵字的項目" do
          target = create(:faq_category, name: 'some_name')
          target2 = create(:faq_category, name: 'another_name')
          visit admin_faq_categories_path
          fill_in("q_name_or_name_en_or_slug_cont", with: 'name')
          click_button(I18n.t('action.search'))
          search_result = find('.index-list')

          expect(search_result).to have_text(target.name)
          expect(search_result).to have_text(target2.name)
        end

        it "不可以篩選出「不符合」關鍵字的項目" do
          target = create(:faq_category, name: 'some_name')
          not_target = create(:faq_category, name: 'another_name')
          visit admin_faq_categories_path
          fill_in("q_name_or_name_en_or_slug_cont", with: target.name)
          click_button(I18n.t('action.search'))
          search_result = find('.index-list')

          expect(search_result).not_to have_text(not_target.name)
        end
      end

      context "依「英文名稱」搜尋" do
        it "篩選出「完全符合」關鍵字的項目" do
          create_list(:faq_category, 5)
          target = FaqCategory.first
          visit admin_faq_categories_path
          fill_in("q_name_or_name_en_or_slug_cont", with: target.name_en)
          click_button(I18n.t('action.search'))
          search_result = find('.index-list')

          expect(search_result).to have_content(target.name_en)
        end

        it "篩選出「包含」關鍵字的項目" do
          target = create(:faq_category, name_en: 'some_name_en')
          target2 = create(:faq_category, name_en: 'another_name_en')
          visit admin_faq_categories_path
          fill_in("q_name_or_name_en_or_slug_cont", with: 'name_en')
          click_button(I18n.t('action.search'))
          search_result = find('.index-list')

          expect(search_result).to have_text(target.name_en)
          expect(search_result).to have_text(target2.name_en)
        end

        it "不可以篩選出「不符合」關鍵字的項目" do
          target = create(:faq_category, name_en: 'some_name_en')
          not_target = create(:faq_category, name_en: 'another_name_en')
          visit admin_faq_categories_path
          fill_in("q_name_or_name_en_or_slug_cont", with: target.name_en)
          click_button(I18n.t('action.search'))
          search_result = find('.index-list')

          expect(search_result).not_to have_text(not_target.name_en)
        end
      end

      context "依「網址」搜尋" do
        it "篩選出「完全符合」關鍵字的項目" do
          create_list(:faq_category, 5)
          target = FaqCategory.first
          visit admin_faq_categories_path
          fill_in("q_name_or_name_en_or_slug_cont", with: target.slug)
          click_button(I18n.t('action.search'))
          search_result = find('.index-list')
          expect(search_result).to have_text(target.name)
        end

        it "篩選出「包含」關鍵字的項目" do
          target = create(:faq_category, slug: 'some-slug')
          target2 = create(:faq_category, slug: 'another-slug')

          visit admin_faq_categories_path
          fill_in("q_name_or_name_en_or_slug_cont", with: 'slug')
          click_button(I18n.t('action.search'))
          search_result = find('.index-list')
          expect(search_result).to have_text(target.name)
          expect(search_result).to have_text(target2.name)
        end

        it "不可以篩選出「不符合」關鍵字的項目" do
          target = create(:faq_category, slug: 'some-slug')
          not_target = create(:faq_category, slug: 'another-slug')

          visit admin_faq_categories_path
          fill_in("q_name_or_name_en_or_slug_cont", with: target.slug)
          click_button(I18n.t('action.search'))
          search_result = find('.index-list')
          expect(search_result).not_to have_text(not_target.name)
        end
      end
    end

    context "以「狀態」搜尋項目" do
      it "篩選出「啟用」狀態的項目" do
        published_category = create(:faq_category, :published_tw)
        hidden_category = create(:faq_category, :hidden_tw)
        visit admin_faq_categories_path
        select(I18n.t('simple_form.tw_status.status.published'), from: 'q_status_eq', visible: false)
        click_button(I18n.t('action.search'))
        search_result = find('.index-list')
        expect(search_result).to have_text(published_category.name)
        expect(search_result).not_to have_text(hidden_category.name)
      end

      it "篩選出「隱藏」狀態的項目" do
        published_category = create(:faq_category, :published_tw)
        hidden_category = create(:faq_category, :hidden_tw)
        visit admin_faq_categories_path
        select(I18n.t('simple_form.tw_status.status.hidden'), from: 'q_status_eq', visible: false)
        click_button(I18n.t('action.search'))
        search_result = find('.index-list')
        expect(search_result).to have_text(hidden_category.name)
        expect(search_result).not_to have_text(published_category.name)
      end
    end
  end
end
