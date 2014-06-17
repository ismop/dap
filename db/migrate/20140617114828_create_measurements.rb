class CreateMeasurements < ActiveRecord::Migration
  def change
    create_table :measurements do |t|
      t.string :custom_id,               null:false, default: ""
      t.float :value,                    null:false
      t.timestamp :timestamp,            null:false
      t.string :source_address,          null:true

      t.belongs_to :sensor
      t.belongs_to :timeline

      t.timestamps
    end

    add_index :measurements, :custom_id, unique: false
    add_index :measurements, :timestamp, unique: false
    add_index :measurements, :sensor_id, unique: false
    add_index :measurements, :timeline_id, unique: false

  end
end
