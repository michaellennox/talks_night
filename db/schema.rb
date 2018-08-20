# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2018_08_10_075343) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "citext"
  enable_extension "plpgsql"

  create_table "events", force: :cascade do |t|
    t.bigint "group_id", null: false
    t.datetime "starts_at"
    t.datetime "ends_at"
    t.text "description"
    t.string "title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["group_id"], name: "index_events_on_group_id"
  end

  create_table "groups", force: :cascade do |t|
    t.bigint "owner_id", null: false
    t.string "name", null: false
    t.text "description", null: false
    t.string "url_slug", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_groups_on_name", unique: true
    t.index ["owner_id"], name: "index_groups_on_owner_id"
    t.index ["url_slug"], name: "index_groups_on_url_slug", unique: true
  end

  create_table "talk_suggestions", force: :cascade do |t|
    t.bigint "talk_id", null: false
    t.bigint "group_id", null: false
    t.text "speaker_contact", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["group_id"], name: "index_talk_suggestions_on_group_id"
    t.index ["talk_id"], name: "index_talk_suggestions_on_talk_id"
  end

  create_table "talks", force: :cascade do |t|
    t.string "title", null: false
    t.text "description"
    t.bigint "speaker_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["speaker_id"], name: "index_talks_on_speaker_id"
  end

  create_table "users", force: :cascade do |t|
    t.citext "email", null: false
    t.string "display_name", null: false
    t.string "password_digest", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["display_name"], name: "index_users_on_display_name", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "events", "groups", on_delete: :restrict
  add_foreign_key "groups", "users", column: "owner_id", on_delete: :restrict
  add_foreign_key "talk_suggestions", "groups", on_delete: :restrict
  add_foreign_key "talk_suggestions", "talks", on_delete: :restrict
  add_foreign_key "talks", "users", column: "speaker_id", on_delete: :restrict
end
