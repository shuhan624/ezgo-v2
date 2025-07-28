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
require 'rails_helper'

RSpec.describe Article, type: :model do
  subject { build(:article) }
  let(:article) { create(:article) }

  context 'Validations' do
    it 'is valid with valid attributes' do
      expect(article).to be_valid
    end

    context '文章發佈' do
      it '中文文章，下架時間不得早於發佈時間' do
        article = build(:article,
                        published_at: 1.days.ago,
                        expired_at: 3.days.ago)
        expect(article).not_to be_valid
      end

      it '英文文章，下架時間不得早於發佈時間' do
        article = build(:article,
                        published_at_en: 1.days.ago,
                        expired_at_en: 3.days.ago)
        expect(article).not_to be_valid
      end
    end

    context 'title validate' do
      it '當「中文狀態」為「公開」時，中文標題為必填欄位' do
        article = build(:article, :published_tw, title: nil)
        expect(article).not_to be_valid

        article = build(:article, :published_tw, title: '')
        expect(article).not_to be_valid

        article = build(:article, :published_tw, title: nil, published_at_en: nil)
        expect(article).not_to be_valid

        article = build(:article, :published_tw, title: '', published_at_en: nil)
        expect(article).not_to be_valid
      end

      it '當「英文狀態」為「公開」時，英文標題為必填' do
        article = build(:article, title_en: nil, published_at_en: Time.current)
        expect(article).not_to be_valid

        article = build(:article, title_en: '', published_at_en: Time.current)
        expect(article).not_to be_valid
      end
    end

    context 'content validate' do
      it '當中文狀態為「公開」時，中文內容為必填' do
        article = build(:article, content: nil, published_at: Time.current)
        expect(article).not_to be_valid

        article = build(:article, content: '', published_at: Time.current)
        expect(article).not_to be_valid
      end

      it '當英文狀態為「公開」時，英文內容為必填' do
        article = build(:article, content_en: nil, published_at_en: Time.current)
        expect(article).not_to be_valid

        article = build(:article, content_en: '', published_at_en: Time.current)
        expect(article).not_to be_valid
      end
    end

    context '網址 slug' do
      it '為必填欄位' do
        article = build(:article, slug: nil)
        expect(article).not_to be_valid

        article = build(:article, slug: '')
        expect(article).not_to be_valid
      end

      it '不可以重複' do
        article2 = build(:article, slug: article.slug)
        expect(article2).not_to be_valid
      end

      it '網址 slug 不可以使用大寫字母' do
        article = build(:article, slug: 'ABC')
        expect(article).not_to be_valid
      end

      it '網址 slug 不可以使用空白格' do
        article = build(:article, slug: 'ab c')
        expect(article).not_to be_valid
      end

      it '網址 slug 不可以使用下底線「_」' do
        article = build(:article, slug: 'abc_def')
        expect(article).not_to be_valid
      end

      it '網址 slug 不可以使用特殊符號' do
        article = build(:article, slug: 'a&b-c.d,')
        expect(article).not_to be_valid
      end

      it '網址 slug 不可以使用中文' do
        article = build(:article, slug: '這是網址')
        expect(article).not_to be_valid
      end

      it '至少必須屬於一個分類' do
        article.article_categories = []
        expect(article).not_to be_valid
      end
    end

    it { should validate_presence_of(:slug) }
    it { should validate_presence_of(:article_categories) }
    it { should validate_presence_of(:default_category) }
  end

  context "Associations" do
    it { should have_one(:seo) }
    it { should have_and_belong_to_many(:article_categories) }
    it { should belong_to(:default_category) }
  end
end
