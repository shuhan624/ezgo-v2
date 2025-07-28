class CreateRoles < ActiveRecord::Migration[6.1]
  def change
    create_table :roles do |t|
      t.string :name, null: false, comment: '名稱'
      t.jsonb :permissions, default: {}, comment: '權限設定'

      t.timestamps
    end
  end
end
