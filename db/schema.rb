# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20160606184815) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "divisions", force: :cascade do |t|
    t.string   "name",       null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "events", force: :cascade do |t|
    t.string   "name",         null: false
    t.text     "description",  null: false
    t.string   "location",     null: false
    t.datetime "starts_at",    null: false
    t.integer  "organizer_id", null: false
    t.integer  "region_id",    null: false
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_index "events", ["organizer_id"], name: "index_events_on_organizer_id", using: :btree
  add_index "events", ["region_id"], name: "index_events_on_region_id", using: :btree

  create_table "regions", force: :cascade do |t|
    t.string   "name",       null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "seasons", force: :cascade do |t|
    t.string   "year",       null: false
    t.datetime "starts_at",  null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "submissions", force: :cascade do |t|
    t.integer  "team_id"
    t.text     "description"
    t.string   "code"
    t.string   "pitch"
    t.string   "demo"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "submissions", ["team_id"], name: "index_submissions_on_team_id", using: :btree

  create_table "teams", force: :cascade do |t|
    t.string   "name",        null: false
    t.text     "description", null: false
    t.integer  "season_id",   null: false
    t.integer  "division_id", null: false
    t.integer  "region_id",   null: false
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "teams", ["division_id"], name: "index_teams_on_division_id", using: :btree
  add_index "teams", ["region_id"], name: "index_teams_on_region_id", using: :btree
  add_index "teams", ["season_id"], name: "index_teams_on_season_id", using: :btree

  add_foreign_key "events", "regions"
  add_foreign_key "submissions", "teams"
  add_foreign_key "teams", "divisions"
  add_foreign_key "teams", "regions"
  add_foreign_key "teams", "seasons"
end
