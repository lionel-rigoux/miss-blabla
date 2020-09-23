class CreateCouleurs < ActiveRecord::Migration[4.2]
  def change
    create_table :couleurs do |t|
      t.string :nom
      t.belongs_to :saison
      t.timestamps
    end
  end
end
