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
FactoryBot.define do
  factory :contact do
    name { FFaker::NameTW.last_name + FFaker::NameTW.first_name }
    email { FFaker::Internet.email }
    phone { FFaker::PhoneNumberTW.home_work_phone_number }
    content { FFaker::Book.description }
    status { Contact::STATUS[:new_case] }

    trait :processing do
      status { Contact::STATUS[:processing] }
    end

    trait :finished do
      status { Contact::STATUS[:finished] }
    end

    trait :note do
      note { FFaker::Lorem.sentence }
    end
  end
end
