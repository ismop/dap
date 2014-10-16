class RemoveSensorIdFromMeasurements < ActiveRecord::Migration
  def change
    remove_reference :measurements, :sensor
  end
end
