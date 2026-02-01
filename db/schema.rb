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

ActiveRecord::Schema[7.2].define(version: 2026_02_01_164028) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "members", force: :cascade do |t|
    t.string "name"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "placements", force: :cascade do |t|
    t.bigint "schedule_id", null: false
    t.bigint "member_id", null: false
    t.integer "position_order"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["member_id"], name: "index_placements_on_member_id"
    t.index ["schedule_id"], name: "index_placements_on_schedule_id"
  end

  create_table "schedules", force: :cascade do |t|
    t.date "date"
    t.bigint "site_id", null: false
    t.text "memo"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["site_id"], name: "index_schedules_on_site_id"
  end

  create_table "sites", force: :cascade do |t|
    t.string "name"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "vehicle_assignments", force: :cascade do |t|
    t.bigint "schedule_id", null: false
    t.bigint "vehicle_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["schedule_id"], name: "index_vehicle_assignments_on_schedule_id"
    t.index ["vehicle_id"], name: "index_vehicle_assignments_on_vehicle_id"
  end

  create_table "vehicles", force: :cascade do |t|
    t.string "name"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "placements", "members"
  add_foreign_key "placements", "schedules"
  add_foreign_key "schedules", "sites"
  add_foreign_key "vehicle_assignments", "schedules"
  add_foreign_key "vehicle_assignments", "vehicles"
end
