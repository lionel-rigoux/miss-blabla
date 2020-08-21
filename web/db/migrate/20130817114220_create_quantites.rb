class CreateQuantites < ActiveRecord::Migration[4.2]
  def change
    create_table :stocks do |t|
      t.timestamps
    end
    create_table :quantites do |t|
      t.references :quantifiable, polymorphic: true
      t.text :detail
      t.timestamps
    end

  end
end
