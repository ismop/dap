class PurgeSensorModel < ActiveRecord::Migration
  def change
    drop_table :sensors
    remove_column :timelines, :sensor_id
  end
end
