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

ActiveRecord::Schema.define(version: 2019_11_13_064828) do

  create_table "end_users", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.string "email"
    t.string "name"
    t.string "profile_name"
    t.string "profile_image_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "favorites", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.integer "end_user_id"
    t.integer "post_image_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "hashtags", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.string "hashname"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["hashname"], name: "index_hashtags_on_hashname", unique: true
  end

  create_table "hashtags_post_images", id: false, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.bigint "post_image_id"
    t.bigint "hashtag_id"
    t.index ["hashtag_id"], name: "index_hashtags_post_images_on_hashtag_id"
    t.index ["post_image_id"], name: "index_hashtags_post_images_on_post_image_id"
  end

  create_table "notifications", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.integer "visitor_id", null: false
    t.integer "visited_id", null: false
    t.integer "post_image_id"
    t.integer "post_comment_id"
    t.string "action", null: false
    t.boolean "checked", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["post_comment_id"], name: "index_notifications_on_post_comment_id"
    t.index ["post_image_id"], name: "index_notifications_on_post_image_id"
    t.index ["visited_id"], name: "index_notifications_on_visited_id"
    t.index ["visitor_id"], name: "index_notifications_on_visitor_id"
  end

  create_table "post_comments", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.text "comment"
    t.integer "post_image_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "end_user_id"
  end

  create_table "post_comments_users", id: false, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.bigint "post_comment_id"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["post_comment_id"], name: "index_post_comments_users_on_post_comment_id"
    t.index ["user_id"], name: "index_post_comments_users_on_user_id"
  end

  create_table "post_images", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.text "caption"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "favorites_count"
    t.string "image_name"
    t.integer "end_user_id"
    t.string "title"
  end

  create_table "relationships", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.integer "following_id"
    t.integer "follower_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.string "name"
    t.string "profile_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "profile_image_id"
    t.text "introduction"
    t.string "uid"
    t.string "provider"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["profile_name"], name: "index_users_on_profile_name", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "hashtags_post_images", "hashtags"
  add_foreign_key "hashtags_post_images", "post_images"
  add_foreign_key "post_comments_users", "post_comments"
  add_foreign_key "post_comments_users", "users"
end
