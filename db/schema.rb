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

ActiveRecord::Schema[7.0].define(version: 2023_01_24_120707) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "citext"
  enable_extension "plpgsql"

  create_table "account_login_change_keys", force: :cascade do |t|
    t.string "key", null: false
    t.string "login", null: false
    t.datetime "deadline", null: false
  end

  create_table "account_password_reset_keys", force: :cascade do |t|
    t.string "key", null: false
    t.datetime "deadline", null: false
    t.datetime "email_last_sent", default: -> { "CURRENT_TIMESTAMP" }, null: false
  end

  create_table "account_verification_keys", force: :cascade do |t|
    t.string "key", null: false
    t.datetime "requested_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "email_last_sent", default: -> { "CURRENT_TIMESTAMP" }, null: false
  end

  create_table "accounts", force: :cascade do |t|
    t.integer "status", default: 1, null: false
    t.citext "email", null: false
    t.string "password_hash"
    t.string "username"
    t.index ["email"], name: "index_accounts_on_email", unique: true, where: "(status = ANY (ARRAY[1, 2]))"
  end

  create_table "comments", force: :cascade do |t|
    t.string "body"
    t.bigint "account_id"
    t.string "commentable_type"
    t.bigint "commentable_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_comments_on_account_id"
    t.index ["commentable_type", "commentable_id"], name: "index_comments_on_commentable"
  end

  create_table "communities", force: :cascade do |t|
    t.string "sub_dir"
    t.string "title"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "memberships_count"
    t.index ["sub_dir"], name: "index_communities_on_sub_dir", unique: true
  end

  create_table "memberships", force: :cascade do |t|
    t.bigint "account_id"
    t.bigint "community_id"
    t.integer "role", default: 1
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_memberships_on_account_id"
    t.index ["community_id"], name: "index_memberships_on_community_id"
  end

  create_table "posts", force: :cascade do |t|
    t.string "title"
    t.text "body"
    t.bigint "account_id", null: false
    t.bigint "community_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_posts_on_account_id"
    t.index ["community_id"], name: "index_posts_on_community_id"
  end

  create_table "votes", force: :cascade do |t|
    t.integer "vote"
    t.bigint "account_id", null: false
    t.string "votable_type"
    t.bigint "votable_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_votes_on_account_id"
    t.index ["votable_type", "votable_id"], name: "index_votes_on_votable"
  end

  add_foreign_key "account_login_change_keys", "accounts", column: "id"
  add_foreign_key "account_password_reset_keys", "accounts", column: "id"
  add_foreign_key "account_verification_keys", "accounts", column: "id"
  add_foreign_key "posts", "accounts"
  add_foreign_key "posts", "communities"
  add_foreign_key "votes", "accounts"
end
