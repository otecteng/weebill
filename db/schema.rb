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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20140624143159) do

  create_table "brands", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.string   "avatar"
    t.integer  "producer_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "producers", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.string   "avatar"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "service_orders", :force => true do |t|
    t.string   "cname"
    t.string   "cmobile"
    t.integer  "site_id"
    t.integer  "tb_trade_id"
    t.string   "status"
    t.float    "price"
    t.string   "site_pix"
    t.integer  "site_worker_id"
    t.integer  "user_id"
    t.string   "uid"
    t.string   "alipay_id"
    t.string   "alipay_pix"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
    t.datetime "time_service"
    t.string   "memo"
    t.datetime "time_pay"
  end

  create_table "site_sessions", :force => true do |t|
    t.integer  "status"
    t.integer  "site_worker_id"
    t.string   "pix"
    t.string   "uid"
    t.string   "state"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  create_table "site_workers", :force => true do |t|
    t.string   "wid"
    t.string   "wuid"
    t.string   "nickname"
    t.string   "name"
    t.string   "phone"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
    t.integer  "site_id"
    t.string   "state"
    t.string   "picture_uploaded"
  end

  create_table "sites", :force => true do |t|
    t.string   "name"
    t.string   "address"
    t.string   "contactor"
    t.string   "location"
    t.string   "province"
    t.string   "city"
    t.string   "county"
    t.string   "star"
    t.integer  "cert"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
    t.string   "alipay_account"
    t.string   "caifu_account"
    t.string   "phone"
    t.integer  "user_id"
  end

  create_table "sms_logs", :force => true do |t|
    t.integer  "user_id"
    t.string   "message"
    t.integer  "amount"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "recv"
    t.string   "status"
  end

  create_table "sms_templates", :force => true do |t|
    t.string   "title"
    t.string   "sms_type"
    t.text     "content"
    t.string   "signature"
    t.integer  "user_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "tb_customers", :force => true do |t|
    t.string   "name"
    t.string   "mobile"
    t.string   "province"
    t.string   "city"
    t.string   "county"
    t.string   "nickname"
    t.boolean  "blacklist"
    t.string   "wid"
    t.string   "wuid"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "tb_trades", :force => true do |t|
    t.integer  "tid",              :limit => 8
    t.string   "num_iid"
    t.integer  "tb_customer_id"
    t.string   "title"
    t.string   "price"
    t.string   "status"
    t.text     "memo"
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
    t.datetime "time_trade"
    t.string   "cname"
    t.string   "cmobile"
    t.string   "cadddress"
    t.integer  "service_order_id"
    t.integer  "user_id"
    t.string   "province"
    t.string   "city"
    t.string   "county"
  end

  create_table "users", :force => true do |t|
    t.string   "name"
    t.string   "username"
    t.string   "password"
    t.string   "phone"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0,  :null => false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "mail_account"
    t.string   "mail_password"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

  create_table "wx_templates", :force => true do |t|
    t.string   "name"
    t.string   "menu_id"
    t.string   "ret_type"
    t.text     "ret_content"
    t.integer  "user_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

end
