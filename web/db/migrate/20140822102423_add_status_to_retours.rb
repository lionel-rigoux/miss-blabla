class AddStatusToRetours < ActiveRecord::Migration[4.2]
  def change
        add_column(:retours, :status, :integer)
  end
end
