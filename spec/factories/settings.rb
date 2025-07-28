# == Schema Information
#
# Table name: settings
#
#  id                 :bigint           not null, primary key
#  name(欄位名稱)     :string           not null
#  slug(slug)         :string
#  category(類別)     :string
#  translations       :jsonb
#  position(排列順序) :integer
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#
# Indexes
#
#  index_settings_on_slug  (slug) UNIQUE
#
FactoryBot.define do
  factory :setting do
    name { FFaker::Lorem.word }
    category { %w(site seo contact).sample }
  end
end
