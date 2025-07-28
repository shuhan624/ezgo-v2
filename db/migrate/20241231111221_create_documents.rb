class CreateDocuments < ActiveRecord::Migration[6.1]
  def change
    create_table :documents, comment: '檔案' do |t|
      t.references :attachable, null: true, polymorphic: true
      t.string :title, comment: '標題'
      t.string :slug, index: { unique: true }, comment: 'slug'
      t.string :file_type, default: 'file', comment: '檔案類型'
      t.string :language, comment: '檔案語系'
      t.string :link, comment: '連結'
      t.jsonb :spec, default: {}, comment: '其他'
      t.integer :position, comment: '排列順序'

      t.timestamps
    end
  end
end
