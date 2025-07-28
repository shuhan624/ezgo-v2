require 'rails_helper'

RSpec.describe "常見問題管理列表", type: :system do
  let(:faq) { create(:faq) }

  before(:all) do
    @permit_role = create(:role, permissions: {
      faq: {
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
        create_list(:faq, 5)
        visit admin_faqs_path
        faq = Faq.first
        category = faq.faq_category
        select(category.name, from: 'q_faq_category_id_eq', visible: false)
        click_button(I18n.t('action.search'))
        search_result = find('.index-list')

        expect(search_result).to have_content(faq.title)
      end

      it "當以「分類 A」為條件搜尋時，不可以出現「分類 B」的項目" do
        category_a = create(:faq_category)
        category_b = create(:faq_category)
        category_a_faq = create(:faq, faq_category: category_a)
        category_b_faq = create(:faq, faq_category: category_b)

        visit admin_faqs_path
        select(category_a.name, from: 'q_faq_category_id_eq', visible: false)
        click_button(I18n.t('action.search'))

        search_result = find('.index-list')
        expect(search_result).not_to have_content(category_b_faq.title)
      end
    end

    context "以「關鍵字」搜尋項目" do
      context "依「標題」搜尋" do
        it "篩選出「完全符合」關鍵字的項目" do
          create_list(:faq, 5)
          target = Faq.first
          visit admin_faqs_path
          fill_in("q_title_or_title_en_cont", with: target.title)
          click_button(I18n.t('action.search'))

          search_result = find('.index-list')
          expect(search_result).to have_content(target.title)
        end

        it "篩選出「包含」關鍵字的項目" do
          target = create(:faq, title: 'some_title')
          target2 = create(:faq, title: 'another_title')
          visit admin_faqs_path
          fill_in("q_title_or_title_en_cont", with: 'title')
          click_button(I18n.t('action.search'))
          search_result = find('.index-list')

          expect(search_result).to have_text(target.title)
          expect(search_result).to have_text(target2.title)
        end

        it "不可以篩選出「不符合」關鍵字的項目" do
          target = create(:faq, title: 'some_title')
          not_target = create(:faq, title: 'another_title')
          visit admin_faqs_path
          fill_in("q_title_or_title_en_cont", with: target.title)
          click_button(I18n.t('action.search'))
          search_result = find('.index-list')

          expect(search_result).not_to have_text(not_target.title)
        end
      end

      context "依「英文標題」搜尋" do
        it "篩選出「完全符合」關鍵字的項目" do
          create_list(:faq, 5)
          target = Faq.first
          visit admin_faqs_path
          fill_in("q_title_or_title_en_cont", with: target.title_en)
          click_button(I18n.t('action.search'))
          search_result = find('.index-list')

          expect(search_result).to have_content(target.title_en)
        end

        it "篩選出「包含」關鍵字的項目" do
          target = create(:faq, title_en: 'some_title_en')
          target2 = create(:faq, title_en: 'another_title_en')
          visit admin_faqs_path
          fill_in("q_title_or_title_en_cont", with: 'title_en')
          click_button(I18n.t('action.search'))
          search_result = find('.index-list')

          expect(search_result).to have_text(target.title_en)
          expect(search_result).to have_text(target2.title_en)
        end

        it "不可以篩選出「不符合」關鍵字的項目" do
          target = create(:faq, title_en: 'some_title_en')
          not_target = create(:faq, title_en: 'another_title_en')
          visit admin_faqs_path
          fill_in("q_title_or_title_en_cont", with: target.title_en)
          click_button(I18n.t('action.search'))
          search_result = find('.index-list')

          expect(search_result).not_to have_text(not_target.title_en)
        end
      end
    end

    context "以「中文狀態」搜尋項目" do
      it "篩選出「公開」狀態的項目" do
        published_category = create(:faq, :published_tw)
        hidden_category = create(:faq, :hidden_tw)
        visit admin_faqs_path
        select(I18n.t('simple_form.tw_status.status.published'), from: 'q_status_eq', visible: false)
        click_button(I18n.t('action.search'))
        search_result = find('.index-list')
        expect(search_result).to have_text(published_category.title)
        expect(search_result).not_to have_text(hidden_category.title)
      end

      it "篩選出「隱藏」狀態的項目" do
        published_category = create(:faq, :published_tw)
        hidden_category = create(:faq, :hidden_tw)
        visit admin_faqs_path
        select(I18n.t('simple_form.tw_status.status.hidden'), from: 'q_status_eq', visible: false)
        click_button(I18n.t('action.search'))
        search_result = find('.index-list')
        expect(search_result).to have_text(hidden_category.title)
        expect(search_result).not_to have_text(published_category.title)
      end
    end

    context "以「英文狀態」搜尋項目" do
      it "當點選「公開」，可篩選出「公開」的項目" do
        published_category = create(:faq, :published_en)
        hidden_category = create(:faq, :hidden_en)

        visit admin_faqs_path
        select('公開', from: 'q_en_status_eq', visible: false)
        click_button(I18n.t('action.search'))
        search_result = find('table tbody')
        expect(search_result).to have_text(published_category.title_en)
      end

      it "當點選「公開」，不可顯示出「隱藏」的項目" do
        published_category = create(:faq, :published_en)
        hidden_category = create(:faq, :hidden_en)

        visit admin_faqs_path
        select('公開', from: 'q_en_status_eq', visible: false)
        click_button(I18n.t('action.search'))
        search_result = find('table tbody')
        expect(search_result).not_to have_text(hidden_category.title_en)
      end
    end
  end
end
