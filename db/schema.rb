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

ActiveRecord::Schema.define(version: 20160304212950) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "blueprint_items", force: :cascade do |t|
    t.integer  "quantity"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.integer  "blueprint_id"
    t.integer  "item_id"
    t.integer  "product_type_id"
  end

  add_index "blueprint_items", ["blueprint_id"], name: "index_blueprint_items_on_blueprint_id", using: :btree
  add_index "blueprint_items", ["item_id"], name: "index_blueprint_items_on_item_id", using: :btree

  create_table "blueprints", force: :cascade do |t|
    t.integer  "type_id"
    t.integer  "product_type_id"
    t.string   "name"
    t.integer  "production_time"
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
    t.text     "keywords"
    t.integer  "product_type_quantity"
  end

  create_table "items", force: :cascade do |t|
    t.integer  "type_id"
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "news", force: :cascade do |t|
    t.string   "title"
    t.text     "body"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "blueprint_items", "blueprints"
  add_foreign_key "blueprint_items", "items"
end
