class Facturation < ActiveRecord::Migration
  def up 
    add_column :commandes, :frais_de_port, :float
  end
end
