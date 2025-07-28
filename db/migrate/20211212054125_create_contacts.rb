class CreateContacts < ActiveRecord::Migration[6.1]
  def change
    create_table :contacts, comment: '聯絡表單' do |t|
      t.string :name, null: false, index: true, comment: '姓名'
      t.string :email, index: true, comment: '電子郵件'
      t.string :phone, null: false, index: true, comment: '聯絡電話'
      t.string :company, comment: '公司名稱'
      t.string :address, comment: '聯絡地址'
      t.text :content, comment: '詢問內容'
      t.text :admin_note, comment: '備註'
      t.string :status, null: false, default: 'new_case', comment: '狀態'

      t.timestamps
    end
  end
end
