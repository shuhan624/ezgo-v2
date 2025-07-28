# == Schema Information
#
# Table name: partners
#
#  id                  :bigint           not null, primary key
#  name(名稱)          :string
#  name_en(英文名稱)   :string
#  slug(slug)          :string
#  status(狀態)        :string           default("published"), not null
#  en_status(英文狀態) :string           default("hidden"), not null
#  position(排列順序)  :integer
#  translations        :jsonb
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#
# Indexes
#
#  index_partners_on_slug  (slug) UNIQUE
#
FactoryBot.define do
  factory :partner do
    name { FFaker::Lorem.characters.first(10) }
    name_en { FFaker::Lorem.characters.first(10) }
    status { 'hidden' }

    trait :with_image do
      after(:build) do |slide|
        slide.image.attach(io: File.open('spec/fixtures/image.jpg'), filename: 'image.jpg')
      end
    end

    trait :with_image_en do
      after(:build) do |slide|
        slide.image_en.attach(io: File.open('spec/fixtures/image.jpg'), filename: 'image.jpg')
      end
    end

    trait :with_image_alt_tw do
      alt_zh_tw { FFaker::Lorem.characters.first(20) }
    end

    trait :with_image_alt_en do
      alt_en { FFaker::Lorem.characters.first(20) }
    end

    trait :published_tw do
      status { "published" }
    end

    trait :published_en do
      status { "hidden" }
      en_status { "published" }
    end

    trait :hidden_tw do
      status { "hidden" }
    end

    trait :hidden_en do
      en_status { "hidden" }
    end

    trait :link_tw do
      link_zh_tw { FFaker::Internet.http_url }
    end

    trait :link_en do
      link_en { FFaker::Internet.http_url }
    end
  end
end
