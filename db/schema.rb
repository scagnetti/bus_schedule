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

ActiveRecord::Schema.define(version: 20160624140844) do

  create_table "bus_lines", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "active",     default: true
  end

  create_table "bus_stops", force: :cascade do |t|
    t.string   "display_name"
    t.string   "search_name"
    t.integer  "direction_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "bus_stops", ["direction_id"], name: "index_bus_stops_on_direction_id"

  create_table "departures", force: :cascade do |t|
    t.integer  "day_type"
    t.integer  "hour"
    t.integer  "minute"
    t.integer  "bus_stop_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "lock_version"
  end

  add_index "departures", ["bus_stop_id"], name: "index_departures_on_bus_stop_id"

  create_table "directions", force: :cascade do |t|
    t.string   "display_name"
    t.string   "search_name"
    t.integer  "bus_line_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "directions", ["bus_line_id"], name: "index_directions_on_bus_line_id"

  create_table "users", force: :cascade do |t|
    t.string   "email"
    t.string   "password_digest"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
