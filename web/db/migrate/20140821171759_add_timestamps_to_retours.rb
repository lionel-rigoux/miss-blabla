class AddTimestampsToRetours < ActiveRecord::Migration[4.2]
  def change
    add_column(:retours, :created_at, :datetime)
    add_column(:retours, :updated_at, :datetime)
  end

end
