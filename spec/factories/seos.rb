# == Schema Information
#
# Table name: seos
#
#  id                  :bigint           not null, primary key
#  seoable_type        :string           not null
#  seoable_id          :bigint           not null
#  canonical(標準網址) :string
#  translations        :jsonb
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#
# Indexes
#
#  index_seos_on_seoable  (seoable_type,seoable_id)
#
FactoryBot.define do
  factory :seo do
    meta_title_zh_tw { FFaker::Lorem.characters.first(10) }
    meta_title_en { FFaker::Lorem.characters.first(10) }
    meta_keywords_zh_tw { FFaker::Lorem.word }
    meta_keywords_en { FFaker::Lorem.word }
    meta_desc_zh_tw { FFaker::Lorem.phrase }
    meta_desc_en { FFaker::Lorem.phrase }
    og_title_zh_tw { FFaker::Lorem.characters.first(10) }
    og_title_en { FFaker::Lorem.characters.first(10) }
    og_desc_zh_tw { FFaker::Lorem.phrase }
    og_desc_en { FFaker::Lorem.phrase }

    after(:build) do |seo|
      seo.og_image.attach(io: File.open('spec/fixtures/image.jpg'), filename: 'image.jpg')
    end

    after(:build) do |seo|
      seo.og_image_en.attach(io: File.open('spec/fixtures/image.jpg'), filename: 'image.jpg')
    end
  end
end
