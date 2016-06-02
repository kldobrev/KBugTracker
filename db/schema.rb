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

ActiveRecord::Schema.define(version: 20160518195551) do

  create_table "comments", force: :cascade do |t|
    t.integer  "defect_id"
    t.integer  "user_id"
    t.string   "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "defects", force: :cascade do |t|
    t.integer  "project_id"
    t.integer  "raised_by_id"
    t.integer  "assigned_to_id"
    t.integer  "to_group_id"
    t.string   "title"
    t.string   "description"
    t.integer  "status"
    t.integer  "importance"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  add_index "defects", ["assigned_to_id"], name: "index_defects_on_assigned_to_id"
  add_index "defects", ["project_id"], name: "index_defects_on_project_id"
  add_index "defects", ["raised_by_id"], name: "index_defects_on_raised_by_id"
  add_index "defects", ["to_group_id"], name: "index_defects_on_to_group_id"

  create_table "group_members", id: false, force: :cascade do |t|
    t.integer  "group_id"
    t.integer  "member_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "group_members", ["group_id"], name: "index_group_members_on_group_id"
  add_index "group_members", ["member_id"], name: "index_group_members_on_member_id"

  create_table "groups", force: :cascade do |t|
    t.integer  "project_id"
    t.string   "name"
    t.integer  "administrative"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  create_table "members", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "project_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "projects", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "title",       null: false
    t.string   "description"
    t.integer  "prtype",      null: false
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "projects_tags", id: false, force: :cascade do |t|
    t.integer "project_id"
    t.integer "tag_id"
  end

  create_table "requests", force: :cascade do |t|
    t.integer "from_usr_id"
    t.integer "to_usr_id"
    t.integer "proj_id"
    t.integer "req_type"
  end

  create_table "tags", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "username",        null: false
    t.string   "email",           null: false
    t.string   "password_digest", null: false
    t.string   "firstname"
    t.string   "lastname"
    t.integer  "acctype",         null: false
    t.integer  "is_pr_creator",   null: false
    t.string   "act_code"
    t.string   "ch_pass_code"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

end
