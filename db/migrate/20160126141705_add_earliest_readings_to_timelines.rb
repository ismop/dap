class AddEarliestReadingsToTimelines < ActiveRecord::Migration
  def up
    execute 'ALTER TABLE timelines ADD COLUMN earliest_measurement_timestamp TIMESTAMP WITH TIME ZONE'
    add_column :timelines, :earliest_measurement_value, :float
  end

  def down
    remove_column :timelines, :earliest_measurement_value
    remove_column :timelines, :earliest_measurement_timestamp
  end
end
