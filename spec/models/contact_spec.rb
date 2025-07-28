# == Schema Information
#
# Table name: contacts
#
#  id                :bigint           not null, primary key
#  name(姓名)        :string           not null
#  email(電子郵件)   :string
#  phone(聯絡電話)   :string           not null
#  company(公司名稱) :string
#  address(聯絡地址) :string
#  content(詢問內容) :text
#  admin_note(備註)  :text
#  status(狀態)      :string           default("new_case"), not null
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
# Indexes
#
#  index_contacts_on_email  (email)
#  index_contacts_on_name   (name)
#  index_contacts_on_phone  (phone)
#
require 'rails_helper'

RSpec.describe Contact, type: :model do
  let(:contact) { create(:contact) }

  context 'Validations' do
    it 'is valid with valid attributes' do
      expect(contact).to be_valid
    end

    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:phone) }
    it { should validate_presence_of(:email) }
    it { should validate_presence_of(:status) }
  end
end
