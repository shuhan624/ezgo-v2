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
require 'rails_helper'

RSpec.describe Faq, type: :model do
  subject { build(:faq) }
  let(:faq) { create(:faq) }

  context 'Validations' do
    it 'is valid with valid attributes' do
      expect(faq).to be_valid
    end

    context 'name validate' do
      it '當「中文狀態」為「公開」時，中文名稱為必填欄位' do
        faq = build(:faq, status: 'published', title: nil)
        expect(faq).not_to be_valid

        faq = build(:faq, status: 'published', title: '')
        expect(faq).not_to be_valid
      end

      it '當「英文狀態」為「公開」時，英文名稱為必填' do
        faq = build(:faq, en_status: 'published', title_en: nil)
        expect(faq).not_to be_valid

        faq = build(:faq, en_status: 'published', title_en: '')
        expect(faq).not_to be_valid
      end
    end

    context 'content validate' do
      it '當中文狀態為「公開」時，中文內容為必填' do
        faq = build(:faq, status: 'published', content: nil)
        expect(faq).not_to be_valid

        faq = build(:faq, status: 'published', content: '')
        expect(faq).not_to be_valid
      end

      it '當英文狀態為「公開」時，英文內容為必填' do
        faq = build(:faq, en_status: 'published', content_en: nil)
        expect(faq).not_to be_valid

        faq = build(:faq, en_status: 'published', content_en: '')
        expect(faq).not_to be_valid
      end
    end
  end

  context 'Associations' do
    it { should belong_to(:faq_category) }
  end
end
