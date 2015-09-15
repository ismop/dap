class AddShapeToDeviceAggregation < ActiveRecord::Migration
  def change
    change_table :device_aggregations do |t|
      t.spatial :shape, geographic: true, has_z: false, srid: 4326
    end

    if column_exists?(:device_aggregations, :placement)
      execute('ALTER TABLE device_aggregations DROP COLUMN placement')
    end
  end
end
