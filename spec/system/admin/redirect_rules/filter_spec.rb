require 'rails_helper'

RSpec.describe "轉址管理列表", type: :system do
  let(:redirect_rule) { create(:redirect_rule) }

  before(:all) do
    @permit_role = create(:role, permissions: {
      redirect_rule: {
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

    context "依「來源路徑」搜尋" do
      it "篩選出「完全符合」關鍵字的項目" do
        create_list(:redirect_rule, 5)
        target = RedirectRule.first
        visit admin_redirect_rules_path
        fill_in("q_source_path_or_target_path_cont", with: target.source_path)
        click_button(I18n.t('action.search'))

        search_result = find('.index-list')
        expect(search_result).to have_content(target.source_path)
      end

      it "篩選出「包含」關鍵字的項目" do
        target = create(:redirect_rule, source_path: '/some_source_path')
        target2 = create(:redirect_rule, source_path: '/another_source_path')
        visit admin_redirect_rules_path
        fill_in("q_source_path_or_target_path_cont", with: 'source_path')
        click_button(I18n.t('action.search'))
        search_result = find('.index-list')

        expect(search_result).to have_text(target.source_path)
        expect(search_result).to have_text(target2.source_path)
      end

      it "不可以篩選出「不符合」關鍵字的項目" do
        target = create(:redirect_rule, source_path: '/some_source_path')
        not_target = create(:redirect_rule, source_path: '/another_source_path')
        visit admin_redirect_rules_path
        fill_in("q_source_path_or_target_path_cont", with: target.source_path)
        click_button(I18n.t('action.search'))
        search_result = find('.index-list')

        expect(search_result).not_to have_text(not_target.source_path)
      end
    end

    context "依「目標路徑」搜尋" do
      it "篩選出「完全符合」關鍵字的項目" do
        create_list(:redirect_rule, 5)
        target = RedirectRule.first
        visit admin_redirect_rules_path
        fill_in("q_source_path_or_target_path_cont", with: target.target_path)
        click_button(I18n.t('action.search'))
        search_result = find('.index-list')

        expect(search_result).to have_content(target.target_path)
      end

      it "篩選出「包含」關鍵字的項目" do
        target = create(:redirect_rule, target_path: '/some_target_path')
        target2 = create(:redirect_rule, target_path: '/another_target_path')
        visit admin_redirect_rules_path
        fill_in("q_source_path_or_target_path_cont", with: 'target_path')
        click_button(I18n.t('action.search'))
        search_result = find('.index-list')

        expect(search_result).to have_text(target.target_path)
        expect(search_result).to have_text(target2.target_path)
      end

      it "不可以篩選出「不符合」關鍵字的項目" do
        target = create(:redirect_rule, target_path: '/some_target_path')
        not_target = create(:redirect_rule, target_path: '/another_target_path')
        visit admin_redirect_rules_path
        fill_in("q_source_path_or_target_path_cont", with: target.target_path)
        click_button(I18n.t('action.search'))
        search_result = find('.index-list')

        expect(search_result).not_to have_text(not_target.target_path)
      end
    end
  end
end
