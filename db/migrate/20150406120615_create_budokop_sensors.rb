class CreateBudokopSensors < ActiveRecord::Migration
  def change
    create_table :budokop_sensors do |t|

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

      t.belongs_to :device

    end
  end
end
