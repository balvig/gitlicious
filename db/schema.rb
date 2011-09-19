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

ActiveRecord::Schema.define(:version => 20110919123826) do

  create_table "authors", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "metrics", :force => true do |t|
    t.string   "name"
    t.string   "command"
    t.string   "score_pattern"
    t.string   "line_number_pattern"
    t.string   "filename_pattern"
    t.string   "description_pattern"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal  "weight",              :default => 1.0
    t.integer  "project_id"
  end

  create_table "problems", :force => true do |t|
    t.integer  "author_id"
    t.integer  "line_number"
    t.string   "filename"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "metric_type"
    t.integer  "result_id"
  end

  create_table "projects", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "repo_url"
  end

  create_table "reports", :force => true do |t|
    t.string   "name"
    t.integer  "project_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "sha"
  end

  create_table "results", :force => true do |t|
    t.integer  "report_id"
    t.integer  "metric_id"
    t.text     "log"
    t.decimal  "score",      :default => 0.0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
