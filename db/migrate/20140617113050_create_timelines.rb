class CreateTimelines < ActiveRecord::Migration
  def change
    create_table :timelines do |t|
      t.string :name,                    null:false, default: "unnamed timeline"
      t.string :measurement_type,        null:false, default: "actual"
      t.timestamps

      t.belongs_to :sensor
    end

    add_index :timelines, :measurement_type, unique: false
    add_index :timelines, :sensor_id, unique: false

  end
end
