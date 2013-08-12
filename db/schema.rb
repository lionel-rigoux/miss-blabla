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

ActiveRecord::Schema.define(version: 20130812102042) do

  create_table "agents", force: true do |t|
    t.string   "nom"
    t.text     "email"
    t.string   "telephone"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "clients", force: true do |t|
    t.string   "societe"
    t.string   "nom"
    t.string   "siren"
    t.string   "email"
    t.string   "telephone"
    t.text     "adresse_1"
    t.text     "adresse_2"
    t.integer  "agent_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "couleurs", force: true do |t|
    t.string   "nom"
    t.integer  "saison_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "modeles", force: true do |t|
    t.string   "numero"
    t.string   "nom"
    t.string   "taille_min"
    t.string   "taille_max"
    t.float    "prix"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "patrons", force: true do |t|
    t.string   "societe"
    t.string   "siren"
    t.text     "adresse"
    t.integer  "agent_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "versions", force: true do |t|
    t.integer  "modele_id"
    t.integer  "couleurs_1_id"
    t.integer  "couleurs_2_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
