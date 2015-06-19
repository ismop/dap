class CreateDevices < ActiveRecord::Migration
  def change
    create_table :devices do |t|
      t.string :custom_id,                null: false, default: "unknown ID"
      t.point :placement,                 geographic: true, has_z: true, srid: 4326
      t.string :device_type,              null: false, default: "unknown" # Enum

      t.references :device_aggregation
      t.references :section

    end
  end
end
