class Defaults < ActiveRecord::Migration
  def change
    change_column :agents, :nom, :string, unique: true
    change_column :clients, :societe, :string, unique: true, null: true
    change_column :clients, :has_tva, :boolean, default: true, null: false
    change_column :commandes, :status, :integer, default: 0, null: false
    change_column :commandes, :numero_facture, :integer, unique: true
    change_column :couleurs, :nom, :string, null: false
    change_column :modeles, :numero, :string, unique: true, null: false
    change_column :modeles, :nom, :string, null: false
    change_column :modeles, :prix, :float, null: false
    change_column :patrons, :adresse, :text, null: false
    change_column :quantites, :detail, :text, default: {}.to_yaml, null: false

    add_index :versions, :couleurs_1_id
  end
end
