class CreatePartners < ActiveRecord::Migration[6.1]
  def change
    create_table :partners, comment: '合作夥伴' do |t|
      t.string :name, comment: '名稱'
      t.string :name_en, comment: '英文名稱'
      t.string :slug, index: { unique: true }, comment: 'slug'
      t.string :status, null: false, default: 'published', comment: '狀態'
      t.string :en_status, null: false, default: 'hidden', comment: '英文狀態'
      t.integer :position, comment: '排列順序'
      t.jsonb :translations, default: {}

      t.timestamps
    end
  end
end
