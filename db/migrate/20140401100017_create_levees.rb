class CreateLevees < ActiveRecord::Migration
  def change
    create_table :levees do |t|
      t.string :name,               null:false, default:"unnamed levee"
      t.string :emergency_level,    null:false, default:"none" # Allowed values: none, heightened, severe
      t.string :threat_level,       null:false, default:"none" # Allowed values: none, heightened, severe

      #t.geometry :shape, srid: 4326, with_z: true
      t.multi_point :shape, geographic: true, has_z: true, srid: 4326
    end

    # Time for some good old-fashioned SQL because the Rails ORM model is too constraining to support this...
    execute "ALTER TABLE levees ADD COLUMN threat_level_updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP"

  end
end
