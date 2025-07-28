class CreateMenus < ActiveRecord::Migration[7.2]
  def change
    create_table :menus, comment: '選單管理' do |t|
      t.integer :parent_id, null: true, index: true, comment: '父節點'
      t.integer :position, null: false, comment: '排序'
      t.string :title, comment: '標題文字'
      t.string :title_en, comment: '英文標題'
      t.string :status, null: false, default: 'hidden', comment: '狀態'
      t.string :en_status, null: false, default: 'hidden', comment: '英文狀態'
      t.string :link, comment: '連結'
      t.string :link_en, comment: '英文連結'
      t.boolean :target, null: false, default: false, comment: '是否開新視窗'
      t.integer :lft, null: false, index: true
      t.integer :rgt, null: false, index: true
      t.integer :depth, null: false, default: 0

      t.timestamps
    end
  end
end
