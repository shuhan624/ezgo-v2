# == Schema Information
#
# Table name: faqs
#
#  id                    :bigint           not null, primary key
#  faq_category_id(分類) :bigint           not null
#  title(標題)           :string
#  title_en(英文標題)    :string
#  status(狀態)          :string           default("published"), not null
#  en_status(英文狀態)   :string           default("hidden"), not null
#  content(內容)         :text
#  content_en(英文內容)  :text
#  translations          :jsonb
#  position(排列順序)    :integer
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#
# Indexes
#
#  index_faqs_on_faq_category_id  (faq_category_id)
#
# Foreign Keys
#
#  fk_rails_...  (faq_category_id => faq_categories.id)
#
FactoryBot.define do
  factory :faq do
    association(:faq_category, :published_tw, :published_en)
    title { FFaker::Lorem.characters.first(10) }
    title_en { FFaker::Lorem.characters.first(10) }
    content { "<p>#{FFaker::Lorem.paragraph}</p>" }

    trait :published_tw do
      status { 'published' }
      faq_category { association(:faq_category, :published_tw) }
    end

    trait :published_en do
      en_status { 'published' }
      faq_category { association(:faq_category, :published_en) }
      content_en { "<p>#{FFaker::Lorem.paragraph}</p>" }
    end

    trait :hidden_tw do
      status { 'hidden' }
    end

    trait :hidden_en do
      en_status { 'hidden' }
    end
  end
end
