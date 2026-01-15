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

ActiveRecord::Schema[8.1].define(version: 2025_12_18_224313) do
  create_table "entries", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "feed_id", null: false
    t.string "image_url"
    t.datetime "liked_at"
    t.datetime "published_at"
    t.datetime "read_at"
    t.text "summary"
    t.string "title"
    t.datetime "updated_at", null: false
    t.string "url"
    t.index ["feed_id"], name: "index_entries_on_feed_id"
  end

  create_table "feeds", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "description"
    t.string "image_url"
    t.string "rss_url"
    t.string "title"
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.index ["user_id"], name: "index_feeds_on_user_id"
  end

  create_table "sessions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "ip_address"
    t.datetime "updated_at", null: false
    t.string "user_agent"
    t.integer "user_id", null: false
    t.index ["user_id"], name: "index_sessions_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email_address"
    t.boolean "guest", default: false, null: false
    t.integer "oauth_provider"
    t.string "oauth_uid"
    t.string "password_digest"
    t.datetime "updated_at", null: false
    t.index ["email_address"], name: "index_users_on_email_address", unique: true, where: "email_address IS NOT NULL"
    t.index ["oauth_provider", "oauth_uid"], name: "index_users_on_oauth_provider_and_oauth_uid", unique: true, where: "oauth_provider IS NOT NULL AND oauth_uid IS NOT NULL"
  end

  add_foreign_key "entries", "feeds"
  add_foreign_key "feeds", "users"
  add_foreign_key "sessions", "users"
end
