class CreatePatrons < ActiveRecord::Migration[4.2]
  def change
    create_table :patrons do |t|
      t.string  :societe
      t.string  :siret
      t.string  :tva
      t.float :capital
      t.text    :adresse
      t.belongs_to :agent
      t.timestamps
    end


  end
end
