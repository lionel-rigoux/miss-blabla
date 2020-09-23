class CreateCommandes < ActiveRecord::Migration[4.2]
  def change
    create_table :commandes do |t|
      t.belongs_to :client
      t.date       :livraison
      t.text       :commentaire
      t.integer    :status
      t.belongs_to :production
      t.timestamps
    end
  end
end
