# == Schema Information
#
# Table name: custom_pages
#
#  id                           :bigint           not null, primary key
#  title(頁面標題)              :string
#  title_en(英文標題)           :string
#  slug(slug)                   :string
#  content(內容)                :text
#  content_en(英文內容)         :text
#  status(狀態)                 :string           default("published")
#  en_status(英文狀態)          :string           default("published")
#  default_page(是否為預設頁面) :boolean          default(FALSE)
#  custom_type(頁面類型)        :string           default("info")
#  translations                 :jsonb
#  created_at                   :datetime         not null
#  updated_at                   :datetime         not null
#
# Indexes
#
#  index_custom_pages_on_slug  (slug) UNIQUE
#
require 'rails_helper'

RSpec.describe CustomPage, type: :model do
  let(:custom_page) { create(:custom_page) }

  context 'Validations' do
    it 'is valid with valid attributes' do
      expect(custom_page).to be_valid
    end

    context 'title validate' do
      it '當「中文狀態」為「公開」時，中文標題為必填欄位' do
        custom_page = build(:custom_page, :published_tw, title: nil)
        expect(custom_page).not_to be_valid

        custom_page = build(:custom_page, :published_tw, title: '')
        expect(custom_page).not_to be_valid
      end

      it '當「英文狀態」為「公開」時，英文標題為必填' do
        custom_page = build(:custom_page, :published_en, title_en: nil)
        expect(custom_page).not_to be_valid

        custom_page = build(:custom_page, :published_en, title_en: '')
        expect(custom_page).not_to be_valid
      end
    end

    context 'slug validate' do
      context 'format 驗證' do
        it '網址 slug 不可以使用大寫字母' do
          custom_page = build(:custom_page, slug: 'ABC')
          expect(custom_page).not_to be_valid
        end

        it '網址 slug 不可以使用空白格' do
          custom_page = build(:custom_page, slug: 'ab c')
          expect(custom_page).not_to be_valid
        end

        it '網址 slug 不可以使用下底線「_」' do
          custom_page = build(:custom_page, slug: 'abc_def')
          expect(custom_page).not_to be_valid
        end

        it '網址 slug 不可以使用特殊符號' do
          custom_page = build(:custom_page, slug: 'a&b-c.d,')
          expect(custom_page).not_to be_valid
        end

        it '網址 slug 不可以使用中文' do
          custom_page = build(:custom_page, slug: '這是網址')
          expect(custom_page).not_to be_valid
        end
      end

      context 'exclusion 驗證' do
        %w(user login logout sign_up cart order en ja ko zh-TW).each do |slug|
          it "網址 slug 不可以使用 #{slug}" do
            custom_page = build(:custom_page, slug: slug)
            expect(custom_page).not_to be_valid
          end
        end
      end
    end

    it { should validate_presence_of(:slug) }
    it { should validate_uniqueness_of(:slug) }
    it { should validate_presence_of(:status) }
    it { should validate_presence_of(:en_status) }
    it { should validate_presence_of(:custom_type) }
  end

  context "Associations" do
    it { should have_one(:seo) }
  end
end
