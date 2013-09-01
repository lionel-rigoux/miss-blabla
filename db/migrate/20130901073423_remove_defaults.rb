class RemoveDefaults < ActiveRecord::Migration
  def change
    change_column :clients, :has_tva, :boolean,  null: false #default: true,
    change_column :commandes, :status, :integer, null: false # default: 0,
    change_column :quantites, :detail, :text,  null: false  #, default: {}.to_yaml,
  end
end
