# == Schema Information
#
# Table name: figures
#
#  id                     :bigint           not null, primary key
#  position(排列順序)     :integer
#  translations           :jsonb
#  imageable_type         :string           not null
#  imageable_id(對象物件) :bigint           not null
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_figures_on_imageable  (imageable_type,imageable_id)
#
FactoryBot.define do
  factory :figure do
    after(:build) do |figure|
      figure.image.attach(io: File.open('spec/fixtures/image.jpg'), filename: 'image.jpg')
    end

    factory :figure_for_product do
      association :imageable, factory: :product
    end

    factory :figure_for_color do
      association :imageable, factory: :color
    end

    trait :for_product do
      association :imageable, factory: :product
    end

    trait :with_alt do
      alt_zh_tw { FFaker::Lorem.characters.first(10) }
      alt_en { FFaker::Lorem.characters.first(10) }
    end
  end
end
