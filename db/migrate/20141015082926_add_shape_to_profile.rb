class AddShapeToProfile < ActiveRecord::Migration
  def change
    change_table :profiles do |t|
      t.multi_point :shape, geographic: true, has_z: false, srid: 4326
    end
  end
end
