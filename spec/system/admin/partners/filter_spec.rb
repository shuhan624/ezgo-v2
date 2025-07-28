require 'rails_helper'

RSpec.describe "合作夥伴管理列表", type: :system do
  let(:partner) { create(:partner) }

  before(:all) do
    @permit_role = create(:role, permissions: {
      partner: {
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
          create_list(:partner, 5)
          target = Partner.first
          visit admin_partners_path
          fill_in("q_name_or_name_en_cont", with: target.name)
          click_button(I18n.t('action.search'))

          search_result = find('.index-list')
          expect(search_result).to have_content(target.name)
        end

        it "篩選出「包含」關鍵字的項目" do
          target = create(:partner, name: 'some_title')
          target2 = create(:partner, name: 'another_title')
          visit admin_partners_path
          fill_in("q_name_or_name_en_cont", with: 'title')
          click_button(I18n.t('action.search'))
          search_result = find('.index-list')

          expect(search_result).to have_text(target.name)
          expect(search_result).to have_text(target2.name)
        end

        it "不可以篩選出「不符合」關鍵字的項目" do
          target = create(:partner, name: 'some_title')
          not_target = create(:partner, name: 'another_title')
          visit admin_partners_path
          fill_in("q_name_or_name_en_cont", with: target.name)
          click_button(I18n.t('action.search'))
          search_result = find('.index-list')

          expect(search_result).not_to have_text(not_target.name)
        end
      end

      context "依「英文名稱」搜尋" do
        it "篩選出「完全符合」關鍵字的項目" do
          create_list(:partner, 5)
          target = Partner.first
          visit admin_partners_path
          fill_in("q_name_or_name_en_cont", with: target.name_en)
          click_button(I18n.t('action.search'))
          search_result = find('.index-list')

          expect(search_result).to have_content(target.name_en)
        end

        it "篩選出「包含」關鍵字的項目" do
          visit admin_partners_path
          fill_in("q_name_or_name_en_cont", with: partner.name_en)
          click_button(I18n.t('action.search'))
          search_result = find('.index-list')

          expect(search_result).to have_content(partner.name_en)
        end

        it "不可以篩選出「不符合」關鍵字的項目" do
          target = create(:partner, name_en: 'some_title')
          not_target = create(:partner, name_en: 'another_title')
          visit admin_partners_path
          fill_in("q_name_or_name_en_cont", with: target.name_en)
          click_button(I18n.t('action.search'))
          search_result = find('.index-list')

          expect(search_result).not_to have_text(not_target.name_en)
        end
      end
    end

    context "以「狀態」搜尋項目" do
      it "篩選出「公開」狀態的項目" do
        published_partner = create(:partner, :published_tw, :with_image)
        hidden_partner = create(:partner, :hidden_tw)
        visit admin_partners_path
        select(I18n.t('simple_form.tw_status.status.published'), from: 'q_status_eq', visible: false)
        click_button(I18n.t('action.search'))
        search_result = find('.index-list')
        expect(search_result).to have_text(published_partner.name)
        expect(search_result).not_to have_text(hidden_partner.name)
      end

      it "篩選出「隱藏」狀態的項目" do
        published_partner = create(:partner, :published_tw, :with_image)
        hidden_partner = create(:partner, :hidden_tw)
        visit admin_partners_path
        select(I18n.t('simple_form.tw_status.status.hidden'), from: 'q_status_eq', visible: false)
        click_button(I18n.t('action.search'))
        search_result = find('.index-list')
        expect(search_result).to have_text(hidden_partner.name)
        expect(search_result).not_to have_text(published_partner.name)
      end
    end
  end
end
