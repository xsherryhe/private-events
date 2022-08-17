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

ActiveRecord::Schema[7.0].define(version: 2022_08_16_204157) do
  create_table "event_registrations", force: :cascade do |t|
    t.integer "attendee_id", null: false
    t.integer "attended_event_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "notes"
    t.index ["attended_event_id"], name: "index_event_registrations_on_attended_event_id"
    t.index ["attendee_id", "attended_event_id"], name: "index_event_registrations_on_attendee_id_and_attended_event_id", unique: true
    t.index ["attendee_id"], name: "index_event_registrations_on_attendee_id"
  end

  create_table "events", force: :cascade do |t|
    t.string "name"
    t.string "location"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "description"
    t.integer "creator_id", null: false
    t.date "happening_date"
    t.time "happening_time"
    t.integer "privacy_status"
    t.datetime "happening_at"
    t.index ["creator_id"], name: "index_events_on_creator_id"
  end

  create_table "invitations", force: :cascade do |t|
    t.text "notes"
    t.integer "invitee_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "invited_event_id", null: false
    t.integer "response"
    t.datetime "viewed_at"
    t.index ["invited_event_id"], name: "index_invitations_on_invited_event_id"
    t.index ["invitee_id", "invited_event_id"], name: "index_invitations_on_invitee_id_and_invited_event_id", unique: true
    t.index ["invitee_id"], name: "index_invitations_on_invitee_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "username", default: "", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["username"], name: "index_users_on_username", unique: true
  end

  add_foreign_key "event_registrations", "events", column: "attended_event_id"
  add_foreign_key "event_registrations", "users", column: "attendee_id"
  add_foreign_key "events", "users", column: "creator_id"
  add_foreign_key "invitations", "events", column: "invited_event_id"
  add_foreign_key "invitations", "users", column: "invitee_id"
end
