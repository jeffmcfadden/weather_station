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

ActiveRecord::Schema.define(version: 2018_02_14_195106) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "sensor_observations", force: :cascade do |t|
    t.bigint "sensor_id"
    t.float "value"
    t.datetime "observed_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["sensor_id"], name: "index_sensor_observations_on_sensor_id"
  end

  create_table "sensors", force: :cascade do |t|
    t.string "name"
    t.integer "sensor_type"
    t.float "latest_value"
    t.datetime "latest_value_observed_at"
    t.text "sensor_settings"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "sensor_observations", "sensors"
end
