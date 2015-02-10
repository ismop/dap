class RemoveTimestampsFromMeasurements < ActiveRecord::Migration
  def change
    remove_timestamps :measurements
  end
end
