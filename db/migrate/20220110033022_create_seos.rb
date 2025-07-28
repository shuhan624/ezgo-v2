class CreateSeos < ActiveRecord::Migration[6.1]
  def change
    create_table :seos do |t|
      t.references :seoable, null: false, polymorphic: true

      t.string :canonical, comment: '標準網址'
      t.jsonb :translations, default: {}

      t.timestamps
    end
  end
end
