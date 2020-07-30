class CreateModeles < ActiveRecord::Migration
  
  def change   

    create_table :modeles do |t|
      t.string :numero
      t.string :nom
      t.string :taille_min
      t.string :taille_max
      t.float  :prix
      t.timestamps
    end
    
    create_table :versions do |t|
      t.belongs_to :modele
      t.references :couleurs_1
      t.references :couleurs_2
      t.timestamps
     end
    
  end
end
