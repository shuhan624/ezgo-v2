# == Schema Information
#
# Table name: faq_categories
#
#  id                  :bigint           not null, primary key
#  name(分類名稱)      :string
#  name_en(英文名稱)   :string
#  slug(slug)          :string
#  status(狀態)        :string           default("published"), not null
#  en_status(英文狀態) :string           default("hidden"), not null
#  translations        :jsonb
#  position(排列順序)  :integer
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#
# Indexes
#
#  index_faq_categories_on_slug  (slug) UNIQUE
#
FactoryBot.define do
  factory :faq_category do
    name { FFaker::Lorem.characters.first(10) }
    name_en { FFaker::Lorem.characters.first(10) }
    slug { (FFaker::Internet.slug(nil, '-') + FFaker::Lorem.characters.first(5)) }

    trait :with_seo do
      seo { association :seo, seoable: instance }
    end

    trait :published_tw do
      status { 'published' }
    end

    trait :hidden_tw do
      status { 'hidden' }
    end

    trait :published_en do
      en_status { 'published' }
    end

    trait :hidden_en do
      en_status { 'hidden' }
    end
  end
end
