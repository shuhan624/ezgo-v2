require "rails_helper"
include ActiveJob::TestHelper # 為了可以使用 perform_enqueued_jobs 這個方法

RSpec.describe "聯絡表單-寄信功能", type: :system do
  let!(:contact_page) { create(:custom_page, slug: 'contact') }
  let!(:thanks_page) { create(:custom_page, slug: 'thanks') }

  context '填寫表單' do
    before do
      visit contact_us_path
    end

    it '送出表單後，會到感謝頁面' do
      fill_in_contact_form_and_submit
      expect(page).to have_content(thanks_page.title)
    end

    it '送出表單後，可以看到寄信者' do
      fill_in_contact_form_and_submit
      contact_mail = ContactMailer.deliveries.last

      # test@gmail.com 為 test.rb 預設的 smtp 名稱
      expect(contact_mail.from).to include('test@gmail.com')
    end

    it '送出表單後，後台 receivers 會收到副本' do
      fill_in_contact_form_and_submit
      receiver = Setting.find_by(name: 'receivers')&.content&.split(',')
      contact_mail = ContactMailer.deliveries.last
      expect(contact_mail.to).to match_array(receiver)
    end

    it '送出表單後，後台 receivers 如果有多位 都會收到副本' do
      setting_receivers = Setting.find_by(name: 'receivers')
      setting_receivers.update(content: 'test1@example.com,test2@example.com')

      fill_in_contact_form_and_submit
      receivers = Setting.find_by(name: 'receivers')&.content&.split(',')
      contact_mail = ContactMailer.deliveries.last
      expect(contact_mail.to).to match_array(receivers)
    end

    it '可以看到信件標題' do
      fill_in_contact_form_and_submit
      contact = Contact.last.decorate
      contact_mail = ContactMailer.deliveries.last
      site_title = Setting.find_by(name: 'site_title').content
      expect(contact_mail.subject).to eq("#{site_title} - #{contact.name}")
    end

    it '可以看到信件內容' do
      fill_in_contact_form_and_submit
      contact = Contact.last.decorate
      contact_mail = ContactMailer.deliveries.last
      expect(contact_mail.body).to have_content(contact.name)
      expect(contact_mail.body).to have_content(contact.email)
      expect(contact_mail.body).to have_content(contact.phone)
      expect(contact_mail.body).to have_content(contact.content)
    end
  end
end


def fill_in_contact_form_and_submit
  fill_in('contact_name', with: FFaker::NameTW.name)
  fill_in('contact_email', with: FFaker::Internet.email)
  fill_in('contact_phone', with: FFaker::PhoneNumberTW.mobile_phone_number)
  fill_in('contact_content', with: FFaker::Lorem.paragraph)
  click_button I18n.t('action.submit')
  # 執行寄信的 job
  perform_enqueued_jobs
end
