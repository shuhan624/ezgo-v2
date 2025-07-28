class CreateHomeSlides < ActiveRecord::Migration[6.1]
  def change
    create_table :home_slides, comment: '首頁輪播' do |t|
      t.text :title, comment: '標題'
      t.text :title_en, comment: '英文標題'
      t.datetime :published_at, comment: '發布時間'
      t.datetime :published_at_en, comment: '英文發布時間'
      t.datetime :expired_at, comment: '下架時間'
      t.datetime :expired_at_en, comment: '英文下架時間'
      t.string :slide_type, null: false, default: 'image', comment: '輪播類型'
      t.jsonb :translations, default: {}
      t.integer :position, comment: '排列順序'

      t.timestamps
    end
  end
end
