# == Schema Information
#
# Table name: admins
#
#  id                       :bigint           not null, primary key
#  email(帳號)              :string           not null
#  name(姓名)               :string
#  cw_chief(前網帳號)       :boolean          default(FALSE)
#  role_id(角色)            :bigint
#  account_active(帳號狀態) :boolean          default(TRUE)
#  language(管理語系)       :jsonb
#  alt(照片描述)            :string
#  encrypted_password       :string           default(""), not null
#  reset_password_token     :string
#  reset_password_sent_at   :datetime
#  remember_created_at      :datetime
#  sign_in_count            :integer          default(0), not null
#  current_sign_in_at       :datetime
#  last_sign_in_at          :datetime
#  current_sign_in_ip       :inet
#  last_sign_in_ip          :inet
#  failed_attempts          :integer          default(0), not null
#  unlock_token             :string
#  locked_at                :datetime
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#
# Indexes
#
#  index_admins_on_email                 (email) UNIQUE
#  index_admins_on_reset_password_token  (reset_password_token) UNIQUE
#  index_admins_on_role_id               (role_id)
#  index_admins_on_unlock_token          (unlock_token) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (role_id => roles.id)
#
FactoryBot.define do
  password = FFaker::Internet.password

  factory :admin do
    association :role
    email { FFaker::Internet.email }
    account_active { true }
    cw_chief { false }
    password { password }
    password_confirmation { password }
    factory :cw_chief do
      cw_chief { true }
    end

    trait :with_name do
      name { FFaker::NameTW.name }
    end

    trait :enabled do
      account_active { true }
    end

    trait :disabled do
      account_active { false }
    end

    trait :no_permissions do
      role { create(:role, :no_permissions, name: 'no_permissions_role') }
    end
  end
end
