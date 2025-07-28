# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.2].define(version: 2025_01_13_040543) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "admins", comment: "後台帳號", force: :cascade do |t|
    t.string "email", null: false, comment: "帳號"
    t.string "name", comment: "姓名"
    t.boolean "cw_chief", default: false, comment: "前網帳號"
    t.bigint "role_id", comment: "角色"
    t.boolean "account_active", default: true, comment: "帳號狀態"
    t.jsonb "language", default: {}, comment: "管理語系"
    t.string "alt", comment: "照片描述"
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at", precision: nil
    t.datetime "remember_created_at", precision: nil
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at", precision: nil
    t.datetime "last_sign_in_at", precision: nil
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.integer "failed_attempts", default: 0, null: false
    t.string "unlock_token"
    t.datetime "locked_at", precision: nil
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_admins_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admins_on_reset_password_token", unique: true
    t.index ["role_id"], name: "index_admins_on_role_id"
    t.index ["unlock_token"], name: "index_admins_on_unlock_token", unique: true
  end

  create_table "ahoy_events", force: :cascade do |t|
    t.bigint "visit_id"
    t.bigint "user_id"
    t.string "name"
    t.jsonb "properties"
    t.datetime "time", precision: nil
    t.index ["name", "time"], name: "index_ahoy_events_on_name_and_time"
    t.index ["properties"], name: "index_ahoy_events_on_properties", opclass: :jsonb_path_ops, using: :gin
    t.index ["user_id"], name: "index_ahoy_events_on_user_id"
    t.index ["visit_id"], name: "index_ahoy_events_on_visit_id"
  end

  create_table "ahoy_visits", force: :cascade do |t|
    t.string "visit_token"
    t.string "visitor_token"
    t.bigint "user_id"
    t.string "ip"
    t.text "user_agent"
    t.text "referrer"
    t.string "referring_domain"
    t.text "landing_page"
    t.string "browser"
    t.string "os"
    t.string "device_type"
    t.string "country"
    t.string "region"
    t.string "city"
    t.float "latitude"
    t.float "longitude"
    t.string "utm_source"
    t.string "utm_medium"
    t.string "utm_term"
    t.string "utm_content"
    t.string "utm_campaign"
    t.string "app_version"
    t.string "os_version"
    t.string "platform"
    t.datetime "started_at", precision: nil
    t.index ["user_id"], name: "index_ahoy_visits_on_user_id"
    t.index ["visit_token"], name: "index_ahoy_visits_on_visit_token", unique: true
  end

  create_table "article_article_categories", id: false, force: :cascade do |t|
    t.bigint "article_id"
    t.bigint "article_category_id"
    t.index ["article_category_id"], name: "index_article_article_categories_on_article_category_id"
    t.index ["article_id"], name: "index_article_article_categories_on_article_id"
  end

  create_table "article_categories", comment: "最新消息分類", force: :cascade do |t|
    t.string "name", comment: "分類名稱"
    t.string "name_en", comment: "英文名稱"
    t.string "status", default: "published", null: false, comment: "狀態"
    t.string "en_status", default: "hidden", null: false, comment: "英文狀態"
    t.string "slug", comment: "slug"
    t.jsonb "translations", default: {}
    t.integer "position", comment: "排列順序"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["slug"], name: "index_article_categories_on_slug", unique: true
  end

  create_table "articles", comment: "最新消息", force: :cascade do |t|
    t.bigint "default_category_id", comment: "預設分類"
    t.string "title", comment: "標題"
    t.string "title_en", comment: "英文標題"
    t.string "slug", comment: "slug"
    t.string "post_type", default: "post", comment: "文章類型"
    t.integer "featured", comment: "精選項目"
    t.integer "top", comment: "置頂"
    t.datetime "published_at", precision: nil, comment: "發布時間"
    t.datetime "published_at_en", precision: nil, comment: "英文發布時間"
    t.datetime "expired_at", precision: nil, comment: "下架時間"
    t.datetime "expired_at_en", precision: nil, comment: "英文下架時間"
    t.datetime "deleted_at", precision: nil, comment: "刪除時間"
    t.text "content", comment: "內容"
    t.text "content_en", comment: "英文內容"
    t.jsonb "translations", default: {}
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["default_category_id"], name: "index_articles_on_default_category_id"
    t.index ["deleted_at"], name: "index_articles_on_deleted_at"
    t.index ["slug"], name: "index_articles_on_slug", unique: true
  end

  create_table "audits", force: :cascade do |t|
    t.integer "auditable_id"
    t.string "auditable_type"
    t.integer "associated_id"
    t.string "associated_type"
    t.integer "user_id"
    t.string "user_type"
    t.string "username"
    t.string "action"
    t.jsonb "audited_changes"
    t.integer "version", default: 0
    t.string "comment"
    t.string "remote_address"
    t.string "request_uuid"
    t.datetime "created_at", precision: nil
    t.index ["associated_type", "associated_id"], name: "associated_index"
    t.index ["auditable_type", "auditable_id", "version"], name: "auditable_index"
    t.index ["created_at"], name: "index_audits_on_created_at"
    t.index ["request_uuid"], name: "index_audits_on_request_uuid"
    t.index ["user_id", "user_type"], name: "user_index"
  end

  create_table "ckeditor_assets", force: :cascade do |t|
    t.string "data_file_name", null: false
    t.string "data_content_type"
    t.integer "data_file_size"
    t.string "data_fingerprint"
    t.string "type", limit: 30
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["type"], name: "index_ckeditor_assets_on_type"
  end

  create_table "contacts", comment: "聯絡表單", force: :cascade do |t|
    t.string "name", null: false, comment: "姓名"
    t.string "email", comment: "電子郵件"
    t.string "phone", null: false, comment: "聯絡電話"
    t.string "company", comment: "公司名稱"
    t.string "address", comment: "聯絡地址"
    t.text "content", comment: "詢問內容"
    t.text "admin_note", comment: "備註"
    t.string "status", default: "new_case", null: false, comment: "狀態"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_contacts_on_email"
    t.index ["name"], name: "index_contacts_on_name"
    t.index ["phone"], name: "index_contacts_on_phone"
  end

  create_table "custom_pages", comment: "頁面管理", force: :cascade do |t|
    t.string "title", comment: "頁面標題"
    t.string "title_en", comment: "英文標題"
    t.string "slug", comment: "slug"
    t.text "content", comment: "內容"
    t.text "content_en", comment: "英文內容"
    t.string "status", default: "published", comment: "狀態"
    t.string "en_status", default: "published", comment: "英文狀態"
    t.boolean "default_page", default: false, comment: "是否為預設頁面"
    t.string "custom_type", default: "info", comment: "頁面類型"
    t.jsonb "translations", default: {}
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["slug"], name: "index_custom_pages_on_slug", unique: true
  end

  create_table "documents", comment: "檔案", force: :cascade do |t|
    t.string "attachable_type"
    t.bigint "attachable_id"
    t.string "title", comment: "標題"
    t.string "slug", comment: "slug"
    t.string "file_type", default: "file", comment: "檔案類型"
    t.string "language", comment: "檔案語系"
    t.string "link", comment: "連結"
    t.jsonb "spec", default: {}, comment: "其他"
    t.integer "position", comment: "排列順序"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["attachable_type", "attachable_id"], name: "index_documents_on_attachable"
    t.index ["slug"], name: "index_documents_on_slug", unique: true
  end

  create_table "download_categories", comment: "檔案分類", force: :cascade do |t|
    t.string "name", comment: "名稱"
    t.string "name_en", comment: "分類名稱"
    t.string "slug", comment: "slug"
    t.string "status", default: "published", null: false, comment: "狀態"
    t.string "en_status", default: "hidden", null: false, comment: "英文狀態"
    t.jsonb "translations", default: {}
    t.integer "position", comment: "排列順序"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["slug"], name: "index_download_categories_on_slug", unique: true
  end

  create_table "downloads", comment: "檔案下載", force: :cascade do |t|
    t.bigint "download_category_id", null: false
    t.string "title", comment: "名稱"
    t.string "title_en", comment: "英文名稱"
    t.string "status", default: "published", null: false, comment: "狀態"
    t.string "en_status", default: "hidden", null: false, comment: "英文狀態"
    t.jsonb "translations", default: {}
    t.integer "position", comment: "排列順序"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["download_category_id"], name: "index_downloads_on_download_category_id"
  end

  create_table "faq_categories", comment: "常見問題分類", force: :cascade do |t|
    t.string "name", comment: "分類名稱"
    t.string "name_en", comment: "英文名稱"
    t.string "slug", comment: "slug"
    t.string "status", default: "published", null: false, comment: "狀態"
    t.string "en_status", default: "hidden", null: false, comment: "英文狀態"
    t.jsonb "translations", default: {}
    t.integer "position", comment: "排列順序"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["slug"], name: "index_faq_categories_on_slug", unique: true
  end

  create_table "faqs", comment: "常見問題", force: :cascade do |t|
    t.bigint "faq_category_id", null: false, comment: "分類"
    t.string "title", comment: "標題"
    t.string "title_en", comment: "英文標題"
    t.string "status", default: "published", null: false, comment: "狀態"
    t.string "en_status", default: "hidden", null: false, comment: "英文狀態"
    t.text "content", comment: "內容"
    t.text "content_en", comment: "英文內容"
    t.jsonb "translations", default: {}
    t.integer "position", comment: "排列順序"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["faq_category_id"], name: "index_faqs_on_faq_category_id"
  end

  create_table "figures", comment: "圖片", force: :cascade do |t|
    t.integer "position", comment: "排列順序"
    t.jsonb "translations", default: {}
    t.string "imageable_type", null: false
    t.bigint "imageable_id", null: false, comment: "對象物件"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["imageable_type", "imageable_id"], name: "index_figures_on_imageable"
  end

  create_table "home_slides", comment: "首頁輪播", force: :cascade do |t|
    t.text "title", comment: "標題"
    t.text "title_en", comment: "英文標題"
    t.datetime "published_at", precision: nil, comment: "發布時間"
    t.datetime "published_at_en", precision: nil, comment: "英文發布時間"
    t.datetime "expired_at", precision: nil, comment: "下架時間"
    t.datetime "expired_at_en", precision: nil, comment: "英文下架時間"
    t.string "slide_type", default: "image", null: false, comment: "輪播類型"
    t.jsonb "translations", default: {}
    t.integer "position", comment: "排列順序"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "menus", comment: "選單管理", force: :cascade do |t|
    t.integer "parent_id", comment: "父節點"
    t.integer "position", null: false, comment: "排序"
    t.string "title", comment: "標題文字"
    t.string "title_en", comment: "英文標題"
    t.string "status", default: "hidden", null: false, comment: "狀態"
    t.string "en_status", default: "hidden", null: false, comment: "英文狀態"
    t.string "link", comment: "連結"
    t.string "link_en", comment: "英文連結"
    t.boolean "target", default: false, null: false, comment: "是否開新視窗"
    t.integer "lft", null: false
    t.integer "rgt", null: false
    t.integer "depth", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["lft"], name: "index_menus_on_lft"
    t.index ["parent_id"], name: "index_menus_on_parent_id"
    t.index ["rgt"], name: "index_menus_on_rgt"
  end

  create_table "milestones", comment: "大事記", force: :cascade do |t|
    t.string "title", comment: "標題"
    t.string "title_en", comment: "英文標題"
    t.date "date", comment: "年月份"
    t.string "status", default: "published", comment: "狀態"
    t.string "en_status", default: "hidden", comment: "英文狀態"
    t.text "content", comment: "內容"
    t.text "content_en", comment: "英文內容"
    t.jsonb "translations", default: {}
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "partners", comment: "合作夥伴", force: :cascade do |t|
    t.string "name", comment: "名稱"
    t.string "name_en", comment: "英文名稱"
    t.string "slug", comment: "slug"
    t.string "status", default: "published", null: false, comment: "狀態"
    t.string "en_status", default: "hidden", null: false, comment: "英文狀態"
    t.integer "position", comment: "排列順序"
    t.jsonb "translations", default: {}
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["slug"], name: "index_partners_on_slug", unique: true
  end

  create_table "redirect_rules", force: :cascade do |t|
    t.string "source_path", comment: "來源路徑"
    t.string "target_path", comment: "目標路徑"
    t.integer "position", comment: "排序"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "roles", force: :cascade do |t|
    t.string "name", null: false, comment: "名稱"
    t.jsonb "permissions", default: {}, comment: "權限設定"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "seos", force: :cascade do |t|
    t.string "seoable_type", null: false
    t.bigint "seoable_id", null: false
    t.string "canonical", comment: "標準網址"
    t.jsonb "translations", default: {}
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["seoable_type", "seoable_id"], name: "index_seos_on_seoable"
  end

  create_table "settings", comment: "全站設定", force: :cascade do |t|
    t.string "name", null: false, comment: "欄位名稱"
    t.string "slug", comment: "slug"
    t.string "category", comment: "類別"
    t.jsonb "translations", default: {}
    t.integer "position", comment: "排列順序"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["slug"], name: "index_settings_on_slug", unique: true
  end

  create_table "taggings", force: :cascade do |t|
    t.bigint "tag_id"
    t.string "taggable_type"
    t.bigint "taggable_id"
    t.string "tagger_type"
    t.bigint "tagger_id"
    t.string "context", limit: 128
    t.datetime "created_at", precision: nil
    t.string "tenant", limit: 128
    t.index ["context"], name: "index_taggings_on_context"
    t.index ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "taggings_idx", unique: true
    t.index ["tag_id"], name: "index_taggings_on_tag_id"
    t.index ["taggable_id", "taggable_type", "context"], name: "taggings_taggable_context_idx"
    t.index ["taggable_id", "taggable_type", "tagger_id", "context"], name: "taggings_idy"
    t.index ["taggable_id"], name: "index_taggings_on_taggable_id"
    t.index ["taggable_type", "taggable_id"], name: "index_taggings_on_taggable_type_and_taggable_id"
    t.index ["taggable_type"], name: "index_taggings_on_taggable_type"
    t.index ["tagger_id", "tagger_type"], name: "index_taggings_on_tagger_id_and_tagger_type"
    t.index ["tagger_id"], name: "index_taggings_on_tagger_id"
    t.index ["tagger_type", "tagger_id"], name: "index_taggings_on_tagger_type_and_tagger_id"
    t.index ["tenant"], name: "index_taggings_on_tenant"
  end

  create_table "tags", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "taggings_count", default: 0
    t.index ["name"], name: "index_tags_on_name", unique: true
  end

  create_table "users", comment: "會員帳號", force: :cascade do |t|
    t.string "email", comment: "帳號"
    t.string "name", comment: "姓名"
    t.string "phone", comment: "電話"
    t.string "role", default: "regular", comment: "會員級別"
    t.boolean "account_active", default: true, comment: "帳號狀態"
    t.string "country", comment: "國家"
    t.string "zip_code", comment: "郵遞區號"
    t.string "city", comment: "縣市"
    t.string "dist", comment: "地區"
    t.string "address", comment: "地址"
    t.string "line_uid", comment: "LINE UID"
    t.string "line_avatar", comment: "LINE 大頭貼"
    t.datetime "line_auth_at", precision: nil, comment: "LINE 註冊日期"
    t.text "note", comment: "備註"
    t.text "admin_note", comment: "後台備註"
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at", precision: nil
    t.string "confirmation_token"
    t.datetime "confirmed_at", precision: nil
    t.datetime "confirmation_sent_at", precision: nil
    t.string "unconfirmed_email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "encrypted_password", default: "", null: false
    t.datetime "remember_created_at", precision: nil
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at", precision: nil
    t.datetime "last_sign_in_at", precision: nil
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.integer "failed_attempts", default: 0, null: false
    t.string "unlock_token"
    t.datetime "locked_at", precision: nil
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["line_uid"], name: "index_users_on_line_uid", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["unlock_token"], name: "index_users_on_unlock_token", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "admins", "roles"
  add_foreign_key "articles", "article_categories", column: "default_category_id"
  add_foreign_key "downloads", "download_categories"
  add_foreign_key "faqs", "faq_categories"
  add_foreign_key "taggings", "tags"
end
