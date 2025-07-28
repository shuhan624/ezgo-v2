require 'rails_helper'

RSpec.describe "聯絡表單", type: :mailer do
  let(:contact) { create(:contact) }
  let(:send_mail) { ContactMailer.contact_email(contact).deliver_now}

  it 'sends an email' do
    previous = ActionMailer::Base.deliveries.count
    send_mail
    after = ActionMailer::Base.deliveries.count
    expect(after).to eq (previous + 1)
  end

  it '可以看到寄信者' do
    expect(send_mail.from).to include('test@gmail.com')
  end

  it '可以看到收信者' do
    expect(send_mail.to).to include('serviceinfo@cianwang.com')
  end

  it '可以看到信件標題' do
    site_title = Setting.find_by(name: 'site_title').content
    expect(send_mail.subject).to eq("#{site_title} - #{contact.name}")
  end

  it '可以看到信件內容' do
    expect(send_mail.body).to have_content(contact.name)
    expect(send_mail.body).to have_content(contact.email)
    expect(send_mail.body).to have_content(contact.phone)
    expect(send_mail.body).to have_content(contact.content)
  end
end
