# == Schema Information
#
# Table name: redirect_rules
#
#  id                    :bigint           not null, primary key
#  source_path(來源路徑) :string
#  target_path(目標路徑) :string
#  position(排序)        :integer
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#
FactoryBot.define do
  factory :redirect_rule do
    source_path { "/#{FFaker::Lorem.characters.first(10)}-#{FFaker::Lorem.characters.first(10)}" }
    target_path { "/news/#{FFaker::Lorem.characters.first(10)}" }

    trait :query_string do
      source_path { "/#{FFaker::Lorem.characters.first(10)}?#{FFaker::Lorem.characters.first(5)}=#{FFaker::Lorem.characters.first(5)}" }
    end
  end
end
