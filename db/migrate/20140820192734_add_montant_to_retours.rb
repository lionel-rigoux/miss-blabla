class AddMontantToRetours < ActiveRecord::Migration
  def up
        add_column :retours, :montant, :float
  end
   def down
      remove_column :retours, :montant
  end
end
