class AddMontantToRetours < ActiveRecord::Migration[4.2]
  def up
        add_column :retours, :montant, :float
  end
   def down
      remove_column :retours, :montant
  end
end
