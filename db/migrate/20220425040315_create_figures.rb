class CreateFigures < ActiveRecord::Migration[6.1]
  def change
    create_table :figures, comment: '圖片' do |t|
      t.integer :position, comment: '排列順序'
      t.jsonb :translations, default: {}

      t.references :imageable, null: false, polymorphic: true, comment: '對象物件'

      t.timestamps
    end
  end
end
