class Indexes < ActiveRecord::Migration
  def up
    add_index :clients, :agent_id
    add_index :commandes, :client_id
    add_index :commandes, :production_id
    add_index :patrons, :agent_id
    add_index :quantites, :quantifiable_id
    add_index :quantites, :quantifiable_type
    add_index :versions, :modele_id
  end

end
