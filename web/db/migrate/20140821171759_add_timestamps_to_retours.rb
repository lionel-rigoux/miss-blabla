class AddTimestampsToRetours < ActiveRecord::Migration
  def change
    add_column(:retours, :created_at, :datetime)
    add_column(:retours, :updated_at, :datetime)
  end

end
