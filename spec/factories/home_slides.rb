# == Schema Information
#
# Table name: home_slides
#
#  id                            :bigint           not null, primary key
#  title(標題)                   :text
#  title_en(英文標題)            :text
#  published_at(發布時間)        :datetime
#  published_at_en(英文發布時間) :datetime
#  expired_at(下架時間)          :datetime
#  expired_at_en(英文下架時間)   :datetime
#  slide_type(輪播類型)          :string           default("image"), not null
#  translations                  :jsonb
#  position(排列順序)            :integer
#  created_at                    :datetime         not null
#  updated_at                    :datetime         not null
#
FactoryBot.define do
  factory :home_slide do

    after(:build) do |slide|
      slide.banner.attach(io: File.open('spec/fixtures/image.jpg'), filename: 'image.jpg')
      slide.banner_m.attach(io: File.open('spec/fixtures/image.jpg'), filename: 'image.jpg')
    end

    trait :with_banner_en do
      after(:build) do |slide|
        slide.banner_en.attach(io: File.open('spec/fixtures/image.jpg'), filename: 'image.jpg')
        slide.banner_m_en.attach(io: File.open('spec/fixtures/image.jpg'), filename: 'image.jpg')
      end
    end

    trait :published_tw do
      published_at { Time.current }
      expired_at { Time.current + 10.days }
    end

    trait :published_en do
      published_at_en { Time.current }
      expired_at_en { Time.current + 10.days }
    end

    trait :future_tw do
      published_at { 3.days.from_now }
      expired_at { 20.days.from_now }
    end

    trait :future_en do
      published_at_en { 3.days.from_now }
      expired_at_en { 20.days.from_now }
    end

    trait :expired_tw do
      published_at { Time.current - 10.days }
      expired_at { Time.current - 3.days }
    end

    trait :expired_en do
      published_at_en { Time.current - 10.days }
      expired_at_en { Time.current - 3.days }
    end

    trait :with_link do
      link_zh_tw { 'https://www.example.com' }
      link_en { 'https://www.example.com/en' }
    end

    trait :with_title do
      title { FFaker::Lorem.characters.first(10) }
      title_en { FFaker::Lorem.characters.first(10) }
    end

    trait :with_alt do
      alt_zh_tw { FFaker::Lorem.characters.first(10) }
      alt_en { FFaker::Lorem.characters.first(10) }
    end

    trait :with_desc do
      desc_zh_tw { FFaker::Lorem.characters.first(10) }
      desc_en { FFaker::Lorem.characters.first(10) }
    end
  end
end
