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

ActiveRecord::Schema[7.0].define(version: 2022_05_23_064234) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "accounts", force: :cascade do |t|
    t.string "public_id"
    t.string "name"
    t.boolean "active"
    t.string "role"
    t.integer "balance", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "auth_identies", force: :cascade do |t|
    t.bigint "account_id", null: false
    t.text "uid"
    t.text "login"
    t.text "token"
    t.text "password_hash"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "provider"
    t.index ["account_id"], name: "index_auth_identies_on_account_id"
  end

  create_table "billing_periods", force: :cascade do |t|
    t.datetime "start_date", null: false
    t.datetime "end_date", null: false
    t.integer "status", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tasks", force: :cascade do |t|
    t.string "public_id", null: false
    t.text "description"
    t.bigint "account_id", null: false
    t.integer "price_assignment", null: false
    t.integer "price_complition", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "jira_id"
    t.index ["account_id"], name: "index_tasks_on_account_id"
  end

  create_table "transactions", force: :cascade do |t|
    t.bigint "account_id", null: false
    t.string "reason", null: false
    t.integer "debit", null: false
    t.integer "credit", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_transactions_on_account_id"
  end

  add_foreign_key "auth_identies", "accounts"
  add_foreign_key "tasks", "accounts"
  add_foreign_key "transactions", "accounts"
end
