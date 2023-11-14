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

ActiveRecord::Schema.define(version: 2023_11_14_144549) do

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
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "clauses", force: :cascade do |t|
    t.text "content"
    t.string "title"
    t.bigint "user_id"
    t.bigint "project_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["project_id"], name: "index_clauses_on_project_id"
    t.index ["user_id"], name: "index_clauses_on_user_id"
  end

  create_table "comments", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "project_id", null: false
    t.integer "parent_comment_id"
    t.text "content"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["project_id"], name: "index_comments_on_project_id"
    t.index ["user_id"], name: "index_comments_on_user_id"
  end

  create_table "compaigns", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "contracts", force: :cascade do |t|
    t.bigint "project_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["project_id"], name: "index_contracts_on_project_id"
  end

  create_table "documents", force: :cascade do |t|
    t.bigint "project_id"
    t.bigint "user_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["project_id"], name: "index_documents_on_project_id"
    t.index ["user_id"], name: "index_documents_on_user_id"
  end

  create_table "file_managers", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "folder_invitees", force: :cascade do |t|
    t.bigint "folder_id", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["folder_id"], name: "index_folder_invitees_on_folder_id"
    t.index ["user_id"], name: "index_folder_invitees_on_user_id"
  end

  create_table "folders", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.text "name"
    t.string "slug"
    t.integer "parent_folder_id"
    t.bigint "user_id"
    t.index ["parent_folder_id"], name: "index_folders_on_parent_folder_id"
    t.index ["user_id"], name: "index_folders_on_user_id"
  end

  create_table "notifications", force: :cascade do |t|
    t.string "notification_type"
    t.string "text"
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.datetime "date"
    t.index ["user_id"], name: "index_notifications_on_user_id"
  end

  create_table "projects", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "name"
    t.string "project_type"
    t.text "description"
    t.datetime "date"
    t.string "notifications"
    t.string "status"
    t.bigint "folder_id"
    t.bigint "created_by_id"
    t.index ["created_by_id"], name: "index_projects_on_created_by_id"
    t.index ["folder_id"], name: "index_projects_on_folder_id"
  end

  create_table "sections", force: :cascade do |t|
    t.text "comment"
    t.text "description"
    t.bigint "user_id"
    t.bigint "document_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["document_id"], name: "index_sections_on_document_id"
    t.index ["user_id"], name: "index_sections_on_user_id"
  end

  create_table "suggests", force: :cascade do |t|
    t.string "suggest_type"
    t.integer "notify", default: -1
    t.string "status"
    t.string "priority"
    t.string "comment"
    t.integer "user_id"
    t.boolean "accepted"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "clause_id", null: false
    t.index ["clause_id"], name: "index_suggests_on_clause_id"
  end

  create_table "teams", force: :cascade do |t|
    t.string "role"
    t.bigint "project_id", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "user_role"
    t.index ["project_id"], name: "index_teams_on_project_id"
    t.index ["user_id"], name: "index_teams_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "first_name"
    t.string "last_name"
    t.boolean "subscription", default: false
    t.string "user_role"
    t.string "language", default: "English"
    t.string "address_line_1", default: ""
    t.string "address_line_2", default: ""
    t.string "town", default: ""
    t.string "country", default: "United States"
    t.string "state", default: ""
    t.string "postal_code", default: ""
    t.datetime "last_login"
    t.boolean "subscription_update", default: false
    t.boolean "project_update", default: false
    t.boolean "pending_actions", default: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "comments", "projects"
  add_foreign_key "comments", "users"
  add_foreign_key "contracts", "projects"
  add_foreign_key "documents", "projects"
  add_foreign_key "documents", "users"
  add_foreign_key "folder_invitees", "folders"
  add_foreign_key "folder_invitees", "users"
  add_foreign_key "folders", "users"
  add_foreign_key "notifications", "users"
  add_foreign_key "projects", "folders"
  add_foreign_key "projects", "users", column: "created_by_id"
  add_foreign_key "sections", "documents"
  add_foreign_key "sections", "users"
  add_foreign_key "suggests", "clauses"
  add_foreign_key "teams", "projects"
  add_foreign_key "teams", "users"
end
