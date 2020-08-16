class FastQuantite < ActiveRecord::Migration
  def up
    add_column :quantites, :total, :integer
    add_column :commandes, :montant, :float

    Quantite.reset_column_information
    Quantite.find_each do |q|
      q.update_total
      q.save
    end

    Commande.reset_column_information
    Commande.find_each do |c|
      c.update_montant
      c.save
    end

  end

  def down
    remove_column :quantites, :total
    remove_column :commandes, :montant
  end
end
