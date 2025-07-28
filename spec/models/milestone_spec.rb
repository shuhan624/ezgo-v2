# == Schema Information
#
# Table name: milestones
#
#  id                   :bigint           not null, primary key
#  title(標題)          :string
#  title_en(英文標題)   :string
#  date(年月份)         :date
#  status(狀態)         :string           default("published")
#  en_status(英文狀態)  :string           default("hidden")
#  content(內容)        :text
#  content_en(英文內容) :text
#  translations         :jsonb
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#
require 'rails_helper'

RSpec.describe Milestone, type: :model do
  let(:milestone) { create(:milestone) }

  context 'Validations' do
    it 'is valid with valid attributes' do
      expect(milestone).to be_valid
    end

    context 'title validate' do
      it '當「中文狀態」為「公開」時，中文標題為必填欄位' do
        milestone = build(:milestone, :published_tw, title: nil)
        expect(milestone).not_to be_valid

        milestone = build(:milestone, :published_tw, title: '')
        expect(milestone).not_to be_valid
      end

      it '當「英文狀態」為「公開」時，英文標題為必填' do
        milestone = build(:milestone, :published_en, title_en: nil)
        expect(milestone).not_to be_valid

        milestone = build(:milestone, :published_en, title_en: nil)
        expect(milestone).not_to be_valid
      end

      it '至少要有一個語系的標題存在' do
        milestone = build(:milestone, :hidden_tw, :hidden_en, title: nil, title_en: nil)
        expect(milestone).not_to be_valid

        milestone = build(:milestone, :hidden_tw, :hidden_en, title: nil, title_en: 'title_en')
        expect(milestone).to be_valid

        milestone = build(:milestone, :hidden_tw, :hidden_en, title: 'title', title_en: nil)
        expect(milestone).to be_valid
      end
    end

    context 'content validate' do
      it '當中文狀態為「公開」時，中文內容為必填' do
        milestone = build(:milestone, :published_tw, content: nil)
        expect(milestone).not_to be_valid

        milestone = build(:milestone, :published_tw, content: '')
        expect(milestone).not_to be_valid
      end

      it '當英文狀態為「公開」時，英文內容為必填' do
        milestone = build(:milestone, :published_en, content_en: nil)
        expect(milestone).not_to be_valid

        milestone = build(:milestone, :published_en, content_en: '')
        expect(milestone).not_to be_valid
      end
    end

    it { should validate_presence_of(:date) }
    it { should validate_presence_of(:status) }
    it { should validate_presence_of(:en_status) }
  end
end
