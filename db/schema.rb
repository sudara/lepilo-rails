# This file is autogenerated. Instead of editing this file, please use the
# migrations feature of ActiveRecord to incrementally modify your database, and
# then regenerate this schema definition.

ActiveRecord::Schema.define(:version => 11) do

  create_table "articles", :force => true do |t|
    t.integer  "thumbnail_id"
    t.boolean  "released"
    t.date     "release_date"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "reference",    :limit => 25
    t.string   "type",         :limit => 25
    t.string   "title",        :limit => 250
    t.text     "description"
  end

  create_table "articles_tags", :id => false, :force => true do |t|
    t.integer "article_id"
    t.integer "tag_id"
  end

  create_table "block_links", :force => true do |t|
    t.integer "linked_id"
    t.string  "linked_type",   :limit => 36
    t.integer "position"
    t.integer "fragment_id"
    t.integer "collection_id"
  end

  create_table "collections", :force => true do |t|
    t.integer  "topic_id"
    t.integer  "thumbnail_id"
    t.boolean  "released"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "title",        :limit => 250
    t.text     "description"
  end

  create_table "fragments", :force => true do |t|
    t.integer  "article_id"
    t.string   "content",     :limit => 64
    t.integer  "position"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "info",        :limit => 250
    t.integer  "fragment_id"
  end

  create_table "mediablocks", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "uploaded_at"
    t.string   "original_name"
    t.string   "content_type",  :limit => 100
    t.string   "filename"
    t.string   "thumbnail"
    t.string   "original"
    t.string   "title"
    t.string   "description"
  end

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :default => "", :null => false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "settings", :force => true do |t|
    t.integer "setting_id",  :default => 0
    t.integer "position"
    t.string  "key"
    t.string  "value"
    t.text    "description"
  end

  create_table "tags", :force => true do |t|
    t.string "name", :limit => 250
  end

  create_table "textblocks", :force => true do |t|
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "title",      :limit => 250
    t.text     "content"
  end

  create_table "topics", :force => true do |t|
    t.integer "topic_id"
    t.integer "position"
    t.string  "title",       :limit => 250
    t.text    "description"
    t.string  "permalink"
    t.integer "article_id"
  end

  create_table "users", :force => true do |t|
    t.datetime "created_at"
    t.string   "login",                     :limit => 80
    t.string   "password",                  :limit => 40
    t.string   "role",                      :limit => 30
    t.string   "name",                      :limit => 150
    t.string   "email",                     :limit => 250
    t.string   "description",               :limit => 250
    t.string   "crypted_password",          :limit => 40
    t.string   "salt",                      :limit => 40
    t.datetime "updated_at"
    t.string   "remember_token"
    t.datetime "remember_token_expires_at"
    t.boolean  "admin"
  end

end
