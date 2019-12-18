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

ActiveRecord::Schema.define(version: 2019_12_18_070020) do

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

  add_foreign_key "hashtags_post_images", "hashtags"
  add_foreign_key "hashtags_post_images", "post_images"
end
