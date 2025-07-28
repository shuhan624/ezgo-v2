class CreateUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :users, comment: '會員帳號' do |t|
      t.string :email, null: true, comment: '帳號'
      t.string :name, comment: '姓名'
      t.string :phone, comment: '電話'
      t.string :role, default: 'regular', comment: '會員級別'
      t.boolean :account_active, default: true, comment: '帳號狀態'
      t.string :country, comment: '國家'
      t.string :zip_code, comment: '郵遞區號'
      t.string :city, comment: '縣市'
      t.string :dist, comment: '地區'
      t.string :address, comment: '地址'
      t.string :line_uid, index: { unique: true }, comment: 'LINE UID'
      t.string :line_avatar, comment: 'LINE 大頭貼'
      t.datetime :line_auth_at, comment: 'LINE 註冊日期'
      t.text :note, comment: '備註'
      t.text :admin_note, comment: '後台備註'

      ## Recoverable
      t.string   :reset_password_token
      t.datetime :reset_password_sent_at

      ## Confirmable
      t.string   :confirmation_token
      t.datetime :confirmed_at
      t.datetime :confirmation_sent_at
      t.string   :unconfirmed_email # Only if using reconfirmable

      t.timestamps
    end

    add_index :users, :email, unique: true
    add_index :users, :reset_password_token, unique: true
    add_index :users, :confirmation_token,   unique: true

    User.first.superb! if User.first.present?
  end
end
