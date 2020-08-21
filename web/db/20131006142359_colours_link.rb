class ColoursLink < ActiveRecord::Migration[4.2]
  def up
    create_table :couleurs_modeles, :id => false do |t|
      t.belongs_to :couleur
      t.belongs_to :modele
    end
    Version.all.each do |v|
      c=Couleur.find_by_id(v.couleurs_1_id)
      v.modele.couleurs.push c if c
    end
  end
  def down
    drop_table :couleurs_modeles
  end
end
