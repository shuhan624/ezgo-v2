# == Schema Information
#
# Table name: roles
#
#  id                    :bigint           not null, primary key
#  name(名稱)            :string           not null
#  permissions(權限設定) :jsonb
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#
FactoryBot.define do
  factory :role do
    name { 'staff' }

    trait :no_permissions do
      permissions {
        {
          dashboard: {
            index: true,
          }
        }
      }
    end
  end
end
