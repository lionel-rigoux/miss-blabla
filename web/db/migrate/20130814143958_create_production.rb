class CreateProduction < ActiveRecord::Migration[4.2]
  def change
    create_table :productions do |t|
      t.timestamps
    end
  end

end
