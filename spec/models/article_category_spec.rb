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
require 'rails_helper'

RSpec.describe ArticleCategory, type: :model do
  subject { build(:article_category) }

  context 'name validate' do
    it '當「中文狀態」為「公開」時，中文名稱為必填欄位' do
      article_category = build(:article_category, :published_tw, name: nil)
      expect(article_category).not_to be_valid

      article_category = build(:article_category, :published_tw, name: '')
      expect(article_category).not_to be_valid
    end

    it '當「英文狀態」為「公開」時，英文名稱為必填' do
      article_category = build(:article_category, :published_en, name_en: nil)
      expect(article_category).not_to be_valid

      article_category = build(:article_category, :published_en, name_en: '')
      expect(article_category).not_to be_valid
    end
  end

  context 'slug validate' do
    it '網址 slug 不可以使用大寫字母' do
      article_category = build(:article_category, slug: 'ABC')
      expect(article_category).not_to be_valid
    end

    it '網址 slug 不可以使用空白格' do
      article_category = build(:article_category, slug: 'ab c')
      expect(article_category).not_to be_valid
    end

    it '網址 slug 不可以使用下底線「_」' do
      article_category = build(:article_category, slug: 'abc_def')
      expect(article_category).not_to be_valid
    end

    it '網址 slug 不可以使用特殊符號' do
      article_category = build(:article_category, slug: 'a&b-c.d,')
      expect(article_category).not_to be_valid
    end

    it '網址 slug 不可以使用中文' do
      article_category = build(:article_category, slug: '這是網址')
      expect(article_category).not_to be_valid
    end
  end

  context 'Validations' do
    it { should validate_presence_of(:status) }
    it { should validate_presence_of(:en_status) }
  end

  context 'Associations' do
    it { should have_one(:seo) }
    it { should have_and_belong_to_many(:articles) }
  end
end
