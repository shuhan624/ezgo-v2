class CreateAdmins < ActiveRecord::Migration[6.1]
  def change
    create_table :admins, comment: '後台帳號' do |t|
      t.string :email, null: false, comment: '帳號'
      t.string :name, comment: '姓名'
      t.boolean :cw_chief, default: false, comment: '前網帳號'
      t.references :role, foreign_key: true, comment: '角色'
      t.boolean :account_active, default: true, comment: '帳號狀態'
      t.jsonb :language, default: {}, comment: '管理語系'
      t.string :alt, comment: '照片描述'

      ## Database authenticatable
      t.string :encrypted_password, null: false, default: ""

      ## Recoverable
      t.string   :reset_password_token
      t.datetime :reset_password_sent_at

      ## Rememberable
      t.datetime :remember_created_at

      ## Trackable
      t.integer  :sign_in_count, default: 0, null: false
      t.datetime :current_sign_in_at
      t.datetime :last_sign_in_at
      t.inet     :current_sign_in_ip
      t.inet     :last_sign_in_ip

      ## Confirmable
      # t.string   :confirmation_token
      # t.datetime :confirmed_at
      # t.datetime :confirmation_sent_at
      # t.string   :unconfirmed_email # Only if using reconfirmable

      ## Lockable
      t.integer  :failed_attempts, default: 0, null: false # Only if lock strategy is :failed_attempts
      t.string   :unlock_token # Only if unlock strategy is :email or :both
      t.datetime :locked_at

      # Uncomment below if timestamps were not included in your original model.
      t.timestamps null: false
    end

    add_index :admins, :reset_password_token, unique: true
    # add_index :admins, :confirmation_token,   unique: true
    add_index :admins, :email, unique: true
    add_index :admins, :unlock_token, unique: true
  end
end
