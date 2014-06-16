class CreateMeasurementTypes < ActiveRecord::Migration
  def change
    create_table :measurement_types do |t|
      t.string :name,               null:false, default:"unnamed measurement"
      t.string :unit,               null:false, default:"unnamed unit"
      t.timestamps
    end

  end
end
