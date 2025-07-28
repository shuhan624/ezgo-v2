class CreateRedirectRules < ActiveRecord::Migration[6.1]
  def change
    create_table :redirect_rules do |t|
      t.string :source_path, comment: '來源路徑'
      t.string :target_path, comment: '目標路徑'
      t.integer :position, comment: '排序'

      t.timestamps
    end
  end
end
