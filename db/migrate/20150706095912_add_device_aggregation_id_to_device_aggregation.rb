class AddDeviceAggregationIdToDeviceAggregation < ActiveRecord::Migration
  def change
    add_reference :device_aggregations, :parent, references: :device_aggregations, index: true, null: true
  end
end
