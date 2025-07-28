class CreateDownloads < ActiveRecord::Migration[6.1]
  def change
    create_table :download_categories, comment: '檔案分類' do |t|
      t.string :name, comment: '名稱'
      t.string :name_en, comment: '分類名稱'
      t.string :slug, index: { unique: true }, comment: 'slug'
      t.string :status, null: false, default: 'published', comment: '狀態'
      t.string :en_status, null: false, default: 'hidden', comment: '英文狀態'
      t.jsonb :translations, default: {}
      t.integer :position, comment: '排列順序'

      t.timestamps
    end

    create_table :downloads, comment: '檔案下載' do |t|
      t.references :download_category, null: false, foreign_key: true
      t.string :title, comment: '名稱'
      t.string :title_en, comment: '英文名稱'
      t.string :status, null: false, default: 'published', comment: '狀態'
      t.string :en_status, null: false, default: 'hidden', comment: '英文狀態'
      t.jsonb :translations, default: {}
      t.integer :position, comment: '排列順序'

      t.timestamps
    end
  end
end
