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

ActiveRecord::Schema.define(version: 20200819115300) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "agents", id: :serial, force: :cascade do |t|
    t.string "nom", limit: 255
    t.text "email"
    t.string "telephone", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "clients", id: :serial, force: :cascade do |t|
    t.string "societe", limit: 255
    t.string "nom", limit: 255
    t.string "siret", limit: 255
    t.string "tva", limit: 255
    t.string "email", limit: 255
    t.string "telephone", limit: 255
    t.text "adresse_1"
    t.text "adresse_2"
    t.integer "agent_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean "has_tva", default: true, null: false
    t.index ["agent_id"], name: "index_clients_on_agent_id"
  end

  create_table "commandes", id: :serial, force: :cascade do |t|
    t.integer "client_id"
    t.date "livraison"
    t.text "commentaire"
    t.integer "status", default: 0, null: false
    t.integer "production_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float "frais_de_port"
    t.integer "nombre_paiments"
    t.integer "numero_facture"
    t.date "date_facturation"
    t.float "montant"
    t.float "avoir"
    t.index ["client_id"], name: "index_commandes_on_client_id"
    t.index ["production_id"], name: "index_commandes_on_production_id"
  end

  create_table "couleurs", id: :serial, force: :cascade do |t|
    t.string "nom", limit: 255, null: false
    t.integer "saison_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "modeles", id: :serial, force: :cascade do |t|
    t.string "numero", limit: 255, null: false
    t.string "nom", limit: 255, null: false
    t.string "taille_min", limit: 255
    t.string "taille_max", limit: 255
    t.float "prix", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "patrons", id: :serial, force: :cascade do |t|
    t.string "societe", limit: 255
    t.string "siret", limit: 255
    t.string "tva", limit: 255
    t.float "capital"
    t.text "adresse", null: false
    t.integer "agent_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["agent_id"], name: "index_patrons_on_agent_id"
  end

  create_table "productions", id: :serial, force: :cascade do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "quantites", id: :serial, force: :cascade do |t|
    t.integer "quantifiable_id"
    t.string "quantifiable_type", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "total"
    t.json "detail"
    t.index ["quantifiable_id"], name: "index_quantites_on_quantifiable_id"
    t.index ["quantifiable_type"], name: "index_quantites_on_quantifiable_type"
  end

  create_table "retours", id: :serial, force: :cascade do |t|
    t.integer "client_id"
    t.float "frais_de_port"
    t.float "montant"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "status"
    t.index ["client_id"], name: "index_retours_on_client_id"
  end

  create_table "stocks", id: :serial, force: :cascade do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "versions", id: :serial, force: :cascade do |t|
    t.integer "modele_id"
    t.integer "couleurs_1_id"
    t.integer "couleurs_2_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["couleurs_1_id"], name: "index_versions_on_couleurs_1_id"
    t.index ["modele_id"], name: "index_versions_on_modele_id"
  end

end
