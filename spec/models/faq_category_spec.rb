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
require 'rails_helper'

RSpec.describe FaqCategory, type: :model do
  subject { build(:faq_category) }
  let(:faq_category) { create(:faq_category) }

  context 'name validate' do
    it '當「中文狀態」為「公開」時，中文名稱為必填欄位' do
      faq_category = build(:faq_category, status: 'published', name: nil)
      expect(faq_category).not_to be_valid

      faq_category = build(:faq_category, status: 'published', name: '')
      expect(faq_category).not_to be_valid
    end

    it '當「英文狀態」為「公開」時，英文名稱為必填' do
      faq_category = build(:faq_category, en_status: 'published', name_en: nil)
      expect(faq_category).not_to be_valid

      faq_category = build(:faq_category, en_status: 'published', name_en: '')
      expect(faq_category).not_to be_valid
    end
  end

  context 'slug validate' do
    it '網址 slug 不可以使用大寫字母' do
      faq_category = build(:faq_category, slug: 'ABC')
      expect(faq_category).not_to be_valid
    end

    it '網址 slug 不可以使用空白格' do
      faq_category = build(:faq_category, slug: 'ab c')
      expect(faq_category).not_to be_valid
    end

    it '網址 slug 不可以使用下底線「_」' do
      faq_category = build(:faq_category, slug: 'abc_def')
      expect(faq_category).not_to be_valid
    end

    it '網址 slug 不可以使用特殊符號' do
      faq_category = build(:faq_category, slug: 'a&b-c.d,')
      expect(faq_category).not_to be_valid
    end

    it '網址 slug 不可以使用中文' do
      faq_category = build(:faq_category, slug: '這是網址')
      expect(faq_category).not_to be_valid
    end
  end

  context 'Validations' do
    it 'is valid with valid attributes' do
      expect(faq_category).to be_valid
    end

    it { should validate_presence_of(:status) }
    it { should validate_presence_of(:en_status) }
  end

  context 'Associations' do
    it { should have_one(:seo) }
    it { should have_many(:faqs) }
  end
end
