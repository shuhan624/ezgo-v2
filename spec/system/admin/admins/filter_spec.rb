require 'rails_helper'

RSpec.describe "後台帳號管理列表", type: :system do
  let(:admin) { create(:admin) }

  before(:all) do
    @permit_role = create(:role,
      name: 'permit_role',
      permissions: {
        admin: {
          index: true,
        }
      }
    )
    @admin_has_permissions = create(:admin, role: @permit_role)
  end

  after(:all) do
    Admin.delete_all
    Role.delete_all
  end

  context "搜尋功能" do
    before { login_as(@admin_has_permissions, scope: :admin) }

    context "以「關鍵字」搜尋帳號" do
      context "依「名稱」搜尋" do
        it "篩選出「完全符合」關鍵字的帳號" do
          create_list(:admin, 5, :with_name)
          target = Admin.last
          visit admin_admins_path
          fill_in("q_email_or_name_cont", with: target.name)
          click_button(I18n.t('action.search'))

          search_result = find('section.content table tbody')
          expect(search_result).to have_content(target.name)
        end

        it "篩選出「包含」關鍵字的帳號" do
          target = create(:admin, name: '陳俊佑')
          target2 = create(:admin, name: '郭俊佑')
          visit admin_admins_path
          fill_in("q_email_or_name_cont", with: '俊佑')
          click_button(I18n.t('action.search'))
          search_result = find('section.content table tbody')

          expect(search_result).to have_text(target.name)
          expect(search_result).to have_text(target2.name)
        end

        it "不可以篩選出「不符合」關鍵字的帳號" do
          target = create(:admin, name: '張家豪')
          not_target = create(:admin, name: '陳冠妤')
          visit admin_admins_path
          fill_in("q_email_or_name_cont", with: target.name)
          click_button(I18n.t('action.search'))
          search_result = find('section.content table tbody')

          expect(search_result).not_to have_text(not_target.name)
        end
      end

      context "依「email」搜尋" do
        it "篩選出「完全符合」關鍵字的帳號" do
          create_list(:admin, 5)
          target = Admin.first
          visit admin_admins_path
          fill_in("q_email_or_name_cont", with: target.email)
          click_button(I18n.t('action.search'))

          search_result = find('section.content table tbody')
          expect(search_result).to have_content(target.email)
        end

        it "篩選出「包含」關鍵字的帳號" do
          target = create(:admin, email: 'admin@example.com')
          target2 = create(:admin, email: 'cw_admin@example.com')
          visit admin_admins_path
          fill_in("q_email_or_name_cont", with: 'admin')
          click_button(I18n.t('action.search'))
          search_result = find('section.content table tbody')

          expect(search_result).to have_text(target.email)
          expect(search_result).to have_text(target2.email)
        end

        it "不可以篩選出「不符合」關鍵字的帳號" do
          target = create(:admin, email: 'cianwang@example.com')
          not_target = create(:admin, email: 'admin@example.com')
          visit admin_admins_path
          fill_in("q_email_or_name_cont", with: target.email)
          click_button(I18n.t('action.search'))
          search_result = find('section.content table tbody')

          expect(search_result).not_to have_text(not_target.email)
        end
      end
    end

    context "以「狀態」搜尋帳號" do
      it "篩選出「啟用」狀態的帳號" do
        enabled_admin  = create(:admin, :enabled)
        disabled_admin = create(:admin, :disabled)
        visit admin_admins_path
        select(I18n.t('simple_form.options.admin.account_active.true'), from: 'q_account_active_eq', visible: false)
        click_button(I18n.t('action.search'))
        search_result = find('section.content table tbody')
        expect(search_result).to have_text(enabled_admin.email)
        expect(search_result).not_to have_text(disabled_admin.email)
      end

      it "篩選出「禁用」狀態的帳號" do
        enabled_admin  = create(:admin, :enabled)
        disabled_admin = create(:admin, :disabled)
        visit admin_admins_path
        select(I18n.t('simple_form.options.admin.account_active.false'), from: 'q_account_active_eq', visible: false)
        click_button(I18n.t('action.search'))
        search_result = find('section.content table tbody')
        expect(search_result).to have_text(disabled_admin.email)
        expect(search_result).not_to have_text(enabled_admin.email)
      end
    end
  end
end
