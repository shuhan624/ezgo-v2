class CreateSettings < ActiveRecord::Migration[6.1]
  def change
    create_table :settings, comment: '全站設定' do |t|
      t.string :name, null: false, comment: '欄位名稱'
      t.string :slug, index: { unique: true }, comment: 'slug'
      t.string :category, comment: '類別'
      t.jsonb :translations, default: {}
      t.integer :position, comment: '排列順序'

      t.timestamps
    end
  end
end
