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

ActiveRecord::Schema.define(version: 2021_07_05_072859) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "group_mission_sheets", force: :cascade do |t|
    t.bigint "group_id", null: false
    t.bigint "mission_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["group_id"], name: "index_group_mission_sheets_on_group_id"
    t.index ["mission_id"], name: "index_group_mission_sheets_on_mission_id"
  end

  create_table "groups", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.text "description"
    t.bigint "user_id"
    t.integer "privacy"
    t.string "code"
    t.index ["user_id"], name: "index_groups_on_user_id"
  end

  create_table "memberships", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "group_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["group_id"], name: "index_memberships_on_group_id"
    t.index ["user_id"], name: "index_memberships_on_user_id"
  end

  create_table "missions", force: :cascade do |t|
    t.string "title", null: false
    t.datetime "start_at", null: false
    t.datetime "end_at", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "priority"
    t.text "content", null: false
    t.integer "status"
    t.bigint "user_id"
    t.string "file"
    t.index ["status"], name: "index_missions_on_status"
    t.index ["title"], name: "index_missions_on_title"
    t.index ["user_id"], name: "index_missions_on_user_id"
  end

  create_table "sharings", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "mission_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["mission_id"], name: "index_sharings_on_mission_id"
    t.index ["user_id"], name: "index_sharings_on_user_id"
  end

  create_table "taggings", force: :cascade do |t|
    t.bigint "tag_id", null: false
    t.bigint "mission_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["mission_id"], name: "index_taggings_on_mission_id"
    t.index ["tag_id"], name: "index_taggings_on_tag_id"
  end

  create_table "tags", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email"
    t.string "password"
    t.string "role"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "avatar"
  end

  add_foreign_key "group_mission_sheets", "groups"
  add_foreign_key "group_mission_sheets", "missions"
  add_foreign_key "groups", "users"
  add_foreign_key "memberships", "groups"
  add_foreign_key "memberships", "users"
  add_foreign_key "missions", "users", on_delete: :cascade
  add_foreign_key "sharings", "missions"
  add_foreign_key "sharings", "users"
  add_foreign_key "taggings", "missions"
  add_foreign_key "taggings", "tags"
end
