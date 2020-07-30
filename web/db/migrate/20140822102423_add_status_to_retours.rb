class AddStatusToRetours < ActiveRecord::Migration
  def change
        add_column(:retours, :status, :integer)
  end
end

