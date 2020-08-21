class Facturation < ActiveRecord::Migration[4.2]
  def change
    add_column :clients, :has_tva, :boolean
    add_column :commandes, :frais_de_port, :float
    add_column :commandes, :nombre_paiments, :integer
    add_column :commandes, :numero_facture, :integer
    add_column :commandes, :date_facturation, :date
  end
end
