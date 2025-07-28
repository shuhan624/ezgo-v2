require 'rails_helper'

RSpec.describe "會員管理列表", type: :system do
  let(:user) { create(:user, :confirmed) }

  before(:all) do
    @permit_role = create(:role, permissions: {
      user: {
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

    context "以「會員等級」搜尋項目" do
      it "篩選出屬於點選的「會員等級」的項目" do
        create_list(:user, 3, :confirmed, :with_name, role: 'regular')
        create_list(:user, 2, :confirmed, :with_name, role: 'vip')
        visit admin_users_path
        user = User.regular.first
        select(I18n.t('simple_form.options.user.role.regular'), from: 'q_role_eq', visible: false)
        click_button(I18n.t('action.search'))
        search_result = find('.index-list')

        expect(search_result).to have_content(user.name)
      end

      it "當以「一般會員」為條件搜尋時，不可以出現「VIP」的項目" do
        regular_user = create(:user, :confirmed, :with_name, role: 'regular')
        vip_user = create(:user, :confirmed, :with_name, role: 'vip')

        visit admin_users_path
        select(I18n.t('simple_form.options.user.role.regular'), from: 'q_role_eq', visible: false)
        click_button(I18n.t('action.search'))

        search_result = find('.index-list')
        expect(search_result).not_to have_content(vip_user.name)
        expect(search_result).to have_content(regular_user.name)
      end

      it "當以「VIP」為條件搜尋時，不可以出現「一般會員」的項目" do
        regular_user = create(:user, :confirmed, :with_name, role: 'regular')
        vip_user = create(:user, :confirmed, :with_name, role: 'vip')

        visit admin_users_path
        select(I18n.t('simple_form.options.user.role.vip'), from: 'q_role_eq', visible: false)
        click_button(I18n.t('action.search'))

        search_result = find('.index-list')
        expect(search_result).not_to have_content(regular_user.name)
        expect(search_result).to have_content(vip_user.name)
      end
    end

    context "以「關鍵字」搜尋項目" do
      context "依「名稱」搜尋" do
        it "篩選出「完全符合」關鍵字的項目" do
          create_list(:user, 5, :confirmed, :with_name)
          target = User.first
          visit admin_users_path
          fill_in("q_name_or_email_or_phone_cont", with: target.name)
          click_button(I18n.t('action.search'))

          search_result = find('.index-list')
          expect(search_result).to have_content(target.name)
        end

        it "篩選出「包含」關鍵字的項目" do
          target = create(:user, :confirmed, name: 'some_name')
          target2 = create(:user, :confirmed, name: 'another_name')
          visit admin_users_path
          fill_in("q_name_or_email_or_phone_cont", with: 'name')
          click_button(I18n.t('action.search'))
          search_result = find('.index-list')

          expect(search_result).to have_text(target.name)
          expect(search_result).to have_text(target2.name)
        end

        it "不可以篩選出「不符合」關鍵字的項目" do
          target = create(:user, :confirmed, name: 'some_name')
          not_target = create(:user, :confirmed, name: 'another_name')
          visit admin_users_path
          fill_in("q_name_or_email_or_phone_cont", with: target.name)
          click_button(I18n.t('action.search'))
          search_result = find('.index-list')

          expect(search_result).not_to have_text(not_target.name)
        end
      end

      context "依「Email」搜尋" do
        it "篩選出「完全符合」關鍵字的項目" do
          create_list(:user, 5, :confirmed, :with_name)
          target = User.first
          visit admin_users_path
          fill_in("q_name_or_email_or_phone_cont", with: target.email)
          click_button(I18n.t('action.search'))
          search_result = find('.index-list')

          expect(search_result).to have_content(target.email)
        end

        it "篩選出「包含」關鍵字的項目" do
          target = create(:user, :confirmed, :with_name, email: 'some_email@example.com')
          target2 = create(:user, :confirmed, :with_name, email: 'another_email@example.com')
          visit admin_users_path
          fill_in("q_name_or_email_or_phone_cont", with: 'email')
          click_button(I18n.t('action.search'))
          search_result = find('.index-list')

          expect(search_result).to have_text(target.email)
          expect(search_result).to have_text(target2.email)
        end

        it "不可以篩選出「不符合」關鍵字的項目" do
          target = create(:user, :confirmed, :with_name, email: 'some_email@example.com')
          not_target = create(:user, :confirmed, :with_name, email: 'another_email@example.com')
          visit admin_users_path
          fill_in("q_name_or_email_or_phone_cont", with: target.email)
          click_button(I18n.t('action.search'))
          search_result = find('.index-list')

          expect(search_result).not_to have_text(not_target.email)
        end
      end
    end
  end
end
