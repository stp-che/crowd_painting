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

ActiveRecord::Schema[7.1].define(version: 2023_12_02_220453) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "paintings", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "title"
    t.integer "width", limit: 2, null: false
    t.integer "height", limit: 2, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_paintings_on_user_id"
  end

  create_table "pixel_changes", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "painting_id", null: false
    t.integer "row", limit: 2, null: false
    t.integer "col", limit: 2, null: false
    t.binary "color", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["painting_id", "created_at"], name: "index_pixel_changes_on_painting_id_and_created_at"
    t.index ["user_id"], name: "index_pixel_changes_on_user_id"
  end

  create_table "pixels", force: :cascade do |t|
    t.bigint "painting_id", null: false
    t.integer "row", limit: 2, null: false
    t.integer "col", limit: 2, null: false
    t.binary "color", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["painting_id", "row", "col"], name: "index_pixels_on_painting_id_and_row_and_col", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

end
