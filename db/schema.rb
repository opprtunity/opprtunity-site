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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130224183924) do

  create_table "industries", :force => true do |t|
    t.integer "code"
    t.string  "groups",      :array => true
    t.string  "description"
  end

  add_index "industries", ["code"], :name => "index_industries_on_code"
  add_index "industries", ["description"], :name => "index_industries_on_description"
  add_index "industries", ["groups"], :name => "index_industries_on_groups"

  create_table "matches", :force => true do |t|
    t.integer  "user_id"
    t.integer  "target_id"
    t.integer  "score"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "matches", ["user_id"], :name => "index_matches_on_user_id"

  create_table "meetings", :force => true do |t|
    t.integer  "rating"
    t.datetime "date"
    t.string   "medium"
    t.integer  "user_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "needs", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "needs_users", :id => false, :force => true do |t|
    t.integer "need_id"
    t.integer "user_id"
  end

  add_index "needs_users", ["need_id", "user_id"], :name => "index_needs_users_on_need_id_and_user_id"
  add_index "needs_users", ["user_id", "need_id"], :name => "index_needs_users_on_user_id_and_need_id"

  create_table "offerings", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "offerings_users", :id => false, :force => true do |t|
    t.integer "offering_id"
    t.integer "user_id"
  end

  add_index "offerings_users", ["offering_id", "user_id"], :name => "index_offerings_users_on_offering_id_and_user_id"
  add_index "offerings_users", ["user_id", "offering_id"], :name => "index_offerings_users_on_user_id_and_offering_id"

  create_table "users", :force => true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.string   "zip_code"
    t.string   "company_name"
    t.string   "google_plus"
    t.string   "skype"
    t.string   "phone"
    t.text     "about"
    t.string   "linked_in"
    t.string   "company_url"
    t.integer  "parent_id"
    t.boolean  "registered",   :default => false
    t.string   "ip"
    t.string   "uid"
    t.string   "provider"
    t.string   "token"
    t.string   "secret"
    t.float    "latitude"
    t.float    "longitude"
    t.datetime "created_at",                      :null => false
    t.datetime "updated_at",                      :null => false
  end

  add_index "users", ["uid"], :name => "index_users_on_uid"

end
