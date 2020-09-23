class AddAvoirToCommandes < ActiveRecord::Migration[4.2]
  def up
      add_column :commandes, :avoir, :float
  end
  def down
      remove_column :commandes, :avoir
  end
end
