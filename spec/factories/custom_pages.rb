# == Schema Information
#
# Table name: custom_pages
#
#  id                           :bigint           not null, primary key
#  title(頁面標題)              :string
#  title_en(英文標題)           :string
#  slug(slug)                   :string
#  content(內容)                :text
#  content_en(英文內容)         :text
#  status(狀態)                 :string           default("published")
#  en_status(英文狀態)          :string           default("published")
#  default_page(是否為預設頁面) :boolean          default(FALSE)
#  custom_type(頁面類型)        :string           default("info")
#  translations                 :jsonb
#  created_at                   :datetime         not null
#  updated_at                   :datetime         not null
#
# Indexes
#
#  index_custom_pages_on_slug  (slug) UNIQUE
#
FactoryBot.define do
  factory :custom_page do
    title { FFaker::Lorem.characters.first(10) }
    title_en { FFaker::Lorem.characters.first(10) }
    slug { FFaker::Lorem.characters.first(10) }

    trait :with_seo do
      seo { association :seo, seoable: instance }
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

    trait :default_page do
      default_page { true }
    end

    trait :non_default_page do
      default_page { false }
    end

    trait :design do
      custom_type { 'design' }
    end

    trait :info do
      custom_type { 'info' }
      content { FFaker::Lorem.paragraph }
      content_en { FFaker::Lorem.paragraph }
    end

    trait :archive do
      custom_type { 'archive' }
    end

    trait :default_page do
      default_page { true }
    end
  end
end
