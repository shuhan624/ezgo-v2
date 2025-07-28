require 'rails_helper'

RSpec.describe "里程碑管理列表", type: :system do
  let(:milestone) { create(:milestone) }

  before(:all) do
    @permit_role = create(:role, permissions: {
      milestone: {
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
          create_list(:milestone, 5)
          target = Milestone.first
          visit admin_milestones_path
          fill_in("q_title_or_title_en_cont", with: target.title)
          click_button(I18n.t('action.search'))

          search_result = find('section.content table tbody')
          expect(search_result).to have_content(target.decorate.short_content)
        end

        it "篩選出「包含」關鍵字的項目" do
          target = create(:milestone, title: 'some_title')
          target2 = create(:milestone, title: 'another_title')
          visit admin_milestones_path
          fill_in("q_title_or_title_en_cont", with: 'title')
          click_button(I18n.t('action.search'))
          search_result = find('section.content table tbody')

          expect(search_result).to have_text(target.decorate.short_content)
          expect(search_result).to have_text(target2.decorate.short_content)
        end

        it "不可以篩選出「不符合」關鍵字的項目" do
          target = create(:milestone, title: 'some_title')
          not_target = create(:milestone, title: 'another_title')
          visit admin_milestones_path
          fill_in("q_title_or_title_en_cont", with: target.title)
          click_button(I18n.t('action.search'))
          search_result = find('section.content table tbody')

          expect(search_result).not_to have_text(not_target.decorate.short_content)
        end
      end

      context "依「英文名稱」搜尋" do
        it "篩選出「完全符合」關鍵字的項目" do
          create_list(:milestone, 5)
          target = Milestone.first
          visit admin_milestones_path
          fill_in("q_title_or_title_en_cont", with: target.title_en)
          click_button(I18n.t('action.search'))
          search_result = find('section.content table tbody')

          expect(search_result).to have_content(target.decorate.short_content)
        end

        it "篩選出「包含」關鍵字的項目" do
          target = create(:milestone, title_en: 'some_title')
          target2 = create(:milestone, title_en: 'another_title')
          visit admin_milestones_path
          fill_in("q_title_or_title_en_cont", with: 'title')
          click_button(I18n.t('action.search'))
          search_result = find('section.content table tbody')

          expect(search_result).to have_content(target.decorate.short_content)
          expect(search_result).to have_content(target2.decorate.short_content)
        end

        it "不可以篩選出「不符合」關鍵字的項目" do
          target = create(:milestone, title_en: 'some_title')
          not_target = create(:milestone, title_en: 'another_title')
          visit admin_milestones_path
          fill_in("q_title_or_title_en_cont", with: target.title_en)
          click_button(I18n.t('action.search'))
          search_result = find('section.content table tbody')

          expect(search_result).not_to have_text(not_target.decorate.short_content)
        end
      end
    end

    context "以「狀態」搜尋項目" do
      context "中文狀態" do
        it "篩選出「公開」狀態的項目" do
          published_milestone = create(:milestone, :published_tw, :with_image)
          hidden_milestone = create(:milestone, :hidden_tw)
          visit admin_milestones_path
          select(I18n.t('simple_form.tw_status.status.published'), from: 'q_status_eq', visible: false)
          click_button(I18n.t('action.search'))
          search_result = find('section.content table tbody')
          expect(search_result).to have_text(published_milestone.decorate.short_content)
          expect(search_result).not_to have_text(hidden_milestone.decorate.short_content)
        end

        it "篩選出「隱藏」狀態的項目" do
          published_milestone = create(:milestone, :published_tw, :with_image)
          hidden_milestone = create(:milestone, :hidden_tw)
          visit admin_milestones_path
          select(I18n.t('simple_form.tw_status.status.hidden'), from: 'q_status_eq', visible: false)
          click_button(I18n.t('action.search'))
          search_result = find('section.content table tbody')
          expect(search_result).to have_text(hidden_milestone.decorate.short_content)
          expect(search_result).not_to have_text(published_milestone.decorate.short_content)
        end
      end

      context "英文狀態" do
        it "篩選出「公開」狀態的項目" do
          published_milestone = create(:milestone, :published_en, :with_image)
          hidden_milestone = create(:milestone, :hidden_en)
          visit admin_milestones_path
          select(I18n.t('simple_form.en_status.en_status.published'), from: 'q_en_status_eq', visible: false)
          click_button(I18n.t('action.search'))
          search_result = find('section.content table tbody')
          expect(search_result).to have_text(published_milestone.decorate.short_content)
          expect(search_result).not_to have_text(hidden_milestone.decorate.short_content)
        end

        it "篩選出「隱藏」狀態的項目" do
          published_milestone = create(:milestone, :published_en, :with_image)
          hidden_milestone = create(:milestone, :hidden_en)
          visit admin_milestones_path
          select(I18n.t('simple_form.en_status.en_status.hidden'), from: 'q_en_status_eq', visible: false)
          click_button(I18n.t('action.search'))
          search_result = find('section.content table tbody')
          expect(search_result).to have_text(hidden_milestone.decorate.short_content)
          expect(search_result).not_to have_text(published_milestone.decorate.short_content)
        end
      end
    end
  end
end
