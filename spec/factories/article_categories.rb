# == Schema Information
#
# Table name: article_categories
#
#  id                  :bigint           not null, primary key
#  name(分類名稱)      :string
#  name_en(英文名稱)   :string
#  status(狀態)        :string           default("published"), not null
#  en_status(英文狀態) :string           default("hidden"), not null
#  slug(slug)          :string
#  translations        :jsonb
#  position(排列順序)  :integer
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#
# Indexes
#
#  index_article_categories_on_slug  (slug) UNIQUE
#
FactoryBot.define do
  factory :article_category, aliases: [:article_default_category] do
    sequence(:name) { |n| "#{FFaker::Lorem.word}_#{n}" }
    sequence(:name_en) { |n| "#{FFaker::Lorem.word}_#{n}" }
    slug { (FFaker::Internet.slug(nil, '-') + FFaker::Lorem.characters.first(5)) }

    trait :with_desc do
      desc_zh_tw { FFaker::Lorem.paragraph }
      desc_en { FFaker::Lorem.paragraph }
    end

    trait :published_tw do
      status { 'published' }
    end

    trait :published_en do
      en_status { 'published' }
    end

    trait :hidden_tw do
      status { 'hidden' }
    end

    trait :hidden_en do
      en_status { 'hidden' }
    end

    trait :with_seo do
      seo { association :seo, seoable: instance }
    end
  end
end
