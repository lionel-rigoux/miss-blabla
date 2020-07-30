class CreateAvoir < ActiveRecord::Migration

  def up
    create_table :retours do |t|
      t.belongs_to :client
      t.float  :frais_de_port
    end
    add_index :retours, :client_id

  end
  def down
    drop_table :retours
  end



end
