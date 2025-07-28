# == Schema Information
#
# Table name: users
#
#  id                          :bigint           not null, primary key
#  email(帳號)                 :string
#  name(姓名)                  :string
#  phone(電話)                 :string
#  role(會員級別)              :string           default("regular")
#  account_active(帳號狀態)    :boolean          default(TRUE)
#  country(國家)               :string
#  zip_code(郵遞區號)          :string
#  city(縣市)                  :string
#  dist(地區)                  :string
#  address(地址)               :string
#  line_uid(LINE UID)          :string
#  line_avatar(LINE 大頭貼)    :string
#  line_auth_at(LINE 註冊日期) :datetime
#  note(備註)                  :text
#  admin_note(後台備註)        :text
#  reset_password_token        :string
#  reset_password_sent_at      :datetime
#  confirmation_token          :string
#  confirmed_at                :datetime
#  confirmation_sent_at        :datetime
#  unconfirmed_email           :string
#  created_at                  :datetime         not null
#  updated_at                  :datetime         not null
#  encrypted_password          :string           default(""), not null
#  remember_created_at         :datetime
#  sign_in_count               :integer          default(0), not null
#  current_sign_in_at          :datetime
#  last_sign_in_at             :datetime
#  current_sign_in_ip          :inet
#  last_sign_in_ip             :inet
#  failed_attempts             :integer          default(0), not null
#  unlock_token                :string
#  locked_at                   :datetime
#
# Indexes
#
#  index_users_on_confirmation_token    (confirmation_token) UNIQUE
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_line_uid              (line_uid) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#  index_users_on_unlock_token          (unlock_token) UNIQUE
#
FactoryBot.define do
  password = FFaker::Internet.password

  factory :user do
    email { FFaker::Internet.email }
    role { 'regular' }
    account_active { 'true' }
    password { password }
    password_confirmation { password }

    trait :with_name do
      name { FFaker::NameTW.name }
    end

    trait :confirmed do
      confirmed_at { DateTime.current }
    end

    trait :unconfirmed do
      confirmed_at { nil }
    end

    trait :active do
      account_active { 'true' }
      confirmed_at { DateTime.current }
    end

    trait :not_active do
      account_active { 'false' }
      confirmed_at { DateTime.current }
    end

    factory :user_with_orders do
      confirmed_at { DateTime.current }
      orders { build_list(:order, 5) }
    end

    trait :with_full_data do
      name { FFaker::NameTW.name }
      phone { FFaker::PhoneNumberTW.phone_number }
      country { 'TW' }
      city { '新北市' }
      dist { '永和區' }
      zip_code { '234' }
      address { FFaker::Address.street_address }
      note { FFaker::Book.description }
    end
  end
end
