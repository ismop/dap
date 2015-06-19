class CreateDeviceAggregations < ActiveRecord::Migration
  def change
    create_table :device_aggregations do |t|
      t.string :custom_id,                null: false, default: "unknown ID"
      t.point :placement,                 geographic: true, has_z: true, srid: 4326

      t.references :profile
    end
  end
end
