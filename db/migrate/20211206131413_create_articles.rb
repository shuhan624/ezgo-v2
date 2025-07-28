class CreateArticles < ActiveRecord::Migration[6.1]
  def change
    create_table :article_categories, comment: '最新消息分類' do |t|
      t.string :name, comment: '分類名稱'
      t.string :name_en, comment: '英文名稱'
      t.string :status, null: false, default: 'published', comment: '狀態'
      t.string :en_status, null: false, default: 'hidden', comment: '英文狀態'
      t.string :slug, index: { unique: true }, comment: 'slug'
      t.jsonb :translations, default: {}
      t.integer :position, comment: '排列順序'

      t.timestamps
    end

    create_table :articles, comment: '最新消息' do |t|
      t.references :default_category, foreign_key: { to_table: :article_categories }, comment: '預設分類'
      t.string :title, comment: '標題'
      t.string :title_en, comment: '英文標題'
      t.string :slug, index: { unique: true }, comment: 'slug'
      t.string :post_type, default: 'post', comment: '文章類型'
      t.integer :featured, comment: '精選項目'
      t.integer :top, comment: '置頂'
      t.datetime :published_at, comment: '發布時間'
      t.datetime :published_at_en, comment: '英文發布時間'
      t.datetime :expired_at, comment: '下架時間'
      t.datetime :expired_at_en, comment: '英文下架時間'
      t.datetime :deleted_at, index: true, comment: '刪除時間'
      t.text :content, comment: '內容'
      t.text :content_en, comment: '英文內容'
      t.jsonb :translations, default: {}

      t.timestamps

    end

    create_table :article_article_categories, id: false do |t|
      t.belongs_to :article
      t.belongs_to :article_category
    end
  end
end
