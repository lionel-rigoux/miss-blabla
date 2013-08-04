class CreateClients < ActiveRecord::Migration
  def change
    create_table :clients do |t|
      t.string  :niveau
      t.string  :nom
      t.string  :siren
      t.text    :adresse_1
      t.text    :adresse_2
      t.references   :parent
      t.timestamps
    end
  end
end
