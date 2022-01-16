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

ActiveRecord::Schema.define(version: 2022_01_16_105955) do

  create_table "bookings", force: :cascade do |t|
    t.integer "zone_id", null: false
    t.integer "traveler_id", null: false
    t.integer "origin_id", null: false
    t.integer "destination_id", null: false
    t.datetime "pickup_scheduled_at"
    t.datetime "dropoff_scheduled_at"
    t.decimal "price", null: false
    t.string "payment_method", default: "cash", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "locations", force: :cascade do |t|
    t.integer "zone_id", null: false
    t.string "name", null: false
    t.decimal "latitude", null: false
    t.decimal "longitude", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "travelers", force: :cascade do |t|
    t.string "first_name", null: false
    t.string "last_name", null: false
    t.string "email", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "registering_app", default: "bridj", null: false
  end

  create_table "zones", force: :cascade do |t|
    t.string "name", null: false
    t.string "time_zone", default: "Australia/Brisbane", null: false
    t.string "currency", default: "AUD", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
