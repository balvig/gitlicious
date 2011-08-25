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

ActiveRecord::Schema.define(:version => 20110825011207) do

  create_table "commits", :force => true do |t|
    t.string   "name"
    t.integer  "project_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal  "flog"
    t.integer  "loc"
    t.string   "comment"
    t.integer  "rbp"
    t.string   "sha"
    t.datetime "commited_at"
    t.text     "metrics_log"
    t.string   "parent_sha"
  end

  create_table "projects", :force => true do |t|
    t.string   "name"
    t.string   "repo_path"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
