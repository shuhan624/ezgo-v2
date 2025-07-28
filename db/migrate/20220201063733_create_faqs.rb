class CreateFaqs < ActiveRecord::Migration[6.1]
  def change
    create_table :faq_categories, comment: '常見問題分類' do |t|
      t.string :name, comment: '分類名稱'
      t.string :name_en, comment: '英文名稱'
      t.string :slug, index: { unique: true }, comment: 'slug'
      t.string :status, null: false, default: 'published', comment: '狀態'
      t.string :en_status, null: false, default: 'hidden', comment: '英文狀態'
      t.jsonb :translations, default: {}
      t.integer :position, comment: '排列順序'

      t.timestamps
    end

    create_table :faqs, comment: '常見問題' do |t|
      t.references :faq_category, null: false, foreign_key: true, comment: '分類'
      t.string :title, comment: '標題'
      t.string :title_en, comment: '英文標題'
      t.string :status, null: false, default: 'published', comment: '狀態'
      t.string :en_status, null: false, default: 'hidden', comment: '英文狀態'
      t.text :content, comment: '內容'
      t.text :content_en, comment: '英文內容'
      t.jsonb :translations, default: {}
      t.integer :position, comment: '排列順序'

      t.timestamps
    end
  end
end
