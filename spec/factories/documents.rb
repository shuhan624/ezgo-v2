# == Schema Information
#
# Table name: documents
#
#  id                  :bigint           not null, primary key
#  attachable_type     :string
#  attachable_id       :bigint
#  title(標題)         :string
#  slug(slug)          :string
#  file_type(檔案類型) :string           default("file")
#  language(檔案語系)  :string
#  link(連結)          :string
#  spec(其他)          :jsonb
#  position(排列順序)  :integer
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#
# Indexes
#
#  index_documents_on_attachable  (attachable_type,attachable_id)
#  index_documents_on_slug        (slug) UNIQUE
#
FactoryBot.define do
  factory :document do
    title { FFaker::Lorem.characters.first(20) }
    slug { (FFaker::Internet.slug(nil, '-') + FFaker::Lorem.characters.first(5)) }
    language { 'tw' }
    file_type { 'link' }
    link { 'https://www.example.com' }

    trait :file do
      file_type { 'file' }
      after(:build) do |document|
        document.file.attach(io: File.open('spec/fixtures/test.pdf'), filename: 'test.pdf')
      end
    end

    trait :xls_file do
      file_type { 'file' }
      after(:build) do |document|
        document.file.attach(io: File.open('spec/fixtures/test.xls'), filename: 'test.xls')
      end
    end

    trait :xlsx_file do
      file_type { 'file' }
      after(:build) do |document|
        document.file.attach(io: File.open('spec/fixtures/test.xlsx'), filename: 'test.xlsx')
      end
    end

    trait :link do
      file_type { 'link' }
      link { FFaker::Internet.http_url }
    end

    trait :tw do
      language { 'tw' }
    end

    trait :en do
      language { 'en' }
    end

    # 最新消息
    trait :article do
      association :attachable, factory: :article
    end

    factory :document_with_file, traits: %i[file]

    factory :document_with_link, traits: %i[link]
  end
end
