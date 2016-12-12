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

ActiveRecord::Schema.define(version: 20161212150310) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "comments", force: :cascade do |t|
    t.string   "author"
    t.string   "author_flair_css_class"
    t.string   "author_flair_text"
    t.text     "body"
    t.text     "body_html"
    t.datetime "created_utc"
    t.string   "comment_id"
    t.string   "link_author"
    t.datetime "link_created_utc"
    t.string   "link_domain"
    t.string   "link_id"
    t.integer  "link_num_comments"
    t.boolean  "link_over_18"
    t.string   "link_permalink"
    t.string   "link_title"
    t.string   "parent_id"
    t.boolean  "stickied"
    t.string   "subreddit"
    t.string   "subreddit_id"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.string   "url"
  end

  create_table "mentions", force: :cascade do |t|
    t.integer  "product_id"
    t.integer  "comment_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "mentions", ["comment_id"], name: "index_mentions_on_comment_id", using: :btree
  add_index "mentions", ["product_id"], name: "index_mentions_on_product_id", using: :btree

  create_table "products", force: :cascade do |t|
    t.string   "title"
    t.string   "offer_url"
    t.integer  "price_in_cents"
    t.string   "asin"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.string   "brand"
    t.string   "display_size"
    t.jsonb    "amazon_api_data"
    t.integer  "ram"
  end

  create_table "specifications", force: :cascade do |t|
    t.string   "brand"
    t.float    "display_size"
    t.integer  "product_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_index "specifications", ["product_id"], name: "index_specifications_on_product_id", using: :btree

  add_foreign_key "mentions", "comments"
  add_foreign_key "mentions", "products"
end
