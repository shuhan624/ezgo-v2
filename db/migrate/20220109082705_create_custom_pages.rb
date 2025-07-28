class CreateCustomPages < ActiveRecord::Migration[6.1]
  def change
    create_table :custom_pages, comment: '頁面管理' do |t|
      t.string :title, comment: '頁面標題'
      t.string :title_en, comment: '英文標題'
      t.string :slug, index: { unique: true }, comment: 'slug'
      t.text :content, comment: '內容'
      t.text :content_en, comment: '英文內容'
      t.string :status, comment: '狀態', default: 'published'
      t.string :en_status, comment: '英文狀態', default: 'published'
      t.boolean :default_page, comment: '是否為預設頁面', default: false
      t.string :custom_type, comment: '頁面類型', default: 'info'
      t.jsonb :translations, default: {}

      t.timestamps
    end
  end
end
