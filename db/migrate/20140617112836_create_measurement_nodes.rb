class CreateMeasurementNodes < ActiveRecord::Migration
  def change
    create_table :measurement_nodes do |t|

      t.string :custom_id,                null: false, default: "unknown ID"
      t.point :placement,                 geographic: true, has_z: true, srid: 4326

      t.integer :battery_state,           null: true
      t.integer :battery_capacity,        null: true

      t.string :manufacturer,             null: false, default: "unknown manufacturer"
      t.string :model,                    null: false, default: "unknown model"
      t.string :serial_number,            null: false, default: "unknown serial number"
      t.string :firmware_version,         null: false, default: "unknown version"

      t.date :manufacture_date,           null: true
      t.date :purchase_date,              null: true
      t.date :warranty_date,              null: true
      t.date :deployment_date,            null: true

      t.timestamp :last_state_change,     null: true

      t.integer :energy_consumption,      null: false, default: 0

      t.belongs_to :edge_node

      t.belongs_to :activity_state
      t.belongs_to :power_type
      t.belongs_to :interface_type

      t.timestamps
    end

    add_index :measurement_nodes, :custom_id, unique: true
    add_index :measurement_nodes, :last_state_change, unique: false
    add_index :measurement_nodes, :interface_type_id, unique: false
    add_index :measurement_nodes, :activity_state_id, unique: false

  end
end
