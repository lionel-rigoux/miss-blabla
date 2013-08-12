class CreateCouleurs < ActiveRecord::Migration
  def change
    create_table :couleurs do |t|
      t.string :nom
      t.belongs_to :saison
      t.timestamps
    end
  end
end
