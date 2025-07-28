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
require 'rails_helper'

RSpec.describe Setting, type: :model do
  subject { build(:setting) }
  let(:setting) { create(:setting) }

  context 'Validations' do
    it 'is valid with valid attributes' do
      expect(setting).to be_valid
    end

    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:category) }
    it { should validate_uniqueness_of(:name) }

    context '如果是網站資訊或聯絡資訊必須要有內容' do
      before do
        name = %w(site_title copyright meta_title meta_keywords meta_desc).sample
        @site_item = Setting.find_by(name: name)
      end

      it 'Valid' do
        expect(@site_item).to be_valid
      end

      it 'Invalid' do
        @site_item.content = nil
        expect(@site_item).to_not be_valid
      end
    end

    context '如果是社群連結必須要有發佈狀態' do
      before { @social_setting = Setting.social.sample }

      it 'Valid' do
        expect(@social_setting).to be_valid
      end

      it 'Invalid' do
        @social_setting.status = nil
        expect(@social_setting).to_not be_valid
      end
    end
  end
end
