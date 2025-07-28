# == Schema Information
#
# Table name: milestones
#
#  id                   :bigint           not null, primary key
#  title(標題)          :string
#  title_en(英文標題)   :string
#  date(年月份)         :date
#  status(狀態)         :string           default("published")
#  en_status(英文狀態)  :string           default("hidden")
#  content(內容)        :text
#  content_en(英文內容) :text
#  translations         :jsonb
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#
FactoryBot.define do
  factory :milestone do
    title { FFaker::Lorem.characters.first(10) }
    title_en { FFaker::Lorem.characters.first(10) }
    content { FFaker::Lorem.paragraph }
    content_en { FFaker::Lorem.paragraph }
    date { Date.today }

    trait :with_image do
      after(:build) do |slide|
        slide.image.attach(io: File.open('spec/fixtures/image.jpg'), filename: 'image.jpg')
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
  end
end
