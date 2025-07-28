# == Schema Information
#
# Table name: articles
#
#  id                            :bigint           not null, primary key
#  default_category_id(預設分類) :bigint
#  title(標題)                   :string
#  title_en(英文標題)            :string
#  slug(slug)                    :string
#  post_type(文章類型)           :string           default("post")
#  featured(精選項目)            :integer
#  top(置頂)                     :integer
#  published_at(發布時間)        :datetime
#  published_at_en(英文發布時間) :datetime
#  expired_at(下架時間)          :datetime
#  expired_at_en(英文下架時間)   :datetime
#  deleted_at(刪除時間)          :datetime
#  content(內容)                 :text
#  content_en(英文內容)          :text
#  translations                  :jsonb
#  created_at                    :datetime         not null
#  updated_at                    :datetime         not null
#
# Indexes
#
#  index_articles_on_default_category_id  (default_category_id)
#  index_articles_on_deleted_at           (deleted_at)
#  index_articles_on_slug                 (slug) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (default_category_id => article_categories.id)
#
FactoryBot.define do
  factory :article do
    default_category { association(:article_default_category, :published_tw, :published_en) }
    article_categories { [default_category] }
    title { FFaker::Lorem.characters.first(20) }
    title_en { FFaker::Lorem.characters.first(20) }
    slug { (FFaker::Internet.slug(nil, '-') + FFaker::Lorem.characters.first(5)) }

    trait :with_image do
      after(:build) do |article|
        article.image.attach(io: File.open('spec/fixtures/image.jpg'), filename: 'image.jpg')
        article.image_en.attach(io: File.open('spec/fixtures/image.jpg'), filename: 'image.jpg')
      end
    end

    trait :with_image_alt do
      alt_zh_tw { FFaker::Lorem.characters.first(20) }
      alt_en { FFaker::Lorem.characters.first(20) }
    end

    trait :post_tw do
      post_type { 'post'}
      content { FFaker::Lorem.paragraph }
    end

    trait :post_en do
      post_type { 'post'}
      content_en { FFaker::Lorem.paragraph }
    end

    trait :link_tw do
      post_type { 'link'}
      source_link_zh_tw { 'https://www.example.com' }
    end

    trait :link_en do
      post_type { 'link'}
      source_link_en { 'https://www.example.com' }
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
      published_at { Time.current + 3.days }
      expired_at { Time.current + 20.days }
    end

    trait :future_en do
      published_at_en { Time.current + 3.days }
      expired_at_en { Time.current + 20.days }
    end

    trait :expired_tw do
      published_at { Time.current - 10.days }
      expired_at { Time.current - 3.days }
    end

    trait :expired_en do
      published_at_en { Time.current - 10.days }
      expired_at_en { Time.current - 3.days }
    end

    trait :with_seo do
      seo { association :seo, seoable: instance }
    end

    factory :tagged_article do
      tag_list { '東, 西, 南, 北' }
      en_tag_list { 'east, west, south, north' }
    end
  end
end
