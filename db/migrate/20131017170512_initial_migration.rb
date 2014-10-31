class InitialMigration < ActiveRecord::Migration
  def change
    create_table "allocation_course_to_exams", force: true do |t|
      t.integer  "course_id"
      t.integer  "exam_id"
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    create_table "allocation_course_to_groups", force: true do |t|
      t.integer  "course_id"
      t.integer  "group_id"
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    create_table "allocation_lesson_to_courses", force: true do |t|
      t.integer  "course_id"
      t.integer  "lesson_id"
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    add_index "allocation_lesson_to_courses", ["course_id"], name: "index_allocation_lesson_to_courses_on_course_id", using: :btree
    add_index "allocation_lesson_to_courses", ["lesson_id"], name: "index_allocation_lesson_to_courses_on_lesson_id", using: :btree

    create_table "allocation_user_to_groups", force: true do |t|
      t.integer  "user_id"
      t.integer  "group_id"
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    create_table "answers", force: true do |t|
      t.integer  "question_id"
      t.string   "text"
      t.boolean  "correct"
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    create_table "courses", force: true do |t|
      t.text    "description"
      t.string  "title"
      t.boolean "pseudo"
    end

    add_index "courses", ["title"], name: "index_courses_on_title", using: :btree

    create_table "exam_sittings", force: true do |t|
      t.integer  "exam_id"
      t.integer  "user_id"
      t.integer  "score"
      t.integer  "max_score"
      t.boolean  "completed"
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    create_table "exams", force: true do |t|
      t.string   "title"
      t.text     "description"
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    create_table "external_links", force: true do |t|
      t.text     "url"
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    add_index "external_links", ["url"], name: "index_external_links_on_url", using: :btree

    create_table "groups", force: true do |t|
      t.string   "name"
      t.string   "description"
      t.boolean  "public"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.boolean  "pseudo"
    end

    create_table "guesses", force: true do |t|
      t.integer  "question_response_id"
      t.integer  "answer_id"
      t.boolean  "correct"
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    add_index "guesses", ["answer_id"], name: "index_guesses_on_answer_id", using: :btree
    add_index "guesses", ["correct"], name: "index_guesses_on_correct", using: :btree
    add_index "guesses", ["question_response_id"], name: "index_guesses_on_question_response_id", using: :btree

    create_table "lessons", force: true do |t|
      t.string   "title"
      t.text     "description"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.string   "external_resource_url"
      t.string   "token"
    end

    add_index "lessons", ["title"], name: "index_lessons_on_title", using: :btree

    create_table "question_responses", force: true do |t|
      t.integer  "exam_sitting_id"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.integer  "score"
      t.integer  "max_score"
      t.integer  "guesses_count",   default: 0
      t.integer  "question_id"
    end

    create_table "questions", force: true do |t|
      t.integer  "exam_id"
      t.string   "question_text"
      t.string   "tag_line"
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    create_table "rates", force: true do |t|
      t.integer  "rater_id"
      t.integer  "rateable_id"
      t.string   "rateable_type"
      t.float    "stars",         null: false
      t.string   "dimension"
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    add_index "rates", ["rateable_id", "rateable_type"], name: "index_rates_on_rateable_id_and_rateable_type", using: :btree
    add_index "rates", ["rater_id"], name: "index_rates_on_rater_id", using: :btree

    create_table "rating_caches", force: true do |t|
      t.integer  "cacheable_id"
      t.string   "cacheable_type"
      t.float    "avg",            null: false
      t.integer  "qty",            null: false
      t.string   "dimension"
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    add_index "rating_caches", ["cacheable_id", "cacheable_type"], name: "index_rating_caches_on_cacheable_id_and_cacheable_type", using: :btree

    create_table "resource_files", force: true do |t|
      t.integer  "lesson_id"
      t.string   "lesson_token"
      t.string   "resource_file"
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    create_table "roles", force: true do |t|
      t.string   "name"
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    create_table "taggings", force: true do |t|
      t.integer  "tag_id"
      t.integer  "taggable_id"
      t.string   "taggable_type"
      t.integer  "tagger_id"
      t.string   "tagger_type"
      t.string   "context",       limit: 128
      t.datetime "created_at"
    end

    add_index "taggings", ["tag_id"], name: "index_taggings_on_tag_id", using: :btree
    add_index "taggings", ["taggable_id", "taggable_type", "context"], name: "index_taggings_on_taggable_id_and_taggable_type_and_context", using: :btree

    create_table "tags", force: true do |t|
      t.string "name"
    end

    create_table "user_interests", force: true do |t|
      t.integer  "user_id"
      t.integer  "tag_id"
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    create_table "user_links", force: true do |t|
      t.string   "link_type"
      t.string   "url"
      t.integer  "user_id"
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    add_index "user_links", ["url"], name: "index_user_links_on_url", using: :btree
    add_index "user_links", ["user_id"], name: "index_user_links_on_user_id", using: :btree

    create_table "user_phone_numbers", force: true do |t|
      t.string   "phone_number_type"
      t.string   "number"
      t.integer  "user_id"
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    add_index "user_phone_numbers", ["number"], name: "index_user_phone_numbers_on_number", using: :btree
    add_index "user_phone_numbers", ["user_id"], name: "index_user_phone_numbers_on_user_id", using: :btree

    create_table "user_roles", force: true do |t|
      t.string   "name"
      t.integer  "role_id"
      t.integer  "user_id"
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    add_index "user_roles", ["role_id"], name: "index_user_roles_on_role_id", using: :btree
    add_index "user_roles", ["user_id"], name: "index_user_roles_on_user_id", using: :btree

    create_table "users", force: true do |t|
      t.string   "email",                  default: "", null: false
      t.string   "encrypted_password",     default: "", null: false
      t.string   "reset_password_token"
      t.datetime "reset_password_sent_at"
      t.datetime "remember_created_at"
      t.integer  "sign_in_count",          default: 0,  null: false
      t.datetime "current_sign_in_at"
      t.datetime "last_sign_in_at"
      t.string   "current_sign_in_ip"
      t.string   "last_sign_in_ip"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.text     "bio"
      t.text     "phone_numbers"
      t.text     "links"
      t.string   "job_title"
      t.string   "avatar_image"
      t.string   "name"
    end

    add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
    add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  end
end
