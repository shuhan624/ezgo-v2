class CreateMilestones < ActiveRecord::Migration[6.1]
  def change
    create_table :milestones, comment: '大事記' do |t|
      t.string :title, comment: '標題'
      t.string :title_en, comment: '英文標題'
      t.date :date, comment: '年月份'
      t.string :status, default: 'published', comment: '狀態'
      t.string :en_status, default: 'hidden', comment: '英文狀態'
      t.text :content, comment: '內容'
      t.text :content_en, comment: '英文內容'
      t.jsonb :translations, default: {}

      t.timestamps
    end
  end
end
