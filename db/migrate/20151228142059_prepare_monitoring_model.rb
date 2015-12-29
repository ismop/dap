class PrepareMonitoringModel < ActiveRecord::Migration
  def change
    add_column :parameters, :monitored, :boolean, default: false
    add_column :parameters, :monitoring_status, :integer, default: 0

    add_index :parameters, :monitored, unique: false
    add_index :parameters, :monitoring_status, unique: false
  end
end
