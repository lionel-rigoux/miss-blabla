class CreateContacts < ActiveRecord::Migration
  def change
    create_table :agents do |t|
        t.string  :nom
        t.text    :email
        t.string  :telephone
        t.timestamps
      end
      
      create_table :clients do |t|
      t.string  :societe
      t.string  :nom
      t.string  :siret
      t.string  :tva
      t.string  :email
      t.string  :telephone
      t.text    :adresse_1
      t.text    :adresse_2
      t.belongs_to :agent
      t.timestamps
    end
    
 
      
  end
end
