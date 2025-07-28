# == Schema Information
#
# Table name: partners
#
#  id                  :bigint           not null, primary key
#  name(名稱)          :string
#  name_en(英文名稱)   :string
#  slug(slug)          :string
#  status(狀態)        :string           default("published"), not null
#  en_status(英文狀態) :string           default("hidden"), not null
#  position(排列順序)  :integer
#  translations        :jsonb
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#
# Indexes
#
#  index_partners_on_slug  (slug) UNIQUE
#
require 'rails_helper'

RSpec.describe Partner, type: :model do
  let(:partner) { create(:partner) }

  context 'Validations' do
    it 'is valid with valid attributes' do
      expect(partner).to be_valid
    end

    context 'image validation' do
      it '如果中文狀態為公開，image必須存在' do
        partner = build(:partner, :published_tw)
        partner.image.attach(io: File.open('spec/fixtures/image.jpg'), filename: 'image.jpg')
        expect(partner).to be_valid
      end

      it '如果中文狀態為公開，image不存在會驗證失敗' do
        partner = build(:partner, :published_tw)
        expect(partner).not_to be_valid
      end

      it '如果英文狀態為公開，image_en必須存在' do
        partner = build(:partner, :published_en)
        partner.image_en.attach(io: File.open('spec/fixtures/image.jpg'), filename: 'image.jpg')
        expect(partner).to be_valid
      end

      it '如果英文狀態為公開，image_en不存在會驗證失敗' do
        partner = build(:partner, :published_en)
        expect(partner).not_to be_valid
      end
    end

    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:name_en) }
    it { should validate_presence_of(:status) }
    it { should validate_presence_of(:en_status) }
  end
end
