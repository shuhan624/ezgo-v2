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
require 'rails_helper'

RSpec.describe User, type: :model do
  subject { build(:user, :confirmed) }

  it 'ensures account_active only accepts true or false' do
    subject.account_active = nil
    expect(subject).not_to be_valid

    subject.account_active = true
    expect(subject).to be_valid

    subject.account_active = false
    expect(subject).to be_valid
  end

  context 'Validations' do
    it { should validate_presence_of(:email) }
    it { should validate_presence_of(:role) }
    it { should validate_presence_of(:password) }
    it { should validate_uniqueness_of(:email).case_insensitive }
  end
end
