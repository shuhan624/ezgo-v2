require 'rails_helper'

RSpec.describe "聯絡表單管理列表", type: :system do
  let(:contact) { create(:contact) }

  before(:all) do
    @permit_role = create(:role, permissions: {
      contact: {
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
          create_list(:contact, 5)
          target = Contact.first
          visit admin_contacts_path
          fill_in("q_name_or_phone_or_email_cont", with: target.name)
          click_button(I18n.t('action.search'))

          search_result = find('.index-list')
          expect(search_result).to have_content(target.name)
        end

        it "篩選出「包含」關鍵字的項目" do
          target = create(:contact, name: '陳俊佑')
          target2 = create(:contact, name: '郭俊佑')
          visit admin_contacts_path
          fill_in("q_name_or_phone_or_email_cont", with: '俊佑')
          click_button(I18n.t('action.search'))
          search_result = find('.index-list')

          expect(search_result).to have_text(target.name)
          expect(search_result).to have_text(target2.name)
        end

        it "不可以篩選出「不符合」關鍵字的項目" do
          target = create(:contact, name: FFaker::NameTW.name)
          not_target = create(:contact, name: FFaker::NameTW.name)
          visit admin_contacts_path
          fill_in("q_name_or_phone_or_email_cont", with: target.name)
          click_button(I18n.t('action.search'))
          search_result = find('.index-list')

          expect(search_result).not_to have_text(not_target.name)
        end
      end

      context "依「電話」搜尋" do
        it "篩選出「完全符合」關鍵字的項目" do
          create_list(:contact, 5)
          target = Contact.first
          visit admin_contacts_path
          fill_in("q_name_or_phone_or_email_cont", with: target.phone)
          click_button(I18n.t('action.search'))
          search_result = find('.index-list')

          expect(search_result).to have_content(target.name)
        end

        it "篩選出「包含」關鍵字的項目" do
          target = create(:contact, phone: '0956123456')
          target2 = create(:contact, phone: '0956456789')
          visit admin_contacts_path
          fill_in("q_name_or_phone_or_email_cont", with: '0956')
          click_button(I18n.t('action.search'))
          search_result = find('.index-list')

          expect(search_result).to have_text(target.name)
          expect(search_result).to have_text(target2.name)
        end

        it "不可以篩選出「不符合」關鍵字的項目" do
          target = create(:contact, phone: '0956123456')
          not_target = create(:contact, phone: '0956456789')
          visit admin_contacts_path
          fill_in("q_name_or_phone_or_email_cont", with: target.phone)
          click_button(I18n.t('action.search'))
          search_result = find('.index-list')

          expect(search_result).not_to have_text(not_target.name)
        end
      end

      context "依「Email」搜尋" do
        it "篩選出「完全符合」關鍵字的項目" do
          create_list(:contact, 5)
          target = Contact.first
          visit admin_contacts_path
          fill_in("q_name_or_phone_or_email_cont", with: target.email)
          click_button(I18n.t('action.search'))
          search_result = find('.index-list')

          expect(search_result).to have_content(target.name)
        end

        it "篩選出「包含」關鍵字的項目" do
          target = create(:contact, email: 'cianwangtest@gmail.com')
          target2 = create(:contact, email: 'test@gmail.com')
          visit admin_contacts_path
          fill_in("q_name_or_phone_or_email_cont", with: 'test')
          click_button(I18n.t('action.search'))
          search_result = find('.index-list')

          expect(search_result).to have_text(target.name)
          expect(search_result).to have_text(target2.name)
        end

        it "不可以篩選出「不符合」關鍵字的項目" do
          target = create(:contact, email: 'cianwangtest@gmail.com')
          not_target = create(:contact, email: 'test@gmail.com')
          visit admin_contacts_path
          fill_in("q_name_or_phone_or_email_cont", with: target.email)
          click_button(I18n.t('action.search'))
          search_result = find('.index-list')

          expect(search_result).not_to have_text(not_target.name)
        end
      end
    end

    context "以「狀態」搜尋項目" do
      it "篩選出「新訊息」狀態的項目" do
        new_case = create(:contact)
        processing = create(:contact, :processing)
        finished = create(:contact, :finished)
        visit admin_contacts_path
        select(I18n.t('simple_form.options.contact.status.new_case'), from: 'q_status_eq', visible: false)
        click_button(I18n.t('action.search'))
        search_result = find('.index-list')
        expect(search_result).to have_text(new_case.name)
        expect(search_result).not_to have_text(processing.name)
        expect(search_result).not_to have_text(finished.name)
      end

      it "篩選出「處理中」狀態的項目" do
        new_case = create(:contact)
        processing = create(:contact, :processing)
        finished = create(:contact, :finished)
        visit admin_contacts_path
        select(I18n.t('simple_form.options.contact.status.processing'), from: 'q_status_eq', visible: false)
        click_button(I18n.t('action.search'))
        search_result = find('.index-list')
        expect(search_result).to have_text(processing.name)
        expect(search_result).not_to have_text(new_case.name)
        expect(search_result).not_to have_text(finished.name)
      end

      it "篩選出「結案」狀態的項目" do
        new_case = create(:contact)
        processing = create(:contact, :processing)
        finished = create(:contact, :finished)
        visit admin_contacts_path
        select(I18n.t('simple_form.options.contact.status.finished'), from: 'q_status_eq', visible: false)
        click_button(I18n.t('action.search'))
        search_result = find('.index-list')
        expect(search_result).to have_text(finished.name)
        expect(search_result).not_to have_text(new_case.name)
        expect(search_result).not_to have_text(processing.name)
      end
    end
  end
end
